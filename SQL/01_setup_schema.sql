-- ============================================================
-- SETUP SCHEMA — SQL Retail Analysis Portfolio
-- Database: UrbanTrend (e-commerce fashion retail dataset)
-- ============================================================

CREATE DATABASE urbantrend;

CREATE SCHEMA retail;

-- ------------------------------------------------------------
-- STEP 1 — Tables without dependencies (base dimensions)
-- ------------------------------------------------------------

CREATE TABLE retail.city_province_region (
    city_id INTEGER PRIMARY KEY,
    city_name VARCHAR(100),
    province VARCHAR(100),
    region VARCHAR(50),
    latitude NUMERIC(9,6),
    longitude NUMERIC(9,6)
);

CREATE TABLE retail.date (
    date_id INTEGER PRIMARY KEY,
    full_date DATE,
    year INTEGER,
    month INTEGER,
    month_name VARCHAR(20),
    day INTEGER,
    quarter INTEGER,
    day_name VARCHAR(20),
    is_weekend SMALLINT,
    is_holiday SMALLINT
);

CREATE TABLE retail.payment_methods (
    payment_id INTEGER PRIMARY KEY,
    method_name VARCHAR(100),
    provider VARCHAR(100),
    fee_percentage NUMERIC(5,2)
);

CREATE TABLE retail.order_status (
    status_id INTEGER PRIMARY KEY,
    status_name VARCHAR(50),
    status_category VARCHAR(50),
    description TEXT
);

CREATE TABLE retail.products (
    product_id INTEGER PRIMARY KEY,
    product_name VARCHAR(150),
    category VARCHAR(100),
    subcategory VARCHAR(100),
    brand VARCHAR(100),
    base_price NUMERIC(14,2),
    cost_price NUMERIC(14,2)
);

-- ------------------------------------------------------------
-- STEP 2 — Table dependent on Step 1
-- ------------------------------------------------------------

CREATE TABLE retail.employees (
    employee_id INTEGER PRIMARY KEY,
    full_name VARCHAR(150),
    email VARCHAR(150),
    department VARCHAR(100),
    position VARCHAR(100),
    gender CHAR(1),
    hire_date DATE,
    salary NUMERIC(14,2),
    city_id INTEGER REFERENCES retail.city_province_region(city_id),
    manager_id INTEGER REFERENCES retail.employees(employee_id)
);

CREATE TABLE retail.customers (
    customer_id INTEGER PRIMARY KEY,
    full_name VARCHAR(150),
    email VARCHAR(150),
    phone VARCHAR(30),
    gender CHAR(1),
    birth_date DATE,
    registration_date DATE,
    city_id INTEGER REFERENCES retail.city_province_region(city_id),
    address TEXT,
    membership_tier VARCHAR(30),
    total_orders INTEGER,
    total_spent NUMERIC(14,2),
    city_name VARCHAR(100)
);

CREATE TABLE retail.subproducts (
    subproduct_id INTEGER PRIMARY KEY,
    product_id INTEGER REFERENCES retail.products(product_id),
    variant_name VARCHAR(150),
    sku VARCHAR(50),
    size VARCHAR(20),
    color VARCHAR(50),
    price_adjustment NUMERIC(14,2),
    final_price NUMERIC(14,2)
);

CREATE TABLE retail.suppliers (
    supplier_id INTEGER PRIMARY KEY,
    supplier_name VARCHAR(150),
    contact_person VARCHAR(150),
    email VARCHAR(150),
    phone VARCHAR(30),
    address TEXT,
    city_id INTEGER REFERENCES retail.city_province_region(city_id),
    category_supplied VARCHAR(100),
    rating NUMERIC(3,1),
    payment_terms VARCHAR(50),
    lead_time_days INTEGER,
    minimum_order_value NUMERIC(14,2),
    status VARCHAR(30),
    contract_start_date DATE
);

CREATE TABLE retail.marketing_campaigns (
    campaign_id INTEGER PRIMARY KEY,
    campaign_name VARCHAR(150),
    channel VARCHAR(100),
    start_date DATE,
    end_date DATE,
    budget NUMERIC(14,2),
    actual_spend NUMERIC(14,2),
    impressions INTEGER,
    clicks INTEGER,
    conversions INTEGER,
    revenue_generated NUMERIC(14,2),
    roas NUMERIC(6,2),
    employee_id INTEGER REFERENCES retail.employees(employee_id),
    status VARCHAR(30),
    target_audience VARCHAR(150)
);

-- ------------------------------------------------------------
-- Step 3 — Table dependent on Step 2
-- ------------------------------------------------------------

CREATE TABLE retail.inventory (
    inventory_id INTEGER PRIMARY KEY,
    subproduct_id INTEGER REFERENCES retail.subproducts(subproduct_id),
    warehouse_id VARCHAR(30),
    quantity INTEGER,
    last_updated TIMESTAMP
);

CREATE TABLE retail.orders_transaction (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER REFERENCES retail.customers(customer_id),
    subproduct_id INTEGER REFERENCES retail.subproducts(subproduct_id),
    quantity INTEGER,
    unit_price NUMERIC(14,2),
    discount_amount NUMERIC(14,2),
    shipping_cost NUMERIC(14,2),
    total_amount NUMERIC(14,2),
    payment_id INTEGER REFERENCES retail.payment_methods(payment_id),
    order_date DATE,
    status_id INTEGER REFERENCES retail.order_status(status_id),
    employee_id INTEGER REFERENCES retail.employees(employee_id),
    city_id INTEGER REFERENCES retail.city_province_region(city_id)
);

-- ------------------------------------------------------------
-- Step 4 — Table dependent on orders_transaction
-- ------------------------------------------------------------

CREATE TABLE retail.return_orders (
    return_id INTEGER PRIMARY KEY,
    order_id INTEGER REFERENCES retail.orders_transaction(order_id),
    customer_id INTEGER REFERENCES retail.customers(customer_id),
    subproduct_id INTEGER REFERENCES retail.subproducts(subproduct_id),
    return_date DATE,
    reason TEXT,
    status VARCHAR(50),
    refund_amount NUMERIC(14,2),
    processed_by INTEGER REFERENCES retail.employees(employee_id),
    resolution_date DATE
);
