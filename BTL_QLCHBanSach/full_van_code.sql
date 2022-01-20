--3.1. Hàm (Function)
--3.1.3. Viết một hàm để trả về danh sách nhân viên làm việc trong tháng 11/2021. 
create function f_nvlv ()
returns @bang table (MaNhanVien nvarchar(10), HoTen nvarchar(30), DiaChi nvarchar(30), DienThoai nvarchar(30))
as
begin
	insert into @bang
	select MaNV, HoTenNV, DiaChi, DienThoai from NhanVien
	where year(NgayLamViec)=2021 and MONTH(NgayLamViec) = 11
	return
end
drop function f_nvlv
select * from f_nvlv()
select * from NhanVien
--3.1.6. Viết một hàm trả về danh sách thời gian làm việc của nhân viên (tính đến ngày hiện tại) và số lượng sách đã bán.
create function f_nvtime ()
returns @bang table (MaNV nvarchar(30), MaHoaDon nvarchar(30), HoTenNV nvarchar(30), SoNgayLamViec int, SLSachDaBan int)
as
begin
	insert into @bang 
	select NHANVIEN.MaNV, DONDATSACH.MaHoaDon , HoTenNV, DATEDIFF(DAY, NgayLamViec, GETDATE()) as SoNgayLamViec, sum(SoLuong) as SLSachDaBan 
	from NHANVIEN, DONDATSACH, CHITIETDATSACH
	where NHANVIEN.MaNV = DONDATSACH.MaNV and DONDATSACH.MaHoaDon = CHITIETDATSACH.MaHoaDon
	group by NHANVIEN.MaNV, HoTenNV, NgayLamViec, DONDATSACH.MaHoaDon
	return
end
drop function f_nvtime
select * from f_nvtime()
--test select bảng nhanvien, dondatsach, chitietdatsach

--3.1.9. Viết một hàm trả về khách hàng chi nhiều tiền nhất cho 1 hóa đơn
create function f_khmax ()
returns @bang table (HoTenKH nvarchar(30), DiaChiKH nvarchar(30), MaHD nvarchar(30), TongTien float)
as
begin
	insert into @bang
	select HoTenKH, DiaChi, DONDATSACH.MaHoaDon, sum(TongTien) as TongTienKHTra from KHACHHANG join DONDATSACH on KHACHHANG.MaKH = DONDATSACH.MaKH
	join CHITIETDATSACH on CHITIETDATSACH.MaHoaDon = DONDATSACH.MaHoaDon
	where TongTien = (select max(TongTien) from CHITIETDATSACH)
	group by DONDATSACH.MaHoaDon, HoTenKH, DiaChi, TongTien
	return
end
select * from f_khmax()

--3.2. Thủ tục (Procedure)
--3.2.3. Tạo thủ tục đưa ra số lượng đã bán của sách với tên sách là tham số đưa vào.
create proc p_SLDaBan @tensach nvarchar(30)
as
begin
	select SACH.MaSach, TenSach, sum(CHITIETDATSACH.SoLuong) as SLBan from SACH
	join CHITIETDATSACH on SACH.MaSach = CHITIETDATSACH.MaSach
	where TenSach=@tensach
	group by SACH.MaSach, TenSach, CHITIETDATSACH.SoLuong
end
p_SLDaBan N'ABC'
--select ProductID, sum(Quantity) as TotalQty from Orders group by ProductID
--3.2.6. Tạo thủ tục đưa ra thể loại được bán nhiều nhất, thuộc nhà xuất bản và tác giả nào?
create proc p_theloai
as
begin 
	select TenTheLoai, TenNXB, TenTacGia from THELOAISACH, NHAXUATBAN, TACGIA, SACH
	where SACH.MaTheLoai = THELOAISACH.MaTheLoai and SACH.MaTacGia = TACGIA.MaTacGia and SACH.MaNXB = NHAXUATBAN.MaNXB 
	and MaSach in 
	(select MaSach from CHITIETDATSACH where SoLuong = (select max(SoLuong) from CHITIETDATSACH))
end
drop proc p_theloai
p_theloai
--3.2.9. Tạo thủ tục thực hiện so sánh thu nhập hai khoảng thời gian khác nhau và thực hiện in ra màn hình khoảng 
--thời gian đạt được thu nhập lớn hơn, và lớn hơn bao nhiêu tiền?
create proc p_sosanh @ngaydau1 date, @ngaycuoi1 date, @ngaydau2 date, @ngaycuoi2 date
as 
begin
	declare @output1 float, @output2 float
	select @output1 = (select sum(TongTien) from CHITIETDATSACH, DONDATSACH
	where CHITIETDATSACH.MaHoaDon=DONDATSACH.MaHoaDon and NgayDat between @ngaydau1 and @ngaycuoi1)

	select @output2 = (select sum(TongTien) from CHITIETDATSACH, DONDATSACH
	where CHITIETDATSACH.MaHoaDon=DONDATSACH.MaHoaDon and NgayDat between @ngaydau2 and @ngaycuoi2)

	if @output1>@output2
		begin
			print N'Khoảng thời gian có thu nhập lớn hơn là: ' + CONVERT(nvarchar(40), @ngaydau1) + ', ' + CONVERT(nvarchar(40), @ngaycuoi1) ;
			print N'Khoảng thời gian đó có thu nhập lớn hơn khoảng thời gian còn lại: ' + convert(nvarchar(30), @output1-@output2) + '(VNĐ)' 
		end
	else if @output2>@output1
		begin
			print N'Khoảng thời gian có thu nhập lớn hơn là: ' + CONVERT(nvarchar(40), @ngaydau2) + ', ' + CONVERT(nvarchar(40), @ngaycuoi2) ;
			print N'Khoảng thời gian đó có thu nhập lớn hơn khoảng thời gian còn lại: ' + convert(nvarchar(30), @output2-@output1) + '(VNĐ)' 
		end
