create database BDS

create table Khach
(	
	MaKH nvarchar(10) not null primary key,
	TenKH nvarchar(30),
	ThanhPho nvarchar(30),
	SoDienThoai nvarchar(30)
)

insert into Khach values
('KH01', N'Vân', N'Hà Nội', '0943248433'),
('KH02', N'Khoa', N'Hà Nam', '093423423'),
('KH03', N'Phan', N'Quảng Ninh', '097332322'),
('KH04', N'Hương', N'Thái Bình', '034343432'),
('KH05', N'Lan', N'Tuyên Quang', '024387433')


create table Nha
(
	MaNha nvarchar(10) not null primary key,
	TenChuNha nvarchar(30),
	DiaChi nvarchar(30),
	GiaThue float
)

insert into Nha values
('MN01', N'Phương', N'Thái Bình', 3000000),
('MN02', N'Hùng', N'Hà Nam', 4000000),
('MN03', N'Hà', N'Thái Bình', 3500000),
('MN04', N'Thiện', N'Quảng Ninh', 3200000),
('MN05', N'Hiền', N'Hà Nam', 4500000)

create table HopDong
(
	SoHD nvarchar(10) not null primary key,
	MaKH nvarchar(10) not null foreign key references Khach(MaKH),
	MaNha nvarchar(10) not null foreign key references Nha(MaNha),
	NgayBatDau date,
	NgayKetThuc date
)

insert into HopDong values
('HD01', 'KH02', 'MN01', '2021-1-3', '2021-9-1'),
('HD02', 'KH01', 'MN05', '2019-1-5', '2020-12-24'),
('HD03', 'KH05', 'MN02', '2020-9-3', '2021-11-11'),
('HD04', 'KH03', 'MN04', '2020-12-1', '2021-11-12'),
('HD05', 'KH04', 'MN03', '2020-11-6', '2021-12-4')

--a. Cho biết danh sách khách hàng đã có ít nhất 2 lần làm hợp đồng
--thuê nhà
select TenKH from Khach
inner join HopDong
on HopDong.MaKH = Khach.MaKH
group by SoHD having count(*) >=2

select MaKH from HopDong
group by SoHD having count(*) >=2
 
--b. Hiển thị danh sách các nhà đang được thuê tính đến thời điểm hiện
--tại chưa đến hạn trả phòng
