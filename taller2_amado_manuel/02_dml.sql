-- Taller 2 · FlotaYa · Fase 3 · Fecha de corte 2026-11-23
USE flotaya;

INSERT INTO departments (name) VALUES
  ('Bogotá D.C.'),
  ('Antioquia'),
  ('Bolívar'),
  ('Valle del Cauca'),
  ('Santander'),
  ('Quindío'),
  ('Magdalena');

INSERT INTO cities (department_id, name) VALUES
  (1, 'Bogotá'),
  (2, 'Medellín'),
  (2, 'Rionegro'),
  (3, 'Cartagena'),
  (4, 'Cali'),
  (5, 'Bucaramanga'),
  (6, 'Armenia');

INSERT INTO branches (city_id, name, address, phone, is_airport) VALUES
  (1, 'FlotaYa Bogotá Calle 26', 'Avenida Calle 26 # 69-76', '6017001001', 0),
  (1, 'FlotaYa Aeropuerto El Dorado', 'Avenida El Dorado # 103-09', '6017001002', 1),
  (2, 'FlotaYa Medellín El Poblado', 'Carrera 43A # 7-50', '6047001003', 0),
  (3, 'FlotaYa Aeropuerto José María Córdova', 'Vía Aeropuerto JMC km 1', '6047001004', 1),
  (4, 'FlotaYa Cartagena Bocagrande', 'Carrera 2 # 8-120', '6057001005', 0),
  (5, 'FlotaYa Cali Granada', 'Avenida 9N # 15-20', '6027001006', 0);

INSERT INTO employees (branch_id, full_name, email, hired_on, role) VALUES
  (1, 'Mónica Gaitán', 'monica.gaitan@flotaya.example.com', '2025-01-10', 'ADMINISTRADOR'),
  (1, 'Gustavo Pérez', 'gustavo.perez@flotaya.example.com', '2025-01-10', 'MECANICO'),
  (1, 'Ana Torres', 'ana.torres@flotaya.example.com', '2025-01-10', 'ASESOR'),
  (2, 'Bruno Marín', 'bruno.marin@flotaya.example.com', '2025-01-10', 'ASESOR'),
  (2, 'Elena Cano', 'elena.cano@flotaya.example.com', '2025-01-10', 'INSPECTOR'),
  (3, 'César Gil', 'cesar.gil@flotaya.example.com', '2025-01-10', 'ASESOR'),
  (4, 'Diana Solano', 'diana.solano@flotaya.example.com', '2025-01-10', 'ASESOR'),
  (4, 'Iris Ríos', 'iris.rios@flotaya.example.com', '2025-01-10', 'INSPECTOR'),
  (5, 'Fabio Acosta', 'fabio.acosta@flotaya.example.com', '2025-01-10', 'ASESOR'),
  (6, 'Gina Osorio', 'gina.osorio@flotaya.example.com', '2025-01-10', 'ASESOR'),
  (6, 'Hugo León', 'hugo.leon@flotaya.example.com', '2025-01-10', 'INSPECTOR'),
  (1, 'Iván Ruiz', 'ivan.ruiz@flotaya.example.com', '2025-01-10', 'INSPECTOR');

INSERT INTO vehicle_categories (name, minimum_age, deposit_amount) VALUES
  ('Económico', 21, 1500000),
  ('Compacto', 21, 1500000),
  ('SUV', 23, 2500000),
  ('Camioneta 4x4', 25, 3000000),
  ('Van', 25, 3000000),
  ('Lujo', 30, 5000000);

INSERT INTO brands (name) VALUES
  ('Renault'),
  ('Kia'),
  ('Chevrolet'),
  ('Mazda'),
  ('Toyota'),
  ('Hyundai'),
  ('Nissan');

INSERT INTO vehicle_models (brand_id, category_id, name, transmission, fuel_type, seats) VALUES
  (1, 1, 'Kwid', 'MECANICA', 'GASOLINA', 5),
  (2, 1, 'Picanto', 'AUTOMATICA', 'GASOLINA', 5),
  (3, 2, 'Onix', 'AUTOMATICA', 'GASOLINA', 5),
  (4, 2, 'Mazda 2', 'AUTOMATICA', 'GASOLINA', 5),
  (1, 3, 'Duster', 'MECANICA', 'GASOLINA', 5),
  (2, 3, 'Sportage', 'AUTOMATICA', 'HIBRIDO', 5),
  (5, 4, 'Hilux', 'MECANICA', 'DIESEL', 5),
  (6, 5, 'Staria', 'AUTOMATICA', 'DIESEL', 11),
  (4, 3, 'CX-30', 'AUTOMATICA', 'GASOLINA', 5);

