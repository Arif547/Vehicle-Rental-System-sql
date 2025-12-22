
# Vehicle Rental System

## Project Overview

The **Vehicle Rental System** is a relational database designed to manage users, vehicles, and bookings for a rental service. It supports multiple user roles (`admin` and `customer`) and tracks vehicle availability, bookings, and rental history.

This project demonstrates core **SQL concepts** including `JOIN`, `EXISTS`, `WHERE`, `GROUP BY`, and `HAVING`.

---

## Database Structure

### 1. Users Table
Stores information about customers and admins.

| Column      | Type         | Description                        |
|------------|-------------|------------------------------------|
| id         | SERIAL      | Primary key                        |
| role       | VARCHAR(20) | User role (`admin` or `customer`) |
| name       | VARCHAR(150)| User full name                     |
| email      | VARCHAR(150)| Unique email address               |
| password   | VARCHAR(255)| Hashed password                    |
| phone      | VARCHAR(20) | Optional phone number              |
| created_at | TIMESTAMP   | Default current timestamp          |
| updated_at | TIMESTAMP   | Default current timestamp          |

---

### 2. Vehicles Table
Stores information about vehicles available for rent.

| Column               | Type          | Description                                      |
|---------------------|---------------|-------------------------------------------------|
| id                  | SERIAL        | Primary key                                     |
| name                | VARCHAR(150)  | Vehicle name                                    |
| type                | VARCHAR(20)   | Vehicle type (`car`, `bike`, `truck`)          |
| model               | VARCHAR(50)   | Vehicle model year                              |
| registration_number | VARCHAR(150)  | Unique registration number                      |
| rental_price        | DECIMAL(8,2)  | Price per day                                   |
| status              | VARCHAR(20)   | Vehicle status (`available`, `rented`, `maintenance`) |
| created_at          | TIMESTAMP     | Default current timestamp                       |
| updated_at          | TIMESTAMP     | Default current timestamp                       |

---

### 3. Bookings Table
Stores information about vehicle bookings.

| Column      | Type         | Description                                             |
|------------|-------------|---------------------------------------------------------|
| booking_id | SERIAL      | Primary key                                             |
| user_id    | INT         | References `users.id`                                   |
| vehicle_id | INT         | References `vehicles.id`                                |
| start_date | DATE        | Booking start date                                      |
| end_date   | DATE        | Booking end date                                        |
| status     | VARCHAR(20) | Booking status (`pending`, `confirmed`, `completed`, `cancelled`) |
| total_cost | DECIMAL(10,2)| Total cost of booking                                   |
| created_at | TIMESTAMP   | Default current timestamp                               |

---

## Sample Data

**Users:**
- Alice (customer)
- Bob (admin)
- Charlie (customer)
- David, Eve, Frank (customers)

**Vehicles:**
- Toyota Corolla, Honda Civic (cars)
- Yamaha R15, Suzuki Hayabusa, Kawasaki Ninja (bikes)
- Ford F-150, Ford Ranger, Tesla Model 3 (trucks/cars)

**Bookings:**
- Multiple bookings for Toyota Corolla and Honda Civic
- Some vehicles never booked (Suzuki Hayabusa, Kawasaki Ninja, Tesla Model 3)

---

## Queries and Explanations

### **Query 1: Retrieve booking info with customer and vehicle names**
```sql
SELECT b.booking_id, u.name AS customer_name, v.name AS vehicle_name, 
       b.start_date, b.end_date, b.status
FROM bookings AS b
JOIN users AS u ON b.user_id = u.id
JOIN vehicles AS v ON b.vehicle_id = v.id
ORDER BY b.booking_id;
````

**Explanation:**

* Uses `JOIN` to combine `bookings`, `users`, and `vehicles`.
* Shows each booking with the corresponding customer name and vehicle name.

---

### **Query 2: Find vehicles that have never been booked**

```sql
SELECT v.id AS vehicle_id, v.name, v.type, v.model, v.registration_number, 
       v.rental_price, v.status
FROM vehicles AS v
WHERE NOT EXISTS (
    SELECT 1 FROM bookings AS b WHERE b.vehicle_id = v.id
)
ORDER BY v.id;
```

**Explanation:**

* Uses `NOT EXISTS` to filter vehicles not referenced in `bookings`.
* Helps identify idle vehicles that can be promoted or maintained.

---

### **Query 3: Retrieve available vehicles of a specific type**

```sql
SELECT id AS vehicle_id, name, type, model, registration_number, rental_price, status
FROM vehicles
WHERE type = 'car'
  AND status = 'available'
ORDER BY id;
```

**Explanation:**

* Uses `WHERE` to filter vehicles by type (`car`) and availability (`available`).
* Useful for showing customers only rentable vehicles of a chosen type.

---

### **Query 4: Total bookings per vehicle with more than 2 bookings**

```sql
SELECT v.name AS vehicle_name, COUNT(b.booking_id) AS total_bookings
FROM bookings AS b
JOIN vehicles AS v ON b.vehicle_id = v.id
GROUP BY v.name
HAVING COUNT(b.booking_id) > 2;
```

**Explanation:**

* Uses `GROUP BY` to aggregate bookings by vehicle.
* `HAVING` filters vehicles with more than 2 bookings.
* Helps analyze high-demand vehicles.

---

## Notes

* All dates use the `YYYY-MM-DD` format.
* Prices are stored in decimal for accuracy in calculations.
* `CHECK` constraints ensure data integrity for roles, vehicle types, statuses, and costs.
* This dataset is suitable for testing all query scenarios: joins, filters, aggregations, and existence checks.

---

## Author

Md. Mahabubul Alam
