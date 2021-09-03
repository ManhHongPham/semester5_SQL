create database ManageStuedent_ReviewTest1
go

use ManageStuedent_ReviewTest1
go

create table student(
	studentID nvarchar(12) primary key,
	studentName nvarchar(25) not null,
	dateofBirth datetime not null,
	email nvarchar(40),
	phone nvarchar(12),
	class nvarchar(10),
)
go

create table subject(
	subjectID nvarchar(10) primary key,
	subjectName nvarchar(25) not null
)
go

create table mark(
	studentID nvarchar(12),
	subjectID nvarchar(10),
	date datetime,
	theory tinyint,
	pracical tinyint,

	constraint pk_mark primary key(studentID, subjectID),
	constraint fk_student foreign key(studentID) references student(studentID),
	constraint fk_subject foreign key(subjectID) references subject(subjectID)
)
go

insert into student values('av0807005','mai trung hieu','11/10/1989','trunghieu@gmail.com','1231232','av1'),
('av0807006','mai hieu','11/10/1989','trunghieu@gmail.com','1231232','av1'),
('av0807007','trung hieu','11/10/1989','trunghieu@gmail.com','1231232','av1'),
('av0807008','hieu','11/10/1989','trunghieu@gmail.com','1231232','av1'),
('av0807009','hoang','11/10/1989','trunghieu@gmail.com','1231232','av1'),
('av0807010','hoa','11/10/1989','trunghieu@gmail.com','1231232','av1'),
('av0807011','minh','11/10/1989','trunghieu@gmail.com','1231232','av1')

insert into  subject values('s001', 'toan'),('s002','van'),('s003','hoa')

insert into mark values('av0807005','s001','6/5/2020', 8, 25),
('av0807006','s001','6/5/2020', 8, 25),
('av0807007','s002','6/5/2020', 8, 25),
('av0807008','s003','6/5/2020', 8, 25),
('av0807009','s001','6/5/2020', 8, 25),
('av0807010','s002','6/5/2020', 8, 25),
('av0807011','s003','6/5/2020', 8, 25),
('av0807005','s002','6/5/2020', 8, 25),
('av0807005','s003','6/5/2020', 8, 25)

--hien thi danh sach sinh vien av2 arrange tang dan theo studentName

select *from subject
select *from student
select *from mark
--tong so sinh vien tung lop
select subjectID, COUNT(*) as N' tong so'
from mark
group by subjectID
