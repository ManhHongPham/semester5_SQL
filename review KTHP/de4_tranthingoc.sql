use master
go

create database phammanh_de4_tranngoc
go

use phammanh_de4_tranngoc
go

create table khoa(
	makhoa char(5) primary key,
	tenkhoa char(10)
)
go

create table lop(
	malop char(5) primary key,
	tenlop char(10),
	siso int,
	makhoa char(5),

	constraint fk1 foreign key(makhoa) references khoa(makhoa)
)
go

create table sinhvien(
	masv char(5) primary key,
	hoten char(10),
	ngaysinh date,
	gioitinh bit,
	malop char(5),
	
	constraint fk2 foreign key(malop) references lop(malop)
)
go

--cau1
insert into khoa values('a1','cntt'),('a2','nn')

insert into lop values('b1','cntt1',70,'a1'),('b2','nnt1',30,'a2')

insert into sinhvien values('c112','tung','1/1/2005',0,'b2'),
('c2','ung','1/2/2000',1,'b1'),
('c3','hung','1/3/2000',1,'b2'),
('c4','mung','1/4/2000',1,'b2'),
('c5','kung','1/5/2000',1,'b2'),
('c6','pung','1/6/2000',0,'b1'),
('c7','vung','1/12/2000',0,'b2')

--test
select *from khoa
select *from lop
select	*from sinhvien

--cau2
create function cau3(@tenkhoa char(5))
returns @danhsach table(
				masv char(5),
				hoten char(10),
				tuoi int
				)
as 
	begin
		insert into @danhsach 
				select	masv, hoten, (2021- year(ngaysinh)) as 'tuoi'
				from --sinhvien inner join lop on sinhvien.malop=lop.malop and
					--lop inner join khoa on khoa.makhoa=lop.makhoa
					lop as a, khoa as b, sinhvien as c
				where b.makhoa=a.makhoa and a.malop=c.malop and tenkhoa= @tenkhoa
		return
	end

--test
select *from sinhvien
select *from cau3('nn')

--cau3
create trigger xoa
on sinhvien
for delete
as
	begin
		declare @tuoi int
		declare @masv char(5)
		set @tuoi= (select (2021- year(ngaysinh)) from deleted)
		set @masv= (select masv from deleted)

		if(not exists(select * from sinhvien inner join deleted on sinhvien.masv=deleted.masv  ))
			begin
				raiserror(N'loi khong co ma sinh vien trong danh sach',16,1)
				rollback transaction
			end
		else
			if(@tuoi >18)
				begin
					raiserror(N'loi tuoi da lon hon 18', 16,1)
					rollback transaction
				end
			else
				update lop set siso=siso-1
		end
			
			
--test
select *from lop
select *from sinhvien
delete from sinhvien where masv= N'c5'