end
exec p_sosanh '2021-10-3', '2021-11-2', '2021-11-10', '2021-12-21'

--3.3. Trigger
--3.3.3. Tạo Trigger sao cho khi thêm 1 dòng dữ liệu vào trong bảng DONDATSACH phải kiểm tra các cột khóa ngoại: 
--cột MaKH trong bảng KHACHHANGvà cột MaNV trong bảng NHANVIEN. Nếu không có phải đưa ra thông báo lỗi còn nếu thỏa mãn thì thông báo thành công.
create trigger t_insDT
on DONDATSACH
for insert
as
begin
	if not exists (select inserted.MaKH from inserted inner join KHACHHANG on inserted.MaKH=KHACHHANG.MaKH)
		begin
			raiserror (N'Không tồn tại khách hàng bạn vừa nhập trong bảng KHACHHANG',16,1)
			rollback transaction
		end
	else if not exists (select inserted.MaNV from inserted inner join NHANVIEN on inserted.MaNV=NHANVIEN.MaNV)
		begin
			raiserror (N'Không tồn tại nhân viên bạn vừa nhập trong bảng NHANVIEN',16,1)
			rollback transaction
		end
	else
		begin
			print N'Thêm thành công!'
		end
end
drop trigger t_insDT
insert into DONDATSACH (MaKH,MaNV,NgayDat,NgayChuyen,NgayGiao,NoiGiao) values
(9, 9, '2021-1-1', '2021-1-1', '2021-1-1', 'hanoi')
-- xoa constraint
sp_helpconstraint 'DONDATSACH'
FK_DONDATSACH_KHACHHANG
alter table DONDATSACH
drop constraint FK_DONDATSACH_KHACHHANG
alter table DONDATSACH
drop constraint FK_DONDATSACH_NHANVIEN
-- xoa constraint

--3.3.6. Viết trigger cho bảng DONDATSACH để sao cho chỉ chấp nhận ngày chuyển sau 
--ngày đặt và ngày giao sau ngày chuyển
create trigger t_checkdate
on DONDATSACH
for insert
as
begin
	declare @ngaydat date, @ngaychuyen date, @ngaygiao as date
	select @ngaydat = (select NgayDat from inserted)
	select @ngaychuyen = (select NgayChuyen from inserted)
	select @ngaygiao = (select NgayGiao from inserted)

	if(datediff(day, @ngaydat, @ngaychuyen) > 0 and datediff(day, @ngaychuyen, @ngaygiao) > 0)
		begin
			print N'Hợp lý!'
		end
	else if (datediff(day, @ngaydat, @ngaychuyen) < 0)
		begin
			raiserror (N'Ngày chuyển phải sau ngày đặt sách',16,1)
			rollback transaction
		end
	else if (datediff(day, @ngaychuyen, @ngaygiao) < 0)
		begin
			raiserror (N'Ngày giao phải sau ngày chuyển hàng',16,1)
			rollback transaction
		end
end 
drop trigger t_checkdate
insert into DONDATSACH (MaKH, MaNV, NgayDat, NgayChuyen, NgayGiao, NoiGiao) values
(1,1,'2021-1-1','2021-9-9','2021-11-11','england')
select * from NHAXUATBAN
--3.4. View
--3.4.3. Tạo View cho biết số tiền lương mà cửa hàng phải trả cho mỗi nhân viên là bao nhiêu.
create view v_salaryNV as
select *, (Luong*PhuCap) as LuongCuoi from NhanVien
select * from v_salaryNV

--3.4.6. Tạo View cho biết tổng số tiền hàng mà cửa hàng thu được trong mỗi tháng của năm 2021.
alter table CHITIETDATSACH
add TongTien float
update CHITIETDATSACH set MucGiamGia=1 where MucGiamGia=0
update CHITIETDATSACH set TongTien=(SoLuong*GiaBan)-(SoLuong*GiaBan*MucGiamGia/100)
select * from CHITIETDATSACH

create view v_thongke as
select month(NgayDat) as Thang, CHITIETDATSACH.TongTien from DONDATSACH, CHITIETDATSACH
where DONDATSACH.MaHoaDon = CHITIETDATSACH.MaHoaDon and year(NgayDat)=2021
group by MONTH(NgayDat), CHITIETDATSACH.TongTien

--3.4.9. Tạo View cho biết đơn đặt sách nào có số lượng đặt hàng được đặt mua ít nhất -- tis paste
create view v_info as
select DONDATSACH.MaHoaDon, sum(SoLuong) as SLHangNhoNhat
from DONDATSACH inner join CHITIETDATSACH on DONDATSACH.MaHoaDon = CHITIETDATSACH.MaHoaDon
group by DONDATSACH.MaHoaDon
having sum(SoLuong) <= ALL (select sum(SoLuong) from DONDATSACH 
inner join CHITIETDATSACH on DONDATSACH.MaHoaDon = CHITIETDATSACH.MaHoaDon group by DONDATSACH.MaHoaDon)

select * from v_info