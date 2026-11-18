# Fase 1 · FlotaYa · Diagrama entidad-relación

## Diagrama (Mermaid)

`||` = exactamente uno, `o{` = cero a muchos, `o|` = cero o uno. Cada FK de la hija identifica la relación con el padre. Las dobles FK a sede identifican por separado recogida y devolución.

```mermaid
erDiagram
    departments {
        BIGINT id PK
        VARCHAR name
    }
    cities {
        BIGINT id PK
        BIGINT department_id FK
        VARCHAR name
    }
    branches {
        BIGINT id PK
        BIGINT city_id FK
        VARCHAR name
        VARCHAR address
        VARCHAR phone
        BOOLEAN is_airport
    }
    employees {
        BIGINT id PK
        BIGINT branch_id FK
        VARCHAR full_name
        VARCHAR email
        DATE hired_on
        ENUM role
    }
    vehicle_categories {
        BIGINT id PK
        VARCHAR name
        INT minimum_age
        DECIMAL deposit_amount
    }
    brands {
        BIGINT id PK
        VARCHAR name
    }
    vehicle_models {
        BIGINT id PK
        BIGINT brand_id FK
        BIGINT category_id FK
        VARCHAR name
        ENUM transmission
        ENUM fuel_type
        INT seats
    }
    seasons {
        BIGINT id PK
        VARCHAR name
        ENUM season_type
        DATE start_date
        DATE end_date
    }
    rates {
        BIGINT id PK
        BIGINT category_id FK
        ENUM season_type
        DECIMAL daily_rate
    }
    vehicles {
        BIGINT id PK
        BIGINT model_id FK
        BIGINT branch_id FK
        VARCHAR plate
        SMALLINT model_year
        VARCHAR color
        INT mileage_km
        ENUM status
    }
    maintenances {
        BIGINT id PK
        BIGINT vehicle_id FK
        ENUM maintenance_type
        VARCHAR description
        VARCHAR workshop
        DATE start_date
        DATE end_date
        DECIMAL cost
    }
    customers {
        BIGINT id PK
        ENUM document_type
        VARCHAR document_number
        VARCHAR first_name
        VARCHAR last_name
        VARCHAR email
        VARCHAR phone
        DATE birth_date
        BIGINT city_id FK
        DATE registered_on
        ENUM status
    }
    licenses {
        BIGINT id PK
        BIGINT customer_id FK
        VARCHAR license_number
        ENUM license_category
        DATE issued_on
        DATE expires_on
        VARCHAR country
    }
    additional_drivers {
        BIGINT id PK
        VARCHAR document_number
        VARCHAR full_name
        DATE birth_date
        VARCHAR license_number
        DATE license_expires_on
    }
    extras {
        BIGINT id PK
        VARCHAR name
        DECIMAL list_daily_price
    }
    reservations {
        BIGINT id PK
        BIGINT customer_id FK
        BIGINT vehicle_id FK
        BIGINT pickup_branch_id FK
        BIGINT return_branch_id FK
        DATE pickup_date
        DATE return_date
        DECIMAL quoted_amount
        DATETIME created_at
        ENUM status
    }
    contracts {
        BIGINT id PK
        BIGINT reservation_id FK
        BIGINT vehicle_id FK
        BIGINT employee_id FK
        DATE start_date
        DATE expected_end_date
        DATE actual_return_date
        DECIMAL rental_amount
        ENUM status
    }
    contract_drivers {
        BIGINT id PK
        BIGINT contract_id FK
        BIGINT additional_driver_id FK
    }
    contract_extras {
        BIGINT id PK
        BIGINT contract_id FK
        BIGINT extra_id FK
        INT quantity
        DECIMAL agreed_daily_price
    }
    pickups {
        BIGINT id PK
        BIGINT contract_id FK
        BIGINT branch_id FK
        BIGINT employee_id FK
        DATETIME occurred_at
        INT mileage_km
        INT fuel_pct
    }
    returns {
        BIGINT id PK
        BIGINT contract_id FK
        BIGINT branch_id FK
        BIGINT employee_id FK
        DATETIME occurred_at
        INT mileage_km
        INT fuel_pct
    }
    inspections {
        BIGINT id PK
        BIGINT contract_id FK
        BIGINT employee_id FK
        ENUM stage
        DATETIME inspected_at
        BOOLEAN exterior_ok
        BOOLEAN interior_ok
        VARCHAR notes
    }
    damages {
        BIGINT id PK
        BIGINT inspection_id FK
        VARCHAR description
        ENUM severity
        DECIMAL repair_cost
        BOOLEAN charge_customer
    }
    deposits {
        BIGINT id PK
        BIGINT contract_id FK
        DECIMAL amount
        DATETIME retained_at
        DATETIME released_at
        DECIMAL applied_amount
        ENUM status
    }
    payments {
        BIGINT id PK
        BIGINT contract_id FK
        ENUM concept
        DECIMAL amount
        ENUM payment_method
        DATETIME paid_at
        CHAR card_last4
        VARCHAR authorization_code
    }
    departments ||--o{ cities : "department_id"
    cities ||--o{ branches : "city_id"
    branches ||--o{ employees : "branch_id"
    brands ||--o{ vehicle_models : "brand_id"
    vehicle_categories ||--o{ vehicle_models : "category_id"
    vehicle_categories ||--o{ rates : "category_id"
    vehicle_models ||--o{ vehicles : "model_id"
    branches ||--o{ vehicles : "branch_id"
    vehicles ||--o{ maintenances : "vehicle_id"
    cities ||--o{ customers : "city_id"
    customers ||--o{ licenses : "customer_id"
    customers ||--o{ reservations : "customer_id"
    vehicles ||--o{ reservations : "vehicle_id"
    branches ||--o{ reservations : "pickup_branch_id"
    branches ||--o{ reservations : "return_branch_id"
    reservations ||--o| contracts : "reservation_id"
    vehicles ||--o{ contracts : "vehicle_id"
    employees ||--o{ contracts : "employee_id"
    contracts ||--o{ contract_drivers : "contract_id"
    additional_drivers ||--o{ contract_drivers : "additional_driver_id"
    contracts ||--o{ contract_extras : "contract_id"
    extras ||--o{ contract_extras : "extra_id"
    contracts ||--o| pickups : "contract_id"
    branches ||--o{ pickups : "branch_id"
    employees ||--o{ pickups : "employee_id"
    contracts ||--o| returns : "contract_id"
    branches ||--o{ returns : "branch_id"
    employees ||--o{ returns : "employee_id"
    contracts ||--o{ inspections : "contract_id"
    employees ||--o{ inspections : "employee_id"
    inspections ||--o{ damages : "inspection_id"
    contracts ||--o| deposits : "contract_id"
    contracts ||--o{ payments : "contract_id"
```

