use QuanLyCuaHang
--Câu 1. Thêm một cột Thanh_tien cho bảng CHITIETDATHANG. Hãy viết một stored 
--procedure đặt tên là sp_ThanhTien cập nhật trường ThanhTien cho bảng 
--CHITIETDATHANG sao cho ThanhTien = SoLuong * GiaBan.
alter table ChiTietDatHang
add ThanhTien float

create proc sp_ThanhTien
as
begin	
	update ChiTietDatHang
	set ThanhTien = SoLuong*GiaBan
end
sp_ThanhTien
select * from ChiTietDatHang

--Câu 2. Thêm một cột TongTien cho bảng DONDATHANG. Viết một stored procedure 
--đặt tên là sp_TongTien để cập nhật trường TongTien cho bảng DONDATHANG bằng 
--tổng ThanhTien của tất cả các sản phẩm trong đơn hàng
select * from DonDatHang
alter table DonDatHang
add TongTien float
create proc sp_TongTien
as
begin
	update DonDatHang set TongTien = ChiTietDatHang.ThanhTien
	from DonDatHang, ChiTietDatHang
	where DonDatHang.SoHoaDon = ChiTietDatHang.SoHoaDon
end
sp_TongTien
--Câu 3. Viết một stored procedure đặt tên là sp_ThuNhap để tính thu nhập của công ty
--trong một khoảng thời gian nào đó với ngày đầu và ngày cuối là tham số đầu vào của thủ
--tục.
create proc sp_ThuNhap @ngaydau as date, @ngaycuoi as date, @thunhap float output
as
begin
	select @thunhap = sum(TongTien) from DonDatHang where 

declare @thunhap_out float
exec sp_ThuNhap '2021-1-3', '2021-5-2', @thunhap = @thunhap_out output

--Câu 4. Viết một đoạn mã T-SQL thực hiện gọi thủ tục sp_ThuNhap hai lần với hai khoảng 
--thời gian khác nhau và thực hiện in ra màn hình khoảng thời gian đạt được thu nhập lớn 
--hơn LẠI: viết lại thành function, so sánh như slide 73, đặt 4 biến cho 4 ngày truyền vào
create proc sp_ThuNhap_01 @ngaydau as date, @ngaycuoi as date
as
begin
	select sum(TongTien) from DonDatHang
	where NgayDatHang between @ngaydau and @ngaycuoi
end

declare @lan01 as float
select @lan01 = (sp_ThuNhap_01 '2021-1-3', '2021-5-2')
print @lan01

declare @lan02 as float
select @lan02 = (sp_ThuNhap_01 '2020-1-3', '2020-5-2')
print @lan02

if @lan01 > @lan02
	print N'Lớn hơn'
else
	print N'Nhỏ hơn'
---------------------------------------lại lại hàm ok ok luoon, theo hàm câu 3 không có output ngoài
create function f_thunhap (@ngaydau as date, @ngaycuoi as date)
returns float
as
begin
	declare @output as float
	set @output = 
	(select sum(TongTien) from DonDatHang
	where NgayDatHang between @ngaydau and @ngaycuoi)
	return @output
end

declare @day1 as date, @day2 as date, @day3 as date, @day4 as date 
set @day1 = '2021-1-3'
set @day2 = '2021-5-2'
set @day3 = '2020-9-3'
set @day4 = '2020-12-3'

if dbo.f_thunhap(@day1, @day2) > dbo.f_thunhap(@day3, @day4)
	begin
		print @day1
		print @day2
	end
else
	begin
		print @day3
		print @day4
	end

-- chữa cách của cô theo câu 3 sửa của cô, là có thêm output ngoài
declare @thunhap_01 float
exec sp_ThuNhap '2021-1-3', '2021-5-2', @thunhap = @thunhap_01 output

declare @thunhap_02 float
exec sp_ThuNhap '2021-1-3', '2021-5-2', @thunhap = @thunhap_02 output

if @thunhap_01>@thunhap_02
	print N'Thu nhập 1 lớn hon thu nhập 2'
	else print N'Thu nhập 1 nhỏ hơn thu nhập 2'

