-- bai 2
---------------------------------------a-------------------------------------------------
--a. Tạo CSDL QLKhachHang với:
-- File dữ liệu chính có kích thước 10MB, kích thước tối đa 50MB và mỗi lần mở rộng là 2MB.
-- File nhật ký có kích thước 5MB, kích thước cực đại là 20MB, đơn vị tang trưởng là 1MB.
-- Các file được lưu vào thư mục đã tạo.

create database QLKhachHang
on primary
	(Name = sinhvien,
	Filename = 'E:\HQTCSDL\TranThaoVan\khachhang.mdf',
	Size = 10 MB,
	MaxSize = 50 MB,
	FileGrowth = 2 MB
	)
log on
	(
	Name = sinhvienLog,
	Filename = 'E:\HQTCSDL\TranThaoVan\khachhangLog.ldf',
	Size = 5 MB,
	MaxSize = 20 MB,
	FileGrowth = 1 MB
	)


---------------------------------------b------------------------------------------------
--b.Thay đổi kích thước của file dữ liệu chính thành 15MB
alter database QLKhachHang
	modify file (name = khachhang, size = 15 MB)


---------------------------------------c-------------------------------------------------
--c.Hủy khả năng tăng trưởng của file nhật ký
alter database QLKhachHang
	modify file (name = khachhangLog, filegrowth = 0)


---------------------------------------d------------------------------------------------
--d.Giảm kích thước tập tin trong CSDL thành 5MB.
use QLKhachHang
	dbcc shrinkfile (name = khachhang, 5)


---------------------------------------e------------------------------------------------
--e.Thêm file dữ liệu phụ có kích thước 10MB, không giới hạn kích thước tối đa và kích thước tự
--tang trưởng là 5MB
alter database QLKhachHang
	add file
	(
		name = subFileNameKH,
		filename = 'E:\HQTCSDL\TranThaoVan\subFileNameKH.mdf',
		size = 10 MB,
		filegrowth = 5 MB
	)


---------------------------------------f-------------------------------------------------
--f. Xóa file file dữ liệu phụ của CSDL QuanLySinhVien -- ok
use QLKhachHang go
dbcc shrinkfile (
	subFileNameKH, emptyfile
) 
go
alter database QLKhachHang
	remove file subFileNameKH


---------------------------------------g------------------------------------------------
--g. Tạo một bản chụp CSDL
create database QLKhachHang_snapshot
on (
	name = QLKhachHangdata_snapshot,
	filename = 'E:\HQTCSDL\TranThaoVan\KhachHang_snapshot.snap'
	)
as snapshot of QLKhachHang


---------------------------------------h-------------------------------------------------
-- h. Thêm bảng KhachHang(IDKhachHang, HoTen, GioiTinh, DiaChi, Email, SoDienThoai) với
-- ID có kiểu dữ liệu int
-- Các trường khác có kiểu dữ liệu nvarchar
-- Thiết lập thuộc tính tự tăng trưởng cho IDKhachHang với giá trị khởi đầu là 1 và bước tăng 
-- trưởng là 1.
-- Thiết lập ràng buộc UNIQUE cho trường Email.
-- Thiết lập ràng buộc CHECK cho trường GioiTinh sao cho GioiTinh chỉ có thể nhận giá trị
-- ‘Nam’ hoặc ‘Nữ’
-- Thiết lập khóa chính cho bảng là trường IDKhachHang
-- Thiết lập ràng buộc bắt buộc khi nhập địa chỉ email phải có dấu @
-- Nhập ít nhất 5 dòng dữ liệu cho bảng KhachHang, trong đó có khách hàng tên Nguyễn Văn 
-- A
create table KhachHang (
	IDKhachHang int identity(1,1) primary key not null, 
	HoTen nvarchar, 
	GioiTinh nvarchar check (GioiTinh = 'Nam' or GioiTinh = 'Nữ'),
	DiaChi nvarchar, 
	Email nvarchar unique check (Email like '%@%'), 
	SoDienThoai nvarchar
)
--Nhập ít nhất 5 dòng dữ liệu cho bảng KhachHang, trong đó có khách hàng tên Nguyễn Văn A
-- đoạn này em chưa hiểu lắm ạ, em viết theo ý hiểu của em cô ạ.
-- cần global var @idKH_new
declare @idKH int
set @idKH = (select top 1 IDKhachHang from KhachHang order by IDKhachHang desc) -- end
declare @idKH_new int
set @idKH_new = @idKH + 1 -- end
create procedure  insertintoKH5rows
as
declare @i int = 1
while @i <=5
	begin
		insert KhachHang (IDKhachHang, HoTen, GioiTinh, DiaChi, Email, SoDienThoai) 
		values	
			(@idKH_new, N'Nguyễn Văn A', N'Nam', N'Hà Nội', 'hello@gmail.com', 093423424),
			(@idKH_new, N'Nguyễn B', N'Nữ', N'Hà Nam', 'hehehe@gmail.com', 0232132133),
			(@idKH_new, N'Nguyễn Văn C', N'Nam', N'Hải Phòng', 'xinchao1@gmail.com', 021323123),
			(@idKH_new, N'Nguyễn D', N'Nữ', N'Nam Định', 'maytinh@gmail.com', 0231243143),
			(@idKH_new, N'Nguyễn Văn E', N'Nam', N'Hà Nội', 'success@gmail.com', 03432432432)
		set @i = @i+1
	end
