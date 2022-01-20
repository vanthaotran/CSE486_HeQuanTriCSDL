/*
3.4.1. Tạo View tổng hợp thông tin về các sách theo nhà xuất bản,
tác giả, thể loại và số lượng (hiện có trong kho)*/
CREATE VIEW View_thong_tin_sach_trong_kho
AS
SELECT TenSach, TenTacGia, TenNXB, SoLuong
FROM SACH INNER JOIN NHAXUATBAN
ON SACH.MaNXB = NHAXUATBAN.MaNXB
INNER JOIN TACGIA
ON SACH.MaTacGia = TACGIA.MaTacGia

Select * from View_thong_tin_sach_trong_kho
/*
3.4.4. Tạo View tổng hợp những sách chưa từng được khách hàng mua.
*/
CREATE VIEW View_sach_chua_duoc_mua
AS
SELECT SACH.MaSach, TenSach, TenTacGia, TenNXB, SoLuong
FROM SACH INNER JOIN TACGIA ON SACH.MaTacGia = TACGIA.MaTacGia
	INNER JOIN NHAXUATBAN ON SACH.MaNXB = NHAXUATBAN.MaNXB
WHERE MaSach NOT IN (SELECT MaSach FROM CHITIETDATSACH)

select * from View_sach_chua_duoc_mua
/*
3.4.7. Tạo View cho biết tổng số tiền lãi mà công ty thu được từ mỗi thể loại sách
trong năm 2021.
*/
CREATE VIEW View_tien_lai_tung_loai_sach
AS
SELECT THELOAISACH.MaTheLoai, TenTheLoai,
		CASE
		WHEN (sum(CHITIETDATSACH.SoLuong*GiaBan) - sum(CHITIETDATSACH.SoLuong*GiaBan*MucGiamGia/100)
				-sum(CHITIETDATSACH.SoLuong*GiaSach)) IS NULL THEN 0
		ELSE (sum(CHITIETDATSACH.SoLuong*GiaBan) - sum(CHITIETDATSACH.SoLuong*GiaBan*MucGiamGia/100)
				-sum(CHITIETDATSACH.SoLuong*GiaSach)) 
		END AS TienLai
FROM THELOAISACH LEFT JOIN SACH ON SACH.MaTheLoai = THELOAISACH.MaTheLoai
		LEFT JOIN CHITIETDATSACH ON SACH.MaSach = CHITIETDATSACH.MaSach
GROUP BY THELOAISACH.MaTheLoai, TenTheLoai

select * from View_tien_lai_tung_loai_sach
-------------------------------------------------------------------------------
/*
3.1.1. Viết hàm trả về một bảng trong đó cho biết tổng số sách hiện có và đã bán
của mỗi mặt hàng là bao nhiêu.
*/
CREATE FUNCTION f_tong_so_sach()
RETURNS @table TABLE(TenSach nvarchar(255), TenTheLoai nvarchar(255),
						SoLuongHienCo int, SoLuongDaBan int)
AS
BEGIN
	INSERT INTO @table
	SELECT TenSach, TenTheLoai, SACH.SoLuong,
			CASE
				WHEN SUM(CHITIETDATSACH.SoLuong) IS NULL THEN 0
				ELSE SUM(CHITIETDATSACH.SoLuong)
				END AS SoLuongDaBan
	FROM SACH LEFT JOIN THELOAISACH ON SACH.MaTheLoai = THELOAISACH.MaTheLoai
		LEFT JOIN CHITIETDATSACH ON SACH.MaSach = CHITIETDATSACH.MaSach
	GROUP BY SACH.MaSach, TenSach, TenTheLoai, SACH.SoLuong
	RETURN
END
select * from f_tong_so_sach()

/*
3.1.4. Viết hàm trả về bảng họ tên nhân viên, ngày sinh và sinh vào thứ mấy trong tuần
*/
CREATE FUNCTION f_ngay_sinh_nhan_vien_trong_tuan()
RETURNS @table TABLE(MaNV int, HoTenNV nvarchar(255),
					NgaySinh nvarchar(12), Thu nvarchar(20))
