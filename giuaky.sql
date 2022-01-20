create table DMKhach (
	MaKhach nvarchar(10) primary key not null,
	TenKhach nvarchar(30),
	DiaChi nvarchar(30),
	DienThoai nvarchar(30)
)
insert into DMKhach values
('KH01', 'van', 'ha noi', '04901932131'),
('KH02', 'vu', 'ha nam', '023123213'),
('KH03', 'cho', 'thai binh', '0342423403'),
('KH04', 'lan', 'quang ninh', '9924324'),
('KH05', 'mai', 'ha noi', '242432232')
select * from DMKhach
create table DMHang (
	MaHang nvarchar(10) primary key not null,
	TenHang nvarchar(30),
	DVT nvarchar(10)
)
insert into DMHang values
('MH01', 'bimbim', 'goi'),
('MH02', 'thach rau cau', 'goi'),
('MH03', 'bim', 'bich'),
('MH04', 'keo mut', 'chiec'),
('MH05', 'may tinh', 'chiec')
select * from DMHang
create table HoaDonBan (
	SoHD nvarchar(10) primary key not null,
	MaKhach nvarchar(10) foreign key references DMKhach(MaKhach) not null,
	NgayHD date,
	TongTien float
)
insert into HoaDonBan values
('HD01', 'KH01', '2021-12-3', 120000),
('HD02', 'KH02', '2020-11-3', 230000),
('HD03', 'KH04', '2020-10-3', 210000),
('HD04', 'KH03', '2021-9-3', 534300000),
('HD05', 'KH02', '2021-8-3', 4230000),
('HD06', 'KH04', '2021-1-3', 2130000)

select * from HoaDonBan
create table ChiTietHoaDon (
	SoHD nvarchar(10) not null foreign key references HoaDonBan(SoHD),
	MaHang nvarchar(10) not null foreign key references DMHang(MaHang),
	SoLuong int,
	DonGia float
)
select * from DMHang
insert into ChiTietHoaDon values
('HD03', 'MH01', 3, 70000),
('HD02', 'MH04', 19, 90000),
('HD03', 'MH01', 1, 20000),
('HD05', 'MH04', 9, 20000),
('HD04', 'MH04', 4, 25000)

select * from ChiTietHoaDon

--1/ Hãy tạo cấu trúc cơ sở dữ liệu trên(Với mỗi bảng nếu có ràng buộc khoá chính hoặc ràng 
--buộc khoá ngoài yêu cầu phải định nghĩa đầy đủ). 
--2/ Tạo View để tổng hợp dữ liệu về các mặt hàng mà có mua từ 2 lần trở lên. 
create view cau2 as
select DMHang.MaHang, TenHang
from DMHang, ChiTietHoaDon
where DMHang.MaHang = ChiTietHoaDon.MaHang
group by DMHang.MaHang, TenHang
having count(SoHD) > 2

select * from cau2

select * from ChiTietHoaDon
--3/ Tạo hàm có tham số vào là @Thang để đưa ra doanh thu của từng mặt hàng có trong 
--tháng (Danh sách đưa ra gồm các thuộc tính sau: MaHang, TenHang, DoanhThu).
create function cau3 (@thang as date)
returns @bang table (mahang nvarchar(10), tenhang nvarchar(30), doanhthu float)
as
begin
	insert into @bang
	select DMHang.MaHang, TenHang, (SoLuong*DonGia) as DoanhThu
	from DMHang, ChiTietHoaDon, HoaDonBan
	where DMHang.MaHang = ChiTietHoaDon.MaHang and HoaDonBan.SoHD = ChiTietHoaDon.SoHD 
	group by DMHang.MaHang, TenHang
	having month(HoaDonBan.NgayHD)=month(@thang)
	return
end

--4/ Tạo TRIGGER DELETE trên bảng DMHang sao cho khi xóa một mặt hàng thì trigger 
--phải kiểm tra sự tồn tại của các MaHang có liên quan trên bảng ChiTietHoaDon. Khi đó, 
--nếu MaHang có tồn tại trong bảng ChiTietHoaDon thì thông báo không thể xóa được. 
--Ngược lại, thì thông báo đã xóa mặt hàng đó rồi

create trigger cau4 
on DMHang
for delete
as
begin
	if exists (select ChiTietHoaDon.MaHang from ChiTietHoaDon inner join deleted on deleted.MaHang = ChiTietHoaDon.MaHang)
		begin
			raiserror('loi', 16, 1)
		end
	else
		begin
			print 'da xoa mat hang1'
		end
end

delete from DMHang where MaHang='MH01'

sp_helpconstraint 'ChiTietHoaDon'

alter table ChiTietHoaDon drop constraint FK__ChiTietHo__MaHan__34C8D9D1
 