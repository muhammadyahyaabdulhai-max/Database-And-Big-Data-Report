
-- PROJECT: E-Commerce Platform Database

CREATE SCHEMA ecommerce_project;
USE ecommerce_project;


-- 1. TABLE CREATION


CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone_number VARCHAR(20),
    registration_date DATE NOT NULL,
    country VARCHAR(50) NOT NULL
);

CREATE TABLE Suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    contact_name VARCHAR(100),
    phone VARCHAR(20),
    country VARCHAR(50)
);

CREATE TABLE Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255)
);

CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    stock INT NOT NULL DEFAULT 0 CHECK (stock >= 0),
    supplier_id INT,
    category_id INT,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00 CHECK (total_amount >= 0),
    o_status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Order_Details (
    order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price_each DECIMAL(10,2) NOT NULL CHECK (price_each > 0),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_date DATE NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    amount DECIMAL(10,2) NOT NULL CHECK (amount >= 0),
    payment_status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

CREATE TABLE Shipping (
    shipping_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL UNIQUE,
    shipping_address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    shipping_date DATE,
    delivery_date DATE,
    shipping_status VARCHAR(20) NOT NULL DEFAULT 'Preparing',
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

CREATE TABLE Reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review_text VARCHAR(500),
    review_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Order_Log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    log_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- 2. SAMPLE DATA INSERTION


INSERT INTO Customers (first_name, last_name, email, phone_number, registration_date, country)
VALUES
('Ali', 'Khan', 'ali.khan@example.com', '03001234567', '2024-01-10', 'Pakistan'),
('Sara', 'Ahmed', 'sara.ahmed@example.com', '03007654321', '2024-02-05', 'Germany'),
('John', 'Miller', 'john.miller@example.com', '0170123456', '2024-03-12', 'USA'),
('Fatima', 'Noor', 'fatima.noor@example.com', NULL, '2024-04-01', 'Germany');

INSERT INTO Suppliers (supplier_name, contact_name, phone, country)
VALUES
('TechSource', 'Emma Brown', '111222333', 'Germany'),
('FashionHub', 'David Lee', '444555666', 'Italy'),
('HomeNeeds', 'Sophie White', '777888999', 'France');

INSERT INTO Categories (category_name, description)
VALUES
('Electronics', 'Electronic devices and accessories'),
('Clothing', 'Fashion and apparel'),
('Home', 'Home and living products');

INSERT INTO Products (product_name, description, price, stock, supplier_id, category_id)
VALUES
('Laptop', '15-inch business laptop', 1200.00, 25, 1, 1),
('Smartphone', '128GB Android smartphone', 700.00, 40, 1, 1),
('Jacket', 'Winter leather jacket', 150.00, 30, 2, 2),
('T-Shirt', 'Cotton casual t-shirt', 25.00, 100, 2, 2),
('Blender', 'Kitchen blender machine', 80.00, 15, 3, 3),
('Desk Lamp', 'LED study lamp', 35.00, 50, 3, 3);

INSERT INTO Orders (customer_id, order_date, total_amount, o_status)
VALUES
(1, '2024-10-01', 1900.00, 'Pending'),
(2, '2024-10-03', 150.00, 'Shipped'),
(1, '2024-10-05', 25.00, 'Completed'),
(3, '2024-10-08', 115.00, 'Pending');

INSERT INTO Order_Details (order_id, product_id, quantity, price_each)
VALUES
(1, 1, 1, 1200.00),
(1, 2, 1, 700.00),
(2, 3, 1, 150.00),
(3, 4, 1, 25.00),
(4, 5, 1, 80.00),
(4, 6, 1, 35.00);

INSERT INTO Payments (order_id, payment_date, payment_method, amount, payment_status)
VALUES
(1, '2024-10-01', 'Credit Card', 1900.00, 'Paid'),
(2, '2024-10-03', 'PayPal', 150.00, 'Paid'),
(3, '2024-10-05', 'Cash on Delivery', 25.00, 'Pending');

INSERT INTO Shipping (order_id, shipping_address, city, postal_code, shipping_date, delivery_date, shipping_status)
VALUES
(1, 'Street 1', 'Berlin', '10115', '2024-10-02', '2024-10-05', 'Delivered'),
(2, 'Street 2', 'Munich', '80331', '2024-10-04', NULL, 'In Transit'),
(3, 'Street 3', 'Lahore', '54000', NULL, NULL, 'Preparing'),
(4, 'Street 4', 'Hamburg', '20095', '2024-10-09', NULL, 'In Transit');

INSERT INTO Reviews (customer_id, product_id, rating, review_text, review_date)
VALUES
(1, 1, 5, 'Excellent laptop for work.', '2024-10-07'),
(2, 3, 4, 'Very good quality jacket.', '2024-10-08'),
(1, 4, 3, 'Nice shirt for the price.', '2024-10-09'),
(3, 5, 4, 'Useful and easy to use.', '2024-10-10');


-- 3. BASIC QUERIES


SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM Payments;
SELECT * FROM Shipping;
SELECT * FROM Reviews;


-- 4. FILTERING AND SORTING


SELECT *
FROM Products
WHERE price > 100;

SELECT *
FROM Customers
WHERE country = 'Germany';

SELECT *
FROM Orders
WHERE order_date BETWEEN '2024-10-01' AND '2024-10-31';

SELECT *
FROM Products
ORDER BY category_id ASC, price DESC;

SELECT *
FROM Orders
ORDER BY order_date DESC;


-- 5. UPDATE AND DELETE


UPDATE Products
SET stock = stock - 2
WHERE product_id = 2;

DELETE FROM Reviews
WHERE review_id = 3;


-- 6. AGGREGATE FUNCTIONS


SELECT COUNT(*) AS total_customers
FROM Customers;

SELECT SUM(total_amount) AS total_sales
FROM Orders;

SELECT AVG(price) AS average_product_price
FROM Products;

SELECT MIN(price) AS cheapest_product_price,
       MAX(price) AS highest_product_price
FROM Products;


-- 7. GROUP BY AND HAVING


SELECT c.category_name, COUNT(p.product_id) AS total_products
FROM Categories c
LEFT JOIN Products p ON c.category_id = p.category_id
GROUP BY c.category_name;

SELECT payment_method, SUM(amount) AS total_received
FROM Payments
GROUP BY payment_method
HAVING SUM(amount) > 100;

SELECT country, COUNT(*) AS total_customers
FROM Customers
GROUP BY country;


-- 8. JOINS


-- INNER JOIN: customers with orders
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    o.order_id,
    o.order_date,
    o.total_amount
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id;

-- INNER JOIN: orders with product details
SELECT
    o.order_id,
    o.order_date,
    p.product_name,
    od.quantity,
    od.price_each
FROM Orders o
INNER JOIN Order_Details od ON o.order_id = od.order_id
INNER JOIN Products p ON od.product_id = p.product_id;

-- INNER JOIN: customer products ordered
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    p.product_name
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id
INNER JOIN Order_Details od ON o.order_id = od.order_id
INNER JOIN Products p ON od.product_id = p.product_id;

-- LEFT JOIN: all customers and their orders
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    o.order_id,
    o.order_date,
    o.total_amount
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id;

-- LEFT JOIN: inactive customers
SELECT
    c.customer_id,
    c.first_name,
    c.last_name
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- LEFT JOIN: orders with payment details
SELECT
    o.order_id,
    o.order_date,
    o.total_amount,
    p.payment_method,
    p.payment_status
FROM Orders o
LEFT JOIN Payments p ON o.order_id = p.order_id;


-- 9. IF AND CASE


SELECT
    first_name,
    last_name,
    IF(registration_date > '2024-01-31', 'New', 'Old') AS customer_type
FROM Customers;

SELECT
    product_name,
    price,
    CASE
        WHEN price > 1000 THEN 'High'
        WHEN price BETWEEN 500 AND 1000 THEN 'Medium'
        ELSE 'Low'
    END AS price_category
FROM Products;


-- 10. STORED PROCEDURE: GET CUSTOMER ORDERS


DELIMITER //

CREATE PROCEDURE GetCustomerOrders(IN cust_id INT)
BEGIN
    SELECT
        order_id,
        order_date,
        total_amount,
        o_status
    FROM Orders
    WHERE customer_id = cust_id;
END //

DELIMITER ;

CALL GetCustomerOrders(1);


-- CHECK AND UPDATE STOCK


DELIMITER //

CREATE PROCEDURE CheckAndUpdateStock(
    IN p_product_id INT,
    IN p_quantity INT
)
BEGIN
    DECLARE current_stock INT;

    SELECT stock INTO current_stock
    FROM Products
    WHERE product_id = p_product_id;

    IF current_stock >= p_quantity THEN
        UPDATE Products
        SET stock = stock - p_quantity
        WHERE product_id = p_product_id;

        SELECT 'Stock updated successfully' AS message;
    ELSE
        SELECT 'Insufficient stock' AS message;
    END IF;
END //

DELIMITER ;

CALL CheckAndUpdateStock(1, 2);


-- STORED PROCEDURE: RECALCULATE ORDER TOTAL


DELIMITER //

CREATE PROCEDURE UpdateOrderTotal(IN p_order_id INT)
BEGIN
    DECLARE new_total DECIMAL(10,2);

    SELECT SUM(quantity * price_each)
    INTO new_total
    FROM Order_Details
    WHERE order_id = p_order_id;

    UPDATE Orders
    SET total_amount = IFNULL(new_total, 0)
    WHERE order_id = p_order_id;
END //

DELIMITER ;

CALL UpdateOrderTotal(4);


-- 13. TRIGGER: LOG NEW ORDERS


DELIMITER //

CREATE TRIGGER log_order_insert
AFTER INSERT ON Orders
FOR EACH ROW
BEGIN
    INSERT INTO Order_Log (order_id, customer_id, order_date, total_amount)
    VALUES (NEW.order_id, NEW.customer_id, NEW.order_date, NEW.total_amount);
END //

DELIMITER ;

-- To Test Trigger
INSERT INTO Orders (customer_id, order_date, total_amount, o_status)
VALUES (2, '2024-10-12', 80.00, 'Pending');

SELECT * FROM Order_Log;


-- 14. TRANSACTION PROCEDURE: PROCESS PAYMENT


DELIMITER //

CREATE PROCEDURE ProcessOrderPayment(
    IN p_order_id INT,
    IN p_payment_method VARCHAR(50),
    IN p_payment_amount DECIMAL(10,2)
)
BEGIN
    DECLARE order_exists INT DEFAULT 0;

    START TRANSACTION;

    SELECT COUNT(*) INTO order_exists
    FROM Orders
    WHERE order_id = p_order_id;

    IF order_exists = 0 THEN
        ROLLBACK;
        SELECT 'Transaction failed: Order does not exist' AS message;
    ELSE
        INSERT INTO Payments (order_id, payment_date, payment_method, amount, payment_status)
        VALUES (p_order_id, CURDATE(), p_payment_method, p_payment_amount, 'Paid');

        UPDATE Orders
        SET o_status = 'Completed'
        WHERE order_id = p_order_id;

        COMMIT;
        SELECT 'Transaction successful' AS message;
    END IF;
END //

DELIMITER ;

CALL ProcessOrderPayment(4, 'Debit Card', 115.00);


-- 15. INDEXES


CREATE INDEX idx_products_category ON Products(category_id);
CREATE INDEX idx_orders_customer ON Orders(customer_id);
CREATE INDEX idx_order_details_order_product ON Order_Details(order_id, product_id);
CREATE UNIQUE INDEX idx_customers_email ON Customers(email);

-- To Test Indexes
SHOW INDEX FROM Products;
SHOW INDEX FROM Orders;
SHOW INDEX FROM Order_Details;
SHOW INDEX FROM Customers;