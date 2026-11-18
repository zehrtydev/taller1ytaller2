-- Taller 1 · BiblioRed · Fase 5: exclusivamente PROCEDIMIENTOS.
USE bibliored;
DROP PROCEDURE IF EXISTS sp_resumen_socio;
DELIMITER $$
CREATE PROCEDURE sp_resumen_socio(IN p_member_id BIGINT)
BEGIN
 IF NOT EXISTS(SELECT 1 FROM members WHERE id=p_member_id) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El socio no existe';
 END IF;
 SELECT m.id,CONCAT(m.first_name,' ',m.last_name) AS socio,
 (SELECT COUNT(*) FROM loans l WHERE l.member_id=m.id AND l.status='ACTIVO') AS prestamos_activos,
 COALESCE((SELECT SUM(f.amount-COALESCE(p.abonos,0)) FROM loans l
 JOIN fines f ON f.loan_id=l.id AND f.status='PENDIENTE'
 LEFT JOIN (SELECT fine_id,SUM(amount) abonos FROM fine_payments GROUP BY fine_id) p ON p.fine_id=f.id
 WHERE l.member_id=m.id),0) AS deuda_pendiente
 FROM members m WHERE m.id=p_member_id;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_prestar_ejemplar;
DELIMITER $$
CREATE PROCEDURE sp_prestar_ejemplar(IN p_copy_id BIGINT,IN p_member_id BIGINT,
 IN p_employee_id BIGINT,IN p_fecha DATE,OUT p_loan_id BIGINT)
