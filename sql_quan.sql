create database sql_quan
use sql_quan

create table DMKhach
(
	MaKhach nvarchar(10) primary key not null,
	TenKhach nvarchar(30),
	DiaChi nvarchar(30),
	DienThoai nvarchar(30)
)
insert into DMKhach values
('KH01','van','hanoi','043053223'),
('KH02','nam','hanam','03423434'),
('KH03','hai','quanninh','03242343'),
('KH04','hung','thaibinh','09594534'),
('KH05','trang','namdinh','035435234')
create table DMHang
(
	MaHang nvarchar(10) not null primary key,
	TenHang nvarchar(30),
	DVT nvarchar(10)
)
insert into DMHang values 
('MH01','bimbim','goi'),
('MH02','thach','tui'),
('MH03','chan','cai'),
('MH04','bim','tui'),
('MH05','bat dua','combo')
create table HoaDonBan
(
	SoHD nvarchar(10) not null primary key,
	MaKhach nvarchar(10) not null foreign key references DMKhach(MaKhach),
	NgayHD date,
	TongTien float
)
insert into HoaDonBan values
('HD01','KH02','2021-12-2',0),
('HD02','KH01','2021-11-2',0),
('HD03','KH03','2021-12-6',0),
('HD04','KH04','2021-11-9',0),
('HD05','KH05','2021-10-2',0)
create table ChiTietHoaDon
(
	SoHD nvarchar(10) not null foreign key references HoaDonBan(SoHD),
	MaHang nvarchar(10) not null foreign key references DMHang(MaHang),
	SoLuong int,
	DonGia float
)
insert into ChiTietHoaDon values
('HD01','MH02',2,120000),
('HD02','MH03',4,123232),
('HD03','MH04',3,2132131),
('HD04','MH01',8,12323),
('HD05','MH02',12,254533)

update HoaDonBan set TongTien = ChiTietHoaDon.SoLuong*ChiTietHoaDon.DonGia from ChiTietHoaDon where ChiTietHoaDon.SoHD = HoaDonBan.SoHD
select * from HoaDonBan

-- cau 2: tạo view tổng hợp dữ liệu vê từng mặt hàng đã được bán: ma hang, ten hang, dvt, soluongban
create view cau2_daban as
select * from DMHang where MaHang in(select MaHang from ChiTietHoaDon)

-- khác
select DMHang.MaHang, TenHang, DVT, sum(SoLuong) as tongluonghang from DMHang, ChiTietHoaDon where DMHang.MaHang = ChiTietHoaDon.MaHang
group by DMHang.MaHang, TenHang, DVT

--Tạo View để tổng hợp dữ liệu về các mặt hàng mà có mua từ 2 lần trở lên.
SELECT MaHang, TenHang, DVT FROM DMHang
where MaHang in ((select MaHang from ChiTietHoaDon group by MaHang having count(MaHang)>2))
select * from DMHang
select * from ChiTietHoaDon
select count(MaHang) as solan, MaHang from ChiTietHoaDon group by MaHang having count(MaHang) > 2 

-- cau3: tạo thủ tục có tham số vào là @sohd để đưa ra danh mục các mặt hàng có trong hóa đơn trên
create proc cau3 @sohd nvarchar(10)
as
begin
	select SoHD, DMHang.MaHang, TenHang, DVT from DMHang, ChiTietHoaDon
	where DMHang.MaHang = ChiTietHoaDon.MaHang and SoHD = @sohd
end
cau3 'HD01'
--Tạo hàm có tham số vào là @Thang để đưa ra doanh thu của từng mặt hàng có trong 
--tháng (Danh sách đưa ra gồm các thuộc tính sau: MaHang, TenHang, DoanhThu).
create function cau3_f (@Thang as int) -- truyền vào 1 tháng
returns @bang table (mahang nvarchar(10), tenhang nvarchar(30), doanhthu float)
as
begin
	insert into @bang
	select DMHang.MaHang, TenHang, (SoLuong*DonGia) as DoanhThu from DMHang, ChiTietHoaDon, HoaDonBan
	where DMHang.MaHang = ChiTietHoaDon.MaHang and HoaDonBan.SoHD = ChiTietHoaDon.SoHD and month(NgayHD) = @Thang
	group by DMHang.MaHang, TenHang, SoLuong, DonGia
	return 
end
select * from cau3_f(11)

-- 4 / Tạo TRIGGER DELETE trên bảng DMHang sao cho khi xóa một mặt hàng thì trigger 
--phải kiểm tra sự tồn tại của các MaHang có liên quan trên bảng ChiTietHoaDon. Khi đó, 
--nếu MaHang có tồn tại trong bảng ChiTietHoaDon thì thông báo không thể xóa được. 
--Ngược lại, thì thông báo đã xóa mặt hàng đó rồi
create trigger cau4
on DMHang
for delete
as 
begin
	if exists (select deleted.MaHang from deleted inner join ChiTietHoaDon on ChiTietHoaDon.MaHang = deleted.MaHang)
		begin
			raiserror ('khong the xoa duoc',16,1)
		end
	else
		begin
			print 'da xoa mat hang'
		end
end

drop trigger cau4
delete from DMHang where MaHang='MH04' -- nhưng nó vẫn làm vẫn xóa
select * from DMHang

-- drop constraint đi để chạy được


FK__ChiTietHo__MaHan__2B3F6F97

sp_helpconstraint 'ChiTietHoaDon'

alter table ChiTietHoaDon
drop constraint FK__ChiTietHo__MaHan__2B3F6F97



-- tạo trigger kiểm tra khi nhập dữ liệu vào bảng chitiethoadon
-- nếu SL hoặc đơn giá nhập vào nhỏ hơn 0 thì in ra lỗi dữ liệu nhập vào k đúng và k cho phép nhập
-- ngược lại thì in ra thông báo đã nhập thành công

create trigger cau4_vuhehehe
on ChiTietHoaDon
for insert
as
begin
	if exists (select SoLuong, DonGia from inserted where SoLuong < 0 or DonGia < 0)
		begin
			rollback transaction
			raiserror ('du lieu nhap vao k dung',16,1)
		
		end
	else
		begin
			print 'dung roi'
		end
end
drop trigger cau4_vuhehehe
insert into ChiTietHoaDon values ('HD01', 'MH02', -2, 1000)
select * from ChiTietHoaDon
delete from ChiTietHoaDon where SoLuong=-2