# SQL-to-the-SQL

# Section 1

# 1. Return the customer IDs of customers who have spent at least $110 with the staff member who has an ID of 2.

SELECT customer_id,SUM(amount)
FROM payment
WHERE staff_id = 2
GROUP BY customer_id
HAVING SUM(amount) > 110;

# 2. How many films begin with the letter J?

SELECT COUNT(*) FROM film
WHERE title LIKE 'J%';

# 3. What customer has the highest customer ID number whose name starts with an 'E' and has an address ID lower than 500?

SELECT first_name,last_name FROM customer
WHERE first_name LIKE ‘E%’
AND address_id <500
ORDER BY customer_id DESC
LIMIT;



# SECTION 2

# How can you retrieve all the information from the cd.facilities table?

SELECT (*) 
FROM cd.facilities; 

# You want to print out a list of all of the facilities and their cost to members. How would you retrieve a list of only facility names and costs?

SELECT name, membercost 
FROM cd.facilities;

# How can you produce a list of facilities that charge a fee to members?

SELECT (*) 
FROM cd.facilities 
WHERE membercost > 0;

# How can you produce a list of facilities that charge a fee to members, and that fee is less than 1/50th of the monthly maintenance cost? Return the facid, facility name, member cost, and monthly maintenance of the facilities in question.

SELECT facid, name, membercost, monthlymaintenance 
FROM cd.facilities 
WHERE membercost > 0 AND (membercost < monthlymaintenance/50.0);

# How can you produce a list of all facilities with the word 'Tennis' in their name?
SELECT (*) 
FROM cd.facilities 
WHERE name like '%Tennis%';

# How can you retrieve the details of facilities with ID 1 and 5? Try to do it without using the OR operator.
SELECT (*) 
FROM cd.facilities 
WHERE facid IN (1,5);

# How can you produce a list of members who joined after the start of September 2012? Return the memid, surname, firstname, and joindate of the members in question.

SELECT memid, surname, firstname, joindate 
FROM cd.members 
WHERE joindate >= '2012-09-01';

# How can you produce an ordered list of the first 10 surnames in the members table? The list must not contain duplicates.

SELECT distinct surname 
FROM cd.members 
ORDER BY surname 
LIMIT 10;

# What is the signup date of your last member?

SELECT max(joindate) as latest 
FROM cd.members;

# Produce a count of the number of facilities that have a cost to guests of 10 or more.
SELECT count(*) 
FROM cd.facilities 
WHERE guestcost >= 10;
 
# Produce a list of the total number of slots booked per facility in the month of September 2012. Produce an output table consisting of facility id and slots, sorted by the number of slots.

SELECT facid, sum(slots) as "Total Slots" 
FROM cd.bookings 
WHERE starttime >= '2012-09-01' AND starttime < '2012-10-01' 
GROUP BY facid 
ORDER BY sum(slots);

# Produce a list of facilities with more than 1000 slots booked. Produce an output table consisting of facility id and total slots, sorted by facility id.

SELECT facid, sum(slots) as "Total Slots" 
FROM cd.bookings 
GROUP BY facid having sum(slots) > 1000 
ORDER BY facid;

# How can you produce a list of the start times for bookings for tennis courts, for the date '2012-09-21'? Return a list of start time and facility name pairings, ordered by the time.

SELECT bks.starttime as start, facs.name as name 
FROM cd.facilities facs 
INNER JOIN cd.bookings bks 
ON facs.facid = bks.facid 
WHERE facs.facid 
IN (0,1) AND bks.starttime >= '2012-09-21' AND bks.starttime < '2012-09-22' 
ORDER BY bks.starttime;

# How can you produce a list of the start times for bookings by members named 'David Farrell'?

SELECT bks.starttime 
FROM cd.bookings bks 
INNER JOIN cd.members mems 
ON mems.memid = bks.memid 
WHERE mems.firstname='David' AND mems.surname='Farrell';



# Section 3
# I was asked to create a new database, tables, and columns based on given information about students and teachers 
# given certain constraints. Here are my results:


CREATE TABLE students (
	student_id SERIAL PRIMARY KEY NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	homeroom_number INTEGER NOT NULL,
	phone INTEGER UNIQUE NOT NULL,
	email VARCHAR UNIQUE NOT NULL,
	graduation_year INTEGER NOT NULL);
 
 CREATE TABLE teachers (
	teacher_id SERIAL PRIMARY KEY NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	homeroom_number INTEGER NOT NULL,
	phone INTEGER UNIQUE NOT NULL,
	email VARCHAR UNIQUE NOT NULL,
	department VARCHAR NOT NULL);
 
 # Student did not have an email, so altered table to drop the NOT NULL constraint
 
 ALTER TABLE students
 ALTER COLUMN email
 DROP NOT NULL;

 INSERT INTO students(
	first_name,
	last_name,
	student_id,
	phone,
	graduation_year,
	homeroom_number);
 	
 VALUES(
	'Mark',
 	'Watney',
	 1,
	7775551234,
 	2035,
 	5);
 
 INSERT INTO teachers(
	 first_name,
	 last_name,
	 teacher_id,
	 email,
	 phone,
	 department,
	 homeroom_number);
 	
 VALUES(
  	'Jonas',
  	'Salk',
 	 1,
  	'jsalk@school.org',
  	7775554321,
  	'Biology',
 	 5);

# Section 4 

# How can you categorize different movie ratings, and find how many of each rating we have?

SELECT
SUM(CASE rating
	WHEN 'R' THEN 1
	ELSE 0
END) as r,

SUM(CASE rating
  	WHEN 'PG' THEN 1
	ELSE 0
END) as pg,

SUM(CASE rating
  	WHEN 'PG-13' THEN 1
	ELSE 0
END) as pg13
FROM film
