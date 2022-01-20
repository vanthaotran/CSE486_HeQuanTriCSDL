use ktraDuy
create table LOP
(
	MaLop nvarchar(10) primary key not null,
	TenLop nvarchar(30),
	Khoa nvarchar(10),
	HeDT nvarchar(10),
	NamNH date,
	SiSo int
)
insert into LOP values 
('L01','61TH1','61','dai hoc','2019',34),
('L02','61TH2','61','dai hoc','2019',35),
('L03','60TH3','60','dai hoc','2018',37),
('L04','61TH4','61','dai hoc','2019',31),
('L05','60TH8','60','dai hoc','2018',39)
create table SINHVIEN
(
	MaSV nvarchar(10) primary key not null,
	TenSV nvarchar(30),
	MaLop nvarchar(10) foreign key references LOP(MaLop) not null,
	GioiTinh nvarchar(10),
	DiaChi nvarchar(30)
)
insert into SINHVIEN values
('SV01','duy','L03','Nam','ha noi'),
('SV02','nam','L03','nu','ha nam'),
('SV03','hai','L02','nu','quang ninh'),
('SV04','dung','L01','Nam','thai binh'),
('SV05','hung','L05','Nam','ha noi')
create table HOCPHAN
(
	MaHP nvarchar(10) not null primary key,
	TenHP nvarchar(30),
	SoTC int,
	MaNganh nvarchar(10) not null,
	HocKi int
)
insert into HOCPHAN values
('HP01','Csharp',3,'CNTTT',3),
('HP02','csdl',3,'CNTTT',4),
('HP03','mysql',7,'kinh te',3),
('HP04','thiet ke he thong',3,'kinh te',4),
('HP05','cong nghe web',2,'CNTTT',3)
select * from HOCPHAN
create table DIEMHP
(
	MaSV nvarchar(10) not null  foreign key references SINHVIEN(MaSV),
	MaHP nvarchar(10) not null foreign key references HOCPHAN(MaHP),
	Diem float
)
insert into DIEMHP values
('SV01','HP02',9),
('SV02','HP01',8),
('SV03','HP03',9.5),
('SV04','HP05',10),
('SV05','HP04',7)

-- cau 2: tong hop thong tin ve cac sinh vien co diem trung binh cao nhat theo tung lop hoc
create view cau2 (masv, tensv, diem)
as
select SINHVIEN.MaSV, SINHVIEN.TenSV, max(Diem)
from SINHVIEN, DIEMHP
where SINHVIEN.MaSV = DIEMHP.MaSV
group by SINHVIEN.MaLop
drop view cau2
--
select SINHVIEN.MaSV, SINHVIEN.TenSV, Diem
from SINHVIEN, DIEMHP
where Diem=(select max(Diem) from DIEMHP where SINHVIEN.MaSV=DIEMHP.MaSV)
group by MaLop
-- 

alter table DiemHP
add DTB  float
select * from DIEMHP

select SINHVIEN.MaSV, TenSV, MaLop, max(Diem) as maxDiem from SINHVIEN, DIEMHP
where SINHVIEN.MaSV = DIEMHP.MaSV
group by MaLop, SINHVIEN.MaSV, TenSV






-- cau 3 
create function cau3 (@tenmon nvarchar(30))
returns @bang table (tensinhvien nvarchar(30))
as
begin
	insert into @bang
	select DIEMHP.MaSV from DIEMHP, HOCPHAN where DIEMHP.MaHP=HOCPHAN.MaHP and TenHP=@tenmon and Diem>7
	return
end 
select * from cau3 ('csdl')

-- cau 4 si so cua lop tuong ung trong lbang LOP tu dong giam xuong
create trigger triger_cau4 
on SINHVIEN
for delete
as
begin
	update LOP set SiSo=SiSo-1 where MaLop in (select MaLop from deleted)
end
drop trigger triger_cau4
delete from SINHVIEN where MaSV='SV03'

select * from LOP
select * from SINHVIEN
--ok ok

sp_helpconstraint 'DiemHP'alter table DiemHPdrop constraint FK__DIEMHP__MaSV__2A4B4B5E