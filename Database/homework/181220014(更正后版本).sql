CREATE DATABASE IF NOT EXISTS HW1;
USE HW1;

# ----------Mission 1----------
CREATE TABLE Customers (
    cid CHAR(4) NOT NULL,
    cname CHAR(20) NOT NULL,
    city CHAR(20) NOT NULL,
    discnt REAL,
    PRIMARY KEY (cid)
);

CREATE TABLE Agents (
    aid CHAR(3) NOT NULL,
    aname CHAR(20) NOT NULL,
    city CHAR(20) NOT NULL,
    perc SMALLINT,
    PRIMARY KEY (aid)
);

CREATE TABLE Products (
    pid CHAR(3) NOT NULL,
    pname CHAR(20) NOT NULL,
    city CHAR(20),
    quantity INT NOT NULL,
    price REAL NOT NULL,
    PRIMARY KEY (pid)
);

CREATE TABLE Orders (
    ordno INT NOT NULL,
    orddate DATE NOT NULL,
    cid CHAR(4) NOT NULL,
    aid CHAR(3) NOT NULL,
    pid CHAR(3) NOT NULL,
    qty INT,
    dols REAL,
    PRIMARY KEY (ordno)
);


# ----------Mission 2----------
INSERT INTO Customers (cid, cname, city, discnt)
VALUES
('c001', 'Tiptop', 'Duluth', 10.00),
('c002', 'Basics', 'Dallas', 12.00),
('c003', 'Allied', 'Dallas', 8.00),
('c004', 'ACME', 'Duluth', 8.00),
('c006', 'ACME', 'Kyoto', 0.00);

INSERT INTO Agents (aid, aname, city, perc)
VALUES
('a01', 'Smith', 'New York', 6),
('a02', 'Jones', 'Newark',   6),
('a03', 'Brown', 'Tokyo',    7),
('a04', 'Gray',  'New York', 6),
('a05', 'Otasi', 'Duluth',   5),
('a06', 'Smith', 'Dallas',   5);

INSERT INTO Products (pid, pname, city, quantity, price)
VALUES
('p01', 'comb',   'Dallas', 111400, 0.50),
('p02', 'brush',  'Newark', 203000, 0.50),
('p03', 'razor',  'Duluth', 150600, 1.00),
('p04', 'pen',    'Duluth', 125300, 1.00),
('p05', 'pencil',  'Dallas', 221400, 1.00),
('p06', 'folder',  'Dallas', 123100, 2.00),
('p07', 'case',   'Newark', 100500, 1.00);

INSERT INTO Orders (ordno, orddate, cid, aid, pid, qty, dols)
VALUES
(1011, '2016-01-08', 'c001', 'a01', 'p01', 1000, 450.00),
(1012, '2016-01-12', 'c001', 'a01', 'p01', 1000, 450.00),
(1019, '2016-02-24', 'c001', 'a02', 'p02', 400,  180.00),
(1017, '2016-02-10', 'c001', 'a06', 'p03', 600,  540.00),
(1018, '2016-02-16', 'c001', 'a03', 'p04', 600,  540.00),
(1023, '2016-03-12', 'c001', 'a04', 'p05', 500,  450.00),
(1022, '2016-03-08', 'c001', 'a05', 'p06', 400,  720.00),
(1025, '2016-04-07', 'c001', 'a05', 'p07', 800,  720.00),
(1013, '2016-01-13', 'c002', 'a03', 'p03', 1000, 880.00),
(1026, '2016-05-20', 'c002', 'a05', 'p03', 800,  704.00),
(1015, '2016-01-23', 'c003', 'a03', 'p05', 1200, 1104.00),
(1014, '2016-01-18', 'c003', 'a03', 'p05', 1200, 1104.00),
(1021, '2016-02-28', 'c004', 'a06', 'p01', 1000, 460.00),
(1016, '2016-01-25', 'c006', 'a01', 'p01', 1000, 500.00),
(1020, '2016-02-05', 'c006', 'a03', 'p07', 600,  600.00),
(1024, '2016-03-12', 'c006', 'a06', 'p01', 800,  400.00);


# ----------Mission 3----------
## 3.1
SELECT Agents.aid
FROM Agents
WHERE Agents.aid NOT IN (
    SELECT DISTINCT Agents.aid
    FROM Agents, Orders, Customers
    WHERE Orders.aid=Agents.aid AND Orders.cid=Customers.cid AND Customers.city='Duluth'
    );

