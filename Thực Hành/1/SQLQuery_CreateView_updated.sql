create database QLCuaHang

create table KhachHang 
(	
	MaKhachHang nvarchar(10) not null primary key,
	TenCongTy nvarchar(30),
	TenGiaoDich nvarchar(30),
	DiaChi nvarchar(30),
	Email nvarchar(30),
	DienThoai nvarchar(30),
	Fax nvarchar(30)
)
insert into KhachHang values
('KH01', 'ABC', N'Bánh Gấu', N'Hà Nội', N'vietnam@gmail.com', '09432233322', '094322'),
('KH02', 'OneThousand', N'Kẹo mút Chuppachup', N'Hà Nam', N'onethousand@gmail.com', '058383283', '05838'),
('KH03', 'Love In', N'Bánh gạo', N'Hải Phòng', N'ovein@gmail.com', '03248457383', '032484'),
('KH04', 'Notebook', N'Bỏng ngô', N'Thái Bình', N'notebook20@gmail.com', '02439852395', '024398'),
('KH05', 'Water Blank', N'Nước khoáng', N'Nam Định', N'waterblank@gmail.com', '07543858343', '075438'),
('KH06', 'Monitor Ok', N'Kẹo cao su ', N'Hà Nội', N'monitorok@gmail.com', '01243583243', '012435'), 
('KH07', 'Dinology On', N'Gia vị bếp', N'Hà Nội', N'dinology@gmail.com', '06539853926', '065398'), 
('KH08', 'Fruit In', N'Đường', N'Tuyên Quang', N'fruitin@gmail.com', '0439583923', '043958'), 
('KH09', 'Restaurant Yummy', N'Giấy ăn', N'Hà Nội', N'restaurantyummy@gmail.com', '05439583457', '054395'), 
('KH010', 'Calculator', N'Máy tính cầm tay', N'Hà Nội', N'alculator@gmail.com', '0342394343', '034239')

create table NhaCungCap 
(
	MaCongTy nvarchar(10) not null primary key,
	TenCongTy nvarchar(30),
	TenGiaoDich nvarchar(30),
	DiaChi nvarchar(30),
	DienThoai nvarchar(30),
	Fax nvarchar(30),
	Email nvarchar(30)
)
insert into NhaCungCap values
('CT01', 'Dinology On', N'Gia vị bếp', N'Hà Nội', '06539853926', '065398', 'dinology@gmail.com'),
('CT02', 'Fruit In', N'Đường', N'Tuyên Quang', '0439583923', '043958', 'fruitin@gmail.com'),
('CT03', 'Water Blank', N'Nước khoáng', N'Nam Định', '07543858343', '075438', 'waterblank@gmail.com'),
('CT04', 'Monitor Ok', N'Kẹo cao su', N'Hà Nội', '01243583243', '012435', 'monitorok@gmail.com'),
('CT05', 'Restaurant Yummy', N'Giấy ăn', N'Hà Nội', '05439583457', '054395', 'restaurantyummy@gmail.com'),
('CT06', 'Calculator', N'Máy tính cầm tay', N'Hà Nội', '0342394343', '034239', 'alculator@gmail.com'),
('CT07', 'Notebook', N'Bỏng ngô', N'Thái Bình', '02439852395', '024398', 'notebook20@gmail.com'),
('CT08', 'Love In', N'Bánh gạo', N'Hải Phòng', '03248457383', '032484', 'ovein@gmail.com'),
('CT09', 'ABC', N'Bánh Gấu', N'Hà Nội', '09432233322', '065398', 'vietnam@gmail.com'),
('CT010', 'OneThousand', N'Kẹo mút Chuppachup', N'Hà Nam', '058383283', '05838', 'onethousand@gmail.com')




create table MatHang
(
	MaHang nvarchar(10) not null primary key,
	TenHang nvarchar(30),
	MaCongTy nvarchar(10),
	MaLoaiHang nvarchar(10) not null,
	SoLuong int,
	DonViTinh float,
	GiaHang float
)

drop table MatHang

