# Taller 1 — BiblioRed

**Autor:** Manuel Amado · **Motor:** MySQL 8.0.16+ · **Fecha de corte:** 2026-11-10 · **Modalidad:** individual.

## Contenido

- `00_diagrama.md`: modelo de 15 tablas, cardinalidades, PK/FK y normalización.
- `01_ddl.sql`: restricciones, valores predeterminados y préstamos desde 1001.
- `02_dml.sql`: datos ficticios y casos D1–D14, actualización/eliminación segura y errores esperados comentados.
- `03_dql.sql`: Q-01 a Q-12, agrupaciones sin doble conteo.
- `04_dql_avanzado.sql`: los **seis procedimientos almacenados** con validaciones y pruebas.
- `05_tcl.sql`: T1 demuestra el riesgo de autocommit y T2 lo resuelve con `ROLLBACK` y `RESIGNAL`.
- `06_retos.sql`: R1–R3 (deudas/libros, rotación por categoría y vencimiento de reservas).

Ejecutar **01 → 02 → 03 → 04 → 05 → 06** en Workbench. No se usan funciones propias, triggers, eventos o usuarios, en cumplimiento de la restricción de la fase 2 del curso.

**Pruebas intencionalmente fallidas:** están comentadas para que no se interrumpa el script general; ejecuta cada una de manera aislada. Para T1, el paso con error debe descomentarse y observarse manualmente antes de la reparación o `ROLLBACK`.

**Consulta de validación esencial:** la última consulta de `02_dml.sql` debe devolver **0** ejemplares prestados sin préstamo activo y **0** préstamos activos sin ejemplar prestado. La consulta de integridad de `05_tcl.sql` también compara ambos totales.

> El modelo de referencia posterior a la entrega no se proporcionó. Los datos ficticios y las salidas se diseñaron a partir del enunciado de BiblioRed adjunto, no de esa solución guiada.
