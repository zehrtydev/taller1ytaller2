-- Taller 2 · FlotaYa · Fase 5 · Funciones, procedimientos y seguridad.
USE flotaya;
-- fn_prueba_1418: MySQL con binary logging activo y seguridad configurada requiere
-- DETERMINISTIC, NO SQL o READS SQL DATA, o configuración administrativa especial.
-- ⚠️ ESPERADO: ERROR 1418 (en servidor con log_bin y log_bin_trust_function_creators=OFF).
-- DELIMITER $$
-- CREATE FUNCTION fn_prueba_1418() RETURNS INT BEGIN RETURN 1; END $$
-- DELIMITER ;
DROP FUNCTION IF EXISTS fn_edad_conductor;
DELIMITER $$
-- DETERMINISTIC/NO SQL: misma pareja de fechas => misma edad; no consulta tablas.
CREATE FUNCTION fn_edad_conductor(p_nacimiento DATE,p_referencia DATE)
RETURNS INT DETERMINISTIC NO SQL
BEGIN
 RETURN TIMESTAMPDIFF(YEAR,p_nacimiento,p_referencia);
END $$
DELIMITER ;

DROP FUNCTION IF EXISTS fn_valor_alquiler;
DELIMITER $$
-- NOT DETERMINISTIC/READS SQL DATA: tarifas/temporadas pueden cambiar.
CREATE FUNCTION fn_valor_alquiler(p_category_id BIGINT,p_inicio DATE,p_fin DATE)
RETURNS DECIMAL(12,2) NOT DETERMINISTIC READS SQL DATA
BEGIN
 DECLARE v_fecha DATE;
 DECLARE v_tipo VARCHAR(10);
 DECLARE v_precio DECIMAL(12,2);
 DECLARE v_total DECIMAL(12,2) DEFAULT 0;
 DECLARE v_error VARCHAR(128);
 IF p_fin IS NULL OR p_inicio IS NULL OR p_fin<=p_inicio THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='La fecha final debe ser posterior a la inicial';
 END IF;
 SET v_fecha=p_inicio;
 WHILE v_fecha<p_fin DO
  SET v_tipo=(SELECT s.season_type FROM seasons s
   WHERE v_fecha BETWEEN s.start_date AND s.end_date ORDER BY s.id LIMIT 1);
  SET v_precio=(SELECT rt.daily_rate FROM rates rt
   WHERE rt.category_id=p_category_id AND rt.season_type=v_tipo LIMIT 1);
  IF v_tipo IS NULL OR v_precio IS NULL THEN
   SET v_error=CONCAT('No hay temporada o tarifa para el día ',DATE_FORMAT(v_fecha,'%Y-%m-%d'));
   SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT=v_error;
  END IF;
  SET v_total=v_total+v_precio;
  SET v_fecha=DATE_ADD(v_fecha,INTERVAL 1 DAY);
 END WHILE;
 RETURN v_total;
END $$
DELIMITER ;

DROP FUNCTION IF EXISTS fn_licencia_vigente;
DELIMITER $$
-- NOT DETERMINISTIC/READS SQL DATA: la respuesta cambia si se registra otra licencia.
CREATE FUNCTION fn_licencia_vigente(p_customer_id BIGINT,p_fecha DATE)
RETURNS BOOLEAN NOT DETERMINISTIC READS SQL DATA
BEGIN
 RETURN EXISTS(SELECT 1 FROM licenses l WHERE l.customer_id=p_customer_id
  AND l.issued_on<=p_fecha AND l.expires_on>=p_fecha);
END $$
DELIMITER ;
-- Pruebas positivas de las 3 funciones.
SELECT fn_edad_conductor('2004-07-15','2026-07-14') AS antes_cumple,
 fn_edad_conductor('2004-07-15','2026-07-15') AS despues_cumple;
