create database ktra
use ktra

--Câu 1. Tạo cơ sở dữ liệu trên
create table KHACHHANG
(
	MaKH nvarchar(10) not null primary key,
	TenKH nvarchar(30),
	DiaChi nvarchar(30),
	SDT nvarchar(30)
)

create table NHANVIEN
(
	MaNV nvarchar(10) not null primary key,
	TenNV nvarchar(30),
	NgaySinh date,
	NgayVaoLam date,
	DiaChi nvarchar(30)
)

create table HANG
(
	MaHang nvarchar(10) not null primary key,
	TenHang nvarchar(30),
	SLCon int, 
	DGiaNhap float
)

create table DONDATHANG
(
	MaDDH nvarchar(10) not null primary key,
	MaKH nvarchar(10) not null foreign key references KHACHHANG(MaKH),
	MaNV nvarchar(10) not null foreign key references NHANVIEN(MaNV),
	NgayDat date,
	NgayGiao date,
	DiaChiGiao nvarchar(30),
	TPGiao nvarchar(30),
	TriGia float
)

create table CT_DonDatHang 
(
	MaDDH nvarchar(10) not null primary key,
	MaHang nvarchar(10) not null foreign key references HANG(MaHang),
	SL int,
	DGiaBan float
)

--Câu 2.Tạo hàm Fc_TLChietKhau nhận vào số lượng đặt và trả về tỷ lệ
--chiết khấu theo quy tắc như sau:

create function Fc_TLChietKhau (@SLDat int)
returns float
as
begin
	declare @tylechietkhau float

	if exists (select MaHang from CT_DonDatHang where SL >=50)
		begin
			set @tylechietkhau = 0.05
		end

	else if exists (select MaHang from CT_DonDatHang where SL >=30)
		begin
			set @tylechietkhau = 0.03
		end
	else 
		begin
			set @tylechietkhau = 0
		end
	return @tylechietkhau
end
--(
--	case
--		when exists (select SoLuong from ChiTietDatHang where SoLuong>@x) then (select SoLuong)
--	end
--	)
---            
--Nếu số lượng hàng đặt >=50 thì tỷ lệ chiết khấu
--là 5%
---            
--Nếu số lượng hàng đặt >=30 thì tỷ lệ chiết khấu
--là 3%
---            
--Ngược lại thì không chiết khấu

--Thêm vào bảng CT_DonDatHang cột
--có tên là TLChietKhau (tỷ lệ chiết khấu) có kiểu số Number(3,2) có giá trị mặc
--định là 0, ràng buộc giá trị từ 0 đến 1. Và sử dụng hàm Fc_TLChietKhau vừa tạo
--để cập nhật giá trị này.
ALTER TABLE CT_DonDatHang
ADD TLChietKhau float;

ALTER TABLE CT_DonDatHang
ADD  TLChietKhau float
DEFAULT 0

update CT_DonDatHang set TLChietKhau = dbo.Fc_TLChietKhau(SL)

--Viết Trigger để cập nhật trị giá của cột TriGia trong bảng DonDatHang, với trị giá của đơn hàng là tổng (Sluong*Dgia*(1-TLChietKhau)
create trigger onDDHT
on CT_DonDatHang
for update
as
begin
	declare @soluong int set @soluong=(select SL from inserted)

	declare @dongia float set @dongia=(select DGiaBan from inserted)

	declare @tyleck float set @tyleck=(select TLChietKhau from inserted)

	update DonDatHang set TriGia = (@soluong*@dongia*(1-@tyleck)
end