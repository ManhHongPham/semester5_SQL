create database qlClass_Function_reviewTest1
go

use qlClass_Function_reviewTest1
go

create table khoa(
	makhoa char(5) primary key, tenkhoa char(5), dienthoai char(10)
)
go
create table lop(
	malop char(5) primary key, tenlop char(5), hedt char(10), namnhaphoc char(10), makhoa char(5),
	constraint fk_lop foreign key(makhoa) references khoa(makhoa)
)
go

insert into khoa values('a1','toan','1232312'),
('a2','ly','12d312'),
('a3','hoa','1s2'),
('a4','sinh','we2312'),
('a5','su','123ere2'),
('a6','dia','12tr312')

insert into lop values('b9','a','daihoc','1900','a1'),
('b13','a','daihoc','2000','a1'),
('b14','a','daihoc','2000','a1'),
('b15','a','daihoc','2000','a2'),
('b16','a','daihoc','2000','a3'),
('b17','a','daihoc','2000','a5'),
('b18','a','daihoc','2000','a4'),
('b19','a','daihoc','2000','a6'),
('b10','a','daihoc','2000','a4')

---ham test
select *from khoa
select *from lop

---ham thong ke xem moi khoa co bao nhieu lop voi ten khoa la tham so truyen vao
create function timkha(@tenkhoa char(5))
returns int
as
	begin	
		declare @tong int
		select @tong=count(*) from khoa inner join lop on lop.makhoa=khoa.makhoa
		where tenkhoa=@tenkhoa

		return @tong
end
--hien thi
select dbo.timkha('toan')


--thong ke tu nam x den nam y co bao nhieu lop duoc dao tao
create function nhaphoc(@namx char(10),@namy char(10))
returns @lopa table(
			malop char(5),
			tenlop char(10),
			hedt char(10),
			nam char(10)
			)
as
	begin
		insert into @lopa 
			select malop, tenlop, hedt, namnhaphoc
			from lop
			where namnhaphoc between @namx and @namy
		return
end

---test
select * from nhaphoc('1920','2000')