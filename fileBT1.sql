--Bai 1
--a.Tạo CSDL QuanLySinhVien với:
--File dữ liệu chính có kích thước 10MB, kích thước tối đa 50MB và mỗi lần mở rộng là 2MB.
--File nhật ký có kích thước 5MB, kích thước cực đại là 20MB, đơn vị tang trưởng là 1MB.
--Các file được lưu vào thư mục đã tạo.
create database QuanLySinhVien
on primary
	(Name = sinhvien,
	Filename = 'E:\HQTCSDL\TranThaoVan\sinhvien.mdf',
	Size = 10 MB,
	MaxSize = 50 MB,
	FileGrowth = 2 MB
	)
log on
	(
	Name = sinhvienLog,
	Filename = 'E:\HQTCSDL\TranThaoVan\sinhvienLog.ldf',
	Size = 5 MB,
	MaxSize = 20 MB,
	FileGrowth = 1 MB
	)
--b.Thay đổi kích thước của file dữ liệu chính thành 15MB
alter database QuanLySinhVien
	modify file (name = sinhvien, size = 15 MB)

--c.Hủy khả năng tăng trưởng của file nhật ký
alter database QuanLySinhVien
	modify file (name = sinhvienLog, filegrowth = 0)

--d.Giảm kích thước tập tin trong CSDL thành 5MB.
use QuanLySinhVien
	dbcc shrinkfile (name = sinhvien, 5)

--e.Thêm file dữ liệu phụ có kích thước 10MB, không giới hạn kích thước tối đa và kích thước tự
--tang trưởng là 5MB
alter database QuanLySinhVien
	add file
	(
		name = subFileName,
		filename = 'E:\HQTCSDL\TranThaoVan\subFileName.mdf',
		size = 10 MB,
		filegrowth = 5 MB
	)

--f. Xóa file file dữ liệu phụ của CSDL QuanLySinhVien
use QuanLySinhVien go
dbcc shrinkfile (
	subFileName, emptyfile
)
go
alter database QuanLySinhVien
	remove file subFileName

--g. Thêm bảng SInhVien(ID, MaSV, HoTen, NgaySinh, GioiTinh, DiaChi, Email) với
-- ID có kiểu dữ liệu int
-- NgaySinh có kiểu dữ liệu data
-- MaSV có kiểu dữ liệu char(10)
-- Các trường khác có kiểu dữ liệu nvarchar
-- Thiết lập thuộc tính tự tăng trưởng cho ID với giá trị khởi đầu là 1 và bước tăng trưởng 
--1.
-- Thiết lập ràng buộc UNIQUE cho trường MaSV
-- Thiết lập ràng buộc UNIQUE cho trường Email.
-- Thiết lập ràng buộc CHECK cho trường GioiTinh sao cho GioiTinh chỉ có thể nhận giá trị
--‘Nam’ hoặc ‘Nữ’
-- Thiết lập khóa chính cho bảng là trường ID
-- Nhập ít nhất 5 dòng dữ liệu cho bảng SinhVien

create table student (
	ID int identity(1,1) primary key,
	MaSV char(10) not null unique,
	HoTen nvarchar,
	NgaySinh datetime,
	GioiTinh nvarchar check (GioiTinh = 'Nam' or GioiTinh = 'Nữ'),
	DiaChi nvarchar,
	Email nvarchar unique
)

go
create procedure  insert5rowsSV
as
declare @i int = 1
while @i <=5
	begin
		declare @id int
		set @id = (select top 1 ID from student order by ID desc) -- end
		declare @id_new int
		set @id_new = @id + 1 -- end
		insert student (ID,MaSV,HoTen,NgaySinh,GioiTinh,DiaChi,Email) 
		values	
			(@id_new, '1A', N'Trần Thảo Vân', 2001-12-25,N'Nữ', N'Hà Nội', 'thaovannihong@gmail.com'),
			(@id_new, '2A', N'Nguyễn Thị A', 2000-1-5, N'Nữ', N'Hà Nam', 'thuyloi123@gmail.com'),
			(@id_new, '3A', N'Phạm Hải A', 2000-3-2, N'Nam', N'Hải Phòng', 'tlugraduate@gmail.com'),
			(@id_new, '4A', N'Lê Hân B', 2001-11-10, N'Nam', N'Hà Tiên', 'happday@gmail.com'),
			(@id_new, '5A', N'Hải Thị Trâm', 2001-5-7, N'Nữ', N'Hà Nội', 'trybest@gmail.com')
		set @i = @i+1
	end
