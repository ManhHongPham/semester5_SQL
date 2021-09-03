use master
go
create database qlkho_review_test2_de2
go

use qlkho_review_test2_de2
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

insert into ton values('a12','banh','200'),
('a13','keo','300'),
('a14','sua','100'),
('a15','nuoc','500')

insert into nhap values('b5','a15',12,200,'11/11/2000'),
('b2','a14',12,2000,'12/1/2000'),
('b3','a12',12,12000,'1/11/2000')

insert into xuat values('c1','a14',22,3000,'1/1/2011'),
('c2','a12',22,3000,'1/11/2011'),
('c3','a13',22,3000,'1/3/2011')

select *from ton
select *from nhap
select *from xuat

--viet thu tuc nhap
create proc nhapdata(@shdx char(5), @mvt char(5),@slx int,@dongiax int, @ngayx date, @kq int output)
as
	begin 
		if(exists (select * from ton where @mvt=ton.mavt and @slx>slton))
			begin
				print('so luong xuat lon hon so luong ton')
				set @kq=0
			end
		else
			begin
				insert into xuat values(
					@shdx , @mvt ,@slx ,@dongiax , @ngayx )
			end
	return @kq
end

select *from nhap
select *from ton
select *from xuat

declare @kq int

exec nhapdata 'c4','a12',200,3000,'12/11/2000', @kq output

--thong ke tong tien
create function thong(@ngaynhap date, @mvt char(5))
returns @bang table(
				ngaynhap date, 
				mavt char(5),
				tenvt char(5),
				tongtien int
				)
as 
	begin 
		insert into @bang
				select ngayn, nhap.mavt, tenvt, sum(slnhap*dongia) as N'tongtien'
				from nhap inner join ton on nhap.mavt=ton.mavt
				where @ngaynhap=ngayn and @mvt=nhap.mavt
				group by ngayn, nhap.mavt, tenvt
		return
	end

select *from nhap
select *from ton
select *from xuat

select* from dbo.thong('12/11/2000','a15')

---trigger
create trigger ta
on nhap
for insert
as
	begin
		if(not exists(select*from inserted inner join ton on ton.mavt=inserted.mavt))
			begin
				raiserror('khong co vat tu trong danh sach',16,1)
				rollback transaction
			end
		else
			begin
				declare @slnhap int
				declare @slton int
				declare @mavt int

				select @slnhap from inserted
				select @mavt from inserted

				select @slton=slton from ton inner join inserted on ton.mavt=inserted.mavt
				where ton.mavt=@mavt

				update ton set slton= slton+ inserted.slnhap 
				from ton inner join inserted on ton.mavt=inserted.mavt
				where inserted.mavt=ton.mavt
			end
end

select *from nhap
select *from ton
select *from xuat

insert into nhap values('b1','a12',20,2000,'12/11/2000')