-- Taller 1 · BiblioRed · Fase 3 · Datos y mantenimiento
USE bibliored;

INSERT INTO branches (name, city, address, opened_on) VALUES
  ('Sede Central Chía', 'Chía', 'Calle 5 6-10', '2012-01-10'),
  ('Sede Cajicá', 'Cajicá', 'Carrera 4 3-11', '2015-03-15'),
  ('Sede Zipaquirá', 'Zipaquirá', 'Calle 8 9-12', '2017-05-01'),
  ('Sede Cota', 'Cota', 'Calle 10 2-15', '2020-02-05'),
  ('Sede Tabio', 'Tabio', 'Carrera 3 5-10', '2026-10-01');

INSERT INTO membership_types (name, max_loans, loan_days, max_renewals, daily_fine, annual_fee) VALUES
  ('Básica', 2, 14, 1, 500, 0),
  ('Estudiante', 3, 14, 2, 300, 0),
  ('Docente', 5, 21, 2, 300, 30000),
  ('Infantil', 2, 7, 1, 200, 0),
  ('Institucional', 10, 30, 3, 1000, 250000);

INSERT INTO categories (name) VALUES
  ('Novela'),
  ('Cuento'),
  ('Poesía'),
  ('Historia'),
  ('Ciencia'),
  ('Infantil'),
  ('Referencia'),
  ('Cómic');

INSERT INTO publishers (name, city) VALUES
  ('Editorial Horizonte', 'Bogotá'),
  ('Letras del Valle', 'Cali'),
  ('Sabana Ediciones', 'Chía'),
  ('Nube Azul', 'Medellín'),
  ('Faro Cultural', 'Tunja'),
  ('Ediciones Sin Títulos', 'Bogotá'),
  ('Editorial Sin Publicaciones', 'Zipaquirá');

INSERT INTO authors (full_name, nationality, birth_year) VALUES
  ('Alicia Montoya', 'Colombiana', 1975),
  ('Ricardo Cárdenas', 'Colombiana', 1981),
  ('Valentina Pardo', 'Colombiana', 1990),
  ('Sofía Casas', 'Colombiana', 1970),
  ('Sebastián Orozco', 'Colombiana', 1985),
  ('Clara Bernal', 'Colombiana', 1968),
  ('Martín Vélez', 'Colombiana', 1977),
  ('Cecilia Arias', 'Colombiana', 1991),
  ('Diana Prado', 'Colombiana', 1982),
  ('Tomás Nieto', 'Colombiana', 1986),
  ('Autor Sin Obra', 'Colombiana', 1959);

INSERT INTO employees (branch_id, full_name, email, hired_on, role) VALUES
  (1, 'Patricia Lemus', 'patricia@bibliored.example.com', '2012-01-10', 'COORDINADOR'),
  (1, 'Óscar Rivas', 'oscar@bibliored.example.com', '2018-03-03', 'BIBLIOTECARIO'),
  (2, 'Luisa Cortés', 'luisa@bibliored.example.com', '2016-06-10', 'BIBLIOTECARIO'),
  (3, 'Camilo Toro', 'camilo@bibliored.example.com', '2019-07-11', 'BIBLIOTECARIO'),
  (4, 'Dora Peña', 'dora@bibliored.example.com', '2021-02-10', 'BIBLIOTECARIO'),
  (5, 'Samuel Ríos', 'samuel@bibliored.example.com', '2026-10-01', 'AUXILIAR');

-- Los títulos sin replacement_cost ejercitan DEFAULT 50000.00.
INSERT INTO titles (isbn, title, published_year, category_id, publisher_id, replacement_cost) VALUES
  ('9780000000001', 'El río de las garzas', 2016, 1, 1, 50000);

INSERT INTO titles (isbn, title, published_year, category_id, publisher_id, replacement_cost) VALUES
  ('9780000000002', 'Cartas desde el páramo', 2012, 1, 2, 42000);

INSERT INTO titles (isbn, title, published_year, category_id, publisher_id) VALUES
  ('9780000000003', 'Cuentos de la Sabana', 2018, 2, 3);

INSERT INTO titles (isbn, title, published_year, category_id, publisher_id, replacement_cost) VALUES
  ('9780000000004', 'La ciudad de los faroles', 2021, 1, 1, 60000);

INSERT INTO titles (isbn, title, published_year, category_id, publisher_id) VALUES
  ('9780000000005', 'El dragón de Guatavita', 2020, 6, 4);

