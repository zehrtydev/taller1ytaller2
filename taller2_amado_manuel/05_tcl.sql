-- Taller 2 · FlotaYa · Fase 6 · TCL. Ejecutar completo tras 01–04 como admin.
USE flotaya;
-- 6.1: Paola / SPT601. Todo dentro de una sola transacción.
SELECT co.id,co.status,v.plate,v.status AS vehiculo,d.status AS deposito,
 (SELECT COUNT(*) FROM payments p WHERE p.contract_id=co.id) AS pagos
FROM contracts co JOIN vehicles v ON v.id=co.vehicle_id JOIN deposits d ON d.contract_id=co.id WHERE co.id=9001;
START TRANSACTION;
INSERT INTO returns(contract_id,branch_id,employee_id,occurred_at,mileage_km,fuel_pct)
VALUES(9001,2,5,'2026-11-23 09:30:00',12480,100);
INSERT INTO inspections(contract_id,employee_id,stage,inspected_at,exterior_ok,interior_ok,notes)
VALUES(9001,5,'DEVOLUCION','2026-11-23 09:40:00',FALSE,TRUE,'Rin delantero izquierdo rayado');
SET @inspeccion_paola=LAST_INSERT_ID(); -- Guardar ANTES de los siguientes INSERT.
SAVEPOINT antes_dano;
INSERT INTO damages(inspection_id,description,severity,repair_cost,charge_customer)
VALUES(@inspeccion_paola,'Rin delantero izquierdo rayado','LEVE',3800000,TRUE);
SELECT * FROM damages WHERE inspection_id=@inspeccion_paola; -- error visible: 3800000
ROLLBACK TO SAVEPOINT antes_dano;
INSERT INTO damages(inspection_id,description,severity,repair_cost,charge_customer)
VALUES(@inspeccion_paola,'Rin delantero izquierdo rayado','LEVE',380000,TRUE);
CALL sp_cerrar_contrato(9001,'2026-11-23',@saldo_paola);
SELECT @saldo_paola AS saldo_cierre; -- 750000
INSERT INTO payments(contract_id,concept,amount,payment_method,paid_at,card_last4,authorization_code)
VALUES(9001,'CIERRE',@saldo_paola,'TARJETA','2026-11-23 10:00:00','3307','AUT-580114');
COMMIT;
SELECT co.id,co.status,co.rental_amount,v.plate,v.status AS vehiculo,v.mileage_km,
 d.status AS deposito,d.applied_amount,
 (SELECT COUNT(*) FROM payments p WHERE p.contract_id=co.id) AS pagos,
 (SELECT COUNT(*) FROM damages da JOIN inspections i ON i.id=da.inspection_id
 WHERE i.contract_id=co.id AND i.stage='DEVOLUCION') AS danos_devolucion
FROM contracts co JOIN vehicles v ON v.id=co.vehicle_id JOIN deposits d ON d.contract_id=co.id WHERE co.id=9001;
-- Si se usa LAST_INSERT_ID() después del INSERT de daño equivocado (en vez de
-- @inspeccion_paola), se obtendría el ID del daño, NO el ID de inspección;
-- se asociaría al registro equivocado o fallaría la FK.

-- 6.2: Carlos / MZD402. Se revierte todo después del intento de pago con CHEQUE.
SELECT co.id,co.status,v.plate,v.status AS vehiculo,d.status AS deposito
FROM contracts co JOIN vehicles v ON v.id=co.vehicle_id JOIN deposits d ON d.contract_id=co.id WHERE co.id=9003;
START TRANSACTION;
INSERT INTO returns(contract_id,branch_id,employee_id,occurred_at,mileage_km,fuel_pct)
VALUES(9003,4,8,'2026-11-23 18:00:00',26950,50);
INSERT INTO inspections(contract_id,employee_id,stage,inspected_at,exterior_ok,interior_ok,notes)
VALUES(9003,8,'DEVOLUCION','2026-11-23 18:10:00',TRUE,TRUE,'Sin novedades');
CALL sp_cerrar_contrato(9003,'2026-11-23',@saldo_carlos);
SELECT @saldo_carlos AS saldo_carlos; -- 970000
-- ⚠️ ESPERADO: ERROR 1265 (ENUM no admite CHEQUE). Ejecutar aislada, ANTES del ROLLBACK:
-- INSERT INTO payments(contract_id,concept,amount,payment_method,paid_at)
-- VALUES(9003,'CIERRE',@saldo_carlos,'CHEQUE','2026-11-23 18:20:00');
SELECT co.id,co.status,v.status AS estado_vehiculo,d.status AS deposito,
 (SELECT COUNT(*) FROM returns r WHERE r.contract_id=co.id) AS devoluciones
FROM contracts co JOIN vehicles v ON v.id=co.vehicle_id JOIN deposits d ON d.contract_id=co.id WHERE co.id=9003;
ROLLBACK;
SELECT co.id,co.status,v.status AS estado_vehiculo,d.status AS deposito,
 (SELECT COUNT(*) FROM returns r WHERE r.contract_id=co.id) AS devoluciones,
 (SELECT COUNT(*) FROM inspections i WHERE i.contract_id=co.id AND i.stage='DEVOLUCION') AS inspecciones
FROM contracts co JOIN vehicles v ON v.id=co.vehicle_id JOIN deposits d ON d.contract_id=co.id WHERE co.id=9003;

-- 6.3: auditoría, tres primeras columnas = 0.
SELECT
 (SELECT COUNT(*) FROM vehicles v WHERE v.status='ALQUILADO'
  AND NOT EXISTS(SELECT 1 FROM contracts co WHERE co.vehicle_id=v.id AND co.status='ABIERTO')) AS alquilados_sin_contrato,
 (SELECT COUNT(*) FROM contracts co WHERE co.status='CERRADO'
  AND NOT EXISTS(SELECT 1 FROM returns r WHERE r.contract_id=co.id)) AS cerrados_sin_devolucion,
 (SELECT COUNT(*) FROM contracts co JOIN deposits d ON d.contract_id=co.id
  WHERE co.status='CERRADO' AND d.status='RETENIDO') AS depositos_retenidos_de_cerrados,
 (SELECT COUNT(*) FROM contracts WHERE status='ABIERTO') AS contratos_abiertos,
 (SELECT COUNT(*) FROM payments) AS pagos;
