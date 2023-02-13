create table store(
	store_id int,
	store_name varchar(50),
	address varchar(100),
	primary KEY(store_id)
);

create table customer(
	customer_id int,
	cutomer_name varchar(50),
	email varchar(100),
	phone_number varchar(20),
	address varchar(100),
	primary key(customer_id)
);

create table inventory(
	product_id int not null primary key,
	product_name varchar(50),
	price decimal(10, 2),
	quantity_in_stock int,
	store_id int,
	foreign key (store_id) references store(store_id)
);

create table orders(
	order_id int not null primary key,
	customer_id int,
	product_id int, 
	quantity int,
	store_id int,
	foreign key (store_id) references store(store_id),
	foreign key (customer_id) references customer(customer_id)
);

-- Insertion

INSERT INTO store (store_id, store_name, address) VALUES
  (1, 'Store A', '123 Main St.'),
  (2, 'Store B', '456 Elm St.');

INSERT INTO customer (customer_id, cutomer_name, email, phone_number, address) VALUES
  (1, 'John Doe', 'johndoe@example.com', '555-1234', '123 Main St.'),
  (2, 'Jane Smith', 'janesmith@example.com', '555-5678', '456 Elm St.'),
  (3, 'Bob Johnson', 'bobjohnson@example.com', '555-9101', '123 Main St.'),
  (4, 'Sara Lee', 'saralee@example.com', '555-1212', '456 Elm St.'),
  (5, 'Mike Brown', 'mikebrown@example.com', '555-3434', '123 Main St.'),
  (6, 'Emily Davis', 'emilydavis@example.com', '555-5656', '456 Elm St.'),
  (7, 'Tom Wilson', 'tomwilson@example.com', '555-7878', '123 Main St.'),
  (8, 'Jenny Garcia', 'jennygarcia@example.com', '555-9090', '456 Elm St.'),
  (9, 'David Kim', 'davidkim@example.com', '555-2323', '123 Main St.'),
  (10, 'Karen Lee', 'karenlee@example.com', '555-4545', '456 Elm St.');
 
INSERT INTO inventory (product_id, product_name, price, quantity_in_stock, store_id) VALUES
  (1, 'Product A', 10.99, 10, 1),
  (2, 'Product B', 20.99, 50, 2),
  (3, 'Product C', 5.99, 200, 1),
  (4, 'Product D', 15.99, 75, 2),
  (5, 'Product E', 8.99, 15, 1),
  (6, 'Product F', 25.99, 25, 2),
  (7, 'Product G', 12.99, 125, 1),
  (8, 'Product H', 30.99, 10, 2),
  (9, 'Product I', 7.99, 175, 1),
  (10, 'Product J', 18.99, 60, 2);
 
INSERT INTO orders (order_id, customer_id, product_id, quantity, store_id) VALUES
  (1, 1, 1, 2, 1),
  (2, 2, 3, 1, 1),
  (3, 3, 5, 4, 1),
  (4, 4, 2, 3, 2),
  (5, 5, 4, 1, 2),
  (6, 6, 8, 2, 2),
  (7, 7, 10, 3, 2),
  (8, 8, 7, 1, 1),
  (9, 9, 9, 2, 1),
  (10, 10, 6, 1, 2);

-- fragmenting the database : horizontanly
-- We will fragment the inventory table into 2 separate tables by store_id 
-- We will fragment the orders table into 2 separate tables also by store_id
 
create table store_1_inventory(
	product_id int not null primary key,
	product_name varchar(50),
	price decimal(10, 2),
	quantity_in_stock int,
	store_id int,
	foreign key (store_id) references store(store_id)
);

create table store_1_orders(
	order_id int not null primary key,
	customer_id int,
	product_id int, 
	quantity int,
	store_id int,
	foreign key (store_id) references store(store_id),
	foreign key (customer_id) references customer(customer_id)
);

create table store_2_inventory(
	product_id int not null primary key,
	product_name varchar(50),
	price decimal(10, 2),
	quantity_in_stock int,
	store_id int,
	foreign key (store_id) references store(store_id)
);

