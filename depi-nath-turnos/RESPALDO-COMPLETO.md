# Depi Nath · todo sobre el sistema de turnos

Documento maestro. Si algún día no te acordás de nada, empezá por acá.

Armado el 8 de octubre de 2026.

---

## 1. Los links

| Para qué | Dirección |
|---|---|
| **La página de tus clientas** | https://depi-nath.netlify.app |
| **Tu agenda privada** | https://depi-nath.netlify.app/panel.html |

El primero es el que va en la bio de Instagram. El segundo es solo tuyo: pide
mail y contraseña.

---

## 2. Las tres cuentas

El sistema se apoya en tres servicios, **todos en plan gratuito y sin tarjeta**.

### GitHub — guarda el código

- Cuenta: **Oriivane**
- Repositorio: **github.com/Oriivane/turnos** (público)
- Ahí viven `index.html`, `panel.html` y `LEEME.md`.

Es el único lugar donde se cambia la página. Subís un archivo nuevo y listo.

### Netlify — publica la página

- Proyecto: **depi-nath**
- Está conectado al repositorio de GitHub.

**No tenés que tocarlo nunca.** Cada vez que subís un archivo a GitHub, Netlify
lo detecta y publica la versión nueva sola, en menos de un minuto.

Dos cosas que ya están configuradas y conviene no cambiar:
- *Project configuration → General → Visitor access* está en **Public**. Si lo
  ponés en privado, tus clientas ven una pantalla de login en vez de la página.
- *Powered by Netlify badge* está **apagado**. Si lo prendés, vuelve a aparecer
  un cartel que tapa el botón de reservar en el celular.

### Supabase — guarda los turnos

- Proyecto: **depi-nath**
- Identificador: `qcistptgeqskkstljuqx`
- Región: South America (São Paulo)
- Plan: **Free**

Acá están los turnos de verdad: nombres, teléfonos, zonas, fechas.

**Para entrar a tu panel** (no al sitio de Supabase, al panel de la agenda):
- `indiaynatu@gmail.com`
- Hay un segundo usuario de respaldo: `yop.ovas@gmail.com`

Los usuarios se administran en Supabase → **Authentication** → **Users**.
Para cambiar el mail o la contraseña: creás uno nuevo con *Add user* marcando
**Auto Confirm User**, probás que entre, y recién ahí borrás el viejo.

---

## 3. Las claves

Dentro de `index.html` y `panel.html` hay una clave larga que empieza con
`eyJ...`. Es la clave **anon public** de Supabase y **es pública a propósito**:
cualquiera que mire el código de tu página la puede ver, y está bien. Sola no
sirve para nada, porque lo que protege los datos son los permisos instalados en
la base.

**Estas tres NO se comparten con nadie, nunca:**

- La **Database password** de Supabase
- La clave **service_role**
- La clave **secret** (`sb_secret_...`)

Dan acceso total a todo. Ningún servicio legítimo te las va a pedir por mensaje.

---

## 4. Cómo funciona, en palabras simples

1. Tu clienta entra al link, marca las zonas, elige uno de tus sábados y un
   horario, y pone nombre y teléfono.
2. Al tocar **Reservar**, el turno se guarda en Supabase y **ese horario
   desaparece al instante** para todas las demás.
3. Se le abre WhatsApp con el mensaje ya escrito hacia vos, que incluye la
   dirección y el aviso de la maquinita.
4. Vos entrás al panel, ves el turno como *Sin confirmar*, le respondés y lo
   marcás **Confirmar**.

**Dos personas no pueden tomar el mismo horario.** No es un control que se pueda
escapar: la base de datos tiene una regla llamada `turno_unico` que rechaza
físicamente el segundo. Si dos tocan el botón en el mismo segundo, una entra y a
la otra le aparece un cartel pidiéndole que elija otro horario.

**Los datos de tus clientas no se ven desde la web.** Está comprobado: un
visitante anónimo no puede leer ni un nombre ni un teléfono. Lo único público es
una lista de fechas y horas ocupadas, sin ningún dato personal.

---

## 5. Tu configuración actual

| | |
|---|---|
| Días que atendés | Primer y tercer sábado de cada mes |
| Horarios | 8:00 a 19:00, cada 20 minutos (34 turnos por día) |
| Anticipación mínima | 24 horas |
| Hasta cuándo se abren turnos | 2 meses hacia adelante |
| Tu WhatsApp | +54 9 11 6251-1587 |
| Dirección | Av. San Martín 3530, Paternal, CABA — Piso 6, depto A |
| Precios | No se muestran |
| Seña | No se cobra |

**Zonas que ofrece la página** (28 en total):

- *Rostro:* Bigote, Mentón, Patillas, Entrecejo, Rostro completo
- *Cuello y escote:* Cuello, Escote, Nuca
- *Brazos:* Axilas, Medio brazo, Brazo completo, Manos
- *Torso:* Pecho, Pecho completo, Areolas, Abdomen, Línea abdominal,
  Espalda media, Espalda completa, Lumbares
- *Zona bikini:* Cavado simple, Cavado completo, Tiro de cola, Glúteos
- *Piernas:* Media pierna, Pierna completa, Rodillas, Pies

---

## 6. El día a día, desde el panel