INSERT INTO titles (isbn, title, published_year, category_id, publisher_id, replacement_cost) VALUES
  ('9780000000006', 'Diccionario escolar ilustrado', 2017, 7, 5, 76000);

INSERT INTO titles (isbn, title, published_year, category_id, publisher_id, replacement_cost) VALUES
  ('9780000000007', 'Átomos para curiosos', 2019, 5, 4, 68000);

INSERT INTO titles (isbn, title, published_year, category_id, publisher_id, replacement_cost) VALUES
  ('9780000000008', 'Astronomía de bolsillo', 2022, 5, 3, 70000);

INSERT INTO titles (isbn, title, published_year, category_id, publisher_id, replacement_cost) VALUES
  ('9780000000009', 'Atlas de caminos antiguos', 2011, 4, 2, 95000);

INSERT INTO titles (isbn, title, published_year, category_id, publisher_id, replacement_cost) VALUES
  ('9780000000010', 'Poemas de la niebla', 2015, 3, 5, 40000);

INSERT INTO titles (isbn, title, published_year, category_id, publisher_id, replacement_cost) VALUES
  ('9780000000011', 'Senderos de papel', 2023, 1, 1, 52000);

INSERT INTO titles (isbn, title, published_year, category_id, publisher_id, replacement_cost) VALUES
  ('9780000000012', 'Química para todos', 2021, 5, 4, 64000);

INSERT INTO titles (isbn, title, published_year, category_id, publisher_id, replacement_cost) VALUES
  ('9780000000013', 'Historia de Chía', 2014, 4, 3, 75000);

INSERT INTO titles (isbn, title, published_year, category_id, publisher_id, replacement_cost) VALUES
  ('9780000000014', 'Aves de la Sabana', 2018, 6, 2, 49000);

INSERT INTO titles (isbn, title, published_year, category_id, publisher_id) VALUES
  ('9780000000015', 'Mapa de los cielos', 2025, 5, 1);

INSERT INTO title_authors (title_id, author_id, author_order) VALUES
  (1, 1, 1),
  (2, 2, 1),
  (3, 3, 1),
  (4, 4, 1),
  (5, 5, 1),
  (6, 6, 1),
  (7, 7, 1),
  (8, 8, 1),
  (9, 9, 1),
  (10, 10, 1),
  (11, 1, 1),
  (12, 2, 1),
  (13, 3, 1),
  (14, 4, 1),
  (15, 5, 1),
  (3, 2, 2),
  (7, 4, 2),
  (9, 5, 2),
  (13, 6, 2);

INSERT INTO copies (title_id, branch_id, barcode, acquired_on, status) VALUES
  (1, 1, 'CH-001', '2016-02-10', 'PRESTADO'),
  (2, 1, 'CH-002', '2012-04-01', 'PRESTADO'),
  (3, 1, 'CH-003', '2018-10-05', 'PRESTADO'),
  (4, 1, 'CH-004', '2021-09-15', 'PRESTADO'),
  (5, 2, 'CJ-005', '2020-12-01', 'PRESTADO'),
  (6, 2, 'CJ-006', '2017-05-05', 'PRESTADO'),
  (7, 2, 'CJ-007', '2019-03-10', 'PRESTADO'),
  (8, 3, 'ZP-008', '2022-04-12', 'PRESTADO'),
  (9, 3, 'ZP-009', '2011-08-20', 'PRESTADO'),
  (10, 4, 'CT-010', '2015-01-12', 'PRESTADO'),
  (7, 4, 'CT-011', '2019-03-01', 'PERDIDO'),
  (8, 1, 'CH-012', '2020-02-02', 'EN_REPARACION'),
  (9, 4, 'CT-013', '2013-05-04', 'DADO_DE_BAJA'),
  (1, 1, 'CH-014', '2016-06-15', 'DISPONIBLE'),
  (2, 2, 'CJ-015', '2017-06-15', 'DISPONIBLE'),
  (3, 3, 'ZP-016', '2018-06-15', 'DISPONIBLE'),
  (4, 4, 'CT-017', '2019-06-15', 'DISPONIBLE'),
  (5, 1, 'CH-018', '2020-06-15', 'DISPONIBLE'),
  (6, 2, 'CJ-019', '2021-06-15', 'DISPONIBLE'),
  (7, 3, 'ZP-020', '2022-06-15', 'DISPONIBLE'),
  (8, 4, 'CT-021', '2023-06-15', 'DISPONIBLE'),
  (9, 1, 'CH-022', '2024-06-15', 'DISPONIBLE'),
  (10, 2, 'CJ-023', '2025-06-15', 'DISPONIBLE'),
  (11, 3, 'ZP-024', '2014-06-15', 'DISPONIBLE'),
  (12, 4, 'CT-025', '2015-06-15', 'DISPONIBLE'),
  (13, 1, 'CH-026', '2016-06-15', 'DISPONIBLE'),
  (14, 2, 'CJ-027', '2017-06-15', 'DISPONIBLE'),
  (1, 3, 'ZP-028', '2018-06-15', 'DISPONIBLE'),
  (2, 4, 'CT-029', '2019-06-15', 'DISPONIBLE'),
  (3, 1, 'CH-030', '2020-06-15', 'DISPONIBLE'),
  (4, 2, 'CJ-031', '2021-06-15', 'DISPONIBLE'),
  (5, 3, 'ZP-032', '2022-06-15', 'DISPONIBLE'),
  (6, 4, 'CT-033', '2023-06-15', 'DISPONIBLE'),
  (7, 1, 'CH-034', '2024-06-15', 'DISPONIBLE'),
  (8, 2, 'CJ-035', '2025-06-15', 'DISPONIBLE'),
  (9, 3, 'ZP-036', '2014-06-15', 'DISPONIBLE'),
  (10, 4, 'CT-037', '2015-06-15', 'DISPONIBLE');