INSERT INTO seasons (name, season_type, start_date, end_date) VALUES
  ('Fin de año 2025', 'ALTA', '2025-12-15', '2026-01-15'),
  ('Baja de inicio de año', 'BAJA', '2026-01-16', '2026-03-28'),
  ('Semana Santa', 'ALTA', '2026-03-29', '2026-04-05'),
  ('Baja de abril a junio', 'BAJA', '2026-04-06', '2026-06-12'),
  ('Vacaciones de mitad de año', 'ALTA', '2026-06-13', '2026-07-19'),
  ('Baja de segundo semestre', 'BAJA', '2026-07-20', '2026-10-02'),
  ('Receso escolar de octubre', 'MEDIA', '2026-10-03', '2026-10-12'),
  ('Baja de noviembre', 'BAJA', '2026-10-13', '2026-11-30'),
  ('Temporada de novenas', 'MEDIA', '2026-12-01', '2026-12-14'),
  ('Fin de año 2026', 'ALTA', '2026-12-15', '2027-01-15');

INSERT INTO rates (category_id, season_type, daily_rate) VALUES
  (1, 'BAJA', 120000),
  (1, 'MEDIA', 140000),
  (1, 'ALTA', 180000),
  (2, 'BAJA', 150000),
  (2, 'MEDIA', 175000),
  (2, 'ALTA', 220000),
  (3, 'BAJA', 230000),
  (3, 'MEDIA', 270000),
  (3, 'ALTA', 340000),
  (4, 'BAJA', 300000),
  (4, 'MEDIA', 350000),
  (4, 'ALTA', 430000),
  (5, 'BAJA', 320000),
  (5, 'MEDIA', 370000),
  (5, 'ALTA', 460000),
  (6, 'BAJA', 450000),
  (6, 'MEDIA', 520000),
  (6, 'ALTA', 650000);

INSERT INTO vehicles (plate, model_id, model_year, color, mileage_km, status, branch_id) VALUES
  ('KWD101', 1, 2024, 'Blanco', 18950, 'DISPONIBLE', 1),
  ('KWD102', 1, 2024, 'Gris', 22100, 'DISPONIBLE', 2),
  ('KWD103', 1, 2021, 'Blanco', 98400, 'FUERA_DE_SERVICIO', 6),
  ('PCN201', 2, 2025, 'Rojo', 10450, 'DISPONIBLE', 2),
  ('PCN202', 2, 2025, 'Blanco', 12400, 'DISPONIBLE', 3),
  ('ONX301', 3, 2024, 'Plata', 30500, 'ALQUILADO', 2),
  ('ONX302', 3, 2023, 'Negro', 41890, 'MANTENIMIENTO', 5),
  ('MZD401', 4, 2025, 'Azul', 9310, 'DISPONIBLE', 4),
  ('MZD402', 4, 2024, 'Rojo', 26300, 'ALQUILADO', 4),
  ('DST501', 5, 2023, 'Blanco', 48620, 'DISPONIBLE', 1),
  ('DST502', 5, 2024, 'Gris', 22710, 'DISPONIBLE', 6),
  ('SPT601', 6, 2025, 'Negro', 11500, 'ALQUILADO', 2),
  ('SPT602', 6, 2025, 'Blanco', 9600, 'DISPONIBLE', 4),
  ('HLX701', 7, 2023, 'Plata', 64380, 'DISPONIBLE', 3),
  ('HLX702', 7, 2022, 'Blanco', 88100, 'MANTENIMIENTO', 6),
  ('STR801', 8, 2024, 'Gris', 35700, 'DISPONIBLE', 2),
  ('STR802', 8, 2025, 'Blanco', 15480, 'DISPONIBLE', 5);

