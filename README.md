# library-management-system

This project contains the database schema and Entity Relationship Diagram (ERD) for a simple library management system.
![library](https://github.com/user-attachments/assets/048702c5-f28f-4c46-8712-e1c9d8a3dfa3)


# Introduction
The Library Management System is a relational database designed to manage books, branches, employees, and members within a library. 
It ensures efficient tracking of book issuance, returns, and maintains records for employee and member activities.

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

- ##  Tables Overview

The system includes the following tables:
- `branch`: Contains details about each library branch.
- `employees`: Stores information about library staff.
- `books`: Contains book metadata such as title, author, and ISBN.
- `members`: Registered members who can borrow books.
- `issued_status`: Records of books issued to members.
- `return_status`: Records of returned books.

- ## 📸 ER Diagram

![ER Diagram](./Library-System-Management%20ERdiagram.png)

Summary Reports
- **High-Demand Books**: Aggregated data to find which books are issued most often.
- **Employee Performance**: Analyzing number of book transactions handled by each employee

. Conclusion
- This system provides a structured and scalable solution for managing library operations. 
- The data analysis and reports help make informed decisions for improving library services.