insert into MatHang values
('MH01', N'Kẹo mút Chuppachup', 'CT010', 'LH01', 10, 1000, 10000),
('MH02', N'Bánh Gấu', 'CT09', 'LH03', 100, 20000, 2000000),
('MH03', N'Bánh gạo', 'CT08', 'LH05', 50, 25000, 1250000),
('MH04', N'Bỏng ngô', 'CT07', 'LH07', 10, 15000, 150000),
('MH05', N'Máy tính cầm tay', 'CT06', 'LH09', 100, 550000, 55000000),
('MH06', N'Giấy ăn', 'CT05', 'LH010', 15, 20000, 300000),
('MH07', N'Kẹo cao su', 'CT04', 'LH02', 200, 1000, 200000),
('MH08', N'Nước khoáng', 'CT03', 'LH04', 100, 5000, 500000),
('MH09', N'Đường', 'CT02', 'LH06', 50, 18000, 900000),
('MH010', N'Gia vị bếp', 'CT01', 'LH08', 1000, 2000, 2000000)




create table DonDatHang
(
	SoHoaDon nvarchar(10) not null primary key,
	MaKhachHang nvarchar(10) not null,
	MaNhanVien nvarchar(10) not null,
	NgayDatHang date,
	NgayGiaoHang date,
	NgayChuyenHang date,
	NoiGiaoHang nvarchar(30)
)

insert into DonDatHang values
('HD01', 'KH01', 'NV02', '2020-12-25', '2021-12-29', '2021-1-2', N'Hà Nội'),
('HD02', 'KH03', 'NV04', '2020-3-25', '2021-3-26', '2021-1-2', N'Hải Phòng'),
('HD03', 'KH05', 'NV06', '2021-1-26', '2021-2-1', '2021-2-6', N'Nam Định'),
('HD04', 'KH07', 'NV08', '2021-2-2', '2021-2-4', '2021-1-8', N'Hà Nội'),
('HD05', 'KH09', 'NV010', '2021-3-6', '2021-3-7','2021-3-9', N'Hà Nội'),
('HD06', 'KH02', 'NV01', '2021-3-7', '2021-3-9', '2021-3-10', N'Hà Nam'),
('HD07', 'KH04', 'NV03', '2021-4-8', '2021-4-9', '2021-4-10', N'Thái Bình'),
('HD08', 'KH06', 'NV05', '2021-4-29', '2021-5-1', '2021-5-2', N'Hà Nội'),
('HD09', 'KH08', 'NV07', '2021-5-25', '2021-5-29', '2021-6-2', N'Tuyên Quang'),
('HD010', 'KH010', 'NV09', '2021-8-25', '2021-8-26', '2021-8-27', N'Hà Nội')


create table ChiTietDatHang
(
	SoHoaDon nvarchar(10) not null,
	MaHang nvarchar(10) not null,
	GiaBan float,
	SoLuong int,
	MucGiamGia float
)
insert into ChiTietDatHang values
('HD01', 'MH01', 1000, 10, 0),
('HD03', 'MH02', 20000, 100, 0),
('HD05', 'MH03', 25000, 50, 0),
('HD07', 'MH04', 15000, 10, 0),
('HD09', 'MH05', 550000, 100, 0),
('HD02', 'MH06', 20000, 15, 0),
('HD04', 'MH07', 1000, 200, 0),
('HD06', 'MH08', 5000, 100, 0),
('HD08', 'MH09', 18000, 50, 0),
('HD010', 'MH010', 2000, 1000, 0)


create table LoaiHang
(
	MaLoaiHang nvarchar(10) not null primary key,
	TenLoaiHang nvarchar(30)
)
insert into LoaiHang values
	('LH01', N'Đồ ăn'),
	('LH02', N'Đồ ăn'),
	('LH03', N'Đồ ăn'),
	('LH04', N'Đồ ăn'),
	('LH05', N'Học tập'),
	('LH06', N'Gia Dụng'),
	('LH07', N'Đồ ăn'),
	('LH08', N'Thiết yếu'),
	('LH09', N'Gia Dụng'),
	('LH010', N'Gia Dụng')