INSERT INTO maintenances (vehicle_id, maintenance_type, description, workshop, start_date, end_date, cost) VALUES
  (15, 'CORRECTIVO', 'Cambio de embrague', 'Diésel del Valle', '2026-11-16', NULL, NULL),
  (7, 'LATONERIA', 'Reparación de latonería', 'Latonería Caribe', '2026-10-26', NULL, NULL),
  (3, 'CORRECTIVO', 'Diagnóstico motor: pérdida total', 'Taller FlotaYa Cali', '2026-10-10', '2026-10-17', 950000),
  (10, 'PREVENTIVO', 'Cambio de filtros', 'Taller FlotaYa Bogotá', '2026-09-01', '2026-09-02', 250000),
  (10, 'PREVENTIVO', 'Revisión de frenos', 'Taller FlotaYa Bogotá', '2026-11-04', '2026-11-05', 360000),
  (2, 'PREVENTIVO', 'Revisión de llantas', 'Taller FlotaYa Bogotá', '2026-10-05', '2026-10-06', 180000);

INSERT INTO customers (first_name, last_name, document_type, document_number, email, phone, birth_date, city_id, registered_on, status) VALUES
  ('Andrea', 'Salazar', 'CC', 'FIC-0001', 'cliente1@example.com', '3107000001', '1990-04-12', 1, '2026-01-15', 'ACTIVO'),
  ('Carlos', 'Mejía', 'CC', 'FIC-0002', 'cliente2@example.com', '3107000002', '1985-09-30', 2, '2026-01-15', 'ACTIVO'),
  ('Juliana', 'Patiño', 'CC', 'FIC-0003', 'cliente3@example.com', '3107000003', '2004-07-15', 1, '2026-01-15', 'ACTIVO'),
  ('Lucas', 'Ferreira', 'CE', 'FIC-0004', 'cliente4@example.com', '3107000004', '1979-02-02', 4, '2026-01-15', 'ACTIVO'),
  ('Diana', 'Rozo', 'CC', 'FIC-0005', 'cliente5@example.com', '3107000005', '1993-11-25', 5, '2026-01-15', 'ACTIVO'),
  ('Emma', 'Walker', 'PASAPORTE', 'FIC-0006', 'cliente6@example.com', '3107000006', '1988-06-18', 4, '2026-01-15', 'ACTIVO'),
  ('Jorge', 'Arango', 'CC', 'FIC-0007', 'cliente7@example.com', '3107000007', '1975-01-09', 2, '2026-01-15', 'ACTIVO'),
  ('Paola', 'Quintero', 'CC', 'FIC-0008', 'cliente8@example.com', '3107000008', '1999-12-03', 1, '2026-01-15', 'ACTIVO'),
  ('Esteban', 'Rueda', 'CC', 'FIC-0009', 'cliente9@example.com', '3107000009', '2002-05-21', 6, '2026-01-15', 'ACTIVO'),
  ('Martha', 'Cifuentes', 'CC', 'FIC-0010', 'cliente10@example.com', '3107000010', '1968-03-14', 1, '2026-01-15', 'BLOQUEADO'),
  ('Kevin', 'Morales', 'CC', 'FIC-0011', 'cliente11@example.com', '3107000011', '2005-10-02', 5, '2026-01-15', 'ACTIVO'),
  ('Laura', 'Benítez', 'CC', 'FIC-0012', 'cliente12@example.com', NULL, '1996-08-08', 2, '2026-01-15', 'ACTIVO'),
  ('Ricardo', 'Lozano', 'CC', 'FIC-0013', 'cliente13@example.com', '3107000013', '1982-12-24', 1, '2026-01-15', 'ACTIVO'),
  ('Sofía', 'Herrera', 'CC', 'FIC-0014', 'cliente14@example.com', '3107000014', '2001-01-30', 3, '2026-01-15', 'ACTIVO');

