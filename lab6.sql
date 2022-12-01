drop table dealer cascade;
drop table client cascade;
drop table sell cascade;
create table dealer (
    id integer primary key ,
    name varchar(255),
    location varchar(255),
    charge float
);


INSERT INTO dealer (id, name, location, charge) VALUES (101, 'Ерлан', 'Алматы', 0.15);
INSERT INTO dealer (id, name, location, charge) VALUES (102, 'Жасмин', 'Караганда', 0.13);
INSERT INTO dealer (id, name, location, charge) VALUES (105, 'Азамат', 'Нур-Султан', 0.11);
INSERT INTO dealer (id, name, location, charge) VALUES (106, 'Канат', 'Караганда', 0.14);
INSERT INTO dealer (id, name, location, charge) VALUES (107, 'Евгений', 'Атырау', 0.13);
INSERT INTO dealer (id, name, location, charge) VALUES (103, 'Жулдыз', 'Актобе', 0.12);

create table client (
    id integer primary key ,
    name varchar(255),
    city varchar(255),
    priority integer,
    dealer_id integer references dealer(id)
);

INSERT INTO client (id, name, city, priority, dealer_id) VALUES (802, 'Айша', 'Алматы', 100, 101);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (807, 'Даулет', 'Алматы', 200, 101);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (805, 'Али', 'Кокшетау', 200, 102);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (808, 'Ильяс', 'Нур-Султан', 300, 102);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (804, 'Алия', 'Караганда', 300, 106);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (809, 'Саша', 'Шымкент', 100, 103);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (803, 'Маша', 'Семей', 200, 107);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (801, 'Максат', 'Нур-Султан', null, 105);


create table sell (
    id integer primary key,
    amount float,
    date timestamp,
    client_id integer references client(id),
    dealer_id integer references dealer(id)
);


INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (201, 150.5, '2012-10-05 00:00:00.000000', 805, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (209, 270.65, '2012-09-10 00:00:00.000000', 801, 105);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (202, 65.26, '2012-10-05 00:00:00.000000', 802, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (204, 110.5, '2012-08-17 00:00:00.000000', 809, 103);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (207, 948.5, '2012-09-10 00:00:00.000000', 805, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (205, 2400.6, '2012-07-27 00:00:00.000000', 807, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (208, 5760, '2012-09-10 00:00:00.000000', 802, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (210, 1983.43, '2012-10-10 00:00:00.000000', 804, 106);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (203, 2480.4, '2012-10-10 00:00:00.000000', 809, 103);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (212, 250.45, '2012-06-27 00:00:00.000000', 808, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (211, 75.29, '2012-08-17 00:00:00.000000', 803, 107);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (213, 3045.6, '2012-04-25 00:00:00.000000', 802, 101);

---1
--a
select * from dealer cross join client;
--b
select d.id,d.name,c.name,city,priority,s.id,date,amount from dealer d join client c on d.id=c.dealer_id
join sell s on c.id=s.client_id and d.id=s.dealer_id
order by d.id;
--c
select d.id,d.name,c.id,c.name
from dealer d inner join client c on d.location=c.city;
--d
select s.id,amount,c.name,city
from sell s join client c on 100<= s.amount and s.amount<=500 and s.client_id=c.id
order by amount;
--e
select distinct d.id
from dealer d right join client c
on d.id=c.dealer_id;
--f
select c.name,city,d.name,charge
from dealer d join client c on d.id=c.dealer_id;
--g
select c.name,city,d.id,d.name,charge
from dealer d join client c on d.id=c.dealer_id and charge>0.12;

--h
select c.name, city, s.id, date,amount,d.name,charge
from client c left outer join sell s on c.id=s.client_id left join dealer d on d.id=c.dealer_id;
--i
select c.name, priority, d.name, s.id, amount
from client c
right outer join dealer d
on d.id=c.dealer_id
left outer join sell s
on s.client_id=c.id
where s.amount>=2000
and  c.priority is not null;

select * from dealer;
select * from client;
select * from sell;
-----2
-- a
create view a as
select date, count(distinct client_id), avg(amount), sum(amount)
from sell s
group by date
order by date;

select * from a;
drop view a;

-- b
create view b as
select date, sum(amount)
from sell
group by date
order by sum(amount) desc limit 5;

select * from b;
drop view b;

-- c
create view c as
select dealer_id, count(dealer_id), avg(amount), sum(amount)
from sell
group by dealer_id
order by dealer_id;

select * from c;
drop view c;

-- d
create view d as
select location,  sum(t)
from (
    select location, sum(amount) * d2.charge as t
    from sell s join dealer d2 on d2.id = s.dealer_id
    group by location, d2.charge) q
    group by location
    having location = q.location;

select * from d;
drop view d;

-- e
create view e as
select location, count(s.id), avg(amount), sum(amount)
from sell s join dealer d on d.id = s.dealer_id
group by location;

select * from e;
drop view e;

-- f
create view f as
select city, count(s.id), avg(amount), sum(amount)
from client c join sell s on c.id = s.client_id
group by city;

select * from f;
drop view f;

-- g
create view g as
select city
from (select sum(amount) as sales, location
from sell join dealer d on d.id = sell.dealer_id
group by location) sls
join
(select city, sum(amount) as expences
from client c join sell s on c.id = s.client_id
group by city) expn
on sales < expences and sls.location = expn.city;

select * from g;
drop view g;


select * from dealer;
select * from client;
select * from sell;
