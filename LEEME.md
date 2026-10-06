# Turnos · Depi Nath

Página de reservas. La clienta elige zonas, día y horario, y al confirmar se le
abre WhatsApp con el mensaje ya escrito hacia +54 9 11 6251-1587.

Son dos archivos:

- `index.html` — la página. Casi nunca la vas a tocar.
- `agenda.json` — **el archivo del día a día.** Acá marcás horarios tomados,
  cerrás un sábado, abrís uno extra o ponés un cartel de aviso.

---

## 1. Subirla a GitHub (una sola vez)

1. Entrá a <https://github.com> con la cuenta **Oriivane**.
2. Arriba a la derecha, el botón **+** → **New repository**.
3. En *Repository name* poné: `turnos`
4. Dejá marcado **Public** y creá el repositorio con **Create repository**.
5. En la pantalla que aparece, tocá **uploading an existing file**.
6. Arrastrá ahí `index.html` y `agenda.json`.
7. Abajo, tocá **Commit changes**.

## 2. Encender la página (una sola vez)

1. En el repositorio, pestaña **Settings**.
2. Menú de la izquierda, **Pages**.
3. En *Branch* elegí `main`, carpeta `/ (root)`, y tocá **Save**.
4. Esperá uno o dos minutos y recargá. Arriba va a aparecer tu link:

   **https://oriivane.github.io/turnos/**

Ese es el link que pegás en la bio de Instagram y mandás por WhatsApp.

---

## 3. El día a día: editar `agenda.json`

Siempre es el mismo gesto:

1. En GitHub, abrí `agenda.json`.
2. Tocá el lápiz (**Edit this file**).
3. Escribí el cambio.
4. Abajo, **Commit changes**.

La página se actualiza sola en menos de un minuto.

**Las reglas de escritura, que son las mismas para todo:**

- Las fechas se escriben `AAAA-MM-DD` → el 17 de octubre de 2026 es `2026-10-17`.
- Las horas se escriben `HH:MM` con dos dígitos → las nueve y veinte son `09:20`.
- Todo va **entre comillas**, y si hay más de uno **se separan con coma**.
- El último de la lista **no lleva coma**.

### Marcar un horario como tomado

```json
"ocupados": [
  "2026-10-17 09:20",
  "2026-10-17 09:40",
  "2026-11-07 15:00"
],
```

### Cerrar un sábado entero

Si te enfermás, viajás o simplemente no vas a atender ese día. El día entero
desaparece de la página; no hace falta listar los horarios.

```json
"diasCerrados": [
  "2026-11-07"
],
```

### Abrir un sábado extra

Si querés atender un sábado que no es el primero ni el tercero.

```json
"diasExtra": [
  "2026-10-24"
],
```

### Poner un cartel de aviso

Aparece arriba de todo, en rosa. Sirve para vacaciones, cambio de dirección,
una promo, lo que sea.

```json
"aviso": "Del 20 de diciembre al 5 de enero no atiendo. Vuelvo el sábado 17 de enero."
```

Para sacarlo, dejalo vacío: `"aviso": ""`

### Las cuatro cosas juntas

Así se ve el archivo completo con todo usado a la vez:

```json
{
  "ocupados": [
    "2026-10-17 09:20",
    "2026-10-17 09:40"
  ],
  "diasCerrados": [
    "2026-11-07"
  ],
  "diasExtra": [
    "2026-10-24"
  ],
  "aviso": "En noviembre atiendo solo el 21."
}
```

> **Importante:** este archivo lo puede leer cualquiera que entre a tu
> repositorio. Poné solo fechas y horas, nunca nombres ni teléfonos de clientas.

Cuando los turnos ya pasaron podés borrar esas líneas para mantenerlo corto,
aunque no hace falta: la página ignora sola todo lo que quedó atrás.

**Si te equivocás escribiendo** (una coma de más, una comilla que falta), la
página no se rompe: vuelve a mostrar la agenda normal con todo libre. Lo vas a
notar porque reaparece un horario que ya habías tomado. Corregís y listo.

---

## 4. Cambios de fondo: editar `index.html`

Esto es para cuando cambia algo estable del negocio, no para el día a día.
Está todo junto al final del archivo, en el bloque que dice `const CONFIG = {`.

| Qué querés cambiar | Qué línea |
|---|---|
| Nombre y bajada | `nombre` y `bajada` |
| Número de WhatsApp | `whatsapp` (solo dígitos) y `whatsappVisible` |
| Qué día de la semana atendés | `diaSemana` — 0 domingo, 1 lunes … 6 sábado |
| Qué semanas del mes | `semanasDelMes` — `[1, 3]` es primer y tercer |
| Horario de atención | `horaDesde` y `horaHasta` |
| Cada cuántos minutos | `intervaloMin` |
| Anticipación mínima | `anticipacionHoras` |
| Hasta cuándo se abren turnos | `mesesAdelante` |
| Las zonas del listado | `zonas` |

Ejemplos:

- Atender **todos** los sábados: `semanasDelMes: [1, 2, 3, 4, 5]`
- Atender el **segundo y cuarto** sábado: `semanasDelMes: [2, 4]`
- Agregar una zona: escribila entre comillas dentro del grupo que corresponda,
  separada con coma.

---

## 5. Lo que esta página no hace

Vale tenerlo claro para que no te sorprenda:

- **El horario no se bloquea solo.** Se bloquea cuando vos lo agregás a
  `agenda.json`. Si dos clientas piden el mismo horario en el mismo rato, te van
  a llegar los dos mensajes y le pedís a una que elija otro.
- **No manda recordatorios.** Los mensajes salen de tu WhatsApp, a mano.
- **No cobra señas.**

Las tres cosas se resuelven agregándole una base de datos gratuita por detrás.
Si el volumen de turnos lo justifica, se hace sobre esto mismo sin rehacer la
página.
