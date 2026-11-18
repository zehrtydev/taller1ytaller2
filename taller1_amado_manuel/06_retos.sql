-- Taller 1 · BiblioRed · Bonificación R1–R3
USE bibliored;
-- R1: alertas de cobro, evita que multas y préstamos se multipliquen.
SELECT m.id,CONCAT(m.first_name,' ',m.last_name) AS socio,m.phone AS telefono,
 COALESCE(d.saldo,0) AS saldo_multas,COALESCE(v.vencidos,0) AS libros_vencidos,
 COALESCE(v.mayor_mora,0) AS dias_vencimiento_mas_antiguo
FROM members m LEFT JOIN (
 SELECT l.member_id,SUM(f.amount-COALESCE(p.abonos,0)) AS saldo
 FROM loans l JOIN fines f ON f.loan_id=l.id AND f.status='PENDIENTE'
 LEFT JOIN (SELECT fine_id,SUM(amount) AS abonos FROM fine_payments GROUP BY fine_id) p ON p.fine_id=f.id
 GROUP BY l.member_id) d ON d.member_id=m.id
LEFT JOIN (SELECT member_id,COUNT(*) AS vencidos,MAX(DATEDIFF('2026-11-10',due_date)) AS mayor_mora
 FROM loans WHERE status='ACTIVO' AND due_date<'2026-11-10' GROUP BY member_id) v ON v.member_id=m.id
WHERE COALESCE(d.saldo,0)>0 OR COALESCE(v.vencidos,0)>0
ORDER BY saldo_multas DESC,libros_vencidos DESC,m.id;
-- R2: subconsultas agregadas con el grano correcto.
SELECT ca.name AS categoria,COALESCE(t.total,0) AS titulos,COALESCE(c.total,0) AS ejemplares,
 COALESCE(l.total,0) AS prestamos_desde_octubre,
 CASE WHEN COALESCE(c.total,0)=0 THEN 0 ELSE ROUND(COALESCE(l.total,0)/c.total,2) END AS prestamos_por_ejemplar
FROM categories ca
LEFT JOIN (SELECT category_id,COUNT(*) total FROM titles GROUP BY category_id) t ON t.category_id=ca.id
LEFT JOIN (SELECT t.category_id,COUNT(*) total FROM copies c JOIN titles t ON t.id=c.title_id
 WHERE c.status NOT IN('PERDIDO','DADO_DE_BAJA') GROUP BY t.category_id) c ON c.category_id=ca.id
LEFT JOIN (SELECT t.category_id,COUNT(*) total FROM loans l JOIN copies c ON c.id=l.copy_id JOIN titles t ON t.id=c.title_id
 WHERE l.loan_date>='2026-10-01' GROUP BY t.category_id) l ON l.category_id=ca.id ORDER BY ca.id;
-- R3: cierre del día, repetible y compatible con Safe Updates (PK).
DROP PROCEDURE IF EXISTS sp_vencer_reservas;
DELIMITER $$
CREATE PROCEDURE sp_vencer_reservas(IN p_fecha_corte DATE,OUT p_vencidas INT)
BEGIN
 UPDATE reservations SET status='VENCIDA'
 WHERE id IN (SELECT id FROM (SELECT id FROM reservations WHERE status='PENDIENTE' AND expires_on<p_fecha_corte) AS pendientes);
 SET p_vencidas=ROW_COUNT();
END $$
DELIMITER ;
CALL sp_vencer_reservas('2026-11-21',@vencidas_1);
SELECT @vencidas_1 AS vencidas_primera_ejecucion;
CALL sp_vencer_reservas('2026-11-21',@vencidas_2);
SELECT @vencidas_2 AS vencidas_segunda_ejecucion; -- esperado: 0