INSERT INTO members (document_number, first_name, last_name, email, phone, birth_date, joined_on, membership_type_id, branch_id, status) VALUES
  ('30000001', 'Mateo', 'Paz', 'm1@example.com', '3205550001', '2000-01-01', '2026-08-15', 1, 1, 'ACTIVO');

INSERT INTO members (document_number, first_name, last_name, email, phone, birth_date, joined_on, membership_type_id, branch_id, status) VALUES
  ('30000002', 'Mariana', 'López', 'm2@example.com', '3205550002', '2002-04-02', '2026-08-15', 2, 1, 'ACTIVO');

INSERT INTO members (document_number, first_name, last_name, email, phone, birth_date, joined_on, membership_type_id, branch_id, status) VALUES
  ('30000003', 'Santiago', 'Méndez', 'm3@example.com', '3205550003', '1984-07-14', '2026-08-15', 3, 1, 'ACTIVO');

INSERT INTO members (document_number, first_name, last_name, email, phone, birth_date, joined_on, membership_type_id, branch_id, status) VALUES
  ('30000004', 'Natalia', 'Suárez', 'm4@example.com', '3205550004', '1999-03-19', '2026-08-15', 2, 2, 'ACTIVO');

INSERT INTO members (document_number, first_name, last_name, email, phone, birth_date, joined_on, membership_type_id, branch_id, status) VALUES
  ('30000005', 'Isabela', 'Torres', 'm5@example.com', '3205550005', '1996-09-20', '2026-08-15', 1, 2, 'ACTIVO');

INSERT INTO members (document_number, first_name, last_name, email, phone, birth_date, joined_on, membership_type_id, branch_id, status) VALUES
  ('30000006', 'Juan Pablo', 'Herrera', 'm6@example.com', '3205550006', '2000-11-15', '2026-08-15', 2, 2, 'ACTIVO');

INSERT INTO members (document_number, first_name, last_name, email, phone, birth_date, joined_on, membership_type_id, branch_id, status) VALUES
  ('30000007', 'Andrea', 'Soto', 'm7@example.com', '3205550007', '1987-06-15', '2026-08-15', 3, 3, 'ACTIVO');

INSERT INTO members (document_number, first_name, last_name, email, phone, birth_date, joined_on, membership_type_id, branch_id, status) VALUES
  ('30000008', 'Camila', 'Torres', 'm8@example.com', '3205550008', '2003-10-10', '2026-08-15', 2, 3, 'ACTIVO');

INSERT INTO members (document_number, first_name, last_name, email, phone, birth_date, joined_on, membership_type_id, branch_id, status) VALUES
  ('30000009', 'Felipe', 'Ramírez', 'm9@example.com', '3205550009', '2000-12-03', '2026-08-15', 2, 4, 'ACTIVO');

INSERT INTO members (document_number, first_name, last_name, email, phone, birth_date, joined_on, membership_type_id, branch_id, status) VALUES
  ('30000010', 'Laura', 'Gómez', 'm10@example.com', '3205550010', '1990-01-01', '2026-08-15', 1, 1, 'SUSPENDIDO');

