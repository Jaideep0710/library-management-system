create database library_project2;
use library_project2;

CREATE TABLE branch
(
            branch_id VARCHAR(10) PRIMARY KEY,
            manager_id VARCHAR(10),
            branch_address VARCHAR(30),
            contact_no VARCHAR(15)
);


-- Create table "Employee"
DROP TABLE IF EXISTS employees;
CREATE TABLE employees
(
            emp_id VARCHAR(10) PRIMARY KEY,
            emp_name VARCHAR(30),
            position VARCHAR(30),
            salary DECIMAL(10,2),
            branch_id VARCHAR(10),
            FOREIGN KEY (branch_id) REFERENCES  branch(branch_id)
);


-- Create table "Members"
DROP TABLE IF EXISTS members;
CREATE TABLE members
(
            member_id VARCHAR(10) PRIMARY KEY,
            member_name VARCHAR(30),
            member_address VARCHAR(30),
            reg_date DATE
);



-- Create table "Books"
DROP TABLE IF EXISTS books;
CREATE TABLE books
(
            isbn VARCHAR(50) PRIMARY KEY,
            book_title VARCHAR(80),
            category VARCHAR(30),
            rental_price DECIMAL(10,2),
            status VARCHAR(10),
            author VARCHAR(30),
            publisher VARCHAR(30)
);



-- Create table "IssueStatus"
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status
(
            issued_id VARCHAR(10) PRIMARY KEY,
            issued_member_id VARCHAR(30),
            issued_book_name VARCHAR(80),
            issued_date DATE,
            issued_book_isbn VARCHAR(50),
            issued_emp_id VARCHAR(10),
            FOREIGN KEY (issued_member_id) REFERENCES members(member_id),
            FOREIGN KEY (issued_emp_id) REFERENCES employees(emp_id),
            FOREIGN KEY (issued_book_isbn) REFERENCES books(isbn) 
);



-- Create table "ReturnStatus"
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status
(
            return_id VARCHAR(10) PRIMARY KEY,
            issued_id VARCHAR(30),
            return_book_name VARCHAR(80),
            return_date DATE,
            return_book_isbn VARCHAR(50),
            FOREIGN KEY (return_book_isbn) REFERENCES books(isbn)
);



alter table issued_status
add constraint fk_member
FOREIGN KEY (issued_member_id) REFERENCES members(member_id);

alter table issued_status
add constraint fk_books
FOREIGN KEY (issued_book_isbn) REFERENCES books(isbn);

alter table issued_status
add constraint fk_employees
FOREIGN KEY (issued_emp_id) REFERENCES employees(emp_id);


alter table employees
add constraint fk_branch
FOREIGN KEY (branch_id) REFERENCES  branch(branch_id);

alter table return_status
add constraint fk_issued_status
FOREIGN KEY (return_book_isbn) REFERENCES books(isbn);


select * from books;
select * from branch;
select * from employees;
select * from issued_status;
select * from members;
select * from return_status;