execute insert5rowsSV
select * from student
go

--h. Thêm bảng MonHoc(Id, MaMon, TenMon, MoTa) với:
-- ID có kiểu dữ liệu int
-- Các trường khác có kiểu dữ liệu nvarchar.
-- Thiết lập thuộc tính tự tăng trưởng cho ID với giá trị khởi đầu là 1 và bước tăng trưởng là 
--1.
-- Thiết lập ràng buộc UNIQUE cho trường MaMon
-- Thiết lập ràng buộc UNIQUE cho trường TenMon
-- Thiết lập khóa chính cho bảng là trường ID
-- Nhập ít nhất 5 dòng dữ liệu cho bảng MonHo

create table monhoc (
	ID int identity(1,1) primary key,
	MaMon nvarchar not null unique,
	TenMon nvarchar unique,
	MoTa nvarchar
)
declare @idMH int
set @idMH = (select top 1 ID from student order by ID desc) -- end
declare @id_MH_new int
set @id_MH_new = @idMH + 1 -- end
create procedure  insert5rowsMH
as
declare @i int = 1
while @i <=5
	begin
		insert monhoc (ID,MaMon,TenMon,MoTa) 
		values	
			(@id_MH_new, '12E', N'Triết học', N'Chủ nghĩa xã hội...'),
			(@id_MH_new, '13E', N'Công nghệ web', N'Code websites'),
			(@id_MH_new, '14E', N'Phân tích thiết kế', N'Hệ thống thông tin'),
			(@id_MH_new, '15E', N'Giáo dục thể chất', N'Bay'),
			(@id_MH_new, '16E', N'Hệ điều hành', N'Window')
		set @i = @i+1
	end
go
execute insert5rowsMH
select * from monhoc

-- i.Thêm bảng KetQua(IDSV, IDMon, Diem)
-- Khóa chính là (IDSV, IDMon)
-- Thiết lập khóa phụ cho IDSV tham chiếu đên ID của bảng SinhVien
-- Thiết lập khóa phụ cho IDMon tham chiếu đến ID của bảng MonHoc
-- Nhập ít nhất 10 dòng dữ liệu cho bảng KetQua
create table ketqua (
	IDSV int not null foreign key (IDSV) references sv(ID),
	IDMon int not null foreign key (IDMon) references monhoc(ID),
	Diem float
)
declare @idSV_KQ int
set @idSV_KQ = (select top 1 ID from student order by ID desc) -- end
declare @idSV_KQ_new int
set @idSV_KQ_new = @idSV_KQ + 1 -- end

declare @idMH_KQ int
set @idMH_KQ = (select top 1 ID from student order by ID desc) -- end
declare @idMH_KQ_new int
set @idMH_KQ_new = @idMH_KQ + 1 -- end

create procedure  insert10rowsKQ
as
declare @i int = 1
while @i <=10
	begin
		insert ketqua (IDSV, IDMon, Diem)
		values	
			(@idSV_KQ_new, @idMH_KQ_new, 9),
			(@idSV_KQ_new, @idMH_KQ_new, 9),
			(@idSV_KQ_new, @idMH_KQ_new, 7),
			(@idSV_KQ_new, @idMH_KQ_new, 6),
			(@idSV_KQ_new, @idMH_KQ_new, 4),
			(@idSV_KQ_new, @idMH_KQ_new, 8),
			(@idSV_KQ_new, @idMH_KQ_new, 10),
			(@idSV_KQ_new, @idMH_KQ_new, 5),
			(@idSV_KQ_new, @idMH_KQ_new, 7),
			(@idSV_KQ_new, @idMH_KQ_new, 9)
		set @i = @i+1
	end
go
execute insert10rowsKQ
select * from ketqua