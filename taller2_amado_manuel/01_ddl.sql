-- Taller 2 · FlotaYa · Fase 2 (MySQL >=8.0.16)
-- Regla | Estructura | Explicación
-- 6 temporadas: CHECK inicio <= fin; ausencia de solapamientos/huecos requiere analizar varias filas.
-- 8 cálculo: NO, se consultan otras tablas/noches, función fn_valor_alquiler.
-- 9 mantenimiento: CHECK fechas y costo; estado del vehículo requiere procedimiento/operación consistente.
-- 14 solapamiento: NO, otras reservas (sp_crear_reserva).
-- 15 edad/licencia: NO, dependen de cliente, licencia, categoría y fechas.
-- 20 daño: CHECK costo y BOOLEAN; prohibición de cobrar daño de entrega requiere otra tabla.
-- 21 depósito: CHECK aplicado<=valor; igualarlo a categoría requiere otra tabla.
-- 23 cierre: NO, requiere pagos, devoluciones, temporadas, daños y cambios atómicos.
DROP DATABASE IF EXISTS flotaya;
CREATE DATABASE flotaya;
USE flotaya;
CREATE TABLE departments (id BIGINT AUTO_INCREMENT PRIMARY KEY,name VARCHAR(80) NOT NULL UNIQUE);
CREATE TABLE cities (id BIGINT AUTO_INCREMENT PRIMARY KEY,department_id BIGINT NOT NULL,
 name VARCHAR(80) NOT NULL,UNIQUE(department_id,name),FOREIGN KEY(department_id) REFERENCES departments(id));
CREATE TABLE branches (id BIGINT AUTO_INCREMENT PRIMARY KEY,city_id BIGINT NOT NULL,
 name VARCHAR(110) NOT NULL UNIQUE,address VARCHAR(160) NOT NULL,phone VARCHAR(25),
 is_airport BOOLEAN NOT NULL DEFAULT FALSE,FOREIGN KEY(city_id) REFERENCES cities(id));
CREATE TABLE employees (id BIGINT AUTO_INCREMENT PRIMARY KEY,branch_id BIGINT NOT NULL,
 full_name VARCHAR(100) NOT NULL,email VARCHAR(120) NOT NULL UNIQUE,hired_on DATE NOT NULL,
 role ENUM('ADMINISTRADOR','ASESOR','INSPECTOR','MECANICO') NOT NULL,
 FOREIGN KEY(branch_id) REFERENCES branches(id));
CREATE TABLE vehicle_categories (id BIGINT AUTO_INCREMENT PRIMARY KEY,name VARCHAR(70) NOT NULL UNIQUE,
 minimum_age INT NOT NULL,deposit_amount DECIMAL(12,2) NOT NULL,
 CHECK(minimum_age>=18),CHECK(deposit_amount>=0));
CREATE TABLE brands (id BIGINT AUTO_INCREMENT PRIMARY KEY,name VARCHAR(60) NOT NULL UNIQUE);
CREATE TABLE vehicle_models (id BIGINT AUTO_INCREMENT PRIMARY KEY,brand_id BIGINT NOT NULL,
 category_id BIGINT NOT NULL,name VARCHAR(90) NOT NULL,
 transmission ENUM('MECANICA','AUTOMATICA') NOT NULL,
 fuel_type ENUM('GASOLINA','DIESEL','HIBRIDO','ELECTRICO') NOT NULL,
 seats INT NOT NULL,UNIQUE(brand_id,name),CHECK(seats>0),
 FOREIGN KEY(brand_id) REFERENCES brands(id),FOREIGN KEY(category_id) REFERENCES vehicle_categories(id));
CREATE TABLE seasons (id BIGINT AUTO_INCREMENT PRIMARY KEY,name VARCHAR(110) NOT NULL UNIQUE,
 season_type ENUM('BAJA','MEDIA','ALTA') NOT NULL,start_date DATE NOT NULL,end_date DATE NOT NULL,
 CHECK(end_date>=start_date));
CREATE TABLE rates (id BIGINT AUTO_INCREMENT PRIMARY KEY,category_id BIGINT NOT NULL,
 season_type ENUM('BAJA','MEDIA','ALTA') NOT NULL,daily_rate DECIMAL(12,2) NOT NULL,
 UNIQUE(category_id,season_type),CHECK(daily_rate>0),FOREIGN KEY(category_id) REFERENCES vehicle_categories(id));
CREATE TABLE vehicles (id BIGINT AUTO_INCREMENT PRIMARY KEY,model_id BIGINT NOT NULL,
 branch_id BIGINT NOT NULL,plate VARCHAR(10) NOT NULL UNIQUE,model_year SMALLINT NOT NULL,
 color VARCHAR(40) NOT NULL,mileage_km INT NOT NULL,
 status ENUM('DISPONIBLE','ALQUILADO','MANTENIMIENTO','FUERA_DE_SERVICIO') NOT NULL DEFAULT 'DISPONIBLE',
 CHECK(mileage_km>=0),FOREIGN KEY(model_id) REFERENCES vehicle_models(id),FOREIGN KEY(branch_id) REFERENCES branches(id));