-- Question
-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
insert into books value('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

select * from books;

-- Task 2: Update an Existing Member's Address
update members
set member_address='125 Main St'
where member_id='C101';
select * from members;


-- Task 3: Delete a Record from the Issued Status Table 
delete from issued_status
where issued_id='IS106';
select * from issued_status;

-- Task 4: Retrieve All Books Issued by a Specific Employee 
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
select * from issued_status 
where issued_emp_id='E101';
select * from issued_status;

-- Task 5: List Members Who Have Issued More Than One Book 
-- Objective: Use GROUP BY to find members who have issued more than one book.
select issued_emp_id,
count(issued_id) as total_issued_id
from issued_status
group by issued_emp_id
having count(issued_id)
order by total_issued_id asc;
select * from issued_status;

-- CTAS
-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results 
-- each book and total book_issued_cnt**
create table  book_cnt 
as 
select
b.isbn,
b.book_title,
count(ist.issued_id) as no_issued
  from  books b
 join issued_status ist
 ON ist.issued_book_isbn = b.isbn
 group by 1,2;
 -- 
 select * from book_cnt;
 
 -- Task 7. Retrieve All Books in a Specific Category:

select * from books
where category='classic';

-- Task 8: Find Total Rental Income by Category:
select  b.category,
sum(b.rental_price)
from books b
join issued_status ist
 ON ist.issued_book_isbn = b.isbn
 group by 1;


-- Task 9. **List Members Who Registered in the Last 180 Days**:
  INSERT INTO members(member_id, member_name, member_address, reg_date)
  VALUES
   ('C122', 'sambhai', '145 Rome St', '2025-02-01'),
   ('C123', 'john wick', '133 paris St', '2025-02-01');

   select * from members where reg_date >= curdate() - INTERVAL 180 DAY;  
    select * from members;

-- task 10 List Employees with Their Branch Manager's Name and their branch details:
select e.*,e.branch_id,e2.emp_name as manager
 from 
employees e 
join branch b on b.branch_id = e.branch_id
join
employees e2 
on b.manager_id=e2.emp_id;

select * from  employees;
select * from branch;


-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold 7USD:
create table expensive_books as
select * from books
where rental_price>7;
select * from books;
select * from expensive_books;


-- Task 12: Retrieve the List of Books Not Yet Returned
select  
distinct ist.issued_book_name
from issued_status ist
 left join
 return_status rs
 on ist.issued_id=rs.issued_id
where rs.return_id is NULL;


/*
Task 13: 
Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period). 
Display the member's_id, member's name, book title, issue date, and days overdue.
*/

select 
ist.issued_member_id,
m.member_name,
bk.book_title,
ist.issued_date,
datediff(current_date(),ist.issued_date) as over_due_date
 from  issued_status as ist
join
members m
  ON m.member_id=ist.issued_member_id
  join 
  books as bk
  on bk.isbn=ist.issued_book_isbn
  left join
  return_status rs
  ON rs.issued_id = ist.issued_id
  where 
  rs.return_date is NULL
  and 
  datediff (current_date(),ist.issued_date)>380
  order by 1;


/*    
Task 14: Update Book Status on Return
Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).
*/
select * from books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM members;
select * from return_status;


delimiter //
create procedure  add_returns_record( In p_return_id varchar(10),In p_issued_id varchar(10))
begin
 DECLARE v_isbn VARCHAR(50);
    DECLARE v_book_name VARCHAR(80);

insert into return_status(return_id, issued_id, return_date)
values(p_return_id,p_issued_id,curdate());

select 
issued_book_isbn,
issued_book_name
into
v_isbn,
v_book_name
from issued_status
where  issued_id =p_issued_id;

update  books
set status='Yes'
where isbn=v_isbn;

    select concat('Thank you for returning the book: %', v_book_name)as message;
end//
delimiter ;


call add_returns_record('RS143', 'IS131');
drop procedure add_returns_record;

/*
Task 15: Branch Performance Report
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.
*/

select * from branch;  
select * from issued_status;
select * from employee;
select * from books;
select * from return_status;


create table branch_report
as
select b.branch_id,
     b.manager_id,
     count(ist.issued_id)as number_books_issued,
     count(ist.issued_id) as number_book_issued,
     sum(bk.rental_price) as total_revenue 
from issued_status as ist
join 
employees as e
ON e.emp_id=ist.issued_emp_id
join
branch as b
ON e.branch_id=b.branch_id
left join
return_status as rs
ON rs.issued_id =ist.issued_id
Join 
books as bk
ON ist.issued_book_isbn=bk.isbn
group by 1,2;

select * from branch_report;

-- Task 16: CTAS: Create a Table of Active Members
-- Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.


select * from issued_status;
select * from members;

create table avtive_members
as
select * from members
where member_id IN (select
 distinct(issued_member_id) from issued_status
 where 
 issued_date >= curdate() - interval 4 month);
 
select * from avtive_members;



-- Task 17: Find Employees with the Most Book Issues Processed
-- Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number 

select e.emp_name,count(ist.issued_id),
b.* from
 issued_status as ist
join
employees as e
ON e.emp_id =ist.issued_emp_id
join 
branch as b
on e.branch_id=b.branch_id
group by 1,3;


-- Task 18: Identify Members Issuing High-Risk Books
-- Write a query to identify members who have issued books more than twice with the status "damaged" in the books table. 
-- Display the member name, book title, and the number of times they've issued damaged books.    
select * from books;
select * from issued_status;
select * from return_status;
select * from members;

-- Adding new column in return_status

ALTER TABLE return_status
ADD Column book_quality VARCHAR(15) DEFAULT('Good');

UPDATE return_status
SET book_quality = 'Damaged'
WHERE return_id = 'RS106';
 
select 
m.member_name,
b.book_title,
rs.book_quality,
count(*) as damaged
from books as b
join 
issued_status as ist
ON b.isbn=ist.issued_book_isbn
join 
return_status as rs
ON rs.issued_id=ist.issued_id
join
members as m
ON m.member_id=ist.issued_member_id
where book_quality="damaged"
group by 1,2,3;
;



/*
Task 19: Stored Procedure Objective: 

Create a stored procedure to manage the status of books in a library system. 

Description: Write a stored procedure that updates the status of a book in the library based on its issuance. 

The procedure should function as follows: 

The stored procedure should take the book_id as an input parameter. 

The procedure should first check if the book is available (status = 'yes'). 

If the book is available, it should be issued, and the status in the books table should be updated to 'no'. 

If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.
*/


select * from books;
select * from issued_status;

delimiter //
create procedure  issued_books (p_issued_id varchar(10),p_issued_member_id varchar(30),p_issued_book_isbn varchar(50),p_issued_emp_id varchar(10))
begin

declare v_status varchar(50);

select status
into v_status
from books 
where isbn= p_issued_book_isbn;

if v_status='Yes' then

   insert into issued_status(issued_id,issued_member_id,issued_date,issued_book_isbn,issued_emp_id)
   values
   (p_issued_id,p_issued_member_id,curdate(),p_issued_book_isbn,p_issued_emp_id);

   UPDATE books
   SET status = 'no'
   WHERE isbn = p_issued_book_isbn;
        
	select concat("Book records added successfully for book isbn : %, p_issued_book_isbn");
else
     select concat("Sorry to inform you the book you have requested is unavailable book_isbn: %', p_issued_book_isbn");

end if;
end ;
//
delimiter ; 

drop procedure issued_books;

-- 978-0-330-25864-8-- 

call issued_books ('IS141','C110','978-0-307-58837-1','E102');

call issued_books ('IS142','C110','978-0-307-58837-1','E102');


/*Task 20: Create Table As Select (CTAS)
Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.

Description: Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days. The table should include:
    The number of overdue books.
    The total fines, with each day's fine calculated at $0.50.
    The number of books issued by each member.
    The resulting table should show:
    Member ID
    Number of overdue books
    Total fines
*/
select * from books;
select * from issued_status;
select * from return_status;
select * from members;


create table Over_due 
as
select 
m.member_id,
datediff(curdate(),ist.issued_date) as no_of_overdue_books,
datediff(curdate(),ist.issued_date) * 0.50 as total_fines
from books as b
join 
issued_status as ist
ON b.isbn=ist.issued_book_isbn
join 
return_status as rs
ON rs.issued_id=ist.issued_id
join
members as m
ON m.member_id=ist.issued_member_id
where 
datediff(curdate(),ist.issued_date)>30;

select * from over_due;