create database plkho_ReviewTest1
go

use plkho_ReviewTest1
go

create table ton(
	mavt char(5) primary key,
	tenvt nvarchar(20),
	soluongT int
)
go
create table nhap(
	sohdn char(5) primary key,
	mavt char(5),
	soluongN int,
	dongiaN int,
	ngayN datetime,

	constraint fk_nhap foreign key(mavt) references ton(mavt)
)
go

create table xuat(
	sohdx char(5) primary key,
	mavt char(5),
	soluongX int,
	dongiaX int,
	ngayX datetime,

	constraint fk_xuat foreign key(mavt) references ton(mavt)
)
go

insert into ton values('a01','keo mut',700),
('a02','keo deo',100),
('a03','keo keo',2200),
('a04','keo que',40),
('a05','keo cung',300),
('a06','keo ngot',200),
('a07','keo sua',100)

insert into nhap values('b012','a07',100,2000,'12/11/2000'),
('b013','a06',200,200,'2/11/2000'),
('b014','a05',500,20001,'1/11/2000'),
('b015','a04',1300,20003,'12/1/2000'),
('b016','a03',1050,20005,'12/11/2000'),
('b017','a02',1003,20040,'12/12/2000'),
('b018','a01',1002,20300,'1/11/2000')


insert into xuat values('b012','a07',10,2000,'12/11/2000'),
('b013','a06',20,200,'2/11/2000'),
('b014','a05',50,20001,'1/11/2000'),
('b015','a04',300,20003,'12/1/2000'),
('b016','a03',100,20005,'12/11/2000'),
('b017','a02',103,20040,'12/12/2000'),
('b018','a01',2,2030,'1/11/2000')

select *from nhap
select *from xuat
select *from ton

--thong ke tien ban theo ma vat tu gom mavt, tenvt,tienban
create view cau1
as
	select ton.mavt, tenvt, sum(soluongX*dongiaX) as 'tien ban'
	from xuat inner join ton on xuat.mavt=ton.mavt
	group by ton.mavt, tenvt

---hien thi
select * from cau1
----thong ke so luong xuat theo ten vattu
create view cau2
as
	select ton.tenvt, sum(soluongX) as'tong sl'
	from xuat inner join ton on xuat.mavt= ton.mavt
	group by ton.tenvt

---
select *from cau2
------