CREATE TABLE maintenances (id BIGINT AUTO_INCREMENT PRIMARY KEY,vehicle_id BIGINT NOT NULL,
 maintenance_type ENUM('PREVENTIVO','CORRECTIVO','LATONERIA') NOT NULL,
 description VARCHAR(180) NOT NULL,workshop VARCHAR(120) NOT NULL,
 start_date DATE NOT NULL,end_date DATE,cost DECIMAL(12,2),
 CHECK(end_date IS NULL OR end_date>=start_date),CHECK(cost IS NULL OR cost>=0),
 CHECK((end_date IS NULL AND cost IS NULL) OR (end_date IS NOT NULL AND cost IS NOT NULL)),
 FOREIGN KEY(vehicle_id) REFERENCES vehicles(id));
CREATE TABLE customers (id BIGINT AUTO_INCREMENT PRIMARY KEY,
 document_type ENUM('CC','CE','PASAPORTE') NOT NULL DEFAULT 'CC',document_number VARCHAR(30) NOT NULL UNIQUE,
 first_name VARCHAR(80) NOT NULL,last_name VARCHAR(80) NOT NULL,
 email VARCHAR(120) NOT NULL UNIQUE,phone VARCHAR(30),birth_date DATE NOT NULL,
 city_id BIGINT NOT NULL,registered_on DATE NOT NULL,
 status ENUM('ACTIVO','BLOQUEADO') NOT NULL DEFAULT 'ACTIVO',FOREIGN KEY(city_id) REFERENCES cities(id));
CREATE TABLE licenses (id BIGINT AUTO_INCREMENT PRIMARY KEY,customer_id BIGINT NOT NULL,
 license_number VARCHAR(40) NOT NULL UNIQUE,
 license_category ENUM('B1','B2','C1','C2') NOT NULL,issued_on DATE NOT NULL,
 expires_on DATE NOT NULL,country VARCHAR(80) NOT NULL,
 CHECK(expires_on>issued_on),FOREIGN KEY(customer_id) REFERENCES customers(id));
CREATE TABLE additional_drivers (id BIGINT AUTO_INCREMENT PRIMARY KEY,
 document_number VARCHAR(30) NOT NULL UNIQUE,full_name VARCHAR(120) NOT NULL,
 birth_date DATE NOT NULL,license_number VARCHAR(40) NOT NULL UNIQUE,license_expires_on DATE NOT NULL);
CREATE TABLE extras (id BIGINT AUTO_INCREMENT PRIMARY KEY,name VARCHAR(90) NOT NULL UNIQUE,
 list_daily_price DECIMAL(12,2) NOT NULL,CHECK(list_daily_price>0));
CREATE TABLE reservations (id BIGINT AUTO_INCREMENT PRIMARY KEY,customer_id BIGINT NOT NULL,
 vehicle_id BIGINT NOT NULL,pickup_branch_id BIGINT NOT NULL,return_branch_id BIGINT NOT NULL,
 pickup_date DATE NOT NULL,return_date DATE NOT NULL,quoted_amount DECIMAL(12,2) NOT NULL,
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 status ENUM('PENDIENTE','CONFIRMADA','CONVERTIDA','CANCELADA') NOT NULL DEFAULT 'PENDIENTE',
 CHECK(return_date>pickup_date),CHECK(quoted_amount>=0),
 FOREIGN KEY(customer_id) REFERENCES customers(id),FOREIGN KEY(vehicle_id) REFERENCES vehicles(id),
 FOREIGN KEY(pickup_branch_id) REFERENCES branches(id),FOREIGN KEY(return_branch_id) REFERENCES branches(id)
) AUTO_INCREMENT=501;
CREATE TABLE contracts (id BIGINT AUTO_INCREMENT PRIMARY KEY,reservation_id BIGINT NOT NULL UNIQUE,
 vehicle_id BIGINT NOT NULL,employee_id BIGINT NOT NULL,start_date DATE NOT NULL,
 expected_end_date DATE NOT NULL,actual_return_date DATE,
 rental_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
 status ENUM('ABIERTO','CERRADO') NOT NULL DEFAULT 'ABIERTO',
 CHECK(expected_end_date>start_date),CHECK(actual_return_date IS NULL OR actual_return_date>start_date),
 CHECK(rental_amount>=0),FOREIGN KEY(reservation_id) REFERENCES reservations(id),
 FOREIGN KEY(vehicle_id) REFERENCES vehicles(id),FOREIGN KEY(employee_id) REFERENCES employees(id)
) AUTO_INCREMENT=9001;
CREATE TABLE contract_drivers (id BIGINT AUTO_INCREMENT PRIMARY KEY,
 contract_id BIGINT NOT NULL,additional_driver_id BIGINT NOT NULL,
 UNIQUE(contract_id,additional_driver_id),FOREIGN KEY(contract_id) REFERENCES contracts(id),
 FOREIGN KEY(additional_driver_id) REFERENCES additional_drivers(id));