## Cardinalidades y participación

`departments` 0..N `cities`, cada ciudad 1..1 departamento; `cities` 0..N `branches`, cada sede 1..1 ciudad. Cada sede 0..N empleados y vehículos; cada empleado/vehículo 1..1 sede vigente. Una marca 0..N modelos, cada modelo 1..1 marca y 1..1 categoría; categoría 0..N modelos y exactamente 3 tarifas por tipo; una temporada establece un intervalo de un tipo de temporada. Un modelo 0..N vehículos. Un vehículo 0..N reservas históricas, mantenimientos y contratos, cada hijo 1..1 vehículo. Una reserva 1..1 cliente, 1..1 vehículo y 1..1 sede de entrega y 1..1 de devolución; cada reserva 0..1 contrato (`UNIQUE`). Cliente 0..N licencias, cada licencia 1..1 cliente. Contrato 0..N conductores adicionales y extras por puente, 0..1 entrega, 0..1 devolución, 0..2 inspecciones (máximo una por etapa), 1..1 depósito en el caso de negocio, 0..N pagos. Cada inspección 0..N daños y cada daño 1..1 inspección.

Las 1:1 opcionales las limita `UNIQUE(contract_id)` en `pickups`, `returns` y `deposits`, y `UNIQUE(contract_id,stage)` en `inspections`. Cada entrega y devolución apunta también a una sede y empleado propios; no es la sede de afiliación de un cliente.

## Normalización y preguntas guía

- **1FN:** una reserva con `[GPS, silla, seguro]` en una sola celda no es atómica; los extras pactados van en filas de `contract_extras`.
- **2FN:** en una relación contrato-extra, `list_daily_price` depende del extra, no del par; vive en `extras`, mientras `agreed_daily_price` es atributo del vínculo y conserva el precio histórico.
- **3FN:** la edad mínima y depósito dependen de categoría, no de placa ni modelo; separarlos evita actualizaciones múltiples. La tarifa depende de `(category_id, season_type)` y son **6 × 3 = 18** tarifas, no 60 para las diez temporadas.
- **4FN:** conjuntos independientes de conductores, extras, pagos y daños residen en tablas separadas; no combinamos sus múltiples valores en un producto cartesiano.

Reserva y contrato no son la misma cosa: la reserva puede cancelarse sin contrato; `contracts.reservation_id` determina al cliente a través de la reserva. Una renovación de licencia añade otra fila y un conductor adicional puede existir sin ser cliente. Un daño pertenece a `inspections`, cuya `stage` distingue previo de nuevo; los previos se marcan no cobrables. Guardamos `quoted_amount` (histórico), `agreed_daily_price`, `rental_amount` al cierre y datos observados; la edad, noches, tarifa aplicable y saldo se **calculan**.

## Reglas y restricciones entre tablas

| Regla | Estructura | Solución adicional |
|---|---|---|
| 6 | Solo `end_date >= start_date` | Comprobar cobertura y solapamiento del calendario completo |
| 8 | No | `fn_valor_alquiler` recorre cada noche |
| 9 | Fechas y nulidad consistente | Operación coordinada al terminar taller |
| 14 | No | `sp_crear_reserva` busca cruces de reservas vivas |
| 15 | No | Edad y licencia vigentes en procedimiento |
| 20 | Costo/etapa/cobro individual | Validar que un daño previo no sea cobrable |
| 21 | `applied_amount <= amount` | Vincular monto con categoría al abrir contrato |
| 23 | No | Cierre con procedimiento y transacción exterior |

Los procedimientos verifican las reglas al acceder por las rutas previstas. Sin triggers, las escrituras directas con cuenta administrativa pueden eludir validaciones cruzadas; por eso las cuentas de uso diario reciben privilegios mínimos.
