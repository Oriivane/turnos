-- ============================================================
--  Depi Nath · base de datos de turnos
--
--  YA ESTÁ INSTALADO. Esto se guarda como respaldo: sirve para
--  rehacer la base desde cero si algún día hiciera falta.
--
--  Se pega entero en: Supabase → SQL Editor → New query → Run
-- ============================================================


-- ------------------------------------------------------------
-- 1. Los turnos. Esta tabla es privada: solo vos, con sesión
--    iniciada, podés leerla. Nadie más ve nombres ni teléfonos.
-- ------------------------------------------------------------
create table if not exists public.turnos (
  id         uuid primary key default gen_random_uuid(),
  fecha      date   not null,
  hora       time   not null,
  zonas      text[] not null default '{}',
  nombre     text   not null,
  telefono   text   not null,
  nota       text,
  estado     text   not null default 'pendiente'
             check (estado in ('pendiente', 'confirmado', 'cancelado')),
  creado_en  timestamptz not null default now()
);

-- Esta línea es la que hace imposible que dos personas tomen el mismo
-- horario: la base de datos rechaza el segundo. Un turno cancelado
-- libera el horario para que otra clienta lo pueda pedir.
create unique index if not exists turno_unico
  on public.turnos (fecha, hora)
  where estado <> 'cancelado';


-- ------------------------------------------------------------
-- 2. Horarios ocupados. Esta sí es pública, pero solo tiene
--    fecha y hora: ningún dato de clientas sale a la web.
-- ------------------------------------------------------------
create table if not exists public.ocupados (
  fecha date not null,
  hora  time not null,
  primary key (fecha, hora)
);


-- ------------------------------------------------------------
-- 3. Mantener "ocupados" al día sola, sin que toques nada.
-- ------------------------------------------------------------
create or replace function public.sync_ocupados()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if (tg_op = 'DELETE') then
    delete from public.ocupados where fecha = old.fecha and hora = old.hora;
    return old;
  end if;

  if (tg_op = 'UPDATE'
      and (old.fecha, old.hora) is distinct from (new.fecha, new.hora)) then
    delete from public.ocupados where fecha = old.fecha and hora = old.hora;
  end if;

  if (new.estado = 'cancelado') then
    delete from public.ocupados where fecha = new.fecha and hora = new.hora;
  else
    insert into public.ocupados (fecha, hora)
    values (new.fecha, new.hora)
    on conflict do nothing;
  end if;

  return new;
end;
$$;

drop trigger if exists trg_sync_ocupados on public.turnos;
create trigger trg_sync_ocupados
  after insert or update or delete on public.turnos
  for each row execute function public.sync_ocupados();


-- ------------------------------------------------------------
-- 4. Días cerrados y días extra, y el cartel de aviso.
--    Es lo que manejás desde la sección "Días" del panel.
-- ------------------------------------------------------------
create table if not exists public.dias (
  fecha date primary key,
  tipo  text not null check (tipo in ('cerrado', 'extra'))
);

create table if not exists public.config (
  clave text primary key,
  valor text not null default ''
);

insert into public.config (clave, valor)
values ('aviso', '')
on conflict (clave) do nothing;


-- ------------------------------------------------------------
-- 5. Permisos. Lo importante: cualquiera puede RESERVAR,
--    nadie puede LEER los turnos salvo vos.
-- ------------------------------------------------------------
alter table public.turnos   enable row level security;
alter table public.ocupados enable row level security;
alter table public.dias     enable row level security;
alter table public.config   enable row level security;

drop policy if exists "reservar"       on public.turnos;
drop policy if exists "ver turnos"     on public.turnos;
drop policy if exists "editar turnos"  on public.turnos;
drop policy if exists "borrar turnos"  on public.turnos;
drop policy if exists "ver ocupados"   on public.ocupados;
drop policy if exists "ver dias"       on public.dias;
drop policy if exists "editar dias"    on public.dias;
drop policy if exists "ver config"     on public.config;
drop policy if exists "editar config"  on public.config;

-- Una clienta puede crear su turno, con datos razonables y a futuro.
create policy "reservar" on public.turnos
  for insert to anon, authenticated
  with check (
    fecha >= current_date
    and char_length(nombre)   between 2 and 80
    and char_length(telefono) between 6 and 30
    and array_length(zonas, 1) between 1 and 30
  );

-- Pero leer, modificar y borrar turnos es solo tuyo.
create policy "ver turnos" on public.turnos
  for select to authenticated using (true);
create policy "editar turnos" on public.turnos
  for update to authenticated using (true) with check (true);
create policy "borrar turnos" on public.turnos
  for delete to authenticated using (true);

-- Los horarios ocupados los puede leer la página. Escribirlos, nadie:
-- los escribe sola la función de arriba.
create policy "ver ocupados" on public.ocupados
  for select to anon, authenticated using (true);

-- Días y aviso: los lee la página, los cambiás vos desde el panel.
create policy "ver dias" on public.dias
  for select to anon, authenticated using (true);
create policy "editar dias" on public.dias
  for all to authenticated using (true) with check (true);

create policy "ver config" on public.config
  for select to anon, authenticated using (true);
create policy "editar config" on public.config
  for all to authenticated using (true) with check (true);