INSERT INTO members (document_number, first_name, last_name, email, phone, birth_date, joined_on, membership_type_id, branch_id, status) VALUES
  ('30000011', 'Daniel', 'Rojas', 'm11@example.com', '3205550011', '1982-07-04', '2026-08-15', 1, 3, 'INACTIVO');

INSERT INTO members (document_number, first_name, last_name, email, phone, birth_date, joined_on, membership_type_id, branch_id, status) VALUES
  ('30000012', 'Martina', 'Pinto', NULL, NULL, '2017-05-01', '2026-08-15', 4, 5, 'ACTIVO');

INSERT INTO members (document_number, first_name, last_name, email, phone, birth_date, joined_on, membership_type_id, branch_id, status) VALUES
  ('30000013', 'José', 'Pérez', NULL, NULL, '2016-09-09', '2026-08-15', 4, 1, 'ACTIVO');

INSERT INTO members (document_number, first_name, last_name, email, phone, birth_date, joined_on, membership_type_id, branch_id, status) VALUES
  ('30000014', 'Lucía', 'Arias', 'm14@example.com', '3205550014', '1987-07-07', '2026-08-15', 2, 1, 'ACTIVO');

INSERT INTO members (document_number, first_name, last_name, email, phone, birth_date, joined_on, membership_type_id, branch_id, status) VALUES
  ('30000015', 'Pedro', 'Rincón', 'm15@example.com', '3205550015', '1999-01-21', '2026-08-15', 2, 4, 'ACTIVO');

INSERT INTO members (document_number, first_name, last_name, email, phone, birth_date, joined_on, membership_type_id, branch_id, status) VALUES
  ('30000016', 'Andrés', 'Peña', 'm16@example.com', NULL, '1982-06-02', '2026-08-15', 1, 4, 'ACTIVO');

INSERT INTO loans (copy_id, member_id, employee_id, loan_date, due_date) VALUES
  (1, 1, 2, '2026-11-03', '2026-11-17');

INSERT INTO loans (copy_id, member_id, employee_id, loan_date, due_date) VALUES
  (2, 1, 2, '2026-11-04', '2026-11-18');

INSERT INTO loans (copy_id, member_id, employee_id, loan_date, due_date) VALUES
  (3, 2, 2, '2026-10-27', '2026-11-10');

INSERT INTO loans (copy_id, member_id, employee_id, loan_date, due_date) VALUES
  (4, 3, 2, '2026-10-20', '2026-11-10');

INSERT INTO loans (copy_id, member_id, employee_id, loan_date, due_date) VALUES
  (5, 4, 3, '2026-10-22', '2026-11-05');

INSERT INTO loans (copy_id, member_id, employee_id, loan_date, due_date) VALUES
  (6, 5, 3, '2026-10-24', '2026-11-07');

INSERT INTO loans (copy_id, member_id, employee_id, loan_date, due_date) VALUES
  (7, 6, 3, '2026-10-14', '2026-10-28');

INSERT INTO loans (copy_id, member_id, employee_id, loan_date, due_date) VALUES
  (8, 7, 4, '2026-10-15', '2026-11-05');

INSERT INTO loans (copy_id, member_id, employee_id, loan_date, due_date) VALUES
  (9, 8, 4, '2026-11-01', '2026-11-15');

INSERT INTO loans (copy_id, member_id, employee_id, loan_date, due_date) VALUES
  (10, 9, 5, '2026-10-09', '2026-11-20');

INSERT INTO loans (copy_id, member_id, employee_id, loan_date, due_date, returned_on, status) VALUES
  (14, 10, 2, '2026-09-10', '2026-09-24', '2026-10-14', 'DEVUELTO');

INSERT INTO loans (copy_id, member_id, employee_id, loan_date, due_date, returned_on, status) VALUES
  (15, 11, 3, '2026-09-05', '2026-09-19', '2026-09-18', 'DEVUELTO');

INSERT INTO loans (copy_id, member_id, employee_id, loan_date, due_date, returned_on, status) VALUES
  (16, 14, 4, '2026-09-15', '2026-09-29', '2026-10-09', 'DEVUELTO');

INSERT INTO loans (copy_id, member_id, employee_id, loan_date, due_date, returned_on, status) VALUES
  (17, 15, 5, '2026-09-20', '2026-10-04', '2026-10-05', 'DEVUELTO');