AS
BEGIN
	INSERT INTO @table
	SELECT MaNV, HoTenNV, NgaySinh, 
		CASE DATEPART(DW, NgaySinh)
			WHEN 2 THEN N'Thứ Hai'
			WHEN 3 THEN N'Thứ Ba'
			WHEN 4 THEN N'Thứ Tư'
			WHEN 5 THEN N'Thứ Năm'
			WHEN 6 THEN N'Thứ Sáu'
			WHEN 7 THEN N'Thứ Bảy'
			ELSE N'Chủ Nhật'
			END AS Thu
	FROM NHANVIEN
	order by datepart(dw,NgaySinh)
	RETURN
END
SELECT * FROM f_ngay_sinh_nhan_vien_trong_tuan()

/*
3.1.7. Viết một hàm trả về danh sách 5 đầu sách sách được ưa thích nhất trong tháng
(được bán nhiều nhất trong tháng).
*/
CREATE FUNCTION f_sach_duoc_ua_thich_nhat(@Thang nvarchar(12))
RETURNS @table TABLE(TenSach nvarchar(255), SoLuongBan int)
AS
BEGIN
	INSERT INTO @table
	SELECT TOP 5 TenSach, sum(CHITIETDATSACH.SoLuong) as SL
	FROM CHITIETDATSACH INNER JOIN SACH ON CHITIETDATSACH.MaSach = SACH.MaSach
		INNER JOIN DONDATSACH ON CHITIETDATSACH.MaHoaDon = DONDATSACH.MaHoaDon
	WHERE month(DONDATSACH.NgayDat) = @Thang
	GROUP BY CHITIETDATSACH.MaSach, TenSach
	ORDER BY SL DESC
	RETURN
END
select * from f_sach_duoc_ua_thich_nhat(12)
--------------------------------------------------
/*
3.2.1. Tạo thủ tục đưa ra thông tin nhân viên và tổng số đơn đã chốt của nhân viên đó.
*/
CREATE PROC pc_so_don_cua_nhan_vien
AS
BEGIN
	SELECT NHANVIEN.MaNV, HoTenNV, COUNT(MaHoaDon) AS SoHoaDonDaLap
	FROM NHANVIEN LEFT JOIN DONDATSACH ON NHANVIEN.MaNV = DONDATSACH.MaNV
	GROUP BY NHANVIEN.MaNV, HoTenNV
END
pc_so_don_cua_nhan_vien

/*
3.2.4. Tạo thủ tục đưa ra danh sách các đầu sách có số lượng bán nhiều hơn một giá trị x, với x là tham số đưa vào.
*/
CREATE PROC sp_so_sanh_sach(@SoLuong int)
AS
BEGIN
	SELECT SACH.MaSach, TenSach, SUM(CHITIETDATSACH.SoLuong) AS SoLuongDaBan
	FROM SACH INNER JOIN CHITIETDATSACH ON SACH.MaSach = CHITIETDATSACH.MaSach
	GROUP BY SACH.MaSach, TenSach
	HAVING SUM(CHITIETDATSACH.SoLuong) > @SoLuong
END

sp_so_sanh_sach 10

/*
3.2.7. Tạo thủ tục thống kê và in ra màn hình số lượng hóa đơn theo ngày trong tuần. 
Ví dụ: Thứ hai: 0 hóa đơn Thứ ba: 1 hóa đơn …. 
Ví dụ: đối với Thứ Hai, đây là số lượng hóa đơn của tất cả các ngày thứ 2, chứ không phải số lượng hóa đơn của một ngày thứ 2 của một tuần nào đó.
Cuối cùng, in ra màn hình xem ngày nào trong tuần thường có nhiều người mua hàng nhất.
*/
CREATE PROC sp_thong_ke_theo_thu
AS
BEGIN
	DECLARE @sohoadon int, @day int, @thu nvarchar(20)
	DECLARE @SLmax int, @daymax nvarchar(20)
	SET @SLmax = 0
	SET @day = 1
	WHILE @day <8
		BEGIN
			SELECT @sohoadon = COUNT(MaHoaDon)
					FROM DONDATSACH
					WHERE DATEPART(dw, NGAYDAT) = @day
			SELECT @thu = (CASE @day
							WHEN 1 THEN N'Chủ Nhật'
							WHEN 2 THEN N'Thứ Hai'
							WHEN 3 THEN N'Thứ Ba'
							WHEN 4 THEN N'Thứ Tư'
							WHEN 5 THEN N'Thứ Năm'
							WHEN 6 THEN N'Thứ Sáu'
							ELSE N'Thứ Bảy' END)
			SET @day = @day + 1
			IF @SLmax < @sohoadon
				BEGIN
					SET @SLmax = @sohoadon
					SET @daymax = @thu
				END
			PRINT @thu + N' có: ' + cast(@sohoadon as nvarchar(5)) + N' hóa đơn'
		END
		PRINT N'Ngày có nhiều đơn hàng nhất là ' + @daymax + ' : ' + cast(@SLmax as nvarchar(20))
