use master
go

create database qlbh_review_KTHP
go

use qlbh_review_KTHP
go

create table hang(
	mahang char(5) primary key,
	tenhang char(5),
	soluong int,
	giaban int
)
go

create table muahang(
	stt char(5) primary key,
	mahang char(5),
	nguoiban char(10),
	soluong int,
	ngayban date,

	constraint fk foreign key(mahang) references hang(mahang)
)
go

insert into hang values('1a','banh',12,2000),
('2a','keo',22,2000),
('3a','sua',52,7000),
('4a','hoa',112,12000),
('5a','nuoc',100,9000)

insert into muahang values('12b','3a','tung',12,'1/1/2000'),
('2b','1a','hoa',4,'1/4/2000'),
('3b','2a','lam',6,'1/5/2000'),
('4b','3a','hoai',3,'1/8/2000'),
('5b','4a','manh',9,'1/1/2000'),
('6b','5a','tung',1,'1/7/2000'),
('7b','3a','tung',3,'1/3/2000')


select *from hang
select *from muahang

--function
create function cau3(@mahang char(5),@x date, @y date)
returns int
as
begin
	declare @tong int
	select @tong=sum(soluong)
	from muahang 
	where @mahang=mahang and ngayban between @x and @y 
	return @tong
end

--test
select *from muahang
select dbo.cau3('3a','12/1/1999','2/2/2010')

--cau 3
create function cau33333(@mahang char(5))
returns @bang table(
				mahang char(5),
				tenhang char(5), 
				soluong int,
				giaban int,
				thanhtien int)
as 
	begin 
		insert into @bang 
			select muahang.mahang, tenhang,muahang.soluong,giaban, (muahang.soluong*giaban)as N'thanhtien'
			from muahang inner join hang on hang.mahang= muahang.mahang
			where muahang.mahang=@mahang
			--group by muahang.mahang, tenhang, muahang.soluong, giaban
	return 
end

--test
select *from muahang

select *from cau33333('3a')


--trigger

create trigger kiemtraaaaaa
on muahang
for insert
as
	begin
		if(not exists(select *from muahang inner join inserted on muahang.mahang=inserted.mahang))
			begin
				raiserror ('ma hang khong ton tai',16,1)
				rollback transaction
			end
		else
			begin
				declare @soluong int
				declare @soluongban int
				declare @mavt char(5)
				select @mavt=mahang from inserted
				select @soluong=hang.soluong from hang --inner join inserted on hang.mahang=inserted.mahang
					where hang.mahang=@mavt

				select @soluongban=soluong from inserted

				if(@soluong < @soluongban)
					begin
						raiserror('so luong khong du ban',16,1)
						rollback transaction
					end
				else
					update hang set hang.soluong= hang.soluong - @soluongban
					from hang inner join inserted on hang.mahang= inserted.mahang
					where hang.mahang=@mavt
			end
	end

--test
select *from hang
select *from muahang

insert into muahang values('37a','3a','hoa','200','1/1/2000')

/*
select mahang, count(*) *100.0/(select count(*) from muahang) as N'phantram'
from muahang
where mahang=N'1a'
group by mahang


select Grade, count(*) * 100.0 / (select count(*) from MyTable)
from MyTable
group by Grade*/	