create table store_2_orders(
	order_id int not null primary key,
	customer_id int,
	product_id int, 
	quantity int,
	store_id int,
	foreign key (store_id) references store(store_id),
	foreign key (customer_id) references customer(customer_id)
);

-- fragmenting database

insert into store_1_orders(select * from orders where store_id = 1)
insert into store_2_orders(select * from orders where store_id = 2)
insert into store_1_inventory(select * from inventory where store_id = 1)
insert into store_2_inventory(select * from inventory where store_id = 2)

select * from store_1_orders;
select * from store_2_orders;
select * from store_1_inventory;
select * from store_2_inventory;


-- Getting inventory of both the stores
select product_id, product_name, price, quantity_in_stock from inventory
select product_id, product_name, price, quantity_in_stock from store_1_inventory
select product_id, product_name, price, quantity_in_stock from store_2_inventory

-- Getting orders from both the stores
select order_id, customer_id, product_id, quantity from orders
select order_id, customer_id, product_id, quantity from store_1_orders
select order_id, customer_id, product_id, quantity from store_2_orders

-- Getting inventory items with quantity less than 100
select product_id, product_name, quantity_in_stock from inventory where quantity_in_stock < 100
select product_id, product_name, quantity_in_stock from store_1_inventory where quantity_in_stock < 100
select product_id, product_name, quantity_in_stock from store_2_inventory where quantity_in_stock < 100

-- Getting inventory items with price greater than 10
select product_id, product_name, price from inventory where price > 10
select product_id, product_name, price from store_1_inventory where price > 10
select product_id, product_name, price from store_2_inventory where price > 10


-- query the average order size from both the stores
select avg(quantity * price) as "Average order size"
	from store_1_orders as a
	join
	store_1_inventory as b
	on a.product_id = b.product_id

select avg(quantity * price) as "Maximum order size"
	from store_2_orders as a
	join
	store_2_inventory as b
	on a.product_id = b.product_id
	
	
select avg(quantity * price) as "Average order size"
	from orders as a
	join
	inventory as b
	on a.product_id = b.product_id
	
-- query the total inventory value from both stores
select sum(quantity_in_stock * price) as "Total inventory value" from inventory
select sum(quantity_in_stock * price) as "Total inventory value" from store_1_inventory
select sum(quantity_in_stock * price) as "Total inventory value" from store_2_inventory


-- query to find customers who have bought the product from nearest store
select c.customer_id, c.cutomer_name, c.email, c.phone_number, o.store_id, c.address 
	from customer as c
	join
	orders as o
	on c.customer_id = o.order_id 
	join 
	store as s 
	on s.store_id = o.store_id
	where c.address = s.address

	
select c.customer_id, c.cutomer_name, c.email, c.phone_number, o.store_id, c.address 
	from customer as c
	join
	store_1_orders as o
	on c.customer_id = o.order_id 
	join 
	store as s 
	on s.store_id = o.store_id
	where c.address = s.address
	
	
select c.customer_id, c.cutomer_name, c.email, c.phone_number, o.store_id, c.address 
	from customer as c
	join
	store_2_orders as o
	on c.customer_id = o.order_id 
	join 
	store as s 
	on s.store_id = o.store_id
	where c.address = s.address
	
	
-- query to find maximum order size from both the stores
select max(quantity * price) as "Maximum order size"
	from orders as a
	join
	inventory as b
	on a.product_id = b.product_id
	
select max(quantity * price) as "Maximum order size"
	from store_1_orders as a
	join
	store_1_inventory as b
	on a.product_id = b.product_id

select max(quantity * price) as "Maximum order size"
	from store_2_orders as a
	join
	store_2_inventory as b
	on a.product_id = b.product_id
	
	
-- Join store_1_inventory and store_2_inventory to get the complete inventory
select * from 
	store_1_inventory
	union
select * from 
	store_2_inventory 
order by product_id
	




-- Join store_1_orders and store_2_orders to get the complete orders
select * from 
	store_1_orders
	union
select * from 
	store_2_orders
order by order_id