END
sp_thong_ke_theo_thu
--------------------------------------------------------
/*
3.3.1. Tạo Trigger sao cho khi thêm 1 dòng dữ liệu vào trong bảng CHITIETDATSACH phải kiểm tra các cột
khóa ngoại: cột MaHoaDon trong bảng DONDATSACH và cột MaSach trong SACH. Nếu không có phải đưa ra 
thông báo lỗi còn nếu thỏa mãn thì thông báo thành công.
*/
CREATE TRIGGER insert_CHITIETDATSACH ON CHITIETDATSACH
FOR INSERT
AS
BEGIN
	IF (SELECT MaHoaDon FROM inserted) not in (SELECT MaHoaDon FROM DONDATSACH)
		BEGIN
			RAISERROR(N'Mã hóa đơn không tồn tại! Kiểm tra lại!', 16, 1)
			rollback
		END
	ELSE IF (SELECT MaSach FROM inserted) not in (SELECT MaSach FROM SACH)
		BEGIN
			RAISERROR(N'Mã sách không tồn tại! Kiểm tra lại!', 16, 1)
			rollback
		END
	ELSE
		PRINT N'Thêm chi tiết đặt hàng thành công!'
END

alter table CHITIETDATSACH
nocheck constraint FK_CHITIETDATSACH_DONDATSACH
alter table CHITIETDATSACH
nocheck constraint FK_CHITIETDATSACH_SACH

insert into CHITIETDATSACH (MaHoaDon, MaSach, SoLuong, GiaBan, MucGiamGia)
values (2, 500, 100000, 2, 0)

/*
3.3.4. Tạo Trigger phục vụ công việc: Khi một bản ghi mới được bổ sung vào bảng CHITIETDATSACH thì
giảm số lượng sách hiện có nếu số lượng sách hiện có lớn hơn hoặc bằng số lượng sách được bán ra.
Ngược lại thì huỷ bỏ thao tác bổ sung.
*/
CREATE TRIGGER insert_soluong_chitietdatsach on CHITIETDATSACH
FOR INSERT
AS
BEGIN
	DECLARE @MaSach nvarchar(10)
	SET @MaSach = (SELECT MaSach FROM inserted)

	IF (SELECT SoLuong FROM SACH WHERE MaSach = @MaSach) >= (SELECT SoLuong FROM inserted)
		BEGIN
			UPDATE SACH
			SET SoLuong = SoLuong - (SELECT SoLuong FROM inserted)
			WHERE MaSach = @MaSach
		END
	ELSE
		BEGIN
			RAISERROR(N'Số lượng hàng trong kho không đủ', 16, 1)
			ROLLBACK TRANSACTION
		END
END

insert into CHITIETDATSACH(MaHoaDon, MaSach, SoLuong, GiaBan, MucGiamGia)
values(9, 23, 500, 100000, 0)



-- vu


create function tong_so_don_dat_hang_cua ( @NV_id int )
returns nvarchar(50)
as
begin
  declare @So_Hoa_Don int
  set @So_Hoa_Don = 0
  select @So_Hoa_Don = count(NHANVIEN.MaNV) 
  from NHANVIEN, DONDATSACH
  where DONDATSACH.MaNV=NHANVIEN.MaNV
  group by NgayLamViec, NHANVIEN.MaNV
  having NHANVIEN.MaNV=@NV_id
  return N'Nhân viên có mã id '+ cast(@NV_id as nvarchar(50)) + N' có tổng ' + cast(@So_Hoa_Don as nvarchar(50)) + N' hóa đơn'
