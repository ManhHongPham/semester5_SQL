use master 
go
create database qlkhoa_reviewTest2
go
use qlkhoa_reviewTest2
go

create table khoa(
	makhoa char(5) primary key, tenkhoa nvarchar(10), dienthoai char(10)
)
go

create table lop(
	malop char(5) primary key,tenlop nvarchar(20), hedt char(10), namnhaphoc int, makhoa char(5)
	
	constraint fk foreign key(makhoa) references khoa(makhoa)
)
go

insert into khoa values('a12','cntt','123'),('a13','kt','134'),('a14','cokhi','127')

insert into lop values('b12','c1','daihoc',2000,'a12'),
('b13','c7','daihoc',2001,'a12'),
('b14','c16','daihoc',2030,'a14'),
('b15','c13','daihoc',2002,'a12'),
('b16','c2','daihoc',2012,'a13'),
('b17','c6','daihoc',2009,'a13')

--viet ham thong ke xem moi khoa co bao nhieu lop voi ten khoa la tham so truyen vao
create function thongkekhoa(@tenkhoa nvarchar(10))
returns int
as
	begin
		declare @tong int
		select @tong=count(*) from khoa inner join lop on khoa.makhoa=lop.makhoa
		where tenkhoa= @tenkhoa
	return @tong
end

select dbo.thongkekhoa('cntt')
--dua ra danh sach gom malop, tenlop, hdt,nam cua cac lop voi ten khoa , nam x,y
create function dslop(@tenkhoa nvarchar(10),@x int, @y int)
returns @lop table(
					malop char(5),
					tenlop nvarchar(20), 
					hedt char(10), 
					namnhaphoc int
				)
as 
	begin
			insert into @lop
				select malop, tenlop, hedt, namnhaphoc from lop inner join khoa on lop.makhoa=khoa.makhoa
				where khoa.tenkhoa=@tenkhoa and namnhaphoc between @x and @y
			return
end

select *from dslop('cntt',2000,2001)