INSERT INTO licenses (customer_id, license_number, license_category, issued_on, expires_on, country) VALUES
  (1, 'LIC-0001', 'B1', '2024-05-10', '2028-05-10', 'Colombia'),
  (2, 'LIC-0002', 'B1', '2019-02-20', '2027-02-20', 'Colombia'),
  (3, 'LIC-0003', 'B1', '2022-08-01', '2032-08-01', 'Colombia'),
  (4, 'LIC-0004', 'B1', '2021-01-01', '2026-12-31', 'Brasil'),
  (5, 'LIC-0005', 'B1', '2019-11-30', '2029-11-30', 'Colombia'),
  (6, 'LIC-0006', 'B1', '2020-06-01', '2031-06-01', 'Canadá'),
  (7, 'LIC-0007', 'C1', '2000-01-15', '2010-01-15', 'Colombia'),
  (7, 'LIC-0008', 'C1', '2010-01-15', '2030-01-15', 'Colombia'),
  (8, 'LIC-0009', 'B1', '2016-12-10', '2026-12-10', 'Colombia'),
  (9, 'LIC-0010', 'B1', '2016-08-01', '2026-08-01', 'Colombia'),
  (10, 'LIC-0011', 'B1', '2018-04-04', '2028-04-04', 'Colombia'),
  (11, 'LIC-0012', 'B1', '2023-10-10', '2033-10-10', 'Colombia'),
  (13, 'LIC-0013', 'B1', '2019-12-24', '2027-12-24', 'Colombia'),
  (14, 'LIC-0014', 'B1', '2021-02-01', '2029-02-01', 'Colombia');

INSERT INTO additional_drivers (document_number, full_name, birth_date, license_number, license_expires_on) VALUES
  ('DRV-0001', 'Felipe Salazar', '1988-03-03', 'ADL-0001', '2029-03-03'),
  ('DRV-0002', 'Mónica Arango', '1977-07-07', 'ADL-0002', '2028-07-07'),
  ('DRV-0003', 'Tomás Ferreira', '2006-03-03', 'ADL-0003', '2030-03-03'),
  ('DRV-0004', 'Natalia Rozo', '1995-05-05', 'ADL-0004', '2026-09-30');

INSERT INTO extras (name, list_daily_price) VALUES
  ('GPS', 15000),
  ('Silla de bebé', 12000),
  ('Seguro total', 45000),
  ('Conductor adicional', 20000),
  ('Wi-Fi portátil', 10000),
  ('Portabicicletas', 18000);

INSERT INTO reservations (customer_id, vehicle_id, pickup_branch_id, return_branch_id, pickup_date, return_date, quoted_amount, status, created_at) VALUES
  (8, 12, 2, 2, '2026-11-15', '2026-11-22', 1610000, 'CONVERTIDA', '2026-11-15 08:00:00'),
  (13, 6, 2, 1, '2026-11-17', '2026-11-21', 600000, 'CONVERTIDA', '2026-11-17 08:00:00'),
  (2, 9, 4, 4, '2026-11-18', '2026-11-25', 1050000, 'CONVERTIDA', '2026-11-18 08:00:00'),
  (4, 17, 5, 5, '2026-10-01', '2026-10-06', 1750000, 'CONVERTIDA', '2026-10-01 08:00:00'),
  (7, 14, 3, 3, '2026-10-15', '2026-10-20', 1500000, 'CONVERTIDA', '2026-10-15 08:00:00'),
  (6, 7, 5, 5, '2026-10-20', '2026-10-24', 600000, 'CONVERTIDA', '2026-10-20 08:00:00'),
  (5, 11, 6, 6, '2026-10-08', '2026-10-12', 920000, 'CONVERTIDA', '2026-10-08 08:00:00'),
  (1, 2, 2, 2, '2026-09-10', '2026-09-13', 360000, 'CONVERTIDA', '2026-09-10 08:00:00'),
  (3, 1, 1, 1, '2026-11-27', '2026-12-02', 620000, 'CONFIRMADA', '2026-11-27 08:00:00'),
  (5, 16, 2, 2, '2026-12-18', '2026-12-23', 2300000, 'CONFIRMADA', '2026-12-18 08:00:00'),
  (11, 5, 3, 3, '2026-12-10', '2026-12-17', 980000, 'PENDIENTE', '2026-12-10 08:00:00'),
  (14, 13, 4, 4, '2026-12-05', '2026-12-09', 1080000, 'PENDIENTE', '2026-12-05 08:00:00'),
  (10, 4, 2, 2, '2026-09-20', '2026-09-23', 420000, 'CANCELADA', '2026-09-20 08:00:00'),
  (9, 8, 4, 4, '2026-10-01', '2026-10-04', 450000, 'CANCELADA', '2026-10-01 08:00:00');