end
print ( dbo.tong_so_don_dat_hang_cua(10) )
create function danh_sach_cac_sach_cua_the_loai (@Ten_the_loai nvarchar(255))
returns @Sach_theo_the_loai table (Sach nvarchar(255), Theloai nvarchar(255))
as
begin
  if (@Ten_the_loai in (select TenTheLoai from THELOAISACH, SACH where THELOAISACH.MaTheLoai=SACH.MaTheLoai)) 
  begin
      insert into @Sach_theo_the_loai 
      select SACH.TenSach, THELOAISACH.TenTheLoai
      from SACH, THELOAISACH
      where SACH.MaTheLoai=THELOAISACH.MaTheLoai and TenTheLoai like @Ten_the_loai
  end
  else 
  begin
      insert into @Sach_theo_the_loai 
      select SACH.TenSach, THELOAISACH.TenTheLoai
      from SACH, THELOAISACH
      where SACH.MaTheLoai=THELOAISACH.MaTheLoai  
      order by TenTheLoai DESC
  end
  return 
end
select * from dbo.danh_sach_cac_sach_cua_the_loai(N'Văn học nghệ thuật')
create function Khach_hang_mua_nhieu_sach_nhat ()
returns table 
as
  return 
  (
      select KHACHHANG.MaKH as N'Mã khách hàng', HoTenKH as N'Họ và tên', sum(SoLuong) as N'Số lượng sách mua'
      from KHACHHANG, DONDATSACH, CHITIETDATSACH
      where KHACHHANG.MaKH=DONDATSACH.MaKH and DONDATSACH.MaHoaDon=CHITIETDATSACH.MaHoaDon
      group by KHACHHANG.MaKH, HoTenKH
      having sum(SoLuong) >= all(
          select sum([SoLuong])
          from KHACHHANG, DONDATSACH, CHITIETDATSACH
          where KHACHHANG.MaKH=DONDATSACH.MaKH and DONDATSACH.MaHoaDon=CHITIETDATSACH.MaHoaDon
          group by KHACHHANG.MaKH
      )
  )
select * from dbo.Khach_hang_mua_nhieu_sach_nhat()
create proc thu_nhap_cua_cua_hang_trong_khoang_tg (@Ngay_bat_dau date, @Ngay_ket_thuc date)
as
begin
  declare @tong_thu_nhap money
  set @tong_thu_nhap=0
  select @tong_thu_nhap = sum((CHITIETDATSACH.SoLuong*CHITIETDATSACH.GiaBan-CHITIETDATSACH.SoLuong*CHITIETDATSACH.GiaBan*CHITIETDATSACH.MucGiamGia/100) - (SACH.GiaSach*CHITIETDATSACH.SoLuong)) 
  from DONDATSACH, CHITIETDATSACH, SACH
  where DONDATSACH.MaHoaDon=CHITIETDATSACH.MaHoaDon and CHITIETDATSACH.MaSach=SACH.MaSach and NgayDat>=@Ngay_bat_dau and NgayDat<=@Ngay_ket_thuc
  print N'Tổng tiền mà cửa hàng thu được từ ' + cast(@Ngay_bat_dau as nvarchar(20)) + N' đến ' + cast(@Ngay_ket_thuc as nvarchar(20)) + N' là ' + cast(@tong_thu_nhap as nvarchar(20)) + N' VNĐ'
end
exec thu_nhap_cua_cua_hang_trong_khoang_tg '12-01-2021', '12-31-2021'
  Tạo thủ tục đếm xem tác giả có bao nhiêu đầu sách với tên tác giả là tham số truyền vào.
create proc So_dau_sach_cua_tac_gia (@Ten_tac_gia nvarchar(255))
as
begin
  declare @So_dau_sach int
  set @So_dau_sach = 0
  select @So_dau_sach = count(MaSach)
  from SACH, TACGIA
  where SACH.MaTacGia=TACGIA.MaTacGia
  group by TACGIA.MaTacGia, TenTacGia
  having TenTacGia like @Ten_tac_gia
  print N'Tác giả ' + @Ten_tac_gia + N' có ' + cast(@So_dau_sach as nvarchar(50)) + N' đầu sách.'