**Recordatorios** (arriba de todo). Desde 3 días antes de cada jornada aparece
la lista de clientas con un botón **Avisar**. Lo tocás y se abre tu WhatsApp con
el mensaje escrito. La fila queda marcada ✓ avisada.

> Esa marca se guarda en el navegador que estés usando. Si avisás desde el
> celular y después abrís el panel en la computadora, las marcas no están. Los
> turnos sí, siempre.

**Turnos.** Agrupados por día, con filtros *Próximos*, *Todos* y *Pasados*.

- **WhatsApp** — abre el chat con esa clienta
- **Confirmar** — la marcás como atendida por vos
- **Cancelar** — **libera el horario** para otra clienta
- **Borrar** — lo saca para siempre; aparece solo en los cancelados

**Días.** Elegís una fecha y *Cerrar ese día* (un sábado que no vas a atender,
desaparece entero) o *Abrir ese día* (un sábado extra fuera del primero y el
tercero). Se deshace con la **×** del chip.

**Cartel de aviso.** Texto que aparece arriba de todo en la página de reservas.
Vacío = no se muestra.

---

## 7. Cambiar algo de fondo

Lo que no sale del panel está en el bloque `const CONFIG = {` de los archivos.

| Qué cambiar | Línea | Archivo |
|---|---|---|
| Nombre y bajada | `nombre`, `bajada` | index |
| Tu WhatsApp | `whatsapp`, `whatsappVisible` | index |
| La dirección | `direccion`, `referencia` | **index y panel** |
| Lo que tiene que traer | `queLlevar` | **index y panel** |
| Día de la semana | `diaSemana` — 0 domingo … 6 sábado | index |
| Qué semanas del mes | `semanasDelMes` — `[1,3]` es primer y tercer | index |
| Horario de atención | `horaDesde`, `horaHasta` | index |
| Duración del turno | `intervaloMin` | index |
| Anticipación mínima | `anticipacionHoras` | index |
| Hasta cuándo se abren | `mesesAdelante` | index |
| Las zonas | `zonas` | index |

**Ojo:** la dirección y el texto de qué llevar están escritos en los **dos**
archivos. Si cambiás uno solo, van a quedar distintos.

Después de editar, subís el archivo a GitHub y Netlify lo publica solo.

---

## 8. Si algo falla

**"No pude cargar la agenda" en la página.** Supabase pausa los proyectos
gratuitos que pasan una semana entera sin actividad. Entrá a supabase.com y tocá
**Restore**. Tarda un par de minutos. Mientras tanto la página no deja reservar y
le muestra tu WhatsApp a la clienta. **No se pierde ningún turno:** siguen
guardados.

**No podés entrar al panel.** Revisá mail y contraseña. Si estás segura, andá a
Supabase → Authentication → Users y fijate que el usuario esté confirmado. Si no,
creá uno nuevo con *Auto Confirm User* marcado.

**La página no se actualiza después de subir un archivo.** Entrá a Netlify y
mirá en *Deploys* si el último dio error. Suele ser que subiste el archivo con
otro nombre.

**Un horario que ya diste sigue apareciendo libre.** Fijate que el turno no esté
en estado *Cancelado*: cancelar libera el horario a propósito.

---

## 9. Lo que el sistema NO hace

Decidido así, a conciencia:

- **No manda recordatorios solo.** Los mandás vos con un toque desde el panel.
  Que salieran automáticos exige la API de WhatsApp Business: se paga por mensaje
  (unos ARS 38 cada uno) y, lo más grave, **te haría perder tu número actual**,
  porque la línea conectada deja de funcionar en la app normal.
- **No cobra señas.**
- **No verifica quién reserva.** Si alguna vez te llenan la agenda de turnos
  falsos, los cancelás desde el panel y los horarios se liberan. Si pasara
  seguido, se puede agregar una verificación.

---

## 10. Pendiente

- [ ] **Cargar tu lista de turnos ya agendados.** Quedó a mitad de camino: hay
      que pasar fecha, hora, nombre, teléfono y zonas de cada uno. Los horarios
      tienen que caer en la grilla de 20 minutos y no puede haber dos en el mismo
      día y hora.
- [ ] **Dar de baja la clave `sb_secret_`** en Supabase → Settings → API Keys →
      Revoke, si todavía no lo hiciste.
- [ ] Opcional: pasar la marca de "✓ avisada" a la base de datos, para que se
      sincronice entre tu celular y tu computadora.

---

## 11. Cómo retomar esto con Claude más adelante

Aunque borres la conversación, **no se pierde nada importante**:

1. **Esta carpeta.** `Escritorio\Adm. Oriana\depi-nath-turnos` tiene los
   archivos, este documento, el `LEEME.md` y el `supabase.sql`. **No la borres.**
2. **La memoria de Claude.** En una conversación nueva abierta desde esta misma
   carpeta, Claude ya arranca sabiendo que Depi Nath es un negocio aparte de
   Tectónica, que solo se usan herramientas gratuitas, y qué se construyó acá.
   Eso vive aparte de la conversación y sobrevive aunque la borres.
3. **El código publicado**, que está en GitHub y en Netlify.

Para retomar, abrí Claude en esta carpeta y decile algo como:

> Leé `depi-nath-turnos/RESPALDO-COMPLETO.md` y seguimos con el sistema de
> turnos de Depi Nath.

Con eso alcanza para que entienda todo el contexto en un minuto.