--Câu 5. Viết một thủ tục sp_NgayTrongTuan để tính ngày trong tuần của một ngày bất kỳ.
create proc sp_NgayTrongTuan (@ngay date, @op nvarchar(20))
as
begin
	declare @st nvarchar(10)
	select @st=
	case datepart(DW, @ngay)
		when 1 then N'Chủ nhật'
		when 2 then N'Thứ hai'
		when 3 then N'Thứ ba'
		when 4 then N'Thứ tu'
		when 5 then N'Thứ năm'
		when 6 then N'Thứ sáu'
		else N'Thứ bảy'
	end
	print @st
end
drop proc sp_NgayTrongTuan
declare @out nvarchar(20)
exec sp_NgayTrongTuan '2020-1-3', @op=@out
--Câu 6. Viết một thủ tục sp_ThongKe để thống kê và in ra màn hình số lượng hóa đơn theo 
--ngày trong tuần. 
--Ví dụ: Thứ hai: 0 hóa đơn
--Thứ ba: 1 hóa đơn
--Ví dụ: đối với Thứ Hai, đây là số lượng hóa đơn của tất cả các ngày thứ 2, chứ
--không phải số lượng hóa đơn của một ngày thứ 2 của một tuần nào đó.
--Cuối cùng, in ra màn hình xem ngày nào trong tuần thường có nhiều người mua hàng nhất. [[[[[[[[[[[[[[[[[[[[not yet]]]]]]]]]]]]]]]]]]]]]
-- ok nhưng không hiện thứ nvarchar ra
create proc sp_ThongKe 
as
begin
	select count(SoHoaDon) as SL, datename(dw, NgayDatHang) as Thu -- trả về thứ tiếng anh
	from DonDatHang
	group by datename(dw, NgayDatHang)
end
drop procedure  sp_ThongKe
sp_ThongKe
-- bài chữa của cô
create proc sp_ThongKe2
as 
begin
	declare @sohoadon int, @day int, @thu nvarchar(20)
	declare @dem int set @dem=0
	while(@day<8)
	begin
		set @sohoadon=0
		select @sohoadon = count(SoHoaDon) from DonDatHang where datepart(dw, NgayDatHang) = @day group by datepart(dw, NgayDatHang)
		select @thu = ( case @day
			when 1 then N'Chủ nhật'
			when 2 then N'Thứ hai'
			when 3 then N'Thứ ba'
			when 4 then N'Thứ tư'
			when 5 then N'Thứ năm'
			when 6 then N'Thứ sáu'
			else N'Thứ bảy'
			end
		)
		if(@dem<@sohoadon) set @dem=@sohoadon
		else set @dem=@dem
		print @thu + ': ' + convert(nvarchar(3), isnull(@sohoadon,0)) + N' hóa đơn'
		set @day = @day + 1
	end
end
-------------------------------------------------------------------------------------------- in ra hóa đơn nhiều nhất
while(@day>0)
	begin
		select @sohoadon = count(SoHoaDon) from DonDatHang where datepart(dw, NgayDatHang) = @day group by datepart(dw, NgayDatHang)
		select @thu = ( case @day
			when 1 then N'Chủ nhật'
			when 2 then N'Thứ hai'
			when 3 then N'Thứ ba'
			when 4 then N'Thứ tư'
			when 5 then N'Thứ năm'
			when 6 then N'Thứ sáu'
			else N'Thứ bảy'
			end
		)
		if(@dem = @sohoadon)
			begin
				print @thu + N' có nhiều đơn hàng nhất là: ' + convert(nvarchar(3), @sohoadon) + N' hóa đơn'
				break
			end
		else @day = @day - 1
	end

sp_ThongKe2

------------------------------------------------------------------------------------------- cách 2 sử dụng con trỏ
create proc sp_thognke_contro @tk_hoadon cursor varying out
as
begin
	set @tk_hoadon = cursor
	for
		select datepart(weekday, NgayDatHang) as weekday, count(SoHoaDon) from DonDatHang group by datepart(weekday, NgayDatHang)
	open @tk_hoadon
end
-- tạo con trỏ, gán dữ liệu
declare @mycursor cursor
exec dbo.sp_thognke_contro @tk_hoadon = @mycursor output

-- in ra màn hình số lượng hóa đơn theo ngày trong tuần
declare @ngay nvarchar(20), @soluong int
fetch next from @mycursor into @ngay, @soluong