CREATE TABLE contract_extras (id BIGINT AUTO_INCREMENT PRIMARY KEY,contract_id BIGINT NOT NULL,
 extra_id BIGINT NOT NULL,quantity INT NOT NULL,agreed_daily_price DECIMAL(12,2) NOT NULL,
 UNIQUE(contract_id,extra_id),CHECK(quantity>=1),CHECK(agreed_daily_price>=0),
 FOREIGN KEY(contract_id) REFERENCES contracts(id),FOREIGN KEY(extra_id) REFERENCES extras(id));
CREATE TABLE pickups (id BIGINT AUTO_INCREMENT PRIMARY KEY,contract_id BIGINT NOT NULL UNIQUE,
 branch_id BIGINT NOT NULL,employee_id BIGINT NOT NULL,occurred_at DATETIME NOT NULL,
 mileage_km INT NOT NULL,fuel_pct INT NOT NULL,
 CHECK(mileage_km>=0),CHECK(fuel_pct BETWEEN 0 AND 100),
 FOREIGN KEY(contract_id) REFERENCES contracts(id),FOREIGN KEY(branch_id) REFERENCES branches(id),
 FOREIGN KEY(employee_id) REFERENCES employees(id));
CREATE TABLE returns (id BIGINT AUTO_INCREMENT PRIMARY KEY,contract_id BIGINT NOT NULL UNIQUE,
 branch_id BIGINT NOT NULL,employee_id BIGINT NOT NULL,occurred_at DATETIME NOT NULL,
 mileage_km INT NOT NULL,fuel_pct INT NOT NULL,
 CHECK(mileage_km>=0),CHECK(fuel_pct BETWEEN 0 AND 100),
 FOREIGN KEY(contract_id) REFERENCES contracts(id),FOREIGN KEY(branch_id) REFERENCES branches(id),
 FOREIGN KEY(employee_id) REFERENCES employees(id));
CREATE TABLE inspections (id BIGINT AUTO_INCREMENT PRIMARY KEY,contract_id BIGINT NOT NULL,
 employee_id BIGINT NOT NULL,stage ENUM('ENTREGA','DEVOLUCION') NOT NULL,
 inspected_at DATETIME NOT NULL,exterior_ok BOOLEAN NOT NULL,interior_ok BOOLEAN NOT NULL,
 notes VARCHAR(255),UNIQUE(contract_id,stage),
 FOREIGN KEY(contract_id) REFERENCES contracts(id),FOREIGN KEY(employee_id) REFERENCES employees(id));
CREATE TABLE damages (id BIGINT AUTO_INCREMENT PRIMARY KEY,inspection_id BIGINT NOT NULL,
 description VARCHAR(180) NOT NULL,severity ENUM('LEVE','MODERADO','GRAVE') NOT NULL,
 repair_cost DECIMAL(12,2) NOT NULL,charge_customer BOOLEAN NOT NULL DEFAULT FALSE,
 CHECK(repair_cost>=0),FOREIGN KEY(inspection_id) REFERENCES inspections(id));
CREATE TABLE deposits (id BIGINT AUTO_INCREMENT PRIMARY KEY,contract_id BIGINT NOT NULL UNIQUE,
 amount DECIMAL(12,2) NOT NULL,retained_at DATETIME NOT NULL,
 released_at DATETIME,applied_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
 status ENUM('RETENIDO','LIBERADO','APLICADO') NOT NULL DEFAULT 'RETENIDO',
 CHECK(amount>=0),CHECK(applied_amount>=0 AND applied_amount<=amount),
 FOREIGN KEY(contract_id) REFERENCES contracts(id));
CREATE TABLE payments (id BIGINT AUTO_INCREMENT PRIMARY KEY,contract_id BIGINT NOT NULL,
 concept ENUM('ALQUILER','EXTRAS','DAÑOS','CIERRE') NOT NULL,
 amount DECIMAL(12,2) NOT NULL,
 payment_method ENUM('TARJETA','EFECTIVO','TRANSFERENCIA','DEPOSITO') NOT NULL,
 paid_at DATETIME NOT NULL,card_last4 CHAR(4),authorization_code VARCHAR(50),
 CHECK(amount>0),FOREIGN KEY(contract_id) REFERENCES contracts(id));
SHOW TABLES;
DESCRIBE reservations;
DESCRIBE contracts;