create table NhanVien 
(
	MaNhanVien nvarchar(10) not null primary key,
	Ho nvarchar(30),
	Ten nvarchar(30),
	NgaySinh date,
	NgayLamViec date,
	DiaChi nvarchar(30),
	DienThoai nvarchar(30),
	LuongCoBan float,
	PhuCap float
)
insert into NhanVien values
('NV01', N'Lê', N'Hoa', '2001-12-2', '2020-2-4', N'Hà Nội', '0994242322', 1000000, 100000),
('NV02', N'Trần', N'Loan', '2001-1-25', '2020-1-5', N'Hà Nam', '0994242322', 2000000, 200000),
('NV03', N'Đinh', N'Hạ', '2001-2-2', '2020-3-1', N'Hải Phòng', '0994242322', 3000000, 300000),
('NV04', N'Nông', N'Bình', '2001-3-5', '2020-1-3', N'Thái Bình', '0994242322', 5000000, 400000),
('NV05', N'Thái', N'Hùng', '2001-5-2', '2020-2-1', N'Quảng Ninh', '0994242322', 7000000, 600000),
('NV06', N'Phạm', N'Phương', '2001-8-9', '2020-1-25', N'Hà Nội', '0994242322', 1500000, 100000),
('NV07', N'Nguyễn', N'Vân', '2001-12-1', '2020-1-10', N'Hưng Yên', '0994242322', 1600000, 50000),
('NV08', N'Trần', N'Nhung', '2001-9-9', '2020-1-15', N'Hải Dương', '0994242322', 2100000, 100000),
('NV09', N'Lê', N'Lan', '2001-4-21', '2020-1-7', N'Tuyên Quang', '0994242322', 1000000, 200000),
('NV010', N'Nguyễn', N'Hương', '2001-12-29', '2020-1-9', N'Hòa Bình', '0994242322', 3100000, 100000)


/*khoa ngoai CHITIETDATHANG (MAHANG) -> MATHANG (MAHANG)*/
ALTER TABLE ChiTietDatHang 
ADD CONSTRAINT fk_htk_MaHang
	FOREIGN KEY (MaHang)
	REFERENCES MatHang(MaHang)

/*khoa ngoai MAHANG (MALOAIHANG) -> LOAIHANG (MALOAIHANG)
em viết thiếu chữ T ở bảng mặt hàng ạ! [[[[[not yett]]]]]!!!
*/ 
ALTER TABLE MatHang
ADD CONSTRAINT fk_htk_MaLoaiHang
	FOREIGN KEY (MaLoaiHang)
	REFERENCES LoaiHang(MaLoaiHang)

/*khoa ngoai MATHANG (MACONGTY) -> NHACUNGCAP (MACONGTY)*/
ALTER TABLE MatHang
ADD CONSTRAINT fk_htk_MaCongTy
	FOREIGN KEY (MaCongTy)
	REFERENCES NhaCungCap(MaCongTy)



/*bai1_tao view_MatHang
tạo view_MatHang(MaHang, TenHang, MaCongTy,
TenCongTyCungCap, MaLoaiHang, TenLoaiHang, SoLuong, DonViTinh,
GiaHang)
*/
CREATE VIEW view_MatHang
AS
	SELECT MatHang.MaHang, MatHang.TenHang, MatHang.MaCongTy, NhaCungCap.TenCongTy, 
	MatHang.MaLoaiHang, LoaiHang.TenLoaiHang, MatHang.SoLuong, MatHang.DonViTinh,
	MatHang.GiaHang
	FROM MatHang, NhaCungCap, LoaiHang
	WHERE MatHang.MaLoaiHang = LoaiHang.MaLoaiHang AND 
	MatHang.MaCongTy = NhaCungCap.MaCongTy

/*bai2_tao view_MatHang
Tạo view View_DonDatHang (SoHoaDon, MaKhachHang,
TenCongTyKhachHang, HoVaTenNhanVien, NgayDatHang, NgayGiaoHang,
NgayChuyenHang, NoiGiaoHang, MaHang, TenHang, SoLuong, GiaBan,
MucGiamGia)
*/
CREATE VIEW view_DonDatHang 
AS
	SELECT DonDatHang.SoHoaDon, DonDatHang.MaKhachHang, KhachHang.TenCongTy, NhanVien.Ho, NhanVien.Ten, 
	DonDatHang.NgayDatHang, DonDatHang.NgayGiaoHang, DonDatHang.NgayChuyenHang, DonDatHang.NoiGiaoHang, 
	MatHang.MaHang, MatHang.TenHang, ChiTietDatHang.GiaBan, ChiTietDatHang.MucGiamGia
	FROM DonDatHang, KhachHang, NhanVien, MatHang, ChiTietDatHang
	WHERE DonDatHang.MaKhachHang = KhachHang.MaKhachHang AND NhanVien.MaNhanVien = DonDatHang.MaNhanVien
	AND ChiTietDatHang.MaHang = MatHang.MaHang


--Thử xem có thể cập nhật, thêm, sửa, xóa dữ liệu qua các view đã tạo không.
select * from view_DonDatHang



