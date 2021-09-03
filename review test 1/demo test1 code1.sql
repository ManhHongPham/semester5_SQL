create database qlsach_demotest1_code1
go

use qlsach_demotest1_code1
go

create table nhaxuatban(
	manxb char(5) primary key,
	tennxb char(10),
	soluongxb int
)
go
create table tacgia(
	matg char(5) primary key,
	tentg char(10)
)
go
create table sach(
	masach char(5) primary key,
	tensach char(10),
	namxb date,
	soluong int,
	dongia int,
	matg char(5),
	manxb char(5),

	constraint fk_tg foreign key(matg) references tacgia(matg),
	constraint fk_xb foreign key(manxb) references nhaxuatban(manxb)
)
go

insert into nhaxuatban values('a12','abc',12),
('a13','cde',22)

insert into tacgia values('b21','hoang mai'),
('b22','khanh mai')

insert into sach values('c27','toan','2000',12,1000,'b22','a12')
insert into sach values('c22','ly','2003',122,1000,'b21','a12')
insert into sach values('c23','hoa','2002',11,100,'b22','a13')
insert into sach values('c24','sinh','2001',32,200,'b21','a12')
insert into sach values('c25','su','2005',132,1300,'b22','a13')

select *from nhaxuatban
select *from sach
select *from tacgia
--cau 1
create view tong
as 
	select nhaxuatban.manxb, nhaxuatban.tennxb, sum(soluong) as 'tong sl'
	from nhaxuatban inner join sach on nhaxuatban.manxb= sach.manxb
	group by nhaxuatban.manxb,nhaxuatban.tennxb

--test
select *from tong
	
---cau 2
create function cau2(@tennxb char(10),@x int, @y int)
returns @bang table(
			masach char(5),
			tensach char(10),
			tentg char(10),
			dongia int
			)
	as
		begin
			insert into @bang	
					select masach, tensach, tentg,dongia
					from sach inner join tacgia on tacgia.matg=sach.matg
						  inner join nhaxuatban on nhaxuatban.manxb= sach.manxb
					where @tennxb=nhaxuatban.tennxb and year(namxb) between @x and @y
		return
end

select *from cau2('abc',2001,2003)

--cau4
create proc xoa(@masach char(5))
as
	begin
		if(not exists(select *from sach where masach=@masach))
			print 'khong ton tai ma nay'
		else
			delete from sach where masach= @masach
end

select*from sach
exec xoa 'c22'
