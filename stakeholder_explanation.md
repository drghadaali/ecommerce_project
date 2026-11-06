# AeroGlobal E-Commerce Database Design

## 1. Email to the Sales Team

**To:** AeroGlobal Sales Team

**From:** Dr. Ghada Ali

**Subject:** Proposed Relational Database Design for the E-Commerce Platform

Dear Sales Team,

Thank you for sharing the initial e-commerce data mockup. Before developing the application, we need to organize the information into a structured Relational Database Management System (RDBMS). An Entity-Relationship Diagram (ERD) is a visual representation of a database that shows its entities, their attributes, and the relationships between them. An entity represents a real-world object or concept that the business needs to store information about, such as a Customer, Product, Supplier, or Order. Each entity is represented as a table, its attributes become columns, and primary keys uniquely identify its records.

For the AeroGlobal project, Customers, Suppliers, Products, and Orders will be separate entities. We will also introduce an OrderItems entity to connect Orders and Products, because one order can contain multiple products and one product can appear in multiple orders. Primary keys and foreign keys will connect these tables while maintaining referential integrity.

The current flat file systems approach stores customer, product, supplier, and order information repeatedly in the same spreadsheet. This creates data redundancy and can lead to update, insertion, and deletion anomalies. By moving to a normalized relational design, we can store each type of information in the appropriate table and connect records through keys. This will make the database more accurate, maintainable, and easier to expand as AeroGlobal's e-commerce operations grow.

Best regards,

Dr. Ghada Ali

---

## 2. Review of the Current Draft Schema

The provided draft_schema.csv contains 20 order-line records and 11 columns. The dataset includes 15 distinct orders, 8 distinct customers, 7 distinct products, and 5 distinct suppliers.

### Identified Redundancy Issues and Data Anomalies

**1. Repeated Customer Information**

Customer names and email addresses are repeated across multiple order lines. For example, Alice Johnson and alice.j@example.com appear in both product rows of order ORD-5001 and in other orders such as ORD-5004 and ORD-5012.

**2. Repeated Product Information**

Product details are repeated whenever the same product is purchased. For example, PROD-103 (In-Flight Wi-Fi (24h)) appears in orders ORD-5002, ORD-5004, ORD-5009, ORD-5011, and ORD-5015 with the same product name, category, supplier, and supplier contact.

**3. Repeated Supplier Information**

Supplier names and contact details appear repeatedly for products supplied by the same company. For example, SkyTech Audio and contact@skytechaudio.com are repeated for products PROD-101 and PROD-106.

**4. Repeated Order Information**

Order-level information, including the customer and order date, is repeated for every product belonging to the same order. For example, ORD-5001 appears twice with the same customer and order date.

### Potential Data Anomalies

- **Update Anomaly:** Changing a supplier's contact information requires updating multiple rows, increasing the risk of inconsistent records.
- **Insertion Anomaly:** The flat file structure does not provide an independent place to register a new customer, supplier, or product without creating an order-line record.
- **Deletion Anomaly:** Deleting the last order line containing a product could also remove the only stored record of that product and its supplier information.

---

## 3. Proposed Normalized Database Schema (3NF)

The proposed relational database consists of five tables: Customers, Suppliers, Products, Orders, and OrderItems. Each table stores information about a specific business entity, while primary keys and foreign keys establish relationships between the tables.

### Table 1: Customers

Stores customer information separately from their orders.

**Primary Key:** customer_id

**Foreign Keys:** None

**Columns:**
- customer_id: INT, Primary Key, auto-generated.
- customer_name: VARCHAR(100), NOT NULL.
- customer_email: VARCHAR(255), NOT NULL, UNIQUE.

### Table 2: Suppliers

Stores supplier details in one central location.

**Primary Key:** supplier_id

**Foreign Keys:** None

**Columns:**
- supplier_id: INT, Primary Key, auto-generated.
- supplier_name: VARCHAR(150), NOT NULL.
- supplier_contact: VARCHAR(255), NOT NULL.

### Table 3: Products

Stores product details and identifies the supplier responsible for each product.

**Primary Key:** product_id

**Foreign Keys:**
- supplier_id references Suppliers(supplier_id).

**Columns:**
- product_id: VARCHAR(20), Primary Key.
- product_name: VARCHAR(200), NOT NULL.
- product_category: VARCHAR(100), NOT NULL.
- supplier_id: INT, Foreign Key, NOT NULL.

### Table 4: Orders

Stores order-level information separately from individual product lines.

**Primary Key:** order_id

**Foreign Keys:**
- customer_id references Customers(customer_id).

**Columns:**
- order_id: VARCHAR(20), Primary Key.
- customer_id: INT, Foreign Key, NOT NULL.
- order_date: DATE, NOT NULL.

### Table 5: OrderItems

Connects Orders and Products and stores the details of each product within an order.

**Primary Key:** order_item_id

**Foreign Keys:**
- order_id references Orders(order_id).
- product_id references Products(product_id).

**Columns:**
- order_item_id: INT, Primary Key, auto-generated.
- order_id: VARCHAR(20), Foreign Key, NOT NULL.
- product_id: VARCHAR(20), Foreign Key, NOT NULL.
- quantity: INT, NOT NULL.
- unit_price: NUMERIC(10,2), NOT NULL.

**Additional Constraint:**
- UNIQUE(order_id, product_id) prevents the same product from appearing in multiple lines within the same order.

**Price Handling:**

The source CSV contains TotalPrice as the total amount for each product line. Unit price is calculated by dividing TotalPrice by Quantity. The line total can therefore be calculated as Quantity multiplied by UnitPrice without storing a redundant calculated value.

---

## 4. Normalization Summary

### First Normal Form (1NF)

Each row represents one order-product combination, and each column contains a single atomic value rather than a repeating group of values.

### Second Normal Form (2NF)

Order-level information is separated from product-level transaction information, ensuring that attributes depend on their complete keys rather than only part of a combined order-product key.

### Third Normal Form (3NF)

Customer, supplier, product, and order attributes are stored in their respective tables, ensuring that non-key attributes depend on their table's primary key rather than on other non-key attributes.

The final design reduces data redundancy, improves data integrity, and provides a structured foundation for AeroGlobal's PostgreSQL database.