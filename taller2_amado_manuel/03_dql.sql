-- Taller 2 · FlotaYa · Fase 4 · Fecha de corte fija: 2026-11-23
USE flotaya;
-- Q-01
SELECT status AS estado,COUNT(*) AS vehiculos FROM vehicles GROUP BY status ORDER BY vehiculos DESC,estado;
-- Q-02
SELECT name AS temporada,start_date AS desde,end_date AS hasta,DATEDIFF(end_date,start_date)+1 AS dias
FROM seasons WHERE season_type='ALTA' ORDER BY start_date;
-- Q-03
SELECT v.plate AS placa,br.name AS marca,vm.name AS modelo,vc.name AS categoria,
 b.name AS sede,ci.name AS ciudad
FROM vehicles v JOIN vehicle_models vm ON vm.id=v.model_id JOIN brands br ON br.id=vm.brand_id
JOIN vehicle_categories vc ON vc.id=vm.category_id JOIN branches b ON b.id=v.branch_id
JOIN cities ci ON ci.id=b.city_id WHERE v.status='DISPONIBLE' ORDER BY vc.id,v.plate;
-- Q-04
SELECT co.id AS contrato,CONCAT(cu.first_name,' ',cu.last_name) AS cliente,v.plate AS placa,
 vm.name AS modelo,b.name AS sede_recogida,co.expected_end_date AS fin_esperado,
 DATEDIFF(co.expected_end_date,'2026-11-23') AS dias_para_devolver,
 (SELECT COUNT(*) FROM contract_drivers cd WHERE cd.contract_id=co.id) AS conductores_adicionales
FROM contracts co JOIN reservations r ON r.id=co.reservation_id JOIN customers cu ON cu.id=r.customer_id
JOIN vehicles v ON v.id=co.vehicle_id JOIN vehicle_models vm ON vm.id=v.model_id
JOIN branches b ON b.id=r.pickup_branch_id WHERE co.status='ABIERTO'
ORDER BY dias_para_devolver,co.id;
-- Q-05: COUNT DISTINCT evita multiplicación de contratos con múltiples pagos.
SELECT b.name AS sede,COUNT(DISTINCT co.id) AS contratos,SUM(p.amount) AS recaudado
FROM payments p JOIN contracts co ON co.id=p.contract_id JOIN reservations r ON r.id=co.reservation_id
JOIN branches b ON b.id=r.pickup_branch_id GROUP BY b.id,b.name HAVING SUM(p.amount)>2000000
ORDER BY recaudado DESC,sede;
-- Q-06
SELECT b.name AS marca,vm.name AS modelo FROM vehicle_models vm JOIN brands b ON b.id=vm.brand_id
WHERE NOT EXISTS(SELECT 1 FROM vehicles v WHERE v.model_id=vm.id) ORDER BY b.name,vm.name;
-- Q-07
SELECT cu.id,CONCAT(cu.first_name,' ',cu.last_name) AS cliente FROM customers cu
WHERE NOT EXISTS(SELECT 1 FROM licenses l WHERE l.customer_id=cu.id
 AND l.issued_on<='2026-11-23' AND l.expires_on>='2026-11-23') ORDER BY cu.id;
-- Q-08: las dos fechas extremas cuentan para el solapamiento de reservas.
SELECT v.plate AS placa,vm.name AS modelo,b.name AS sede
FROM vehicles v JOIN vehicle_models vm ON vm.id=v.model_id JOIN branches b ON b.id=v.branch_id
WHERE v.status='DISPONIBLE' AND NOT EXISTS(SELECT 1 FROM reservations r WHERE r.vehicle_id=v.id
 AND r.status IN('PENDIENTE','CONFIRMADA','CONVERTIDA')
 AND r.pickup_date<='2026-12-31' AND r.return_date>='2026-12-01') ORDER BY v.plate;
-- Q-09: mantenimiento sin costo cuenta como vehículo, no como dinero.
SELECT t.plate AS placa,t.gasto AS gasto FROM (
 SELECT v.id,v.plate,SUM(COALESCE(m.cost,0)) AS gasto FROM vehicles v
 JOIN maintenances m ON m.vehicle_id=v.id GROUP BY v.id,v.plate) t
WHERE t.gasto>(SELECT AVG(x.gasto) FROM (
 SELECT SUM(COALESCE(m.cost,0)) AS gasto FROM maintenances m GROUP BY m.vehicle_id) x)
ORDER BY t.gasto DESC,t.plate;
SELECT ROUND(AVG(x.gasto),2) AS promedio_por_vehiculo,COUNT(*) AS vehiculos,
 SUM(x.con_gasto>0) AS con_gasto FROM (
 SELECT m.vehicle_id,SUM(COALESCE(m.cost,0)) AS gasto,COUNT(m.cost) AS con_gasto
 FROM maintenances m GROUP BY m.vehicle_id) x;
-- En curso: registra vehículo en denominador, pero costo NULL suma 0; aún no constituye gasto conocido.
-- Q-10: MAX correlacionado incluye empates, Lujo sin vehículos no aparece.
SELECT vc.name AS categoria,v.plate AS placa,v.mileage_km AS kilometraje
FROM vehicles v JOIN vehicle_models vm ON vm.id=v.model_id JOIN vehicle_categories vc ON vc.id=vm.category_id
WHERE v.mileage_km=(SELECT MAX(v2.mileage_km) FROM vehicles v2
 JOIN vehicle_models vm2 ON vm2.id=v2.model_id WHERE vm2.category_id=vc.id)
ORDER BY vc.id,v.plate;
-- Q-11: tarifas pactadas; nocturnidad real o esperada; incluye extras sin contratos.
SELECT e.name AS extra,COUNT(DISTINCT ce.contract_id) AS contratos,
 COALESCE(SUM(ce.quantity*ce.agreed_daily_price*
  DATEDIFF(COALESCE(co.actual_return_date,co.expected_end_date),co.start_date)),0) AS ingresos
FROM extras e LEFT JOIN contract_extras ce ON ce.extra_id=e.id
LEFT JOIN contracts co ON co.id=ce.contract_id GROUP BY e.id,e.name ORDER BY ingresos DESC,e.name;
-- Q-12
SELECT co.id AS contrato,v.plate AS placa,CONCAT(cu.first_name,' ',cu.last_name) AS cliente,
 i.stage AS etapa,d.description AS dano,d.severity AS severidad,d.repair_cost AS costo,
 IF(d.charge_customer,'Sí','No') AS se_cobra
FROM damages d JOIN inspections i ON i.id=d.inspection_id JOIN contracts co ON co.id=i.contract_id
JOIN reservations r ON r.id=co.reservation_id JOIN customers cu ON cu.id=r.customer_id
JOIN vehicles v ON v.id=co.vehicle_id ORDER BY co.id,d.id;