end
exec So_dau_sach_cua_tac_gia N'F.Scott Fitzgerald'
 Tạo thủ tục lưu trữ để thông qua thủ tục này có thể bổ sung 
 thêm một bản ghi mới cho bảng SACH (thủ tục phải thực hiện kiểm 
 tra tính hợp lệ của dữ liệu cần bổ sung: không trùng khoá chính và đảm bảo toàn vẹn tham chiếu). 
insert into TACGIA
values (N'Kevin Mitnick')
create proc Bo_sung_cho_bang_SACH_du_lieu ( @Ten_sach nvarchar(255), 
                                          @Ma_the_loai int, 
                                          @Ma_NXB int, 
                                          @Ma_tac_gia int, 
                                          @Ngay_XB date,
                                          @Gia_sach money,
                                          @So_luong int)
as 
  begin
      if (@Ma_NXB in (select MaNXB from NHAXUATBAN) and
          @Ma_tac_gia in (select MaTacGia from TACGIA) and
          @Ma_the_loai in (select MaTheLoai from THELOAISACH))
          begin
              insert into SACH
              values (@Ten_sach, @Ma_the_loai, @Ma_NXB, @Ma_tac_gia, @Ngay_XB, @Gia_sach, @So_luong)
              print N'Dữ liệu đã được thêm!'
          end
      else
          begin
              print N'Thông tin truyền vào không hợp lệ, kiểm tra lại'
          end
  end
exec Bo_sung_cho_bang_SACH_du_lieu N'Ghost in the Wires', 1, 27, 25, '2016-03-04', 200000, 200 
 Tạo Trigger sao cho khi thêm 1 dòng dữ liệu vào trong bảng SACH phải kiểm tra 
 các cột khóa ngoại: cột MaNXB trong bảng NHAXUATBAN và cột MaTheLoai trong bảng THELOAI. 
 Nếu không có phải đưa ra thông báo lỗi còn nếu thỏa mãn thì thông báo thành công.
create trigger Them_vao_du_lieu_vao_SACH
on SACH
for insert
as
begin
  if  (select MaNXB from inserted) not in (select MaNXB from NHAXUATBAN)
      begin
          raiserror (N'Không tồn tại Nhà Xuất Bản bạn vừa nhập :))', 16, 1)
          rollback transaction
      end
  else if (select MaTheLoai from inserted) not in (select MaTheLoai from THELOAISACH)
      begin
          raiserror (N'Không tồn tại Thể Loại Sách bạn vừa nhập :))', 16, 1)
          rollback transaction
      end
  else if (select MaTacGia from inserted) not in (select MaTacGia from TACGIA)
      begin
          raiserror (N'Không tồn tại Tác Giả bạn vừa nhập :))', 16, 1)
          rollback transaction
      end
  else 
      begin
          print 'Chúc mừng bạn đã thêm sách thành công!'
      end
end
sp_helpconstraint 'SACH'
alter table SACH
drop constraint FK_SACH_NHAXUATBAN, FK_SACH_TACGIA, FK_SACH_THELOAISACH
insert into SACH
values ('The Art of Invisibility', 1, 27, 26, '2016-05-06', 300000, 200)
Khi cập nhật lại số lượng sách được bán ở bảng CHITIETDATSACH, 
kiểm tra số lượng sách được cập nhật lại có phù hợp hay không 
(số lượng sách bán ra không được vượt quá số lượng sách hiện có trong bảng SACH và không được nhỏ hơn 1). 
Nếu dữ liệu hợp lệ thì giảm (hoặc tăng) số lượng sách hiện có trong cửa hàng, ngược lại thì huỷ bỏ thao tác cập nhật.
create trigger kiem_tra_va_cap_nhat_so_luong
on CHITIETDATSACH
for update
as 
begin
  if  (select sum(SoLuong) from inserted) >= 1 and 
      (select sum(SoLuong) from inserted) <= (select SoLuong from SACH where MaSach=(select MaSach from inserted group by MaSach))
      begin
          if update(SOLUONG)
              begin
                  begin
                      update SACH
                      set SACH.SoLuong = SACH.SoLuong + ((select sum(SoLuong) from deleted) - (select sum(SoLuong) from inserted))
                  end
              end
          end
  else 
      begin
          raiserror (N'Số lượng sách bán ra không được vượt quá số lượng sách hiện có trong bảng SACH và không được nhỏ hơn 1', 16, 1)
          rollback transaction
      end
