use master
go

create database qlbanhang_de12094
go

create table vattu(
	mavt char(5) primary key,
	tenvt char(20),
	dvtinh char(10),
	slcon int,
	mota char(20)
)
go

create table hoadon(
	mahd char(5) primary key,
	ngaylap date,
	hotenkhach char(20),
	gioitinh bit
)
go
create table cthoadon(
	mahd char(5),
	mavt char(5),
	dongiaban int,
	slban int,
	ngayban date,

	primary key(mahd,mavt),
	constraint fk1 foreign key(mahd) references hoadon(mahd),
	constraint fk2 foreign key(mavt) references vattu(mavt)
)
go

insert into vattu values('a1','sua','hop',100,'nuoc'),
('a2','banh','hop',200,'man'),
('a3','keo','tui',300,'ngot')

insert into hoadon values('b1','1/1/2000','tung',1),
('b2','1/4/2000','hung',0),
('b3','1/2/2000','vung',0)

insert into cthoadon values('b1','a1',3000,12,'2/2/2002'),
('b1','a2',4000,120,'2/2/2002'),
('b2','a1',8000,12,'2/2/2002'),
('b2','a2',1000,32,'2/2/2002'),
('b1','a3',7000,72,'2/2/2002')

--test
select *from vattu
select *from hoadon
select *from cthoadon


--cau2
create function cau2(@tenvt char(20), @ngayban date)
returns int
as 
begin
	declare @tongtienhang int
	set @tongtienhang= ( select sum(dongiaban* slban) from cthoadon inner join
	vattu on cthoadon.mavt=vattu.mavt
	where tenvt=@tenvt and ngayban=@ngayban)

	return @tongtienhang
end


--test
select *from vattu
select *from cthoadon
select dbo.cau2('sua','2/2/2002')

--cau3
create proc cau333(@thang int, @nam int, @tongsl int output)
as
begin
	--declare @tongsl int
	set @tongsl= (select sum(slban) from cthoadon where MONTH(ngayban)=@thang
	and YEAR(ngayban)=@nam)

	return @tongsl
end

--test
declare @tongsl int
exec cau33 2,2002