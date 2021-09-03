use master
go

create database de3_nguyenthihop
go

use de3_nguyenthihop
go

create table benhvien(
	mabv char(5) primary key,
	tenbv char(10),
	diachi char(20),
	dienthoai char(10)
)
go

create table khoakham(
	makhoa char(5) primary key,
	tenkhoa char(20),
	sobenhnhan int,
	mabv char(5),
	
	constraint fk1 foreign key(mabv) references benhvien(mabv)
)
go

create table benhnhan(	
	mabn char(5) primary key,
	hoten char(20),
	ngaysinh date,
	gioitinh bit,
	dienthoai char(20),
	makhoa char(5),
	
	constraint fk2 foreign key(makhoa) references khoakham(makhoa)
)
go

insert into benhvien values('a1','dakhoa','hn',12345),('a2','dalieu','hn',2323)

insert into khoakham values('b1','mat',200,'a1'),('b2','da',100,'a2')

insert into benhnhan values('c1','tung','1/1/2000',0,12121,'b1'),
('c2','hung','1/7/2000',1,1221,'b2'),
('c3','vung','1/5/2000',1,1221,'b2'),
('c4','lung','1/3/2000',1,2121,'b2'),
('c5','cung','1/8/2000',0,12321,'b1')

--cau3
create function cau3(@makhoa char(5))
returns @bang table(
				makhoa char(5),
				tenkhoa char(20),
				songuoi int
				)
as 
	begin
		insert into @bang
				select b.makhoa, tenkhoa, sobenhnhan
				from benhvien as a, khoakham as b, benhnhan as c
				where a.mabv= b.mabv and b.makhoa=c.makhoa and gioitinh= 1
		return
	end
--test
select *from benhnhan
select *from cau3('b2')

--cau 4

create trigger cau4
on benhnhan
for insert
as 
	begin
		declare @sdt int
		declare @check bit
		set @sdt= (select dienthoai from inserted)

		set @check= ISNUMERIC(@sdt)

		if(@check=0)
			begin
				raiserror('loi sdt khong hop le',16,1)
				rollback transaction
			end
		else
			begin
				update khoakham set sobenhnhan= sobenhnhan+1
			end
	end
--test
select*from khoakham
select*from benhnhan

insert into benhnhan values('as','tung','1/1/1999',1,'asas','b2')
			
			