end
drop trigger kiem_tra_va_cap_nhat_so_luong
update CHITIETDATSACH
set SoLuong = 11
where MaSach = 1 
. Tạo View tổng hợp thông tin về các sách xuất bản năm 2010 đã được bán.
create view Tong_hop_thong_tin (Tensach, Theloai, Tacgia, Ngayxuatban)
as
select SACH.TenSach, THELOAISACH.TenTheLoai, TACGIA.TenTacGia, SACH.NgayXB
from SACH, TACGIA, THELOAISACH, CHITIETDATSACH
where SACH.MaSach=CHITIETDATSACH.MaSach and SACH.MaTheLoai=THELOAISACH.MaTheLoai and SACH.MaTacGia=TACGIA.MaTacGia and year(NgayXB)='2010'
select * from Tong_hop_thong_tin
Tạo View cho biết mỗi một nhân viên của cửa hàng đã lập bao nhiêu đơn đặt sách(nếu nhân viên chưa từng lập hóa đơn nào thì trả về kết quả bằng 0).
create view So_don_dat_sach_nhan_vien_da_lap (TenNhanVien, SoHoaDonDaNhap)
as
select NHANVIEN.HoTenNV, count(DONDATSACH.MaNV)
from NHANVIEN left join DONDATSACH on  NHANVIEN.MaNV=DONDATSACH.MaNV
group by NHANVIEN.DienThoai, NHANVIEN.HoTenNV
select * from So_don_dat_sach_nhan_vien_da_lap
3.4.8. Tạo View thống kê xem trong năm 2020 mỗi sách trong mỗi tháng và trong cả năm bán được với số lượng bao nhiêu.
create view Thong_ke_so_luong_sach_da_ban (TenSach, ThangMot, ThangHai, ThangBa, ThangTu, ThangNam, ThangSau, ThangBay, ThangTam, ThangChin, ThangMuoi, ThangMuoiMot, ThangMuoiHai, CaNam)
as
select    SACH.TenSach,
      sum(
          case month(DONDATSACH.NgayDat) when 1 then CHITIETDATSACH.SoLuong else 0 end
      ) as Thang1,
      sum(
          case month(DONDATSACH.NgayDat) when 2 then CHITIETDATSACH.SoLuong else 0 end
      ) as Thang2,
      sum(
          case month(DONDATSACH.NgayDat) when 3 then CHITIETDATSACH.SoLuong else 0 end
      ) as Thang3,
      sum(
          case month(DONDATSACH.NgayDat) when 4 then CHITIETDATSACH.SoLuong else 0 end
      ) as Thang4,
      sum(
          case month(DONDATSACH.NgayDat) when 5 then CHITIETDATSACH.SoLuong else 0 end
      ) as Thang5,
      sum(
          case month(DONDATSACH.NgayDat) when 6 then CHITIETDATSACH.SoLuong else 0 end
      ) as Thang6,
      sum(
          case month(DONDATSACH.NgayDat) when 7 then CHITIETDATSACH.SoLuong else 0 end
      ) as Thang7,
      sum(
          case month(DONDATSACH.NgayDat) when 8 then CHITIETDATSACH.SoLuong else 0 end
      ) as Thang8,
      sum(
          case month(DONDATSACH.NgayDat) when 9 then CHITIETDATSACH.SoLuong else 0 end
      ) as Thang9,
      sum(
          case month(DONDATSACH.NgayDat) when 10 then CHITIETDATSACH.SoLuong else 0 end
      ) as Thang10,
      sum(
          case month(DONDATSACH.NgayDat) when 11 then CHITIETDATSACH.SoLuong else 0 end
      ) as Thang11,
      sum(
          case month(DONDATSACH.NgayDat) when 12 then CHITIETDATSACH.SoLuong else 0 end
      ) as Thang12,
      sum(CHITIETDATSACH.SoLuong) as Canam
from SACH, CHITIETDATSACH, DONDATSACH
where SACH.MaSach=CHITIETDATSACH.MaSach and CHITIETDATSACH.MaHoaDon=DONDATSACH.MaHoaDon and year(DONDATSACH.NgayDat)=2021
group by CHITIETDATSACH.MaSach, TenSach
select * from Thong_ke_so_luong_sach_da_ban