-- Taller 1 · BiblioRed · Fase 2 (MySQL 8.0.16+)
-- Reglas no expresables con CHECK: cálculo de vencimiento (requiere membresía);
-- validaciones de estado, multa y cupo (otras filas/tablas);
-- integridad ejemplar-préstamo y devolución (cambios de dos tablas);
-- renovaciones, reservas vencidas y mora (agregados y referencia temporal);
-- monto acumulado de abonos, estado PAGADA y pérdidas (otras tablas).
-- Se atienden con procedimientos y TCL (no se usan triggers ni funciones).
DROP DATABASE IF EXISTS bibliored;
CREATE DATABASE bibliored;
USE bibliored;

CREATE TABLE branches (
 id BIGINT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(100) NOT NULL UNIQUE,
 city VARCHAR(70) NOT NULL, address VARCHAR(160) NOT NULL, opened_on DATE NOT NULL
);
CREATE TABLE membership_types (
 id BIGINT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(60) NOT NULL UNIQUE,
 max_loans INT NOT NULL, loan_days INT NOT NULL, max_renewals INT NOT NULL,
 daily_fine DECIMAL(10,2) NOT NULL, annual_fee DECIMAL(12,2) NOT NULL DEFAULT 0,
 CHECK(max_loans>0), CHECK(loan_days>0), CHECK(max_renewals>=0),
 CHECK(daily_fine>=0), CHECK(annual_fee>=0)
);
CREATE TABLE categories (id BIGINT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(70) NOT NULL UNIQUE);
CREATE TABLE publishers (
 id BIGINT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(100) NOT NULL UNIQUE, city VARCHAR(70) NOT NULL
);
CREATE TABLE authors (
 id BIGINT AUTO_INCREMENT PRIMARY KEY, full_name VARCHAR(120) NOT NULL,
 nationality VARCHAR(50) NOT NULL, birth_year SMALLINT NOT NULL
);
CREATE TABLE employees (
 id BIGINT AUTO_INCREMENT PRIMARY KEY, branch_id BIGINT NOT NULL,
 full_name VARCHAR(120) NOT NULL, email VARCHAR(120) NOT NULL UNIQUE,
 hired_on DATE NOT NULL,
 role ENUM('COORDINADOR','BIBLIOTECARIO','AUXILIAR') NOT NULL DEFAULT 'BIBLIOTECARIO',
 FOREIGN KEY(branch_id) REFERENCES branches(id)
);
CREATE TABLE titles (
 id BIGINT AUTO_INCREMENT PRIMARY KEY, isbn VARCHAR(20) NOT NULL UNIQUE,
 title VARCHAR(160) NOT NULL, published_year SMALLINT NOT NULL,
 category_id BIGINT NOT NULL, publisher_id BIGINT NOT NULL,
 replacement_cost DECIMAL(12,2) NOT NULL DEFAULT 50000.00,
 CHECK (replacement_cost>0),
 FOREIGN KEY(category_id) REFERENCES categories(id),
 FOREIGN KEY(publisher_id) REFERENCES publishers(id)
);
CREATE TABLE title_authors (
 id BIGINT AUTO_INCREMENT PRIMARY KEY, title_id BIGINT NOT NULL, author_id BIGINT NOT NULL,
 author_order INT NOT NULL, UNIQUE(title_id,author_id), UNIQUE(title_id,author_order),
 CHECK(author_order>0), FOREIGN KEY(title_id) REFERENCES titles(id),
 FOREIGN KEY(author_id) REFERENCES authors(id)
);
CREATE TABLE copies (
 id BIGINT AUTO_INCREMENT PRIMARY KEY, title_id BIGINT NOT NULL, branch_id BIGINT NOT NULL,
 barcode VARCHAR(25) NOT NULL UNIQUE, acquired_on DATE NOT NULL,
 status ENUM('DISPONIBLE','PRESTADO','EN_REPARACION','PERDIDO','DADO_DE_BAJA') NOT NULL DEFAULT 'DISPONIBLE',
 FOREIGN KEY(title_id) REFERENCES titles(id), FOREIGN KEY(branch_id) REFERENCES branches(id)
);
CREATE TABLE members (
 id BIGINT AUTO_INCREMENT PRIMARY KEY, document_number VARCHAR(25) NOT NULL UNIQUE,
 first_name VARCHAR(80) NOT NULL, last_name VARCHAR(80) NOT NULL,
 email VARCHAR(120) UNIQUE, phone VARCHAR(30), birth_date DATE NOT NULL,
 joined_on DATE NOT NULL, membership_type_id BIGINT NOT NULL, branch_id BIGINT NOT NULL,
 status ENUM('ACTIVO','SUSPENDIDO','INACTIVO') NOT NULL DEFAULT 'ACTIVO',
 FOREIGN KEY(membership_type_id) REFERENCES membership_types(id),
 FOREIGN KEY(branch_id) REFERENCES branches(id)
);
CREATE TABLE loans (
 id BIGINT AUTO_INCREMENT PRIMARY KEY, copy_id BIGINT NOT NULL, member_id BIGINT NOT NULL,
 employee_id BIGINT NOT NULL, loan_date DATE NOT NULL, due_date DATE NOT NULL,
 returned_on DATE,
 status ENUM('ACTIVO','DEVUELTO','PERDIDO') NOT NULL DEFAULT 'ACTIVO',
 CHECK(due_date>loan_date), CHECK(returned_on IS NULL OR returned_on>=loan_date),
 FOREIGN KEY(copy_id) REFERENCES copies(id), FOREIGN KEY(member_id) REFERENCES members(id),
 FOREIGN KEY(employee_id) REFERENCES employees(id)
) AUTO_INCREMENT=1001;
CREATE TABLE renewals (
 id BIGINT AUTO_INCREMENT PRIMARY KEY, loan_id BIGINT NOT NULL,
 renewed_on DATE NOT NULL, old_due_date DATE NOT NULL, new_due_date DATE NOT NULL,
 CHECK(new_due_date>old_due_date), FOREIGN KEY(loan_id) REFERENCES loans(id)
);
CREATE TABLE reservations (
 id BIGINT AUTO_INCREMENT PRIMARY KEY, member_id BIGINT NOT NULL,
 title_id BIGINT NOT NULL, pickup_branch_id BIGINT NOT NULL,
 reserved_on DATE NOT NULL, expires_on DATE NOT NULL,
 status ENUM('PENDIENTE','ATENDIDA','CANCELADA','VENCIDA') NOT NULL DEFAULT 'PENDIENTE',
 CHECK(expires_on>=reserved_on), FOREIGN KEY(member_id) REFERENCES members(id),
 FOREIGN KEY(title_id) REFERENCES titles(id), FOREIGN KEY(pickup_branch_id) REFERENCES branches(id)
);
CREATE TABLE fines (
 id BIGINT AUTO_INCREMENT PRIMARY KEY, loan_id BIGINT NOT NULL,
 reason ENUM('MORA','DAÑO','PERDIDA') NOT NULL, fine_days INT NOT NULL DEFAULT 0,
 amount DECIMAL(12,2) NOT NULL, generated_on DATE NOT NULL,
 status ENUM('PENDIENTE','PAGADA','ANULADA') NOT NULL DEFAULT 'PENDIENTE',
 CHECK(fine_days>=0), CHECK(amount>0), FOREIGN KEY(loan_id) REFERENCES loans(id)
);
CREATE TABLE fine_payments (
 id BIGINT AUTO_INCREMENT PRIMARY KEY, fine_id BIGINT NOT NULL,
 amount DECIMAL(12,2) NOT NULL, paid_on DATE NOT NULL,
 method ENUM('EFECTIVO','TARJETA','TRANSFERENCIA') NOT NULL,
 CHECK(amount>0), FOREIGN KEY(fine_id) REFERENCES fines(id)
);
SHOW TABLES;
DESCRIBE loans;
