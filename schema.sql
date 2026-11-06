
-- AeroGlobal E-Commerce Database
-- Database Architecture and Scalability
-- ============================================

-- This normalized relational design stores customers,
-- suppliers, products, orders, and order items in
-- separate but connected tables. Primary and foreign
-- keys maintain relationships and prevent isolated
-- data silos.
--
-- The design provides a foundation for future
-- horizontal scalability across additional database
-- server nodes, subject to suitable infrastructure
-- and distributed database architecture.
--
-- Transaction Integrity and Atomicity:
-- Primary keys ensure unique records, while foreign
-- keys maintain referential integrity. During order
-- placement, related database operations should run
-- inside a PostgreSQL transaction so all changes
-- succeed together or are rolled back.
--
-- PostgreSQL transactions use BEGIN, COMMIT, and
-- ROLLBACK to enforce the all-or-nothing principle.



--- Table 1: Customers
CREATE TABLE customers (
    customer_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    customer_email VARCHAR(255) NOT NULL UNIQUE
);

-- Table 2: Suppliers

CREATE TABLE suppliers (
    supplier_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    supplier_name VARCHAR(150) NOT NULL UNIQUE,
    supplier_contact VARCHAR(255) NOT NULL
);

-- Table 3: Products

CREATE TABLE products (
    product_id VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    product_category VARCHAR(100) NOT NULL,
    supplier_id INT NOT NULL,

    CONSTRAINT fk_products_suppliers
        FOREIGN KEY (supplier_id)
        REFERENCES suppliers(supplier_id)
);

-- Table 4: Orders

CREATE TABLE orders (
    order_id VARCHAR(20) PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,

    CONSTRAINT fk_orders_customers
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

-- Table 5: OrderItems

CREATE TABLE order_items (
    order_item_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id VARCHAR(20) NOT NULL,
    product_id VARCHAR(20) NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0),

    CONSTRAINT fk_order_items_orders
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT fk_order_items_products
        FOREIGN KEY (product_id)
        REFERENCES products(product_id),

    CONSTRAINT uq_order_product
        UNIQUE (order_id, product_id)
);

