# Depi Nath · turnos

Dos páginas:

| | Para qué | Link |
|---|---|---|
| `index.html` | La que ven tus clientas | **depi-nath.netlify.app** |
| `panel.html` | Tu agenda privada | **depi-nath.netlify.app/panel.html** |

Los turnos se guardan en Supabase. **El horario se bloquea solo** en el momento
en que una clienta reserva: ya no hay que marcar nada a mano.

---

## Cómo funciona ahora

1. La clienta entra al link, elige zonas, día y horario, y pone sus datos.
2. Al tocar **Reservar**, el turno se guarda y **ese horario desaparece al
   instante** para todas las demás. Si dos personas tocan el botón en el mismo
   segundo, una entra y a la otra le aparece un cartel pidiéndole que elija otro.
3. Se le abre WhatsApp con el mensaje ya escrito hacia tu número.
4. Vos entrás a tu panel, ves el turno como **Sin confirmar**, le respondés por
   WhatsApp y lo marcás **Confirmar**.

Confirmar o no confirmar no cambia la disponibilidad: el horario queda ocupado
desde que la clienta reserva. Es solo para que vos sepas a quién ya le
contestaste.

---

## Tu panel

Entrás en **depi-nath.netlify.app/panel.html** con el mail y la contraseña que
creaste en Supabase. Cualquiera puede llegar a esa dirección, pero sin tu
contraseña no ve nada.

**Turnos.** Agrupados por día, con tres filtros: *Próximos*, *Todos*, *Pasados*.
De cada turno ves la hora, el nombre, el teléfono, las zonas y la nota.

- **WhatsApp** — te abre el chat con esa clienta.
- **Confirmar** — lo marcás como atendido por vos.
- **Cancelar** — **libera el horario** para que otra clienta lo pueda tomar.
- **Borrar** — lo saca de la lista para siempre. Aparece solo en los cancelados.

**Días.** Elegís una fecha y:

- *Cerrar ese día* — un sábado que no vas a atender. Desaparece entero de la página.
- *Abrir ese día* — un sábado extra, fuera del primero y el tercero.

Para deshacerlo, tocá la **×** del chip.

**Cartel de aviso.** El texto que aparece arriba de todo en la página de
reservas. Vacío = no se muestra.

---

## Lo que ya no hace falta

`agenda.json` quedó sin uso: todo eso ahora lo manejás desde el panel. Podés
borrarlo del repositorio o dejarlo, da igual.

---

## Si algo falla

**La página dice "No pude cargar la agenda".** Supabase pausa los proyectos
gratuitos que pasan una semana entera sin actividad. Entrá a supabase.com y
tocá **Restore**. Tarda un par de minutos.

Mientras esté así, la página no deja reservar y le muestra a la clienta tu
WhatsApp para que te escriba directo. No se pierde ningún turno de los que ya
tenías: siguen guardados.

**No podés entrar al panel.** Revisá el mail y la contraseña. Si estás segura de
que son correctos, en Supabase → **Authentication** → **Users** abrí tu usuario
y fijate que esté confirmado.

---

## Cambios de fondo

Los días que atendés, los horarios, las zonas y tu número están juntos al final
de `index.html`, en el bloque `const CONFIG = {`.

| Qué cambiar | Qué línea |
|---|---|
| Nombre y bajada | `nombre`, `bajada` |
| Tu WhatsApp | `whatsapp` (solo dígitos) y `whatsappVisible` |
| Día de la semana | `diaSemana` — 0 domingo … 6 sábado |
| Qué semanas del mes | `semanasDelMes` — `[1, 3]` es primer y tercer |
| Horario de atención | `horaDesde`, `horaHasta` |
| Duración del turno | `intervaloMin` |
| Anticipación mínima | `anticipacionHoras` |
| Hasta cuándo se abren turnos | `mesesAdelante` |
| Las zonas | `zonas` |

Las dos páginas tienen arriba la dirección y la clave de Supabase. Esa clave es
pública a propósito: sola no sirve para nada, porque los permisos de la base son
los que protegen los datos.

---

## Lo que sigue sin hacer

- **No manda recordatorios automáticos.** Los mensajes salen de tu WhatsApp.
- **No cobra señas.**
- **Cualquiera puede reservar sin verificar quién es.** Si alguna vez te llenan
  la agenda de turnos falsos, se puede agregar una verificación. Mientras tanto,
  los cancelás desde el panel y el horario se libera.