declare @weekday nvarchar(50), @ngay_max nvarchar(20), @max int = @soluong, @a int =1
while @a <= 7
	begin
		select @weekday = ( case @a
			when 1 then N'Chủ nhật'
			when 2 then N'Thứ hai'
			when 3 then N'Thứ ba'
			when 4 then N'Thứ tư'
			when 5 then N'Thứ năm'
			when 6 then N'Thứ sáu'
			when 7 then N'Thứ bảy'
			end
		)
		if @a = @ngay
			begin
				while(@@FETCH_STATUS = 0) -- trạng thái con trỏ chỉ vị trí, đến cuối bảng chuyển thành 1
					begin
						print @weekday + ': ' + convert(nvarchar(5), @soluong) + N' hóa đơn'
						if @max < @soluong
							begin
								select @max = @soluong, @ngay_max = @weekday
							end
						fetch next from @mycursor into @ngay, @soluong
					end
			end
		else
			begin
				print @weekday + ': ' + N'0 hóa đơn'
			end
		set @a = @a + 1
	end
print char(10) + @ngay_max + N' là ngày trong tuần có nhiều người mua hàng nhất'
close @mycursor
deallocate @mycursor


--Câu 7. Viết một thủ tục sp_SLSP đưa ra số lượng đã bán của một sản phẩm với tên sản
--phẩm là tham số đưa vào
create proc sp_SLSP @tensp as nvarchar(30)
as
begin
	select count(ChitietDatHang.SoLuong) as SoLanBan, ChitietDatHang.MaHang from ChiTietDatHang
	inner join MatHang on ChiTietDatHang.MaHang = MatHang.MaHang
	where TenHang = @tensp
	group by ChitietDatHang.MaHang
end

sp_SLSP N'Bánh gạo'
--Câu 8. Viết một thủ tục sp_SPCao đưa ra danh sách các sản phẩm có số lượng bán nhiều
--hơn một giá trị x, với x là tham số đưa vào---- ok
create proc sp_SPCao @x as int
as
begin
	
	select distinct MaHang, SL = 
	(
	case
		when exists (select SoLuong from ChiTietDatHang where SoLuong>@x) then (select SoLuong)
	end
	)
	from ChiTietDatHang where SoLuong>@x
end 

select distinct MaHang, SoLuong
from ChiTietDatHang where SoLuong>20

drop proc sp_SPCao
sp_SPCao 20
------------------------------------------------------------------------------------------ làm hàm cho bài này
create function ds_sp (@x as int)
returns @bang table (soluong int)
as
begin
	insert into @bang 
	select distinct SoLuong from ChiTietDatHang where SoLuong>@x
	return
end
select * from ds_sp(20) --- chạy ok
--Câu 9. Tạo thủ tục lưu trữ để thông qua thủ tục này có thể bổ sung thêm một bản ghi mới
--cho bảng MATHANG (thủ tục phải thực hiện kiểm tra tính hợp lệ của dữ liệu cần bổ sung: 
--không trùng khoá chính và đảm bảo toàn vẹn tham chiếu). [[[[[[[[[[[[[[[[[not yet]]]]]]]]]]]]]]]]]]]]]]]]]] --> viết trigger
create proc insertintoMatHang @mahang as nvarchar(10), @tenhang nvarchar(30), @macongty as nvarchar(10), @maloaihang as nvarchar(10), @soluong as int, @donvitinh as float, @giahang as float
as
begin
	if @mahang is null or exists (select MaHang from MatHang where MaHang = @mahang)
		print N'Mặt hàng này đã tồn tại'
	else if (@macongty not in (select MaCongTy from NhaCungCap where MaCongTy=@macongty))
		print N'Không có công ty này'
	else if (@maloaihang not in (select MaLoaiHang from LoaiHang where MaLoaiHang = @maloaihang))
		print N'Không có loại hàng này'
	else
		begin
			insert into MatHang 
		values (@mahang, @tenhang, @macongty, @maloaihang, @soluong, @donvitinh, @giahang)
		print N'Thêm thành công mặt hàng'
		end
end
--Câu 10. Tạo thủ tục lưu trữ có chức năng thống kê tổng số lượng hàng bán được của một
--mặt hàng có mã bất kỳ (mã mặt hàng cần thống kê là tham số của thủ tục).
create proc sp_stored @mamathang as nvarchar(10)
as
begin	
	declare @bang table (SL int, mahang nvarchar(10))
	insert into @bang
	select sum(SoLuong) as TongSoLuong, MaHang from ChiTietDatHang
	group by MaHang