go
execute insertintoKH5rows
select * from KhachHang


---------------------------------------i-------------------------------------------------
--i. Thêm bảng SanPham(IdSanPham, TenSP, MoTa, DonGia) với:
-- ID có kiểu dữ liệu int
-- DonGia có kiểu dữ liệu float
-- Các trường khác có kiểu dữ liệu nvarchar.
-- Thiết lập thuộc tính tự tăng trưởng cho IDSanPham với giá trị khởi đầu là 1 và bước tăng 
-- trưởng là 1.
create table SanPham (
	IdSanPham int identity(1,1) not null, 
	TenSP nvarchar, 
	MoTa nvarchar, 
	DonGia float
)
-- Thiết lập ràng buộc UNIQUE cho trường TenSP bằng lệnh ALTER TABLE
alter table SanPham
add unique (TenSP)
-- Thiết lập khóa chính cho bảng là trường IDSanPham bằng lệnh ALTER TABLE
alter table SanPham
add primary key (IdSanPham)
-- Nhập ít nhất 5 dòng dữ liệu cho bảng SanPham
declare @idSP int
set @idSP = (select top 1 IdSanPham from SanPham order by IdSanPham desc) -- end
declare @idSP_new int
set @idSP_new = @idSP + 1 -- end
create procedure  insertinto_SP_5rows
as
declare @i int = 1
while @i <=5
	begin
		insert SanPham (IdSanPham, TenSP, MoTa, DonGia)
		values	
			(@idSP_new, N'Sữa Dialax', N'Sữa dành cho trẻ em', 34000),
			(@idSP_new, N'Sữa healthy', N'Dành cho người lớn', 54123),
			(@idSP_new, N'Sữa milo', N'Dành cho học sinh sinh viên', 534324),
			(@idSP_new, N'Sữa đậu nành', N'Dành cho bạn nữ', 867500),
			(@idSP_new, N'Sữa óc chó', N'Dành cho người muốn thông minh', 424234)
		set @i = @i+1
	end
go
execute insertinto_SP_5rows
select * from SanPham


---------------------------------------j-------------------------------------------------
--j. Thêm bảng DonHang(IDDonHang, IDKhachHang, NgayDatHang, TongTien)
-- NgayDatHang co kieu du lieu Date
-- TongTien có kiểu dữ liệu float
-- Khóa chính là IDDonHang
-- Các trường IDDonHang và IDKhachHang không được phép NULL
create table DonHang (
	IDDonHang int primary key not null, 
	IDKhachHang int not null, 
	NgayDatHang Date, 
	TongTien float
)
--Thiết lập khóa phụ cho IDKhachHang tham chiếu đến IDKhachHang của bảng KhachHang
--bằng lệnh ALTER TABLE
alter table DonHang
add foreign key (IDKhachHang) references KhachHang(IDKhachHang)
--Nhập ít nhất 5 dòng dữ liệu cho bảng DonHang trong đó có đơn hàng của khách hàng 
--Nguyễn Văn A, bỏ qua không nhập giá trị cho TongTien
declare @idDH_sub int
set @idDH_sub = (select top 1 IDDonHang from DonHang order by IDDonHang desc)
declare @idDH_sub_new int
set @idDH_sub_new = @idDH_sub + 1 --end
declare @idKH_sub int
set @idKH_sub = (select top 1 IDKhachHang from KhachHang order by IDKhachHang desc)
declare @idKH_sub_new int
set @idKH_sub_new = @idKH_sub + 1 --end
create procedure  insertintoDH5rows
as
declare @i int = 1
while @i <=5
	begin
		insert DonHang (IDDonHang, IDKhachHang, NgayDatHang, TongTien)
		values	
			(@idDH_sub_new, @idKH_sub_new, 2020-12-25, 12333),
			(@idDH_sub_new, @idKH_sub_new, 2020-1-8, 23213),
			(@idDH_sub_new, @idKH_sub_new, 2020-3-15, 7657445),
			(@idDH_sub_new, @idKH_sub_new, 2020-15-5, 957543),
			(@idDH_sub_new, @idKH_sub_new, 2020-3-2, 34234)
		set @i = @i+1
	end
go
execute insertintoDH5rows
select * from DonHang


