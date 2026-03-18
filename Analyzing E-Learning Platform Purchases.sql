-- 1. Database & Table Creation:
create database e_learning;
use e_learning;
create table learners (
	learner_id int auto_increment primary key,
    full_name varchar(150) not null,
    country varchar(50) not null );
create table courses (
	course_id int auto_increment primary key,
    course_name varchar(100) not null,
    category varchar(50) not null,
    unit_price decimal(10,2) not null );
create table purchases (
	purchase_id int auto_increment primary key,
    learner_id int not null,
    course_id int not null,
    quantity int not null,
    purchase_date date not null,
    foreign key (learner_id) references learners(learner_id),
    foreign key ( course_id) references courses(course_id) );
alter table learners auto_increment = 10001;
alter table courses auto_increment = 5001;

-- Insertion of Sample Data:
insert into learners(full_name,country)
values
		('Innaiya Fathima', 'USA'),
        ('Aaliya', 'India'),
        ('Benny Jack', 'Spain'),
        ('Chen Wei', 'China'),
        ('Goldina Thomas', 'Germany');
select * from learners;
insert into courses(course_name,category,unit_price)
values
		('Power BI','Technology', 399.50),
        ('Python Fundamentals','Technology', 499.55),
        ('Business Communication','Business', 250.00),
        ('Financial Accounting','Finance',180.22),
        ('Creative Writing','Arts',89.45);
select * from courses;
select * from learners;
insert into purchases(learner_id,course_id,quantity,purchase_date)
values
		(10001,5001,2,'2026-01-01'),
        (10002,5004,3,'2026-02-07'),
        (10003,5002,1,'2026-02-18'),
        (10004,5003,1,'2026-02-20'),
        (10005,5005,1,'2026-03-02'),
        (10002,5003,3,'2026-03-10'),
        (10004,5004,2,'2026-03-12'),
        (10003,5005,5,'2026-03-14');
select * from purchases;
select * from courses;
select * from learners;

-- 2. Data Exploration using Joins:

select category,
		round(avg(unit_price),2) as Avg_Price,
        round(sum(unit_price),2) as Total_Price
from courses
group by category
order by total_price desc;

-- using Inner Join
select	l.learner_id,
		l.full_name,
        c.course_name,
        c.category,
        p.purchase_date,
        p.quantity,
        round(p.quantity * c.unit_price, 2) as Total_Amount
from purchases p
inner join learners l on p.learner_id = l.learner_id
inner join courses c on p.course_id = c.course_id
order by l.full_name, p.purchase_date desc;

-- using Left Join
select	l.learner_id,
		l.full_name,
        c.course_name,
        c.category,
        p.purchase_date,
        p.quantity,
        round(p.quantity * c.unit_price, 2) as Total_Amount
from learners l
left join purchases p on l.learner_id = p.learner_id
left join courses c on c.course_id = p.course_id
order by l.full_name, p.purchase_date desc;

-- using Right Join
select	l.learner_id,
		l.full_name,
        c.course_name,
        c.category,
        p.purchase_date,
        p.quantity,
        round(p.quantity * c.unit_price, 2) as Total_Amount
from purchases p
right join courses c on p.course_id = c.course_id
right join learners l on p.learner_id = l.learner_id
order by c.course_name, p.purchase_date desc;

-- Total Spending along with their countries:
select  l.learner_id,
		l.full_name,
        l.country,
        round(sum(p.quantity * c.unit_price),2) as Total_Spent
from purchases p
inner join learners l on p.learner_id = l.learner_id
inner join courses c on p.course_id = c.course_id
group by l.learner_id,l.full_name,l.country
order by Total_Spent desc;

-- The top 3 most purchased courses based on quantity sold:
select  c.course_id,
		c.course_name,
        c.category,
        sum(p.quantity) as Total_Quantity_Sold
from purchases p
inner join courses c on p.course_id = c.course_id
group by c.course_id,c.course_name,c.category
order by Total_Quantity_Sold desc
limit 3;
		
-- Each Course category total revenue and no. of unique learners:
select  c.category,
		round(sum(p.quantity * c.unit_price),2) as Total_Revenue,
        count(distinct p.learner_id) as Unique_learners
from purchases p
inner join courses c on p.course_id = c.course_id
group by category
order by Total_Revenue desc;

-- Learners who purchased courses from more than one category:
select  l.learner_id,
		l.full_name,
        count(distinct c.category) as Category_Count
from purchases p 
inner join learners l on p.learner_id = l.learner_id
inner join courses c on p.course_id = c.course_id
group by l.learner_id,l.full_name
having Category_Count > 1
order by Category_Count desc;

-- Courses that have not been purchased at all:
select 	c.course_id,
		c.course_name,
        c.category,
        c.unit_price
from courses c
left join purchases p on c.course_id = p.course_id
where p.course_id is null
order by course_name;
        

    