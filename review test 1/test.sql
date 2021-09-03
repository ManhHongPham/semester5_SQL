create database ql_hang_test1
go

use ql_hang_test1
go

create table hang(
	mahang char(5) not null primary key, tenhang char(20), dvtinh char(10), sl int
)
go
create table hdban(
	mahd char(5) not null primary key,ngayban date, hoten char(20)
)
go
create table hangban(
	mahd char(5) not null,
	mahang char(5) not null,
	dongia int,
	soluong int,

	constraint pk_hang primary key(mahd,mahang),
	constraint fk_hang foreign key(mahd) references hdban(mahd),
	constraint fk_ban foreign key(mahang) references hang(mahang)
)
go

insert into hang values('ab1','banh','vnd',200),('ab2','keo','vnd',1100),('ab3','nuoc','vnd',100)

insert into hdban values('de1','12/11/1990','tung'),('de2','12/11/1994','thoa'),('de3','12/11/1999','hoan')

insert into hangban values('de1','ab1',12,24)
insert into hangban values('de1','ab2',12,24)
insert into hangban values('de2','ab1',12,24)
insert into hangban values('de2','ab3',12,24)


create view cau1
as
	select hang.mahang, hang.tenhang, sum(soluong*dongia) as'tong tien'
	from hang inner join hangban on hang.mahang= hangban.mahang
	group by hang.mahang, hang.tenhang

select *from cau1

create function cau2(@tenhang char(5),@x int, @y int)
returns @bang table(
		mahang char(5),
		tenhang char(20),
		soluong int,
		dongia int)
as
	begin
		insert into @bang
			select hang.mahang, tenhang, soluong, dongia
			from hangban inner join hang on hangban.mahang=hang.mahang
						 inner join hdban on hangban.mahang=hangban.mahang	
			where @tenhang=tenhang and year(ngayban) between @x and @y
	return
end

select *from cau2('keo','1990','1992')
