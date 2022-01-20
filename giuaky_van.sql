create database kiemtraGK_van
use kiemtraGK_van
-- ĐÈ 27
create table KHACHHANG
(
	MaCT nvarchar(10) not null primary key,
	TenCT nvarchar(30),
	DiaChi nvarchar(30),
	DienThoai nvarchar(30)
)
select * from KHACHHANG
insert into KHACHHANG values
('KH01','van','ha noi','034234324'),
('KH02','hai','ha nam','03243243'),
('KH03','nam','quang ninh','0546346'),
('KH04','vu','vinh phuc','021314314'),
('KH05','tuan','thai binh','04324')
--------------------------------------------------------------------------
create table VATTU
(
	MaVatTu nvarchar(10) not null primary key,
	TenVatTu nvarchar(30),
	DVT nvarchar(30),
	SLCon int
)
select * from VATTU
insert into VATTU values
('VT01','xi mang','bao', 200),
('VT02','cat','kg', 500),
('VT03','dinh','tui', 200),
('VT04','oc','tui', 200),
('VT05','gach','vien', 2000)
--------------------------------------------------------------------------
create table DonDatHang
(
	SoHD nvarchar(10) not null primary key,
	MaCT nvarchar(10) not null foreign key references KHACHHANG(MaCT),
	NgayHD date,
	TongTien float
)
select * from DonDatHang
insert into DonDatHang values
('HD01','KH02','2021-10-10',0),
('HD02','KH01','2021-12-10',0),
('HD03','KH03','2021-9-10',0),
('HD04','KH04','2021-11-10',0)
--------------------------------------------------------------------------
create table ChiTietDonDH
(
	SoHD nvarchar(10) not null foreign key references DonDatHang(SoHD),
	MaVatTu nvarchar(10) not null foreign key references VATTU(MaVatTu),
	SLDat int,
	DonGia float
)
select * from ChiTietDonDH
insert into ChiTietDonDH values
('HD01','VT02',10,100000),
('HD02','VT05',100,5000),
('HD03','VT04',20,50000),
('HD04','VT01',50,300000)
--2/ Tạo view hiển thị thông tin về các vật tư mà chưa được công ty nào đặt hàng trong năm
--2021.
select * from VATTU
select * from DonDatHang
select * from ChiTietDonDH
create view v_cau2 as
select VATTU.MaVatTu, TenVatTu, DVT from VATTU, DonDatHang, ChiTietDonDH
where not exists (select MaVatTu from ChiTietDonDH) and year(NgayHD)=2021 
select * from v_cau2
--2/ Tạo view hiển thị thông tin tổng hợp thống kê tổng số lượng đặt của từng vật tư theo
--từng tháng trong năm 2021.
create view v_c2 as
select ChiTietDonDH.MaVatTu, sum(ChiTietDonDH.SLDat) as TongSLDat, month(NgayHD) as Thang from VATTU, ChiTietDonDH, DonDatHang
where VATTU.MaVatTu=ChiTietDonDH.MaVatTu and DonDatHang.SoHD =  ChiTietDonDH.SoHD
group by month(NgayHD), ChiTietDonDH.MaVatTu, SLDat

--3/ Tạo thủ tục có tham số vào là @ngay để đưa ra danh sách các vật tư đã được đặt trong
--ngay (Danh sách đưa ra gồm các thuộc tính sau: MaVatTu, TenVatTu, TongSL, SoTien
--với SoTien là tổng tiền thu được của từng loại vật tư.
create proc p_cau3 (@ngay date)
as
begin
	select VATTU.MaVatTu, TenVatTu, sum(SLDat) as TongSL, (SLDat*DonGia) as SoTien from VATTU, ChiTietDonDH, DonDatHang
	where VATTU.MaVatTu = ChiTietDonDH.MaVatTu and ChiTietDonDH.SoHD = DonDatHang.SoHD and NgayHD=@ngay --
	group by VATTU.MaVatTu, TenVatTu, SLDat, DonGia
end
p_cau3 '2021-10-10' --
--4/ Viết 1 trigger sao cho khi thêm 1 dòng dữ liệu vào bảng ChiTietDonDH phải kiểm tra số lượng
--tồn kho có lớn hơn số lượng đặt không, nếu lớn hơn thì cho đặt hàng còn không thì đưa ra thông
--báo và cập nhật lại số lượng tồn kho khi trừ đi số lượng đặt hàng.
create trigger t_cau4
on ChiTietDonDH
for insert 
as
begin
	declare @slDat int
	select @slDat =(select SLDat from inserted)

	declare @slTonKho int
	select @slTonKho =(select SLCon from VATTU, inserted where VATTU.MaVatTu = inserted.MaVatTu)

	if @slDat > @slTonKho
		begin
			raiserror (N'Số lượng đạt lớn hơn số lượng tồn kho!',16,1)
			rollback transaction -- 
		end
	else
		begin 
			update VATTU set SLCon=SLCon-@slDat from VATTU inner join inserted on VATTU.MaVatTu = inserted.MaVatTu 
			where VATTU.MaVatTu=inserted.MaVatTu
		end
	
end
insert into ChiTietDonDH values ('HD100','VT01',500,10000)
insert into ChiTietDonDH values ('HD101','VT01',5,10000)
alter table ChiTietDonDH
drop constraint FK__ChiTietDon__SoHD__2A4B4B5E