BEGIN
 DECLARE v_estado_socio VARCHAR(20);
 DECLARE v_estado_copia VARCHAR(20);
 DECLARE v_max INT;
 DECLARE v_dias INT;
 DECLARE v_activos INT;
 DECLARE v_error VARCHAR(128);
 IF NOT EXISTS(SELECT 1 FROM members WHERE id=p_member_id) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El socio no existe';
 END IF;
 SELECT m.status,mt.max_loans,mt.loan_days INTO v_estado_socio,v_max,v_dias
 FROM members m JOIN membership_types mt ON mt.id=m.membership_type_id WHERE m.id=p_member_id;
 IF v_estado_socio<>'ACTIVO' THEN
  SET v_error=CONCAT('El socio no está activo: ',v_estado_socio);
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT=v_error;
 END IF;
 IF NOT EXISTS(SELECT 1 FROM copies WHERE id=p_copy_id) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El ejemplar no existe';
 END IF;
 SELECT status INTO v_estado_copia FROM copies WHERE id=p_copy_id;
 IF v_estado_copia<>'DISPONIBLE' THEN
  SET v_error=CONCAT('El ejemplar no está disponible: ',v_estado_copia);
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT=v_error;
 END IF;
 IF EXISTS(SELECT 1 FROM loans l JOIN fines f ON f.loan_id=l.id
  WHERE l.member_id=p_member_id AND f.status='PENDIENTE') THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El socio tiene multas pendientes';
 END IF;
 SELECT COUNT(*) INTO v_activos FROM loans WHERE member_id=p_member_id AND status='ACTIVO';
 IF v_activos>=v_max THEN
  SET v_error=CONCAT('El socio alcanzó su tope de ',v_max,' préstamos');
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT=v_error;
 END IF;
 -- Deliberadamente no hay transacción aquí: fase TCL estudia la anomalía.
 UPDATE copies SET status='PRESTADO' WHERE id=p_copy_id;
 INSERT INTO loans(copy_id,member_id,employee_id,loan_date,due_date)
 VALUES(p_copy_id,p_member_id,p_employee_id,p_fecha,DATE_ADD(p_fecha,INTERVAL v_dias DAY));
 SET p_loan_id=LAST_INSERT_ID();
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_devolver_ejemplar;
DELIMITER $$
CREATE PROCEDURE sp_devolver_ejemplar(IN p_loan_id BIGINT,IN p_fecha DATE,OUT p_multa DECIMAL(12,2))
BEGIN
 DECLARE v_estado VARCHAR(20);
 DECLARE v_inicio DATE;
 DECLARE v_vence DATE;
 DECLARE v_copy BIGINT;
 DECLARE v_tarifa DECIMAL(10,2);
 DECLARE v_mora INT;
 IF NOT EXISTS(SELECT 1 FROM loans WHERE id=p_loan_id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El préstamo no existe'; END IF;
 SELECT l.status,l.loan_date,l.due_date,l.copy_id,mt.daily_fine
 INTO v_estado,v_inicio,v_vence,v_copy,v_tarifa
 FROM loans l JOIN members m ON m.id=l.member_id JOIN membership_types mt ON mt.id=m.membership_type_id WHERE l.id=p_loan_id;
 IF v_estado<>'ACTIVO' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El préstamo no está activo'; END IF;
 IF p_fecha<v_inicio THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='La fecha de devolución es anterior al préstamo'; END IF;
 SET v_mora=GREATEST(DATEDIFF(p_fecha,v_vence),0);
 SET p_multa=v_mora*v_tarifa;
 IF p_multa>0 THEN
  INSERT INTO fines(loan_id,reason,fine_days,amount,generated_on) VALUES(p_loan_id,'MORA',v_mora,p_multa,p_fecha);
 END IF;
 UPDATE loans SET status='DEVUELTO',returned_on=p_fecha WHERE id=p_loan_id;
 UPDATE copies SET status='DISPONIBLE' WHERE id=v_copy;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_renovar_prestamo;
DELIMITER $$
CREATE PROCEDURE sp_renovar_prestamo(IN p_loan_id BIGINT,IN p_fecha DATE,OUT p_nuevo_vence DATE)
BEGIN
 DECLARE v_estado VARCHAR(20);
 DECLARE v_vence DATE;
 DECLARE v_dias INT;
 DECLARE v_max INT;
 DECLARE v_total INT;
 DECLARE v_titulo BIGINT;
 DECLARE v_error VARCHAR(128);
 IF NOT EXISTS(SELECT 1 FROM loans WHERE id=p_loan_id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El préstamo no existe'; END IF;
 SELECT l.status,l.due_date,mt.loan_days,mt.max_renewals,c.title_id
 INTO v_estado,v_vence,v_dias,v_max,v_titulo
 FROM loans l JOIN members m ON m.id=l.member_id JOIN membership_types mt ON mt.id=m.membership_type_id
 JOIN copies c ON c.id=l.copy_id WHERE l.id=p_loan_id;
 IF v_estado<>'ACTIVO' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El préstamo no está activo'; END IF;
 IF p_fecha>v_vence THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El préstamo está vencido: primero debe devolverse'; END IF;
 SELECT COUNT(*) INTO v_total FROM renewals WHERE loan_id=p_loan_id;
 IF v_total>=v_max THEN SET v_error=CONCAT('El préstamo ya usó sus ',v_max,' renovaciones');
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT=v_error; END IF;
 IF EXISTS(SELECT 1 FROM reservations WHERE title_id=v_titulo AND status='PENDIENTE') THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Hay reservas pendientes para este título'; END IF;
 SET p_nuevo_vence=DATE_ADD(v_vence,INTERVAL v_dias DAY);
 INSERT INTO renewals(loan_id,renewed_on,old_due_date,new_due_date) VALUES(p_loan_id,p_fecha,v_vence,p_nuevo_vence);
 UPDATE loans SET due_date=p_nuevo_vence WHERE id=p_loan_id;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_reporte_sedes;
DELIMITER $$
CREATE PROCEDURE sp_reporte_sedes(IN p_fecha DATE)
BEGIN
 DECLARE v_fin INT DEFAULT 0;
 DECLARE v_id BIGINT;
 DECLARE v_nombre VARCHAR(100);
 DECLARE v_total INT;
 DECLARE v_activos INT;
 DECLARE v_error VARCHAR(128);
 DECLARE v_vencidos INT;
 DECLARE v_cursor CURSOR FOR SELECT id,name FROM branches ORDER BY id;
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_fin=1;
 DROP TEMPORARY TABLE IF EXISTS tmp_reporte_sedes;
 CREATE TEMPORARY TABLE tmp_reporte_sedes(sede VARCHAR(100),ejemplares INT,prestados INT,vencidos INT,ocupacion_pct DECIMAL(7,2));
 OPEN v_cursor;
 ciclo: LOOP
  FETCH v_cursor INTO v_id,v_nombre;
  IF v_fin=1 THEN LEAVE ciclo; END IF;
  SELECT COUNT(*) INTO v_total FROM copies WHERE branch_id=v_id AND status NOT IN('PERDIDO','DADO_DE_BAJA');
  SELECT COUNT(*) INTO v_activos FROM loans l JOIN copies c ON c.id=l.copy_id WHERE c.branch_id=v_id AND l.status='ACTIVO';
  SELECT COUNT(*) INTO v_vencidos FROM loans l JOIN copies c ON c.id=l.copy_id
  WHERE c.branch_id=v_id AND l.status='ACTIVO' AND l.due_date<p_fecha;
  INSERT INTO tmp_reporte_sedes VALUES(v_nombre,v_total,v_activos,v_vencidos,
   CASE WHEN v_total=0 THEN NULL ELSE ROUND(v_activos*100/v_total,2) END);
 END LOOP;
 CLOSE v_cursor;
 SELECT sede,ejemplares,prestados,vencidos,ocupacion_pct FROM tmp_reporte_sedes ORDER BY ocupacion_pct DESC,sede;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_pagar_multa;
DELIMITER $$
CREATE PROCEDURE sp_pagar_multa(IN p_fine_id BIGINT,IN p_valor DECIMAL(12,2),
 IN p_medio VARCHAR(30),IN p_fecha DATE,OUT p_saldo DECIMAL(12,2))
BEGIN
 DECLARE v_estado VARCHAR(20);
 DECLARE v_total DECIMAL(12,2);
 DECLARE v_pagado DECIMAL(12,2);
 -- El ENUM del pago rechaza CHEQUE; el handler traduce el error de columna.
 DECLARE v_medio_invalido BOOL DEFAULT FALSE;
 DECLARE CONTINUE HANDLER FOR 1265 SET v_medio_invalido=TRUE;
 IF NOT EXISTS(SELECT 1 FROM fines WHERE id=p_fine_id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='La multa no existe'; END IF;
 SELECT status,amount INTO v_estado,v_total FROM fines WHERE id=p_fine_id;
 IF v_estado<>'PENDIENTE' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='La multa no está pendiente'; END IF;
 SELECT COALESCE(SUM(amount),0) INTO v_pagado FROM fine_payments WHERE fine_id=p_fine_id;
 SET p_saldo=v_total-v_pagado;
 IF p_valor IS NULL OR p_valor<=0 OR p_valor>p_saldo THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El abono debe ser mayor que 0 y no superar el saldo'; END IF;
 INSERT INTO fine_payments(fine_id,amount,paid_on,method) VALUES(p_fine_id,p_valor,p_fecha,p_medio);
 IF v_medio_invalido THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Medio de pago no válido: use EFECTIVO, TARJETA o TRANSFERENCIA';
 END IF;
 SET p_saldo=p_saldo-p_valor;
 IF p_saldo=0 THEN UPDATE fines SET status='PAGADA' WHERE id=p_fine_id; END IF;
END $$
DELIMITER ;

-- Pruebas positivas; fallos intencionales, ejecutar UNA A UNA (comentados para reproducibilidad).
-- sp_resumen_socio · pruebas 1,2,3
CALL sp_resumen_socio(10);
CALL sp_resumen_socio(1);
-- ⚠️ ESPERADO: ERROR 1644: El socio no existe
-- CALL sp_resumen_socio(999);
-- sp_prestar_ejemplar · pruebas 1 a 6
CALL sp_prestar_ejemplar(14,12,2,'2026-11-10',@prestamo_creado);
SELECT @prestamo_creado AS prestamo_creado;
-- ⚠️ ESPERADO: ERROR 1644: El socio no está activo: SUSPENDIDO
-- CALL sp_prestar_ejemplar(15,10,2,'2026-11-10',@x);
-- ⚠️ ESPERADO: ERROR 1644: El ejemplar no está disponible: PRESTADO
-- CALL sp_prestar_ejemplar(1,13,2,'2026-11-10',@x);
-- ⚠️ ESPERADO: ERROR 1644: El socio tiene multas pendientes
-- CALL sp_prestar_ejemplar(15,16,2,'2026-11-10',@x);
-- ⚠️ ESPERADO: ERROR 1644: El socio alcanzó su tope de 2 préstamos
-- CALL sp_prestar_ejemplar(15,1,2,'2026-11-10',@x);
-- ⚠️ ESPERADO: ERROR 1644: El ejemplar no existe
-- CALL sp_prestar_ejemplar(999,13,2,'2026-11-10',@x);
-- sp_devolver_ejemplar · pruebas 1,2 y negativas 3,4
CALL sp_devolver_ejemplar(1007,'2026-11-10',@mora_1);
SELECT @mora_1 AS multa_generada; -- 13 * 300 = 3900
CALL sp_devolver_ejemplar(1003,'2026-11-10',@mora_2);
SELECT @mora_2 AS sin_mora; -- 0
-- ⚠️ ESPERADO: ERROR 1644: El préstamo no está activo
-- CALL sp_devolver_ejemplar(1012,'2026-11-10',@x);
-- ⚠️ ESPERADO: ERROR 1644: La fecha de devolución es anterior al préstamo
-- CALL sp_devolver_ejemplar(1002,'2026-10-01',@x);
-- sp_renovar_prestamo · pruebas
CALL sp_renovar_prestamo(1004,'2026-11-10',@nuevo_vencimiento);
SELECT @nuevo_vencimiento AS nuevo_vencimiento;
-- ⚠️ ESPERADO: ERROR 1644: El préstamo ya usó sus 2 renovaciones
-- CALL sp_renovar_prestamo(1010,'2026-11-10',@x);
-- ⚠️ ESPERADO: ERROR 1644: El préstamo está vencido: primero debe devolverse
-- CALL sp_renovar_prestamo(1005,'2026-11-10',@x);
-- ⚠️ ESPERADO: ERROR 1644: Hay reservas pendientes para este título
-- CALL sp_renovar_prestamo(1009,'2026-11-10',@x);
CALL sp_reporte_sedes('2026-11-10'); -- incluye Tabio con NULL en ocupación
-- sp_pagar_multa · pruebas: saldo completo, préstamo reintentado, abono, errores.
CALL sp_pagar_multa(6,68000,'EFECTIVO','2026-11-10',@saldo_1);
SELECT @saldo_1 AS saldo_restante;
CALL sp_prestar_ejemplar(15,16,2,'2026-11-10',@nuevo_sin_deuda);
CALL sp_pagar_multa(4,500,'TARJETA','2026-11-10',@saldo_2);
SELECT @saldo_2 AS saldo_restante;
-- ⚠️ ESPERADO: ERROR 1644: La multa no está pendiente
-- CALL sp_pagar_multa(2,100,'TARJETA','2026-11-10',@x);
-- ⚠️ ESPERADO: ERROR 1644: El abono debe ser mayor que 0 y no superar el saldo
-- CALL sp_pagar_multa(4,50000,'EFECTIVO','2026-11-10',@x);
-- ⚠️ ESPERADO: ERROR 1644: Medio de pago no válido: use EFECTIVO, TARJETA o TRANSFERENCIA
-- CALL sp_pagar_multa(4,100,'CHEQUE','2026-11-10',@x);
SHOW PROCEDURE STATUS WHERE Db='bibliored'; -- 6 procedimientos