INSERT INTO loans (copy_id, member_id, employee_id, loan_date, due_date, returned_on, status) VALUES
  (18, 6, 2, '2026-09-25', '2026-10-09', '2026-10-19', 'DEVUELTO');

INSERT INTO loans (copy_id, member_id, employee_id, loan_date, due_date, returned_on, status) VALUES
  (19, 4, 3, '2026-09-02', '2026-09-16', '2026-09-17', 'DEVUELTO');

INSERT INTO loans (copy_id, member_id, employee_id, loan_date, due_date, returned_on, status) VALUES
  (11, 16, 3, '2026-10-01', '2026-10-15', NULL, 'PERDIDO');

INSERT INTO loans (copy_id, member_id, employee_id, loan_date, due_date, returned_on, status) VALUES
  (20, 14, 4, '2026-10-01', '2026-10-29', '2026-10-10', 'DEVUELTO');

INSERT INTO loans (copy_id, member_id, employee_id, loan_date, due_date, returned_on, status) VALUES
  (21, 15, 5, '2026-10-02', '2026-10-16', '2026-10-15', 'DEVUELTO');

INSERT INTO loans (copy_id, member_id, employee_id, loan_date, due_date, returned_on, status) VALUES
  (22, 14, 2, '2026-10-20', '2026-11-03', '2026-11-02', 'DEVUELTO');

INSERT INTO loans (copy_id, member_id, employee_id, loan_date, due_date, returned_on, status) VALUES
  (23, 15, 3, '2026-10-22', '2026-11-05', '2026-11-03', 'DEVUELTO');

INSERT INTO loans (copy_id, member_id, employee_id, loan_date, due_date, returned_on, status) VALUES
  (24, 16, 4, '2026-10-10', '2026-10-24', '2026-10-20', 'DEVUELTO');

INSERT INTO loans (copy_id, member_id, employee_id, loan_date, due_date, returned_on, status) VALUES
  (25, 14, 5, '2026-09-01', '2026-09-15', '2026-09-14', 'DEVUELTO');

INSERT INTO loans (copy_id, member_id, employee_id, loan_date, due_date, returned_on, status) VALUES
  (26, 15, 2, '2026-09-02', '2026-09-16', '2026-09-15', 'DEVUELTO');

INSERT INTO loans (copy_id, member_id, employee_id, loan_date, due_date, returned_on, status) VALUES
  (27, 2, 3, '2026-09-04', '2026-09-18', '2026-09-18', 'DEVUELTO');

INSERT INTO loans (copy_id, member_id, employee_id, loan_date, due_date, returned_on, status) VALUES
  (28, 3, 4, '2026-09-20', '2026-10-11', '2026-10-09', 'DEVUELTO');

INSERT INTO renewals (loan_id, renewed_on, old_due_date, new_due_date) VALUES
  (1010, '2026-10-15', '2026-10-23', '2026-11-06'),
  (1010, '2026-10-30', '2026-11-06', '2026-11-20'),
  (1018, '2026-10-03', '2026-10-15', '2026-10-29');

INSERT INTO reservations (member_id, title_id, pickup_branch_id, reserved_on, expires_on, status) VALUES
  (12, 5, 5, '2026-11-03', '2026-11-20', 'PENDIENTE'),
  (2, 9, 3, '2026-11-01', '2026-11-20', 'PENDIENTE'),
  (3, 7, 2, '2026-11-02', '2026-11-18', 'PENDIENTE'),
  (4, 2, 1, '2026-10-20', '2026-11-08', 'PENDIENTE'),
  (5, 4, 1, '2026-10-17', '2026-11-10', 'ATENDIDA'),
  (6, 6, 2, '2026-10-10', '2026-10-30', 'CANCELADA'),
  (7, 1, 2, '2026-10-10', '2026-10-19', 'VENCIDA'),
  (8, 3, 2, '2026-11-04', '2026-11-24', 'PENDIENTE');

INSERT INTO fines (loan_id, reason, fine_days, amount, generated_on, status) VALUES
  (1011, 'MORA', 20, 10000, '2026-10-14', 'PENDIENTE'),
  (1013, 'MORA', 10, 3000, '2026-10-09', 'PAGADA'),
  (1014, 'MORA', 1, 300, '2026-10-05', 'PAGADA'),
  (1015, 'MORA', 10, 3000, '2026-10-19', 'PENDIENTE'),
  (1016, 'DAÑO', 0, 7500, '2026-09-17', 'ANULADA'),
  (1017, 'PERDIDA', 0, 68000, '2026-10-20', 'PENDIENTE');

