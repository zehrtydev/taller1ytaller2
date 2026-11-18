# Capturas exigidas en el Taller 2

Las capturas deben salir de **MySQL Workbench ejecutado realmente**. Aquí no se adjuntan imágenes ficticias.

Después de ejecutar `01`–`04` como administrador, configura tres conexiones independientes al host `127.0.0.1` con las cuentas del enunciado y la contraseña de práctica `Practica_2026*`. En cada conexión ejecuta `SELECT USER(), CURRENT_USER(), CURRENT_ROLE();` seguido de `SHOW TABLES;` y muestra una instrucción permitida junto a una rechazada. Las sentencias exactas están en comentarios al final de `04_dql_avanzado.sql`.

1. **`asesor_flotaya.png`** — éxito al crear y confirmar la reserva de Sofía (12–15 de diciembre) y error al intentar leer `payments` o `licenses`.
2. **`taller_flotaya.png`** — éxito al finalizar el mantenimiento de HLX702 y error al intentar actualizar `mileage_km` o consultar contratos.
3. **`auditor_flotaya.png`** — éxito al consultar solo las columnas autorizadas de `payments` y error al seleccionar `card_last4` o los clientes.

Guarda las capturas sin recortarlas de forma que pierdan el usuario, consulta o mensaje de error. Regresa al usuario administrador para ejecutar `05_tcl.sql`.

**Precaución:** no ejecutes dos veces las instrucciones de inserción de reserva para Sofía ni la del mantenimiento preventivo sin reinstalar la base. Los scripts SQL 01–05 completos reinician/crean su propio estado cuando se siguen desde el principio.