---------------------------------------k-------------------------------------------------
--k. Thêm bảng SP_DonHang(IDDonHang, IDSanPham, SoLuong, ThanhTien)
-- SoLuong có kiểu dữ liệu int
-- ThanhTien có kiểu dữ liệu float
-- Khóa chính là (IDDonHang, IDSanPham)
-- Thiết lập ràng buộc mặc định cho SoLuong là 1
-- Thiết lập khóa phụ cho IDDonHang tham chiếu đến IDDonHang của bảng DonHang
-- Thiết lập khóa phụ cho IDSanPham tham chiếu đến IDSanPham của bảng SanPham
create table SP_DonHang (
	IDDonHang int not null foreign key (IDDonHang) references DonHang(IDDonHang), 
	IdSanPham int not null foreign key (IdSanPham) references SanPham(IdSanPham), 
	SoLuong int default 1, 
	ThanhTien float
)
-- Nhập ít nhất 10 dòng dữ liệu cho bảng SP_DonHang, bỏ qua không nhập giá trị cho 
--TongTien
-- var for idDH and idSP
declare @idDH_k int
set @idDH_k = (select top 1 IDDonHang from DonHang order by IDDonHang desc)
declare @idDH_k_new int
set @idDH_k_new = @idDH_k + 1 --end
declare @idSP_k int
set @idSP_k = (select top 1 IdSanPham from SanPham order by IdSanPham desc)
declare @idSP_k_new int
set @idSP_k_new = @idSP_k + 1 --end
create procedure  insertintoDH5rows
as
declare @i int = 1
while @i <=5
	begin
		insert DonHang (IDDonHang, IDKhachHang, NgayDatHang, TongTien)
		values	
			(@idDH_k_new, @idSP_k_new, 2020-12-25, 12333),
			(@idDH_k_new, @idSP_k_new, 2020-1-8, 23213),
			(@idDH_k_new, @idSP_k_new, 2020-3-15, 7657445),
			(@idDH_k_new, @idSP_k_new, 2020-15-5, 957543),
			(@idDH_k_new, @idSP_k_new, 2020-3-2, 34234)
		set @i = @i+1
	end
go
execute insertintoDH5rows
select * from DonHang


----------------------------------------------------------BÀI 3--------------------------
----------------------------------------------------------a--------------------------
--a. Cập nhật trường ThanhTien cho bảng SP_DonHang bằng SoLuong*DonGia

-- select so luong, don gia from
declare @soLuong int
set @soLuong = (select SoLuong from SP_DonHang)
-- select so luong, don gia from
declare @donGia float
set @donGia = (select DonGia from SanPham)
-- variable for ThanhTien
declare @idThanhTien int
set @idThanhTien = 0
set @idThanhTien = @soLuong *@donGia -- KQ THANH TIEN!!!

update SP_DonHang
set ThanhTien = @idThanhTien

-- bài chữa của Tuấn
update SP_DonHang
set ThanhTien = (SanPham.DonGia*SP_DonHang.SoLuong)
from SP_DonHang inner join SanPham
on SP_DonHang.IdSanPham = SanPham.IdSanPham
-- bài chữa của Tuấn

----------------------------------------------------------b-------------------------
--b. Cập nhật trường TongTien trong bảng DonGia bằng tổng Thành tiền của tất cả
--các sản phẩn trong đơn hàng, cô chữa!
update DonHang
set TongTien = 
(
	select sum(ThanhTien) from SP_DonHang
	where DonHang.IDDonHang = SP_DonHang.IDDonHang
)

----------------------------------------------------------c------------------------------
--c. Viết câu lệnh trích ra phần tên khách hàng từ trường HoTen

declare @nameKH nvarchar 
set @nameKH = (select HoTen from KhachHang )

select 
--substring (@nameKH, 1, CHARINDEX(' ', @nameKH) + 1, len(@nameKH)) as nameKH
SUBSTRING(@nameKH, CHARINDEX(' ', @nameKH) + 1, len(@nameKH)) AS nameKH
from KhachHang 

-- bài chữa của Tuấn
select HoTen, RIGHT(KhachHang.HoTen, CHARINDEX(' ', reverse(KhachHang.HoTen)) - 1)
as TenKH from KhachHang
-- bài chữa của Tuấn

----------------------------------------------------------d------------------------------
--d. Viết câu lệnh trả về thông tin các đơn hàng của khách hàng có tên là ‘Nguyễn Văn A’.
select HoTen, TenSP, DonGia, SoLuong, NgayDatHang, ThanhTien 
from SanPham , DonHang, SP_DonHang, KhachHang 
where 
	KhachHang.IDKhachHang = DonHang.IDKhachHang and DonHang.IDDonHang = SP_DonHang.IDDonHang
	and SanPham.IdSanPham = SP_DonHang.IdSanPham and
	KhachHang.HoTen = N'Nguyễn Văn A'

----------------------------------------------------------e-----------------------------
--e. Viết câu lệnh trả về tổng số tiền mà khách hàng ‘Nguyễn Văn A’ đã trả cho tất cả các đơn hàng
select sum(DonHang.TongTien) as TongSoTien
from DonHang
where IDKhachHang = (select KhachHang.IDKhachHang from KhachHang
					where KhachHang.Hoten = N'Nguyễn Văn A'
					)


-- tên đệm ----
select HoTen,
	left (HoTen, charindex(' ', ltrim(HoTen))-1) as Ho, 
	substring (
				HoTen, 
				charindex (' ', HoTen)+1,
				len(HoTen)-charindex(' ', ltrim(HoTen))-charindex(' ', reverse(rtrim(HoTen)))
	) as TenDem,
	right(HoTen, charindex (' ', reverse(HoTen)))-1) as TenKH
from KhachHang