INSERT INTO fine_payments (fine_id, amount, paid_on, method) VALUES
  (2, 3000, '2026-10-12', 'EFECTIVO'),
  (3, 100, '2026-10-08', 'TARJETA'),
  (3, 200, '2026-10-09', 'TRANSFERENCIA'),
  (4, 1000, '2026-10-20', 'EFECTIVO');

-- Fase 3 · mantenimiento: SELECT previo, UPDATE/DELETE por PK, SELECT posterior.
SELECT * FROM copies WHERE id=12;
UPDATE copies SET status='DISPONIBLE' WHERE id=12;
SELECT * FROM copies WHERE id=12;
SELECT * FROM reservations WHERE id=4;
UPDATE reservations SET status='VENCIDA' WHERE id=4 AND status='PENDIENTE' AND expires_on<'2026-11-10';
SELECT * FROM reservations WHERE id=4;
SELECT * FROM membership_types WHERE id=3;
UPDATE membership_types SET annual_fee=annual_fee*1.10 WHERE id=3;
SELECT * FROM membership_types WHERE id=3;
SELECT * FROM members WHERE id=16;
UPDATE members SET phone='3105551616' WHERE id=16;
SELECT * FROM members WHERE id=16;
SELECT * FROM reservations WHERE id=6;
DELETE FROM reservations WHERE id=6;
SELECT * FROM reservations WHERE id=6;
SELECT p.*, (SELECT COUNT(*) FROM titles t WHERE t.publisher_id=p.id) AS titulos FROM publishers p WHERE p.id=6;
DELETE FROM publishers WHERE id=6;
SELECT * FROM publishers WHERE id=6;
-- ⚠️ ESPERADO: ERROR 1062 (UNIQUE). Ejecutar aislada.
-- INSERT INTO copies(title_id,branch_id,barcode,acquired_on) VALUES(1,1,'CH-001','2026-11-10');
-- ⚠️ ESPERADO: ERROR 3819 (CHECK). Ejecutar aislada.
-- INSERT INTO fine_payments(fine_id,amount,paid_on,method) VALUES(1,0,'2026-11-10','EFECTIVO');
-- ⚠️ ESPERADO: ERROR 1451 (FK). Ejecutar aislada.
-- DELETE FROM categories WHERE id=1;
-- Conteos finales: branches 5, membership_types 5, categories 8, publishers 6, authors 11,
-- employees 6, titles 15, title_authors 19, copies 37, members 16,
-- loans 26, renewals 3, reservations 7, fines 6, fine_payments 4.
SELECT 'branches' AS tabla,COUNT(*) AS filas FROM branches UNION ALL SELECT 'membership_types',COUNT(*) FROM membership_types
UNION ALL SELECT 'categories',COUNT(*) FROM categories UNION ALL SELECT 'publishers',COUNT(*) FROM publishers
UNION ALL SELECT 'authors',COUNT(*) FROM authors UNION ALL SELECT 'employees',COUNT(*) FROM employees
UNION ALL SELECT 'titles',COUNT(*) FROM titles UNION ALL SELECT 'title_authors',COUNT(*) FROM title_authors
UNION ALL SELECT 'copies',COUNT(*) FROM copies UNION ALL SELECT 'members',COUNT(*) FROM members
UNION ALL SELECT 'loans',COUNT(*) FROM loans UNION ALL SELECT 'renewals',COUNT(*) FROM renewals
UNION ALL SELECT 'reservations',COUNT(*) FROM reservations UNION ALL SELECT 'fines',COUNT(*) FROM fines
UNION ALL SELECT 'fine_payments',COUNT(*) FROM fine_payments;
-- D14: ambas cantidades deben ser 0.
SELECT (SELECT COUNT(*) FROM copies c WHERE c.status='PRESTADO' AND NOT EXISTS
 (SELECT 1 FROM loans l WHERE l.copy_id=c.id AND l.status='ACTIVO')) AS prestados_sin_prestamo,
 (SELECT COUNT(*) FROM loans l WHERE l.status='ACTIVO' AND NOT EXISTS
 (SELECT 1 FROM copies c WHERE c.id=l.copy_id AND c.status='PRESTADO')) AS prestamos_sin_ejemplar;