INSERT INTO contracts (reservation_id, vehicle_id, employee_id, start_date, expected_end_date, actual_return_date, rental_amount, status) VALUES
  (501, 12, 4, '2026-11-15', '2026-11-22', NULL, 1610000, 'ABIERTO'),
  (502, 6, 4, '2026-11-17', '2026-11-21', NULL, 600000, 'ABIERTO'),
  (503, 9, 7, '2026-11-18', '2026-11-25', NULL, 1050000, 'ABIERTO'),
  (504, 17, 9, '2026-10-01', '2026-10-06', '2026-10-06', 1750000, 'CERRADO'),
  (505, 14, 6, '2026-10-15', '2026-10-20', '2026-10-20', 1500000, 'CERRADO'),
  (506, 7, 9, '2026-10-20', '2026-10-24', '2026-10-24', 600000, 'CERRADO'),
  (507, 11, 10, '2026-10-08', '2026-10-12', '2026-10-13', 1350000, 'CERRADO'),
  (508, 2, 4, '2026-09-10', '2026-09-13', '2026-09-13', 360000, 'CERRADO');

INSERT INTO contract_drivers (contract_id, additional_driver_id) VALUES
  (9001, 1),
  (9003, 2),
  (9004, 3),
  (9005, 4);

INSERT INTO contract_extras (contract_id, extra_id, quantity, agreed_daily_price) VALUES
  (9001, 3, 1, 45000),
  (9001, 4, 1, 20000),
  (9002, 1, 1, 15000),
  (9003, 4, 1, 20000),
  (9003, 2, 2, 12000),
  (9006, 1, 1, 15000);

INSERT INTO pickups (contract_id, branch_id, employee_id, occurred_at, mileage_km, fuel_pct) VALUES
  (9001, 2, 4, '2026-11-15 09:00:00', 11500, 100),
  (9002, 2, 4, '2026-11-17 09:00:00', 30500, 100),
  (9003, 4, 7, '2026-11-18 09:00:00', 26300, 100),
  (9004, 5, 9, '2026-10-01 09:00:00', 15000, 90),
  (9005, 3, 6, '2026-10-15 09:00:00', 64000, 100),
  (9006, 5, 9, '2026-10-20 09:00:00', 41000, 100),
  (9007, 6, 10, '2026-10-08 09:00:00', 22200, 100),
  (9008, 2, 4, '2026-09-10 09:00:00', 21000, 100);

INSERT INTO returns (contract_id, branch_id, employee_id, occurred_at, mileage_km, fuel_pct) VALUES
  (9004, 5, 9, '2026-10-06 10:00:00', 15480, 85),
  (9005, 3, 6, '2026-10-20 10:00:00', 64380, 100),
  (9006, 5, 9, '2026-10-24 10:00:00', 41890, 95),
  (9007, 6, 11, '2026-10-13 10:00:00', 22710, 65),
  (9008, 2, 5, '2026-09-13 10:00:00', 22100, 90);

INSERT INTO inspections (contract_id, employee_id, stage, inspected_at, exterior_ok, interior_ok, notes) VALUES
  (9001, 5, 'ENTREGA', '2026-11-15 09:15:00', 1, 1, NULL),
  (9002, 5, 'ENTREGA', '2026-11-17 09:15:00', 1, 1, NULL),
  (9003, 8, 'ENTREGA', '2026-11-18 09:15:00', 1, 1, NULL),
  (9004, 9, 'ENTREGA', '2026-10-01 09:15:00', 0, 1, 'Rayón previo en el bómper trasero'),
  (9004, 9, 'DEVOLUCION', '2026-10-06 10:15:00', 1, 1, NULL),
  (9005, 6, 'ENTREGA', '2026-10-15 09:15:00', 1, 1, NULL),
  (9005, 6, 'DEVOLUCION', '2026-10-20 10:15:00', 0, 1, 'Rayón en la puerta del conductor'),
  (9006, 9, 'ENTREGA', '2026-10-20 09:15:00', 1, 1, NULL),
  (9006, 9, 'DEVOLUCION', '2026-10-24 10:15:00', 0, 1, 'Golpe en la puerta trasera derecha'),
  (9007, 11, 'ENTREGA', '2026-10-08 09:15:00', 1, 1, NULL),
  (9007, 11, 'DEVOLUCION', '2026-10-13 10:15:00', 1, 1, NULL),
  (9008, 5, 'ENTREGA', '2026-09-10 09:15:00', 1, 1, NULL),
  (9008, 5, 'DEVOLUCION', '2026-09-13 10:15:00', 1, 1, NULL);

