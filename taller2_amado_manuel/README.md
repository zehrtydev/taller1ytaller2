# Taller 2 — FlotaYa

**Autor:** Manuel Amado · **Motor:** MySQL 8.0.16+ · **Fecha de corte:** 2026-11-23 · **Modalidad:** individual.

## Contenido

- `00_diagrama.md`: 25 tablas, relaciones 1:1, N:M, múltiples FK y normalización.
- `01_ddl.sql`: esquema, `CHECK`, `ENUM`, FKs, numeración 501/9001.
- `02_dml.sql`: datos obligatorios, 14 reservas, 8 contratos, mantenimiento de tarifas/sedes y pruebas de integridad.
- `03_dql.sql`: 12 consultas Q-01 a Q-12.
- `04_dql_avanzado.sql`: 3 funciones, 2 procedimientos y roles/cuentas MySQL con privilegio mínimo.
- `05_tcl.sql`: cierre de Paola con `SAVEPOINT`, reversión completa del cierre de Carlos y auditoría de consistencia.
- `06_retos.sql`: tres retos de temporadas, cartera y conductores sin requisitos.
- `evidencias/INSTRUCCIONES.md`: pasos para recoger las 3 capturas reales.

Ejecutar **01 → 02 → 03 → 04 → 05 → 06** usando la cuenta administrativa de práctica. La creación de roles/cuentas y los GRANT exigen permisos suficientes del servidor; las pruebas por perfil requieren tres conexiones independientes.

## Casos clave de verificación

- `fn_valor_alquiler` debe devolver **620000, 2300000, 1080000 y 1202500**, para los ejemplos de clase.
- `sp_crear_reserva` debe cotizar la Hilux de Jorge en **1290000**.
- El cierre de Ricardo debe calcular saldo **60000**.
- El cierre de Paola debe calcular saldo **750000** y registrar un solo daño de **380000**, aplicado al depósito.
- El escenario de Carlos debe mostrar saldo **970000** dentro de una transacción y permitir regresar a estado inicial con `ROLLBACK`.
- La auditoría debe mostrar **0** en sus tres primeras columnas.

**Observación de seguridad:** la contraseña `Practica_2026*` es expresamente de laboratorio y **no debe reutilizarse en producción**. Para evidencia, usar las cuentas del enunciado y luego retirarlas del servidor si no se necesitan.

**Pruebas que deben fallar:** descomentar y ejecutar individualmente las sentencias marcadas `⚠️ ESPERADO`, especialmente las de errores 1142/1143 en perfiles separados. El resto del script se diseñó para no interrumpir la ejecución por esos fallos didácticos.
