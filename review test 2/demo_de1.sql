use master
go
create database qlkho_review_test2
go

use qlkho_review_test2
go

create table ton(
	mavt char(5) primary key,
	tenvt nvarchar(30),
	slton int
)
go

create table nhap(
	sohdn char(5) primary key,
	mavt char(5),
	slnhap int,
	dongia int,
	ngayn date

	constraint fk_nhap foreign key(mavt) references ton(mavt)
)
go

create table xuat(
	sohdx char(5) primary key,
	mavt char(5),
	slxuat int,
	dongia int,
	ngayx date

	constraint sl_xuat foreign key(mavt) references ton(mavt)
)
go

insert into ton values('a12','banh','200'),('a13','keo','300'),('a14','sua','100'),('a15','nuoc','500')

insert into nhap values('b1','a15',12,200,'12/11/2000'),
('b2','a14',12,2000,'12/1/2000'),
('b3','a12',12,12000,'1/11/2000')

insert into xuat values('c1','a14',22,3000,'1/1/2011'),
('c2','a12',22,3000,'1/11/2011'),
('c3','a13',22,3000,'1/3/2011')

select *from ton
select *from nhap
select *from xuat

--thong ke tong tien nhap
create function thongke(@ngaynhap date, @mavt char(5))
returns @tong table(
				ngaynhap date,
				mavt char(5),
				tenvt nvarchar(10),
				tiennhap int
				)
as 
	begin 
			insert into @tong
				select ngayn, nhap.mavt, tenvt, slnhap*dongia as N'tiennhap'
				from ton inner join nhap on ton.mavt= nhap.mavt
				where nhap.mavt=@mavt and @ngaynhap=ngayn
			return
	end

select *from dbo.thongke('1/11/2000','a12')

--cau3 thu tuc nhap

create proc thutuca(@shdx char(5), @mavt char(5),@slxuat int,
								@dongiax int, @ngayx date, @ketqua int output)
as 
begin 
	if(exists(select * from ton where @mavt=ton.mavt and @slxuat > ton.slton ))
		begin
			print ('sl xuat lon hon so luong ton')
			set @ketqua=0
		end
	else 
		begin
		   insert into xuat values(
					@shdx,
					@mavt,
					@slxuat,
					@dongiax,
					@ngayx
					)
			set @ketqua=1
		end 
end

select *from xuat
select *from ton

declare @ketqua int
exec thutuca 'c2','a12',1000,400,'12/2/2300', @ketqua output

--trigger
create trigger checkX
on xuat
for insert
as
	begin
		declare @slxuat int
		declare @slton int

		select @slxuat = inserted.slxuat from inserted 
		
		select @slton=slton from ton inner join inserted on ton.mavt=inserted.mavt
		
		if((@slxuat> @slton))
			begin
				raiserror ('sl xuat lon hon sl ton',16,1)
				rollback transaction
			end
		else
			update ton set slton= slton- @slton
			from ton inner join inserted on ton.mavt=inserted.mavt
end

select *from xuat
select *from ton

insert into xuat values('c27','a13',300,3000,'1/1/2000')