INSERT INTO damages (inspection_id, description, severity, repair_cost, charge_customer) VALUES
  (4, 'Rayón previo en el bómper trasero', 'LEVE', 180000, 0),
  (7, 'Rayón en la puerta del conductor', 'LEVE', 350000, 1),
  (9, 'Golpe en la puerta trasera derecha', 'GRAVE', 2400000, 1);

INSERT INTO deposits (contract_id, amount, retained_at, released_at, applied_amount, status) VALUES
  (9001, 2500000, '2026-11-15 09:20:00', NULL, 0, 'RETENIDO'),
  (9002, 1500000, '2026-11-17 09:20:00', NULL, 0, 'RETENIDO'),
  (9003, 1500000, '2026-11-18 09:20:00', NULL, 0, 'RETENIDO'),
  (9004, 3000000, '2026-10-01 09:20:00', '2026-10-06 11:00:00', 0, 'LIBERADO'),
  (9005, 3000000, '2026-10-15 09:20:00', '2026-10-20 11:00:00', 350000, 'APLICADO'),
  (9006, 1500000, '2026-10-20 09:20:00', '2026-10-24 11:00:00', 1500000, 'APLICADO'),
  (9007, 2500000, '2026-10-08 09:20:00', '2026-10-13 11:00:00', 0, 'LIBERADO'),
  (9008, 1500000, '2026-09-10 09:20:00', '2026-09-13 11:00:00', 0, 'LIBERADO');

INSERT INTO payments (contract_id, concept, amount, payment_method, paid_at, card_last4, authorization_code) VALUES
  (9001, 'ALQUILER', 1610000, 'TARJETA', '2026-11-15 09:20:00', '3307', 'AUT-580111'),
  (9002, 'ALQUILER', 600000, 'TARJETA', '2026-11-17 09:20:00', '2345', 'AUT-580112'),
  (9004, 'ALQUILER', 1000000, 'TRANSFERENCIA', '2026-10-06 11:00:00', NULL, NULL),
  (9004, 'CIERRE', 750000, 'EFECTIVO', '2026-10-06 11:01:00', NULL, NULL),
  (9005, 'ALQUILER', 1500000, 'TARJETA', '2026-10-20 11:00:00', '7788', 'AUT-580113'),
  (9005, 'DAÑOS', 350000, 'DEPOSITO', '2026-10-20 11:01:00', NULL, NULL),
  (9006, 'ALQUILER', 600000, 'TARJETA', '2026-10-24 11:00:00', '2299', 'AUT-580115'),
  (9006, 'EXTRAS', 60000, 'EFECTIVO', '2026-10-24 11:01:00', NULL, NULL),
  (9006, 'DAÑOS', 1500000, 'DEPOSITO', '2026-10-24 11:02:00', NULL, NULL),
  (9007, 'ALQUILER', 700000, 'TRANSFERENCIA', '2026-10-13 11:00:00', NULL, NULL),
  (9007, 'CIERRE', 650000, 'EFECTIVO', '2026-10-13 11:01:00', NULL, NULL),
  (9008, 'ALQUILER', 200000, 'TARJETA', '2026-09-13 11:00:00', '8800', 'AUT-580116'),
  (9008, 'CIERRE', 160000, 'EFECTIVO', '2026-09-13 11:01:00', NULL, NULL);

-- Mínimos alcanzados antes de mantenimiento: 7 departamentos, 7 ciudades, 6 sedes,
-- 12 empleados, 6 categorías, 18 tarifas, 10 temporadas, 17 vehículos,
-- 6 mantenimientos, 14 clientes, 14 licencias, 4 conductores, 14 reservas,
-- 8 contratos, 13 inspecciones, 3 daños, 8 depósitos, 13 pagos.
-- Operación 1: apertura Bucaramanga (sin is_airport y sin status explícitos).
SELECT id,name FROM cities WHERE id=6;
INSERT INTO branches(city_id,name,address,phone) VALUES(6,'FlotaYa Bucaramanga Cabecera','Carrera 35 # 48-20','6077001007');
INSERT INTO employees(branch_id,full_name,email,hired_on,role)
VALUES(7,'Daniel Rojas','daniel.rojas@flotaya.example.com','2026-11-20','ASESOR');
INSERT INTO vehicles(model_id,branch_id,plate,model_year,color,mileage_km)
VALUES(5,7,'DST503',2026,'Rojo',1200);
SELECT b.name AS sede,b.is_airport AS es_aeropuerto,ci.name AS ciudad,e.full_name AS asesor,
 v.plate AS placa,v.status AS estado FROM branches b JOIN cities ci ON ci.id=b.city_id
 JOIN employees e ON e.branch_id=b.id JOIN vehicles v ON v.branch_id=b.id WHERE b.id=7;