SELECT fn_valor_alquiler(1,'2026-11-27','2026-12-02') AS economico_620000,
 fn_valor_alquiler(5,'2026-12-18','2026-12-23') AS van_2300000,
 fn_valor_alquiler(3,'2026-10-08','2026-10-12') AS suv_1080000,
 fn_valor_alquiler(6,'2026-12-14','2026-12-16') AS lujo_1202500;
-- ⚠️ ESPERADO: ERROR 1644: La fecha final debe ser posterior a la inicial.
-- SELECT fn_valor_alquiler(1,'2026-12-05','2026-12-05');
-- ⚠️ ESPERADO: ERROR 1644: No hay temporada o tarifa para el día 2027-01-16.
-- SELECT fn_valor_alquiler(1,'2027-01-14','2027-01-18');
SELECT fn_licencia_vigente(7,'2026-11-23') AS jorge_si,
 fn_licencia_vigente(8,'2026-11-23') AS paola_si,
 fn_licencia_vigente(8,'2026-12-15') AS paola_no,
 fn_licencia_vigente(9,'2026-12-15') AS esteban_no,
 fn_licencia_vigente(12,'2026-12-15') AS laura_no;
-- Clientes menores de 25 y comparación de edades mínimas.
SELECT CONCAT(c.first_name,' ',c.last_name) AS cliente,c.birth_date AS nacimiento,
 fn_edad_conductor(c.birth_date,'2026-11-23') AS edad,
 IF(fn_edad_conductor(c.birth_date,'2026-11-23')>=23,'Sí','No') AS puede_suv,
 IF(fn_edad_conductor(c.birth_date,'2026-11-23')>=25,'Sí','No') AS puede_4x4_o_van
FROM customers c WHERE fn_edad_conductor(c.birth_date,'2026-11-23')<25
ORDER BY edad,c.id;
-- Clientes sin licencia vigente al 15 de diciembre.
SELECT c.id,CONCAT(c.first_name,' ',c.last_name) AS cliente,
 IF(fn_licencia_vigente(c.id,'2026-11-23'),'Sí','No') AS vigente_al_corte,
 IF(fn_licencia_vigente(c.id,'2026-12-15'),'Sí','No') AS vigente_15_dic
FROM customers c WHERE fn_licencia_vigente(c.id,'2026-12-15')=FALSE ORDER BY c.id;

DROP PROCEDURE IF EXISTS sp_crear_reserva;
DELIMITER $$
-- SQL SECURITY DEFINER (por defecto) permite validar licencias sin GRANT SELECT al asesor.
CREATE DEFINER=CURRENT_USER PROCEDURE sp_crear_reserva(
 IN p_customer_id BIGINT,IN p_vehicle_id BIGINT,IN p_pickup_branch_id BIGINT,
 IN p_return_branch_id BIGINT,IN p_pickup DATE,IN p_return DATE,OUT p_reserva BIGINT)
