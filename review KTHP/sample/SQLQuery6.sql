use master
go
create database QLKHOtiep1
go
use QLKHOtiep1
go
create table ton(
mavt nvarchar(10) not null primary key,
tenvt nvarchar(30)not null,
slton int
)
create table nhap(
sohdn nvarchar(10) not null,
mavt nvarchar(10) not null,
primary key(sohdn,mavt),
foreign key (mavt) references ton (mavt)on update cascade on delete cascade,
slnhap int,
dgnhap money,
ngayn date
)

create table xuat(
sohdx nvarchar(10) not null,
mavt nvarchar(10)not null,
primary key (sohdx,mavt),
foreign key (mavt) references ton(mavt) on update cascade on delete cascade,
slxuat int,
dgxuat money,
ngayx date
)

insert into ton values
('vt1',N'nước hoa',200),
('vt2',N'kem nền',100),
('vt3',N'son tint',300),
('vt4',N'toner',200)

insert into nhap values
('n1','vt1',100,50,'4/5/2019'),
('n2','vt3',200,40,'2/6/2019'),
('n3','vt4',100,60,'4/9/2020')

insert into xuat values
('x1','vt1',100,100,'3/2/2020'),
('x2','vt2',50,100,'7/6/2020'),
('x3','vt3',100,70,'4/8/2020')

select * from ton
select * from nhap
select * from xuat 
---------------------------------------------
--cau2: viết thủ tục nhập dl cho bảng xuất với các tham chiếu truyền vào
--sohdx,mavt,slx,dgx,ngayx. kiểm tra xem slx<= slt hay không? nếu thỏa mãn cho phép xuất và ngược lại
create proc cau2(@sohdx nvarchar(10),@mavt nvarchar(10),@slx int,@dgx money,@ngayx date)
as 
begin
     declare @slton int 
	 select @slton=slton from ton where mavt=@mavt
	 if(@slx>@slton)
	     print (N'Không đủ số lượng bán')
	 else 
	     begin 
		      insert into xuat values(@sohdx,@mavt,@slx,@dgx,@ngayx)
			  print(N'xuat thanh cong')
		end
end
-------------------test----------------
exec cau2 'n4','vt2',150,100,'8/9/2020'
exec cau2 'n5','vt2',50,100,'8/9/2020'
select * from xuat
------------------------------------------------------------
 --cau3: Tạo hàm đưa ra thống kê tổng tiền nhập với ngayfn và tenvt truyền vào
 create function fn_cau3(@tenvt nvarchar(20),@ngayn date)
 returns money
 as
 begin
      declare @tongtiennhap money
	  set @tongtiennhap=(select sum(slnhap*dgnhap) 
	                     from nhap inner join ton on ton.mavt=nhap.mavt
						 where @tenvt=tenvt and @ngayn=ngayn
						 )
	  return @tongtiennhap
end
----------------test----------------
select dbo.fn_cau3 (N'nước hoa','4/5/2019') as N'Tổng tiền nhập'
--------------------------------------------------------------------
 --cau4: viết trigger cho bảng nhập sc khi vt nhập hợp lệ(mavt ở nhập có trong ton)
 -- thì slton đc cập nhật tăng theo slnhap. trái lại thì rollback 

create trigger cau44
on Nhap
for insert
as
begin
	declare @mavt nchar(20)
	set @mavt = (select mavt from inserted)
	if(exists(select * from Ton where mavt = @mavt))
		begin
			declare @sln int
			set @sln = (select slnhap from inserted where MaVT = @mavt)
			update ton set slton = slton + @sln
			from ton where mavt= @mavt
		end
	else
		begin	
			raiserror(N'Vat Tu Khong Ton Tai' , 16,1)
			rollback tran
		end
end
	
-------------------------------------------
select * from ton
select * from nhap
insert into nhap values ('n8','vt3',10,10,'4/6/2020')