## 3.2
SELECT Agents.aid
FROM Agents
WHERE EXISTS(
    SELECT Products.pid
    FROM Products
    WHERE NOT EXISTS (
        SELECT *
        FROM Customers
        WHERE Customers.city IN ('Duluth', 'Kyoto') AND NOT EXISTS (
            SELECT *
            FROM Orders
            WHERE Orders.aid=Agents.aid AND Orders.pid=Products.pid AND Orders.cid=Customers.cid
            )
        )
);

## 3.3
SELECT DISTINCT o.cid
FROM Orders o
WHERE o.aid='a03'
  AND o.cid IN (
    SELECT d.cid
    FROM Orders d
    WHERE d.aid='a05'
  )
  AND NOT EXISTS (
    SELECT *
    FROM Orders r
    WHERE r.cid=o.cid AND r.aid NOT IN ('a03', 'a05')
    );

## 3.4
SELECT Products.pid
FROM Products
WHERE NOT EXISTS (
    SELECT Customers.city
    FROM Customers
    WHERE NOT EXISTS (
        SELECT *
        FROM Orders, Customers c
        WHERE Orders.cid=c.cid AND Orders.pid=Products.pid AND c.city=Customers.city
        )
    );

## 3.5
SELECT Orders.cid, Orders.orddate
FROM Orders
WHERE 2 > (
    SELECT COUNT(*)
    FROM Orders o
    WHERE o.cid=Orders.cid AND o.orddate < Orders.orddate
    )
ORDER BY Orders.cid, Orders.ordno ASC;

## 3.6
SELECT Products.pid
FROM Products
WHERE NOT EXISTS (
    SELECT *
    FROM Customers
    WHERE Customers.city='Dallas' AND NOT EXISTS (
        SELECT *
        FROM Orders
        WHERE Orders.pid=Products.pid AND Orders.cid=Customers.cid
        )
    );

## 3.7
SELECT Agents.aid, Agents.perc
FROM Agents
WHERE NOT EXISTS (
    SELECT *
    FROM Customers
    WHERE Customers.city='Duluth' AND NOT EXISTS(
        SELECT *
        FROM Orders
        WHERE Orders.aid=Agents.aid AND Orders.cid=Customers.cid
        )
    )
ORDER BY Agents.perc DESC ;

## 3.8
SELECT Products.pid
FROM Products
WHERE EXISTS(
    SELECT *
    FROM Agents a, Customers c, Orders o
    WHERE o.aid=a.aid AND o.cid=c.cid AND c.city=a.city AND o.pid=Products.pid
          );

## 3.9
### without set function
SELECT a.aname
FROM Agents a
WHERE a.perc >= ALL(
    SELECT Agents.perc
    FROM Agents
);

### with set function
SELECT a.aname
FROM Agents a
WHERE a.perc = ALL(
    SELECT MAX(Agents.perc)
    FROM Agents
);

## 3.10
SELECT Orders.cid, SUM(Orders.qty)
FROM Orders
WHERE Orders.aid='a04' AND Orders.cid NOT IN (
    SELECT o.cid
    FROM Orders o
    WHERE o.aid<>'a04'
    )
GROUP BY Orders.cid

## 3.11
SELECT t.aid, t.pid, t.total
FROM
    (SELECT Orders.aid, Orders.pid, SUM(Orders.qty) AS total
    FROM Orders
    GROUP BY Orders.aid, Orders.pid) t
WHERE t.total>1000 AND 3>(
    SELECT COUNT(*)
    FROM
        (SELECT Orders.aid, Orders.pid, SUM(Orders.qty) AS total
        FROM Orders
        GROUP BY Orders.aid, Orders.pid) t1
    WHERE t1.pid=t.pid AND t1.total>t.total
    )
ORDER BY t.pid ASC;

## 3.12
SELECT DISTINCT Orders.cid
FROM Orders
WHERE NOT EXISTS (
    SELECT o.pid
    FROM Orders o
    WHERE o.cid=Orders.cid
    GROUP BY o.pid
    HAVING AVG(o.qty)<300
    );


# ----------Mission 4----------
DROP TABLE Agents, Customers, Orders, Products;


