DROP TABLE Warehouses cascade ;
DROP TABLE Boxes cascade ;
CREATE TABLE Warehouses(
    code int not null,
    location varchar(255) not null,
    capacity int not null,
    primary key (code)

);

CREATE TABLE Boxes(
    code varchar(255) not null,
    contents varchar(255) not null,
    value real not null,
    warehouse int not null,
    primary key (code),
    foreign key (warehouse) references Warehouses(code)
);
INSERT INTO Warehouses VALUES(1, 'Chicago', 3);
INSERT INTO Warehouses VALUES(2, 'Rocks', 4);
INSERT INTO Warehouses VALUES(3, 'New York', 7);
INSERT INTO Warehouses VALUES(4, 'Los Angeles', 2);
INSERT INTO Warehouses VALUES(5, 'San Francisko', 8);

INSERT INTO Boxes VALUES ('0MN7', 'Rocks', 180, 3);
INSERT INTO Boxes VALUES ('4H8P', 'Rocks', 250, 1);
INSERT INTO Boxes VALUES ('4RT3', 'Scissors', 190, 4);
INSERT INTO Boxes VALUES ('7G3H', 'Rocks', 200, 1);
INSERT INTO Boxes VALUES ('8JN6', 'Papers', 75, 1);
INSERT INTO Boxes VALUES ('8Y6U', 'Papers', 50, 3);
INSERT INTO Boxes VALUES ('9J6F', 'Papers', 175, 2);
INSERT INTO Boxes VALUES ('LL08', 'Rocks', 140, 4);
INSERT INTO Boxes VALUES ('P0H6', 'Scissors', 125, 1);
INSERT INTO Boxes VALUES ('P2T6', 'Scissors', 150, 2);
INSERT INTO Boxes VALUES ('TUSS', 'Papers', 90, 5);
--4
select *from Warehouses;
--5
select *from Boxes where value>150;
--6
select distinct contents from Boxes;
--7
 SELECT Warehouse,count(warehouse)
 as "Number of boxes" from Boxes group by warehouse order by warehouse asc;
--8
 SELECT Warehouse,count(warehouse)
 as "Number of boxes" from Boxes group by warehouse  having warehouse>2 order by warehouse asc;
--9
insert into Warehouses (code,location,capacity) values (6,'New York','3');
--10
insert into Boxes (code, contents, value,warehouse) values('H5RT','Papers','200','2');
--11
UPDATE Boxes set value=value*0.85 where value in (select distinct value as val from Boxes order by value desc limit 1 offset 2);
--12
DELETE FROM Boxes where value<150;
--13
DELETE FROM Boxes where warehouse='3' returning*;


