-- Taller 2 · FlotaYa · Retos R1–R3 · Después de 05_tcl.sql.
USE flotaya;
-- R1: cotizado distinto del calendario; las reservas del procedimiento no difieren
-- porque la cotización se genera con la misma fn_valor_alquiler.
SELECT r.id AS reserva,CONCAT(c.first_name,' ',c.last_name) AS cliente,
 vc.name AS categoria,r.pickup_date AS inicio,r.return_date AS fin,
 r.quoted_amount AS cotizado,
 fn_valor_alquiler(vc.id,r.pickup_date,r.return_date) AS segun_temporada,
 fn_valor_alquiler(vc.id,r.pickup_date,r.return_date)-r.quoted_amount AS diferencia
FROM reservations r JOIN customers c ON c.id=r.customer_id
JOIN vehicles v ON v.id=r.vehicle_id JOIN vehicle_models vm ON vm.id=v.model_id
JOIN vehicle_categories vc ON vc.id=vm.category_id
WHERE r.quoted_amount<>fn_valor_alquiler(vc.id,r.pickup_date,r.return_date)
ORDER BY diferencia DESC,r.id;
-- R2: cada agregado se calcula independientemente (evita producto cartesiano).
SELECT co.id AS contrato,CONCAT(c.first_name,' ',c.last_name) AS cliente,
 co.rental_amount AS alquiler,COALESCE(ex.extras,0) AS extras,
 COALESCE(da.danos,0) AS danos,COALESCE(pa.pagado,0) AS pagado,
 co.rental_amount+COALESCE(ex.extras,0)+COALESCE(da.danos,0)-COALESCE(pa.pagado,0) AS saldo
FROM contracts co JOIN reservations r ON r.id=co.reservation_id JOIN customers c ON c.id=r.customer_id
LEFT JOIN (SELECT ce.contract_id,SUM(ce.quantity*ce.agreed_daily_price*
 DATEDIFF(COALESCE(ct.actual_return_date,ct.expected_end_date),ct.start_date)) extras
 FROM contract_extras ce JOIN contracts ct ON ct.id=ce.contract_id GROUP BY ce.contract_id) ex ON ex.contract_id=co.id
LEFT JOIN (SELECT i.contract_id,SUM(d.repair_cost) danos FROM damages d JOIN inspections i ON i.id=d.inspection_id
 WHERE i.stage='DEVOLUCION' AND d.charge_customer=TRUE GROUP BY i.contract_id) da ON da.contract_id=co.id
LEFT JOIN (SELECT contract_id,SUM(amount) pagado FROM payments GROUP BY contract_id) pa ON pa.contract_id=co.id
WHERE co.status='CERRADO'
AND co.rental_amount+COALESCE(ex.extras,0)+COALESCE(da.danos,0)>COALESCE(pa.pagado,0)
ORDER BY saldo DESC,co.id;
-- R3: UNION ALL titular y conductor adicional, todo contrato.
SELECT z.contrato,z.conductor,z.rol,z.categoria,z.edad,z.edad_minima,z.licencia_vigente
FROM (
 SELECT co.id AS contrato,CONCAT(c.first_name,' ',c.last_name) AS conductor,'TITULAR' AS rol,
 vc.name AS categoria,fn_edad_conductor(c.birth_date,co.start_date) AS edad,
 vc.minimum_age AS edad_minima,
 IF(EXISTS(SELECT 1 FROM licenses l WHERE l.customer_id=c.id AND l.issued_on<=co.start_date
 AND l.expires_on>=COALESCE(co.actual_return_date,co.expected_end_date)),'Sí','No') AS licencia_vigente
 FROM contracts co JOIN reservations r ON r.id=co.reservation_id JOIN customers c ON c.id=r.customer_id
 JOIN vehicle_models vm ON vm.id=(SELECT v.model_id FROM vehicles v WHERE v.id=co.vehicle_id)
 JOIN vehicle_categories vc ON vc.id=vm.category_id
 UNION ALL
 SELECT co.id,ad.full_name,'ADICIONAL',vc.name,
 fn_edad_conductor(ad.birth_date,co.start_date),vc.minimum_age,
 IF(ad.license_expires_on>=COALESCE(co.actual_return_date,co.expected_end_date),'Sí','No')
 FROM contracts co JOIN contract_drivers cd ON cd.contract_id=co.id
 JOIN additional_drivers ad ON ad.id=cd.additional_driver_id
 JOIN vehicles v ON v.id=co.vehicle_id JOIN vehicle_models vm ON vm.id=v.model_id
 JOIN vehicle_categories vc ON vc.id=vm.category_id
) z WHERE z.edad<z.edad_minima OR z.licencia_vigente='No'
ORDER BY z.contrato,z.rol,z.conductor;
