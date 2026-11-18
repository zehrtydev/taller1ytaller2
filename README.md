# Entrega MySQL II — Manuel Amado

Dos talleres independientes, en español, diseñados para **MySQL 8.0.16 o superior** y **MySQL Workbench**. Se incluyen sus **tres retos opcionales** cada uno. La guía «Procedimientos y funciones · BiblioRed» se usó únicamente como material de consulta, no como entregable.

| Taller | Caso | Base | Modelo | Fecha fija |
|---|---|---|---|---|
| 1 | BiblioRed | `bibliored` | 15 tablas | 2026-11-10 |
| 2 | FlotaYa | `flotaya` | 25 tablas | 2026-11-23 |

## Cómo ejecutar

Para **cada taller por separado**, abre MySQL Workbench con una conexión **administrativa local**, abre los archivos SQL y ejecútalos **en orden**:

1. `01_ddl.sql` — crea esquema, restricciones y claves.
2. `02_dml.sql` — carga los datos y ejecuta modificaciones con comprobaciones.
3. `03_dql.sql` — 12 consultas de negocio con columnas del enunciado.
4. `04_dql_avanzado.sql` — rutinas y pruebas. En FlotaYa también crea roles y usuarios: requiere permisos de administración de MySQL.
5. `05_tcl.sql` — transacciones y auditoría (algunos fallos de aprendizaje se comprueban manualmente).
6. `06_retos.sql` — tres retos de bonificación.

**Atención:** ejecutar `01_ddl.sql` **borra y recrea la base** del respectivo taller. Los scripts son reproducibles desde cero, pero no deben ejecutarse dentro de una base que contenga información real.

Los errores intencionales están **comentados** y llevan la marca `⚠️ ESPERADO`. Para demostrar uno, descomenta **solo esa instrucción**, ejecútala con Ctrl+Enter y vuelve a comentarla. Es especialmente importante para los casos de TCL donde debes observar un estado dentro de la transacción y luego realizar `ROLLBACK`.

`00_diagrama.md` muestra el diagrama ER de cada sistema mediante Mermaid (GitHub lo representa directamente), cardinalidades y normalización 1FN–4FN. Consulta también el `README.md` de cada taller.

## Evidencias que requieren MySQL Workbench

Las capturas del control de privilegios de las cuentas `asesor_flotaya`, `taller_flotaya` y `auditor_flotaya` **no se incluyen como si fueran pruebas realizadas**. Deben generarse con conexiones reales siguiendo las instrucciones de `taller2_amado_manuel/evidencias/INSTRUCCIONES.md`.