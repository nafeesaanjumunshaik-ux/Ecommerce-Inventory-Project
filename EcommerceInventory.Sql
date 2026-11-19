-- =====================================
-- PROJECT: E-COMMERCE INVENTORY SYSTEM
-- DOMAIN: SQL INTERNSHIP
-- =====================================

-- 1. Create and select database
CREATE DATABASE IF NOT EXISTS EcommerceDB;
USE EcommerceDB;

-- 2. Create Categories table
CREATE TABLE IF NOT EXISTS Categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

-- 3. Create Products table
CREATE TABLE IF NOT EXISTS Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category_id INT,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    FOREIGN KEY (category_id)
        REFERENCES Categories(category_id)
);

-- 4. Create Customers table
CREATE TABLE IF NOT EXISTS Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    city VARCHAR(50)
);

-- 5. Create Orders table
CREATE TABLE IF NOT EXISTS Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_status VARCHAR(30) DEFAULT 'Pending',
    FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id)
);

-- 6. Create Order_Items table
CREATE TABLE IF NOT EXISTS Order_Items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id)
        REFERENCES Orders(order_id),
    FOREIGN KEY (product_id)
        REFERENCES Products(product_id)
);

-- =====================================
-- INSERT SAMPLE DATA
-- =====================================

-- 7. Insert Categories
INSERT IGNORE INTO Categories (category_name)
VALUES
('Electronics'),
('Clothing'),
('Books'),
('Accessories');

-- 8. Insert Products
INSERT INTO Products
(product_name, category_id, price, stock_quantity)
SELECT 'Laptop', category_id, 55000, 10
FROM Categories WHERE category_name = 'Electronics'
AND NOT EXISTS (SELECT 1 FROM Products WHERE product_name = 'Laptop');

INSERT INTO Products
(product_name, category_id, price, stock_quantity)
SELECT 'Mobile Phone', category_id, 20000, 15
FROM Categories WHERE category_name = 'Electronics'
AND NOT EXISTS (SELECT 1 FROM Products WHERE product_name = 'Mobile Phone');

INSERT INTO Products
(product_name, category_id, price, stock_quantity)
SELECT 'T-Shirt', category_id, 500, 30
FROM Categories WHERE category_name = 'Clothing'
AND NOT EXISTS (SELECT 1 FROM Products WHERE product_name = 'T-Shirt');

INSERT INTO Products
(product_name, category_id, price, stock_quantity)
SELECT 'SQL Book', category_id, 400, 20
FROM Categories WHERE category_name = 'Books'
AND NOT EXISTS (SELECT 1 FROM Products WHERE product_name = 'SQL Book');

INSERT INTO Products
(product_name, category_id, price, stock_quantity)
SELECT 'Headphones', category_id, 1500, 12
FROM Categories WHERE category_name = 'Accessories'
AND NOT EXISTS (SELECT 1 FROM Products WHERE product_name = 'Headphones');

-- 9. Insert Customers
INSERT IGNORE INTO Customers
(customer_name, email, city)
VALUES
('Anjali', 'anjali@gmail.com', 'Tirupati'),
('Rahul', 'rahul@gmail.com', 'Chennai'),
('Priya', 'priya@gmail.com', 'Bangalore'),
('Arun', 'arun@gmail.com', 'Hyderabad');

-- 10. Insert Orders
INSERT INTO Orders (customer_id, order_date, order_status)
SELECT customer_id, '2026-11-15', 'Delivered'
FROM Customers
WHERE email = 'anjali@gmail.com'
AND NOT EXISTS (
    SELECT 1 FROM Orders
    WHERE customer_id = Customers.customer_id
    AND order_date = '2026-11-15'
);

INSERT INTO Orders (customer_id, order_date, order_status)
SELECT customer_id, '2026-11-16', 'Pending'
FROM Customers
WHERE email = 'rahul@gmail.com'
AND NOT EXISTS (
    SELECT 1 FROM Orders
    WHERE customer_id = Customers.customer_id
    AND order_date = '2026-11-16'
);

