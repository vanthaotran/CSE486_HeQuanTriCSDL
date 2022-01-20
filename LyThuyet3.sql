create proc sp_Tong2So @x float, @y float, @sum float output
as
begin
	set @sum = @x+@y
	print @sum
end
drop procedure sp_Tong2So

declare @tong float
exec sp_Tong2So 3,4, @sum=@tong output
-----------------------------------------------------------------------
create function tinhtong (@xx float, @yy float)
returns float
as
begin		
	declare @sum float
	set @sum =  @xx+@yy
	return @sum
end
print dbo.tinhtong(3,4)
---------------------------------------------------------------------------
--1. Hàm đưa ra các thông tin của sinh viên theo từng khóa
create function dssv_khoa (@khoa int)
returns @bien table (masv char(5), hodem nvarchar(30), ten nvarchar(300)
as
begin
	insert into @bien
		select masv, hodem, ten
			from sinhvien join lop
			on sinhvien.malop = lop.malop
			wh
	return
end

--2. Thống kê số lượng sinh viên theo mã khoa
create function slsv_makhoa (@khoa nvarchar(30))
returns @bien table (makhoa nvarchar(10), tenkhoa nvarchar(20), SoLuong int)
as
begin
	insert into @bien
	select makhoa, tenkhoa, SoLuong = 
	(count(masv)
		from sinhvien 
		join lop on sinhvien.malop = lop.malop
		join khoa on khoa.makhoa = lop.makhoa
		group by makhoa, tenkhoa
	)
	return
end

create procedure dssv @tenTinh nvarchar(30)=N'%Hà Nội%'
as
begin
	select * from sinhvien where noisinh like @tenTinh
end
execute dssv N''
------------------------------------------------------------------ thủ tục trả về con trỏ cursor
create procedure thutuc @gioitinh bit, @dssv cursor varying output
as
begin
	set @dssv = cursor
	for
	select * from sinhvien where gioitinh=@gioitinh
	open @dssv
end
---- gọi ra để dùng thủ tục đó
declare @myCur cursor
exec thutuc 0, @dssv =@myCur output
fetch next from @myCur
while(@@fetch_status = 0)
	fetch next from @myCur
close @myCur
deallocate @myCur

create function slsv_mon (@tenmon nvarchar(30))
returns int
as
begin
	declare @sl int
	select @sl = count(masv)...
	return @sl
end

--Bài 1: Viết hàm tính độ tuổi trung bình của Sinh Viên trong 
--bảng SinhVien
alter table
add Tuoi int

update table sinhvien set tuoi=year(getdate())-year(ngaysinh)

create function f_avgAgeSV ()
returns float
as
begin
	declare @avgTuoi float
	set @avgTuoi = (select avg(Tuoi) from sinhvien)
	return @avgTuoi
end
print dbo.f_avgAgeSV ()
--Bài 2: Viết hàm trả về danh sách các môn thi của một
--sinh viên có điểm cao hơn điểm trung bình tất cả các
--môn của sinh viên đó./ max diem cua sinh vien do dat duoc
create function f_monthi
returns @bang table (masv, mamon, tenmon, )
as
begin
	insert into @bang 
	select masv, mamonhoc, tenmonhoc
	from diemthi, monhoc, sinhvien 
	where diemthi.mamonhoc = monhoc.mamonhoc and sinhvien.masv = diemthi.masv
	where diemthi.diem = max(diem)
end

------------------------------------------------------------------ trigger sql
use QLKhachHang
create trigger insert_trigger_KH
on KhachHang
for insert
as print N'Bạn đã chèn thành công khách hàng'

insert into KhachHang values(N'Phạm Văn 
HoàngA','Nam',N' Đống Đa', 'hoang@jhkf', '3545')