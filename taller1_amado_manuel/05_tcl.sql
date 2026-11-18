-- Taller 1 · Fase 6: estudiar anomalía de ejecución y corregir con TCL.
USE bibliored;
-- T1 · sin transacción, el UPDATE de copies se confirma incluso si el INSERT falla por FK.
SELECT id,barcode,status FROM copies WHERE id=16;
-- ⚠️ ESPERADO: ERROR 1452 (empleado 999 inexistente); ejecutar aislada.
-- CALL sp_prestar_ejemplar(16,13,999,'2026-11-10',@fallido);
-- DESPUÉS DE EJECUTAR ESA LLAMADA, ejecutar las consultas siguientes y reparar:
SELECT c.id,c.barcode FROM copies c LEFT JOIN loans l ON l.copy_id=c.id AND l.status='ACTIVO'
WHERE c.status='PRESTADO' AND l.id IS NULL;
-- SELECT previo a UPDATE; con la llamada comentada, ya está DISPONIBLE.
SELECT id,barcode,status FROM copies WHERE id=16;
UPDATE copies SET status='DISPONIBLE' WHERE id=16 AND status='PRESTADO';
SELECT id,barcode,status FROM copies WHERE id=16;
-- T1 · con transacción: descomentar CALL aislada y ROLLBACK manual después de ver estado.
START TRANSACTION;
SELECT id,barcode,status FROM copies WHERE id=16;
-- ⚠️ ESPERADO: ERROR 1452; ejecutar aislada DENTRO de esta transacción.
-- CALL sp_prestar_ejemplar(16,13,999,'2026-11-10',@fallido_tx);
SELECT id,barcode,status FROM copies WHERE id=16;
ROLLBACK;
SELECT id,barcode,status FROM copies WHERE id=16;
-- Respuesta T1: sin START TRANSACTION cada UPDATE se confirma con autocommit;
-- la falla posterior del INSERT no revierte una sentencia ya confirmada.

DROP PROCEDURE IF EXISTS sp_prestar_ejemplar_tx;
DELIMITER $$
CREATE PROCEDURE sp_prestar_ejemplar_tx(IN p_copy_id BIGINT,IN p_member_id BIGINT,
 IN p_employee_id BIGINT,IN p_fecha DATE,OUT p_loan_id BIGINT)
BEGIN
 DECLARE EXIT HANDLER FOR SQLEXCEPTION
 BEGIN
  ROLLBACK;
  RESIGNAL;
 END;
 START TRANSACTION;
 CALL sp_prestar_ejemplar(p_copy_id,p_member_id,p_employee_id,p_fecha,p_loan_id);
 COMMIT;
END $$
DELIMITER ;
-- T2: conteo antes y después. Errores aislados y comentados para no parar el archivo.
SELECT COUNT(*) AS prestamos_antes FROM loans;
-- ⚠️ ESPERADO: ERROR 1452; id 16 queda DISPONIBLE.
-- CALL sp_prestar_ejemplar_tx(16,13,999,'2026-11-10',@x);
SELECT id,status FROM copies WHERE id=16;
-- ⚠️ ESPERADO: ERROR 1644: El ejemplar no está disponible: PRESTADO.
-- CALL sp_prestar_ejemplar_tx(1,13,2,'2026-11-10',@x);
CALL sp_prestar_ejemplar_tx(16,13,2,'2026-11-10',@t2_prestamo);
SELECT @t2_prestamo AS nuevo_prestamo;
SELECT COUNT(*) AS prestamos_despues FROM loans;
SELECT (SELECT COUNT(*) FROM copies WHERE status='PRESTADO') AS ejemplares_prestados,
       (SELECT COUNT(*) FROM loans WHERE status='ACTIVO') AS prestamos_activos;
-- Respuesta T2: los valores AUTO_INCREMENT consumidos por INSERT que falla
-- no se recuperan por ROLLBACK; la numeración puede presentar huecos.