-- Operación 2: ajustes con consulta previa.
SELECT * FROM rates WHERE category_id=6 AND season_type='ALTA';
UPDATE rates SET daily_rate=ROUND(daily_rate*1.05,2) WHERE category_id=6 AND season_type='ALTA';
SELECT * FROM rates WHERE category_id=6 AND season_type='ALTA';
SELECT * FROM extras WHERE id=1;
UPDATE extras SET list_daily_price=16000 WHERE id=1;
SELECT ex.name,ex.list_daily_price AS precio_lista,ce.agreed_daily_price AS precio_pactado,
 ce.contract_id FROM extras ex JOIN contract_extras ce ON ce.extra_id=ex.id WHERE ex.id=1;
-- Operación 3: primero se muestra el filtro no indexado, sin ejecutarlo con Safe Updates.
SELECT * FROM reservations WHERE status='PENDIENTE' AND pickup_date>='2026-12-01';
-- ⚠️ ESPERADO: ERROR 1175 con SQL_SAFE_UPDATES=1; ejecutar aislada.
-- UPDATE reservations SET status='CONFIRMADA' WHERE status='PENDIENTE' AND pickup_date>='2026-12-01';
SELECT * FROM reservations WHERE id IN (511,512);
UPDATE reservations SET status='CONFIRMADA' WHERE id IN (511,512) AND status='PENDIENTE' AND pickup_date>='2026-12-01';
SELECT * FROM reservations WHERE id IN (511,512);
-- Operación 4: limpieza de objetos sin dependientes.
SELECT b.*, (SELECT COUNT(*) FROM vehicle_models vm WHERE vm.brand_id=b.id) AS modelos FROM brands b WHERE b.id=7;
DELETE FROM brands WHERE id=7;
SELECT * FROM brands WHERE id=7;
SELECT ex.*, (SELECT COUNT(*) FROM contract_extras ce WHERE ce.extra_id=ex.id) AS usos FROM extras ex WHERE ex.id=6;
DELETE FROM extras WHERE id=6;
SELECT * FROM extras WHERE id=6;
SELECT vc.*, (SELECT COUNT(*) FROM vehicle_models vm WHERE vm.category_id=vc.id) AS modelos,
 (SELECT COUNT(*) FROM rates rt WHERE rt.category_id=vc.id) AS tarifas FROM vehicle_categories vc WHERE vc.id=1;
-- ⚠️ ESPERADO: ERROR 1451 por FK; ejecutar aislada.
-- DELETE FROM vehicle_categories WHERE id=1;
-- Operación 5: tres tipos de restricción.
-- ⚠️ ESPERADO: ERROR 1062 por UNIQUE de placa.
-- INSERT INTO vehicles(model_id,branch_id,plate,model_year,color,mileage_km) VALUES(1,1,'KWD101',2026,'Azul',1);
-- ⚠️ ESPERADO: ERROR 3819 por CHECK de cantidad.
-- INSERT INTO contract_extras(contract_id,extra_id,quantity,agreed_daily_price) VALUES(9001,1,0,15000);
-- ⚠️ ESPERADO: ERROR 1265 por ENUM del medio de pago (modo estricto).
-- INSERT INTO payments(contract_id,concept,amount,payment_method,paid_at) VALUES(9001,'CIERRE',100,'CHEQUE','2026-11-23 10:00:00');
-- Conteo final; 7 sedes, 13 empleados y 18 vehículos después de la apertura.
SELECT 'branches' AS tabla,COUNT(*) filas FROM branches UNION ALL SELECT 'employees',COUNT(*) FROM employees
UNION ALL SELECT 'vehicles',COUNT(*) FROM vehicles UNION ALL SELECT 'reservations',COUNT(*) FROM reservations
UNION ALL SELECT 'contracts',COUNT(*) FROM contracts UNION ALL SELECT 'payments',COUNT(*) FROM payments;
