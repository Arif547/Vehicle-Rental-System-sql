
-- Database create commmand
create database Vehicle_Rental_System


-- Users Table Create
  
create table Users (
  id  SERIAL primary key,
  role varchar(20) NOT NULL CHECK (role IN ('admin', 'customer')),
  name varchar(150) NOT NULL,
  email varchar(150) NOT NULL unique,
  password VARCHAR(255) NOT NULL,
  phone varchar(20),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP    
);



-- Users Data Entry

insert into users (name, email, password, phone, role) values 
('Alice', 'alice@example.com', '$2b$10$hashedpassword1', '1234567890', 'customer'),
('Bob', 'bob@example.com', '$2b$10$hashedpassword2', '0987654321', 'admin'),
('Charlie', 'charlie@example.com', '$2b$10$hashedpassword3', '1122334455', 'customer');



-- Vechiles Table Create

create table Vehicles (
  id  SERIAL primary key,
  name varchar(150) NOT NULL,
  type varchar(20) NOT NULL CHECK (type IN ('car', 'bike', 'truck')),
  model varchar(50) NOT NULL,
  registration_number varchar(150) NOT null unique,
  rental_price decimal(8,2) NOT null CHECK (rental_price > 0),
  status varchar(20) NOT NULL check (status IN ('available', 'rented', 'maintenance')),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  
)


-- Insert vehicles Data  
INSERT INTO vehicles (
    id, name, type, model, registration_number, rental_price, status
) VALUES
(1, 'Toyota Corolla', 'car', 2022, 'ABC-123', 50, 'available'),
(2, 'Honda Civic', 'car', 2021, 'DEF-456', 60, 'rented'),
(3, 'Yamaha R15', 'bike', 2023, 'GHI-789', 30, 'available'),
(4, 'Ford F-150', 'truck', 2020, 'JKL-012', 100, 'maintenance');


-- Create Booking Table

CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL references users(id),
    vehicle_id INT NOT NULL references vehicles(id),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL 
        CHECK (status IN ('pending', 'confirmed', 'completed', 'cancelled')),
    total_cost DECIMAL(10,2) NOT NULL 
        CHECK (total_cost >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP    
);


-- insert Bookings Data

INSERT INTO bookings (
    booking_id, user_id, vehicle_id, start_date, end_date, status, total_cost
) VALUES
(1, 1, 2, '2023-10-01', '2023-10-05', 'completed', 240),
(2, 1, 2, '2023-11-01', '2023-11-03', 'completed', 120),
(3, 3, 2, '2023-12-01', '2023-12-02', 'confirmed', 60),
(4, 1, 1, '2023-12-10', '2023-12-12', 'pending', 100);


-- Query 1: JOIN
-- Requirement: Retrieve booking information along with Customer name and Vehicle name.

select b.booking_id, u.name as customer_name, v.name as vehicle_name, b.start_date, b.end_date, b.status 
  from bookings as b 
  join users as u on user_id = u.id
  join vehicles as v on vehicle_id = v.id 
  order by b.booking_id


-- Query 2: EXISTS
-- Requirement: Find all vehicles that have never been booked.
  
select v.id as vehicle_id, v.name, v.type, v.model, v.registration_number, v.rental_price, v.status
  from vehicles as v
  where not exists (
  select 1 FROM bookings as b
  where b.vehicle_id = v.id
  ) 
order by v.id;


-- Query 3: WHERE
-- Requirement: Retrieve all available vehicles of a specific type (e.g. cars).

select id as vehicle_id, name, type, model, registration_number, rental_price, status
from vehicles 
where type= 'car'
and status = 'available'
order by id;


-- Query 4: GROUP BY and HAVING
-- Requirement: Find the total number of bookings for each vehicle and display only those vehicles that have more than 2 bookings.

select v.name as vehicle_name, COUNT(b.booking_id) as total_bookings
from bookings as b 
join vehicles as v 
on b.vehicle_id = v.id
group by v.name 
having COUNT(b.booking_id) >2;
