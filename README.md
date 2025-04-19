# library-management-system

This project contains the database schema and Entity Relationship Diagram (ERD) for a simple library management system.

## 📂 Files Included

- `library_project1.sql`: SQL script to create and populate the database.
- `Library-System-Management ERdiagram.png`: ERD showing relationships between entities like Books, Members, Employees, etc.

## 🧱 Database Tables

- `branch`
- `employees`
- `books`
- `members`
- `issued_status`
- `return_status`

- ## 🧱 Tables Overview

### `branch`
Stores library branch information like address and contact number.

### `employees`
Contains employee details and links each employee to a branch.

### `books`
Book records including title, author, ISBN, publisher, and rental price.

### `members`
Registered library members with their address and registration date.

### `issued_status`
Tracks which book was issued to which member, when, and by which employee.

### `return_status`
Tracks the return status of issued books and return dates.
