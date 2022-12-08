---1
-- a
create function add1(ans int)
returns int
language plpgsql
as
    $$
    begin
        ans = ans + 1;
        return ans;
    end;
    $$;

select * from add1(2);

-- b
create function sum(f int, s int)
returns int
language plpgsql
as
    $$
    declare ans int;
    begin
        ans = f + s;
        return ans;
    end;
    $$;

select * from sum(332, 68);


-- c
create function div_by_2(variadic num numeric[])
returns bool
language plpgsql
as
    $$
    declare f bool;
    declare i int;
    begin
        f = false;
        select into i
        from generate_subscripts(num, 1)g(i)
        where mod(num[i], 2) = 0;
--         if
--              then f = true;
--         end if;
        return f;
    end;
    $$;

select * from div_by_2(3, 7, 9);
drop function div_by_2;

-- d
create function valid(password varchar)
returns bool
language plpgsql
as
$$
    declare ans bool;
        begin
        ans = true;
        if char_length(password) < 8 or char_length(password) > 16 or not password ~ '[A-Z]' then ans = false;
            end if;
        return ans;
    end;
    $$;

select *from valid('solo');
drop function valid;

-- e
create function outputs(inp varchar, out first varchar, out second varchar)
as
    $$
        begin
        first = split_part(inp,' ', 1);
        second = split_part(inp,' ', 2);
    end
    $$
language plpgsql;


select * from outputs('Zhakupova Elvira');
drop function outputs;


drop function outputs;
----2
-- a
create table Student(
    ID int primary key generated always as identity ,
    First_Name varchar not null ,
    Last_Name varchar not null ,
    Date_of_birth date not null
);

create table changes(
    ID int generated always as identity ,
    student_ID int not null ,
    last_name varchar not null ,
    changed_on timestamp(6) not null
);

CREATE FUNCTION trigger_function()
   RETURNS TRIGGER
   LANGUAGE PLPGSQL
AS $$
    declare upd timestamp;
BEGIN
        IF NEW.last_name <> OLD.last_name THEN
		 INSERT INTO changes(student_ID,last_name,changed_on)
		 VALUES(OLD.id,OLD.last_name,now());
	END IF;
    return upd;
END;
$$;

create trigger last_name_changes
    after update
    on Student
    for each row
    execute procedure  trigger_function();

insert into Student (First_Name, Last_Name, date_of_birth)
values ('Jan', 'Alan', '13.11.1993' );
insert into Student (First_Name, Last_Name)
values ('Anna', 'Stone' );
insert into Student (First_Name, Last_Name)
values ('Mile', 'Li');

update Student set Last_Name = 'Brown' where ID = 2;
update Student set Last_Name = 'Depp' where ID = 1;
update Student set Last_Name = 'Scott' where ID = 3;

select *
from Student;
select *
from changes;

drop trigger last_name_changes on student;
drop function trigger_function();
drop table changes;
drop table Student;

-- b
create table Employee(
    ID int primary key generated always as identity ,
    First_Name varchar not null ,
    Last_Name varchar not null ,
    Date_of_birth date
);

create table ages(
    ID int generated always as identity ,
    employee_ID int not null ,
    last_name varchar not null ,
    age int not null
);

insert into employee (first_name, last_name, date_of_birth)
values ('Adams', 'Vanessa', '12-12-2012');

CREATE FUNCTION for_age()
   RETURNS TRIGGER
   LANGUAGE PLPGSQL
AS $$
    declare Date_of_birth date;
BEGIN
     insert into ages (employee_ID, last_name, age) values (new.ID, new.last_name, (current_date - new.Date_of_birth)/365.25);
     return Date_of_birth;
END;
$$;

create trigger age_trigger
    after insert
    on Employee
    for each row
    execute procedure  for_age();

select * from employee;
select * from ages;

drop trigger age_trigger on employee;
drop function for_age();
drop table ages;
drop table employee;


-- c
create table product(
    ID int generated always as identity,
    Price int not null
);

create function tax_price()
returns trigger
language plpgsql
as
    $$
    begin
        update product
        set price = price * 1.12
        where id = new.id;
        return new;
        end;
    $$;

create trigger tax
    after insert
    on product
    for each row
    execute procedure tax_price();

insert into product (Price) values (100);
insert into product (Price) values (90);


select * from product;

drop trigger tax on product;
drop function tax_price();
drop table product;


-- d
create table deletion(
    ID int generated always as identity,
    Name varchar not null
);

create function prev_deletion()
returns trigger
language plpgsql
as $$
    begin
        raise exception 'Deletion prohibited1';
    end;
    $$;

create trigger del_prev
    after delete
    on deletion
    for each row
    execute procedure prev_deletion();

insert into deletion (Name) values ('Emma');
insert into deletion (Name) values ('Inna');

select * from deletion;

delete
from deletion
where name = 'Emma';

drop trigger del_prev on deletion;
drop function prev_deletion();
drop table deletion;

-- e
create table profile(
    username varchar,
    first_last varchar,
    password varchar,
    val boolean
);

create function create_prof()
returns trigger
language plpgsql
as $$
    begin
        if valid(new.password ) = true then
            update profile
            set val = true, first_last = outputs(new.first_last)
            where username = new.username;
        else
            update profile
            set val = false
            where username = new.username;
        end if;
        return new;
    end;
    $$;

create trigger creating
    after insert
    on profile
    for each row
    execute procedure create_prof();

insert into profile (username, first_last, password)
values ('Ella', 'Zhakupova Elvira', 'Elya22');

insert into profile (username, first_last, password)
values ('Nurs', 'Maulen Nursultan', 'nm1234');

select * from profile;

drop trigger creating on profile;
drop function create_prof();
drop table profile;
---3---4

create table empl(
    ID int primary key generated always as  identity,
    name  varchar,
    date_of_birth date,
    age int,
    salary int,
    workexperience int,
    discount int
);

insert into empl (name, date_of_birth, age, salary, workexperience, discount)
values ('Luck', '1985-03-26', 36, 1000,9, 1);

insert into empl(name, date_of_birth, age, salary, workexperience, discount)
values ('Tyler', '1970-04-19', 51, 5000, 20, 4);

select *
from empl;

-- a
create procedure inc_salary()
language plpgsql
as $$
    begin
        update empl
        set salary = salary * (1.1)^(workexperience/2), discount = 10
        where workexperience > 2;
        update empl
        set discount = discount + 1
        where workexperience > 5;
        commit ;
    end;
    $$;

call inc_salary();

-- b
create procedure inc_salary2()
language plpgsql
as $$
    begin
        update empl
        set salary = salary * (1.15)
        where age >= 40;
        update empl
        set salary = salary * (1.15), discount = 20
        where workexperience >= 8;
        commit ;
    end;
    $$;

call inc_salary2();

drop table empl;
drop procedure inc_salary();
drop procedure inc_salary2();