SQL SECURITY DEFINER
BEGIN
 DECLARE v_estado_cliente VARCHAR(20);
 DECLARE v_estado_vehiculo VARCHAR(25);
 DECLARE v_edad INT;
 DECLARE v_min INT;
 DECLARE v_categoria BIGINT;
 DECLARE v_error VARCHAR(128);
 IF NOT EXISTS(SELECT 1 FROM customers WHERE id=p_customer_id) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El cliente no existe'; END IF;
 SELECT status INTO v_estado_cliente FROM customers WHERE id=p_customer_id;
 IF v_estado_cliente='BLOQUEADO' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El cliente está bloqueado'; END IF;
 IF p_return<=p_pickup OR p_pickup IS NULL OR p_return IS NULL THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='La devolución debe ser posterior a la recogida'; END IF;
 IF NOT EXISTS(SELECT 1 FROM vehicles WHERE id=p_vehicle_id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El vehículo no existe'; END IF;
 SELECT v.status,vc.id,vc.minimum_age INTO v_estado_vehiculo,v_categoria,v_min
 FROM vehicles v JOIN vehicle_models vm ON vm.id=v.model_id
 JOIN vehicle_categories vc ON vc.id=vm.category_id WHERE v.id=p_vehicle_id;
 IF v_estado_vehiculo='FUERA_DE_SERVICIO' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El vehículo está fuera de servicio'; END IF;
 -- Extremos inclusivos: entregar el mismo día de la otra recogida sí se considera cruce.
 IF EXISTS(SELECT 1 FROM reservations r WHERE r.vehicle_id=p_vehicle_id
 AND r.status IN('PENDIENTE','CONFIRMADA','CONVERTIDA')
 AND r.pickup_date<=p_return AND r.return_date>=p_pickup) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El vehículo ya está reservado en esas fechas'; END IF;
 SET v_edad=(SELECT fn_edad_conductor(birth_date,p_pickup) FROM customers WHERE id=p_customer_id);
 IF v_edad<v_min THEN
  SET v_error=CONCAT('El cliente tiene ',v_edad,' años y la categoría exige ',v_min);
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT=v_error;
 END IF;
 -- Se comprueba vigencia de la licencia desde la recogida hasta la devolución.
 IF NOT EXISTS(SELECT 1 FROM licenses l WHERE l.customer_id=p_customer_id AND l.issued_on<=p_pickup
  AND l.expires_on>=p_return) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El cliente no tiene licencia vigente durante todo el alquiler'; END IF;
 INSERT INTO reservations(customer_id,vehicle_id,pickup_branch_id,return_branch_id,pickup_date,return_date,quoted_amount,created_at)
 VALUES(p_customer_id,p_vehicle_id,p_pickup_branch_id,p_return_branch_id,p_pickup,p_return,
 fn_valor_alquiler(v_categoria,p_pickup,p_return),CONCAT(p_pickup,' 08:00:00'));
 SET p_reserva=LAST_INSERT_ID();
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_cerrar_contrato;
DELIMITER $$
CREATE PROCEDURE sp_cerrar_contrato(IN p_contract_id BIGINT,IN p_fecha_cierre DATE,OUT p_saldo DECIMAL(12,2))
BEGIN
 DECLARE v_estado VARCHAR(20);
 DECLARE v_inicio DATE;
 DECLARE v_fin DATE;
 DECLARE v_vehiculo BIGINT;
 DECLARE v_categoria BIGINT;
 DECLARE v_renta DECIMAL(12,2);
 DECLARE v_extras DECIMAL(12,2);
 DECLARE v_danos DECIMAL(12,2);
 DECLARE v_deposito DECIMAL(12,2);
 DECLARE v_aplicar DECIMAL(12,2);
 DECLARE v_pagado DECIMAL(12,2);
 DECLARE v_sede BIGINT;
 DECLARE v_km INT;
 IF NOT EXISTS(SELECT 1 FROM contracts WHERE id=p_contract_id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El contrato no existe'; END IF;
 SELECT status,start_date,vehicle_id INTO v_estado,v_inicio,v_vehiculo FROM contracts WHERE id=p_contract_id;
 IF v_estado<>'ABIERTO' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El contrato no está abierto'; END IF;
 IF NOT EXISTS(SELECT 1 FROM returns WHERE contract_id=p_contract_id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El contrato no tiene devolución registrada'; END IF;
 IF NOT EXISTS(SELECT 1 FROM inspections WHERE contract_id=p_contract_id AND stage='DEVOLUCION') THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Falta la inspección de devolución'; END IF;
 IF p_fecha_cierre<=v_inicio THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='La fecha de cierre debe ser posterior al inicio'; END IF;
 SELECT DATE(occurred_at),branch_id,mileage_km INTO v_fin,v_sede,v_km FROM returns WHERE contract_id=p_contract_id;
 SELECT vm.category_id INTO v_categoria FROM vehicles v JOIN vehicle_models vm ON vm.id=v.model_id WHERE v.id=v_vehiculo;
 SET v_renta=fn_valor_alquiler(v_categoria,v_inicio,v_fin);
 SELECT COALESCE(SUM(ce.quantity*ce.agreed_daily_price*DATEDIFF(v_fin,v_inicio)),0)
 INTO v_extras FROM contract_extras ce WHERE ce.contract_id=p_contract_id;
 SELECT COALESCE(SUM(d.repair_cost),0) INTO v_danos FROM damages d
 JOIN inspections i ON i.id=d.inspection_id WHERE i.contract_id=p_contract_id
 AND i.stage='DEVOLUCION' AND d.charge_customer=TRUE;
 SELECT amount INTO v_deposito FROM deposits WHERE contract_id=p_contract_id;
 SET v_aplicar=LEAST(v_deposito,v_danos);
 IF v_aplicar>0 THEN
  UPDATE deposits SET status='APLICADO',applied_amount=v_aplicar,
  released_at=CONCAT(p_fecha_cierre,' 23:00:00') WHERE contract_id=p_contract_id;
  INSERT INTO payments(contract_id,concept,amount,payment_method,paid_at)
  VALUES(p_contract_id,'DAÑOS',v_aplicar,'DEPOSITO',CONCAT(p_fecha_cierre,' 22:00:00'));
 ELSE
  UPDATE deposits SET status='LIBERADO',released_at=CONCAT(p_fecha_cierre,' 23:00:00')
  WHERE contract_id=p_contract_id;
 END IF;
 UPDATE contracts SET status='CERRADO',actual_return_date=v_fin,rental_amount=v_renta WHERE id=p_contract_id;
 UPDATE vehicles SET status='DISPONIBLE',branch_id=v_sede,mileage_km=v_km WHERE id=v_vehiculo;
 SELECT COALESCE(SUM(amount),0) INTO v_pagado FROM payments WHERE contract_id=p_contract_id;
 SET p_saldo=v_renta+v_extras+v_danos-v_pagado;
END $$
DELIMITER ;
-- Procedimientos: pruebas, positivas y casos que deben fallar.
CALL sp_crear_reserva(7,14,3,3,'2026-12-19','2026-12-22',@nueva_reserva);
SELECT @nueva_reserva AS reserva_jorge,
 (SELECT quoted_amount FROM reservations WHERE id=@nueva_reserva) AS cotizacion; -- 1290000
-- ⚠️ ESPERADO: ERROR 1644: El vehículo ya está reservado en esas fechas.
-- CALL sp_crear_reserva(2,1,1,1,'2026-11-30','2026-12-04',@x);
-- ⚠️ ESPERADO: ERROR 1644: El cliente tiene 22 años y la categoría exige 23.
-- CALL sp_crear_reserva(3,13,4,4,'2026-12-12','2026-12-14',@x);
-- ⚠️ ESPERADO: ERROR 1644: El cliente no tiene licencia vigente durante todo el alquiler.
-- CALL sp_crear_reserva(8,2,2,2,'2026-12-08','2026-12-12',@x);
-- ⚠️ ESPERADO: ERROR 1644: El cliente está bloqueado.
-- CALL sp_crear_reserva(10,2,2,2,'2026-12-01','2026-12-03',@x);
-- ⚠️ ESPERADO: ERROR 1644: El vehículo está fuera de servicio.
-- CALL sp_crear_reserva(1,3,6,6,'2026-12-01','2026-12-03',@x);
-- ⚠️ ESPERADO: ERROR 1644: El contrato no está abierto.
-- CALL sp_cerrar_contrato(9004,'2026-11-23',@x);
-- ⚠️ ESPERADO: ERROR 1644: El contrato no tiene devolución registrada.
-- CALL sp_cerrar_contrato(9003,'2026-11-23',@x);
-- Ricardo: devolución, inspección, cierre, saldo 60000. Test ejecutable.
INSERT INTO returns(contract_id,branch_id,employee_id,occurred_at,mileage_km,fuel_pct)
VALUES(9002,1,12,'2026-11-21 10:00:00',30910,100);
INSERT INTO inspections(contract_id,employee_id,stage,inspected_at,exterior_ok,interior_ok,notes)
VALUES(9002,12,'DEVOLUCION','2026-11-21 10:10:00',TRUE,TRUE,'Sin novedades');
CALL sp_cerrar_contrato(9002,'2026-11-21',@saldo_ricardo);
SELECT @saldo_ricardo AS saldo_ricardo; -- esperado 60000
SELECT co.id,co.status,co.rental_amount,v.plate,v.status AS estado_vehiculo,
 v.branch_id,v.mileage_km,d.status AS deposito FROM contracts co
 JOIN vehicles v ON v.id=co.vehicle_id JOIN deposits d ON d.contract_id=co.id WHERE co.id=9002;

-- Roles y cuentas: privilegio mínimo. Repetible; requiere cuenta administradora MySQL.
DROP USER IF EXISTS 'asesor_flotaya'@'localhost';
DROP USER IF EXISTS 'taller_flotaya'@'localhost';
DROP USER IF EXISTS 'auditor_flotaya'@'localhost';
DROP ROLE IF EXISTS 'rol_asesor_flotaya';
DROP ROLE IF EXISTS 'rol_taller_flotaya';
DROP ROLE IF EXISTS 'rol_auditor_flotaya';
CREATE ROLE 'rol_asesor_flotaya','rol_taller_flotaya','rol_auditor_flotaya';
GRANT SELECT ON flotaya.reservations TO 'rol_asesor_flotaya';
GRANT UPDATE (status) ON flotaya.reservations TO 'rol_asesor_flotaya';
GRANT SELECT ON flotaya.customers TO 'rol_asesor_flotaya';
GRANT SELECT ON flotaya.vehicles TO 'rol_asesor_flotaya';
GRANT EXECUTE ON PROCEDURE flotaya.sp_crear_reserva TO 'rol_asesor_flotaya';
GRANT EXECUTE ON FUNCTION flotaya.fn_valor_alquiler TO 'rol_asesor_flotaya';
GRANT SELECT,INSERT,UPDATE ON flotaya.maintenances TO 'rol_taller_flotaya';
GRANT SELECT (id,plate,status,mileage_km,branch_id) ON flotaya.vehicles TO 'rol_taller_flotaya';
GRANT UPDATE (status) ON flotaya.vehicles TO 'rol_taller_flotaya';
GRANT SELECT ON flotaya.contracts TO 'rol_auditor_flotaya';
GRANT SELECT ON flotaya.reservations TO 'rol_auditor_flotaya';
GRANT SELECT ON flotaya.vehicles TO 'rol_auditor_flotaya';
GRANT SELECT ON flotaya.maintenances TO 'rol_auditor_flotaya';
GRANT SELECT ON flotaya.returns TO 'rol_auditor_flotaya';
GRANT SELECT ON flotaya.inspections TO 'rol_auditor_flotaya';
GRANT SELECT ON flotaya.damages TO 'rol_auditor_flotaya';
GRANT SELECT ON flotaya.deposits TO 'rol_auditor_flotaya';
GRANT SELECT (id,contract_id,concept,amount,paid_at) ON flotaya.payments TO 'rol_auditor_flotaya';
CREATE USER 'asesor_flotaya'@'localhost' IDENTIFIED BY 'Practica_2026*';
CREATE USER 'taller_flotaya'@'localhost' IDENTIFIED BY 'Practica_2026*';
CREATE USER 'auditor_flotaya'@'localhost' IDENTIFIED BY 'Practica_2026*';
GRANT 'rol_asesor_flotaya' TO 'asesor_flotaya'@'localhost';
GRANT 'rol_taller_flotaya' TO 'taller_flotaya'@'localhost';
GRANT 'rol_auditor_flotaya' TO 'auditor_flotaya'@'localhost';
SET DEFAULT ROLE 'rol_asesor_flotaya' TO 'asesor_flotaya'@'localhost';
SET DEFAULT ROLE 'rol_taller_flotaya' TO 'taller_flotaya'@'localhost';
SET DEFAULT ROLE 'rol_auditor_flotaya' TO 'auditor_flotaya'@'localhost';
SHOW GRANTS FOR 'rol_taller_flotaya';
SHOW GRANTS FOR 'asesor_flotaya'@'localhost';
-- SET ROLE NONE / SET ROLE DEFAULT en una conexión de asesor muestran la diferencia.
-- Para capturas reales: abrir tres conexiones (127.0.0.1, cada usuario, clave de práctica).
-- Como asesor_flotaya: ejecutar separado y guardar captura de éxito y error.
-- SELECT CURRENT_USER(),USER(),CURRENT_ROLE(); SHOW TABLES;
-- CALL sp_crear_reserva(14,13,4,4,'2026-12-12','2026-12-15',@reserva_sofia);
-- SELECT @reserva_sofia; -- 810000
-- UPDATE reservations SET status='CONFIRMADA' WHERE id=@reserva_sofia;
-- ⚠️ ESPERADO: ERROR 1142
-- SELECT * FROM payments;
-- ⚠️ ESPERADO: ERROR 1142
-- DELETE FROM reservations WHERE id=@reserva_sofia;
-- ⚠️ ESPERADO: ERROR 1142
-- SELECT COUNT(*) FROM licenses;
-- Como taller_flotaya:
-- SELECT CURRENT_USER(),USER(),CURRENT_ROLE(); SHOW TABLES;
-- SELECT * FROM maintenances WHERE id=1;
-- UPDATE maintenances SET end_date='2026-11-23',cost=1850000 WHERE id=1;
-- UPDATE vehicles SET status='DISPONIBLE' WHERE id=15;
-- INSERT INTO maintenances(vehicle_id,maintenance_type,description,workshop,start_date,end_date,cost)
-- VALUES(13,'PREVENTIVO','Alineación y balanceo','Taller FlotaYa Bogotá','2026-11-23','2026-11-23',120000);
-- ⚠️ ESPERADO: ERROR 1142
-- SELECT * FROM vehicles;
-- ⚠️ ESPERADO: ERROR 1143
-- UPDATE vehicles SET mileage_km=90000 WHERE id=15;
-- ⚠️ ESPERADO: ERROR 1142
-- SELECT COUNT(*) FROM contracts;
-- Como auditor_flotaya:
-- SELECT CURRENT_USER(),USER(),CURRENT_ROLE(); SHOW TABLES;
-- SELECT id,contract_id,concept,amount,paid_at FROM payments WHERE contract_id=9006;
-- SELECT status,COUNT(*) FROM contracts GROUP BY status;
-- ⚠️ ESPERADO: ERROR 1143
-- SELECT card_last4 FROM payments;
-- ⚠️ ESPERADO: ERROR 1142
-- SELECT * FROM payments;
-- ⚠️ ESPERADO: ERROR 1142
-- UPDATE contracts SET status='ABIERTO' WHERE id=9006;
-- ⚠️ ESPERADO: ERROR 1142
-- SELECT COUNT(*) FROM customers;
-- Respuestas:
-- 1) SQL SECURITY DEFINER ejecuta con privilegios del DEFINER, no del INVOKER.
--    Riesgo: un procedimiento inseguro podría elevar permisos; validar argumentos y evitar SQL dinámico.
-- 2) SELECT * exige SELECT de todas las columnas, por eso puede informar 1142;
--    una columna concreta no autorizada suele devolver 1143.
-- 3) Sin rol activo no se aplican sus GRANT; SET ROLE DEFAULT lo recupera.