INSERT INTO Orders (customer_id, order_date, order_status)
SELECT customer_id, '2026-11-17', 'Delivered'
FROM Customers
WHERE email = 'priya@gmail.com'
AND NOT EXISTS (
    SELECT 1 FROM Orders
    WHERE customer_id = Customers.customer_id
    AND order_date = '2026-11-17'
);

-- 11. Insert Order Items
INSERT INTO Order_Items
(order_id, product_id, quantity, unit_price)
SELECT o.order_id, p.product_id, 1, p.price
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Products p ON p.product_name = 'Laptop'
WHERE c.email = 'anjali@gmail.com'
AND o.order_date = '2026-11-15'
AND NOT EXISTS (
    SELECT 1 FROM Order_Items oi
    WHERE oi.order_id = o.order_id
    AND oi.product_id = p.product_id
);

INSERT INTO Order_Items
(order_id, product_id, quantity, unit_price)
SELECT o.order_id, p.product_id, 2, p.price
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Products p ON p.product_name = 'T-Shirt'
WHERE c.email = 'rahul@gmail.com'
AND o.order_date = '2026-11-16'
AND NOT EXISTS (
    SELECT 1 FROM Order_Items oi
    WHERE oi.order_id = o.order_id
    AND oi.product_id = p.product_id
);

INSERT INTO Order_Items
(order_id, product_id, quantity, unit_price)
SELECT o.order_id, p.product_id, 1, p.price
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Products p ON p.product_name = 'SQL Book'
WHERE c.email = 'priya@gmail.com'
AND o.order_date = '2026-11-17'
AND NOT EXISTS (
    SELECT 1 FROM Order_Items oi
    WHERE oi.order_id = o.order_id
    AND oi.product_id = p.product_id
);

-- =====================================
-- SQL QUERIES / REPORTS
-- =====================================

-- 12. Display all products
SELECT * FROM Products;

-- 13. Display all customers
SELECT * FROM Customers;

-- 14. Display product names with categories
SELECT p.product_name, c.category_name,
       p.price, p.stock_quantity
FROM Products p
JOIN Categories c
ON p.category_id = c.category_id;

-- 15. Find products with low stock
SELECT * FROM Products
WHERE stock_quantity < 15;

-- 16. Find products costing more than 1000
SELECT * FROM Products
WHERE price > 1000;

-- 17. Display customer orders
SELECT c.customer_name, o.order_id,
       o.order_date, o.order_status
FROM Customers c
JOIN Orders o
ON c.customer_id = o.customer_id;

-- 18. Calculate order-wise total amount
SELECT o.order_id, c.customer_name,
       SUM(oi.quantity * oi.unit_price) AS total_amount
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Order_Items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, c.customer_name;

-- 19. Calculate total sales
SELECT SUM(quantity * unit_price) AS total_sales
FROM Order_Items;

-- 20. Count products in each category
SELECT c.category_name,
       COUNT(p.product_id) AS total_products
FROM Categories c
LEFT JOIN Products p
ON c.category_id = p.category_id
GROUP BY c.category_id, c.category_name;

-- 21. Find the most expensive product
SELECT * FROM Products
ORDER BY price DESC
LIMIT 1;

-- 22. Find total orders
SELECT COUNT(*) AS total_orders
FROM Orders;

-- 23. Find delivered orders
SELECT * FROM Orders
WHERE order_status = 'Delivered';

-- 24. Display product sales quantity
SELECT p.product_name,
       SUM(oi.quantity) AS total_quantity_sold
FROM Products p
JOIN Order_Items oi
ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name;

-- 25. Display customers from Tirupati
SELECT * FROM Customers
WHERE city = 'Tirupati';

-- =====================================
-- PROJECT COMPLETED
-- =====================================