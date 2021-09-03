create database QLBV
go
use QLBV
go

CREATE TABLE BV
(
  MABV nvarchar(30) not null primary key,
  TENBV nvarchar(30)
);

CREATE TABLE KHOAKHAM
(
  MAKHOA nvarchar(30) not null primary key,
  TENKHOA nvarchar(30),
  SOBN int,
  MABV nvarchar(30),
  foreign key(MABV) references BV(MABV)
);

CREATE TABLE BENHNHAN
(
  MABENHNHAN nvarchar(30) not null primary key,
  HOTEN nvarchar(30),
  NGAYSINH date,
  GIOITINH bit,
  SODT nvarchar(100),
  MAKHOA nvarchar(30),
  foreign key(MAKHOA) references KHOAKHAM(MAKHOA)
);
insert into BV values('BV1','BVA')
insert into BV values('BV2','BVB')

insert into KHOAKHAM values('K1','TENKHOA1',10,'BV1')
insert into KHOAKHAM values('K2','TENKHOA2',20,'BV2')

insert into BENHNHAN values('BN1','TENBN1','12-3-2000',1,'12','K1')

insert into BENHNHAN values('BN5','TENBN5','12-3-2004',0,'16','K2')
select * from BV
select * from BENHNHAN
drop table BV
drop table KHOAKHAM
drop table BENHNHAN

select MABENHNHAN,HOTEN,2021-year(NGAYSINH) as 'TUOI'
from BENHNHAN
where YEAR(NGAYSINH)=(select min(year(NGAYSINH)) from BENHNHAN ) 


CREATE FUNCTION cau3
(
    @MABENHNHAN nvarchar(30)
    
)
RETURNS @returntable TABLE 
(
	MABENHNHAN nvarchar(30),
    HOTEN nvarchar(30),
    NGAYSINH date,
    GIOITINH nvarchar(30),
	TENKHOA nvarchar(30),
	TENBV nvarchar(30)
)
AS
BEGIN
    INSERT into @returntable
    SELECT MABENHNHAN,HOTEN,NGAYSINH,CASE GIOITINH when 0 then 'NU' WHEN 1 THEN 'NAM' end as 'GIOITINH',TENKHOA,TENBV
	from	BV,BENHNHAN,KHOAKHAM
	where BV.MABV=KHOAKHAM.MABV AND KHOAKHAM.MAKHOA=BENHNHAN.MAKHOA AND @MABENHNHAN=MABENHNHAN
		
    RETURN 
END



select * from cau3('BN2')

----cau4-----


----cau5---

CREATE TRIGGER cau5
    ON BENHNHAN
    FOR  INSERT
    AS
    BEGIN
         declare @SOBN int;
		 select @SOBN=KHOAKHAM.SOBN from KHOAKHAM,inserted Where KHOAKHAM.MAKHOA=inserted.MAKHOA;
		 declare @SODT nvarchar(100);
		 select @SODT=BENHNHAN.SODT from BENHNHAN,inserted WHERE BENHNHAN.MABENHNHAN=inserted.MABENHNHAN;
		 IF((select ISNUMERIC(@SODT))=1 AND (LEN(@SODT)=10))
		 BEGIN
			UPDATE KHOAKHAM set SOBN=SOBN+1 from inserted,KHOAKHAM Where KHOAKHAM.MAKHOA=inserted.MAKHOA;

		 END
		 else
		 begin
			raiserror('LOI',16,1)
			rollback transaction
		 end
		 

    END
	if((select ISNUMERIC(123323))=1)
	Begin
		print('ok')
	end

	drop trigger cau5
select * from KHOAKHAM
select * from BENHNHAN

insert into BENHNHAN values('BN2','TENBN2','12-3-2001',1,'1234567891','K2')
insert into BENHNHAN values('BN3','TENBN3','12-3-2002',0,'1365655666','K2')
insert into BENHNHAN values('BN4','TENBN4','12-3-2003',1,'1455555556','K1')