end
sp_stored 'MH01'
--Câu 11. Viết hàm trả về một bảng trong đó cho biết tổng số lượng hàng bán được của mỗi
--mặt hàng. Sử dụng hàm này để thống kê xem tổng số lượng hàng (hiện có và đã bán) của 
--mỗi mặt hàng là bao nhiêu.
create function f_tongdonhang()
returns @bang table (mahang nvarchar(10), tenhang nvarchar(30), tongluonghang int)
as
begin
	insert into @bang
	select MatHang.MaHang, TenHang, MatHang.SoLuong +
		case 
			when sum(ChiTietDatHang.SoLuong) is null then 0
			else sum(ChiTietDatHang.SoLuong)
		end as TongSoLuong
	from MatHang left outer join ChiTietDatHang
	on MatHang.MaHang = ChiTietDatHang.MaHang
	group by MatHang.MaHang, TenHang, MatHang.SoLuong
end
--Câu 12. Viết một hàm để tính tổng số đơn đặt hàng của một nhân viên bất kỳ
create function f_tongdonhang

returns int
as
begin
	select count(SoHoaDon) as TongDonHangBanDuoc, MaNhanVien
	from DonDatHang
	group by MaNhanVien
end
--------------------------------------------------------------------------------------------
create function f_tongdonhang
returns int
as
begin
	select count(SoHoaDon) as TongDonHangBanDuoc
	from DonDatHang
	where MaNhanVien = 'NV01'
end
--Câu 13. Viết một hàm để trả về danh sách nhân viên làm việc trong tháng 5/2020. ok ok
create function f_nv ()
returns @bang table (manhanvien nvarchar(10), ho nvarchar(30), ten nvarchar(30))
as
begin
	insert into @bang
	select MaNhanVien, Ho, Ten from NhanVien
	where day(NgayLamViec) between 1 and 30 and year(NgayLamViec)=2020
	return
end
drop function f_nv
select * from f_nv()
select * from NhanVien
--Câu 14. Viết một hàm trả về giá trị thứ trong tuần của một kiểu datetime. Sử dụng hàm đó 
--để lấy ra những nhân viên sinh vào ‘Chủ nhật’.
create function f_ngaytuan (@ngay date)
returns nvarchar(20)
as
begin
	declare @st nvarchar(10)
	select @st=
	case datepart(DW, @ngay)
		when 1 then N'Chủ nhật'
		when 2 then N'Thứ hai'
		when 3 then N'Thứ ba'
		when 4 then N'Thứ tu'
		when 5 then N'Thứ năm'
		when 6 then N'Thứ sáu'
		else N'Thứ bảy'
	end
	return @st
end
drop function f_ngaytuan
select * from NhanVien
where dbo.f_ngaytuan(NgaySinh) = N'Chủ nhật' --LẠI: dbo.hàm(biến, output) 



--Câu 15. Viết một hàm trả về danh sách các mặt hàng của một loại hàng bất kỳ. Nếu loại 
--hàng không có trong CSDL thì hiển thị tất cả cả các mặt hàng theo từng loại hàng.
create function f_checkloaihang (@tenloaihang nvarchar(30))
returns @bang table (mahang nvarchar(10), tenhang nvarchar(30))
as
begin
	if exists (select MaHang, TenHang from MatHang join LoaiHang on LoaiHang.MaLoaiHang = MatHang.MaLoaiHang 
	where LoaiHang.TenLoaiHang= @tenloaihang) 
		begin
			insert into @bang 
			select MaHang, TenHang
			from MatHang join LoaiHang
			on LoaiHang.MaLoaiHang = MatHang.MaLoaiHang
			where LoaiHang.TenLoaiHang= @tenloaihang
		end
	else 
		begin
			insert into @bang 
			select MaHang, TenHang from MatHang where MaLoaiHang in
				(select distinct MatHang.MaLoaiHang
				from MatHang left outer join LoaiHang
				on LoaiHang.MaLoaiHang = MatHang.MaLoaiHang
				group by MatHang.MaLoaiHang)
		end
	return
end
drop function f_checkloaihang
select * from f_checkloaihang(N'Đồ ănnn') -- khong co
select * from f_checkloaihang(N'Đồ ăn') -- co