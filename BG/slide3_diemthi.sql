create database DiemThiSV

create table SinhVien (
MaSV nvarchar(10) not null primary key,
HoDem nvarchar(30),
Ten nvarchar(30),
MaLop nvarchar(10) not null,
NgaySinh date
)

insert into SinhVien values 
('SV01', N'Nguyễn Thị', N'A', '61THNB', '2000-12-3'),
('SV02', N'Nguyễn Văn', N'B', '61TH6', '2001-1-5'),
('SV03', N'Phạm Thị Thảo', N'Lan', '61TH1', '2001-5-9'),
('SV04', N'Trần Hương', N'Nam', '61TH6', '2000-12-3'),
('SV05', N'Đinh Phú', N'Nghĩa', '61TH1', '2001-10-19'),
('SV06', N'Nguyễn Quang', N'Toàn', '61THNB', '2001-1-10')

create table MonHoc (
MaMon nvarchar(10) not null primary key,
TenMonHoc nvarchar(30),
SoDVHT int
)
insert into MonHoc values 
('MH01', N'Cơ sở dữ liệu', 4),
('MH02', N'Thiết kế hệ thống thông tin', 3),
('MH03', N'Công nghệ web', 3),
('MH04', N'Mạng máy tính', 3),
('MH05', N'Lập trình di động', 3)

create table DiemThi (
MaSV nvarchar(10) not null,
foreign key (MaSV) references SinhVien(MaSV),
MaMon nvarchar(10) not null,
foreign key (MaMon) references MonHoc(MaMon),
Diem float
)

insert into DiemThi values 
('SV01', 'MH02', 9),
('SV01', 'MH05', 10),
('SV03', 'MH03', 5),
('SV04', 'MH02', null),
('SV02', 'MH01', 4),
('SV06', 'MH01', 10),
('SV06', 'MH01', null)

insert into DiemThi values 
('SV05', 'MH02', 7)

select * from SinhVien
select * from MonHoc
select * from DiemThi

--Từ bảng SinhVien và bảng Diemthi, tính điểm trung
--bình của sinh viên có tên Nguyễn Ngọc Anh và hiển thị
--‘Đạt’ nếu điểm trung bình lớn hơn hoặc bằng 3.5
declare @diemTB float
select @diemTB = avg(DiemThi.Diem)
from SinhVien, DiemThi
where SinhVien.MaSV = DiemThi.MaSV and SinhVien.Ten = N'Lan' and SinhVien.HoDem = N'Phạm Thị Thảo'
if @diemTB >= 3.5
	print N'Đạt'
else print N'Sinh viên không đạt'

--Xếp loại điểm thi môn học
declare @diemTB_01 float
select @diemTB_01 = avg(DiemThi.Diem)
from DiemThi, SinhVien
where DiemThi.MaSV = SinhVien.MaSV
print cast(@diemTB_01 as char(10))
if @diemTB_01<3.5 print N'Xếp loại: Không Đạt'
else if @diemTB_01<5 print N'Xếp loại: D'
else if @diemTB_01<6.5 print N'Xếp loại: C'
else if @diemTB_01<8 print N'Xếp loại: B'
else print N'Xếp loại: A'

--hiện ra màn hình tên tháng hiện tại
declare @thanghientai nvarchar(20)
set @thanghientai = 
(
case month(GETDATE())
	when 1 then N'tháng mười hai'
	when 12 then N'tháng một'
	else 'Dont know'
end
)
print @thanghientai

--Viết lại ví dụ xếp loại SV Nguyễn Ngọc Anh vd4
declare @diemTB_02 float
select @diemTB_02 = avg(DiemThi.Diem)
from DiemThi, SinhVien
where DiemThi.MaSV = SinhVien.MaSV and SinhVien.Ten = N'A' and SinhVien.HoDem = N'Nguyễn Thị'

print N'Điểm trung bình: ' + cast(@diemTB_02 as char(10))
declare @xeploai nvarchar(30)
select @xeploai = 
(
case @diemTB_02
	when @diemTB_02 < 3.5 then N'Xếp loại: Không Đạt'
	when @diemTB_02<5 then N'Xếp loại: D'
	when @diemTB_02<6.5 then N'Xếp loại: C'
	when @diemTB_02<8 then N'Xếp loại: B'
	else N'Xếp loại: A'
end
)
print @xeploai

--Hiển thị các số từ 1 đến 9
declare @i as int
set @i = 1
while @i < 10
	begin
		print @i
		set @i=@i+1
	end

--Hiển thị MaSV, HoTen, KetQua của tất cả các sinh viên trong bảng 
--SinhVien với KetQua = ‘Còn nợ môn’ với sinh viên có môn thi chưa đạt 
--và ‘Đã qua hết’ với sinh viên đã qua hết các môn
select MaSV, HoDem, Ten, KetQua = 
(
	case
		when exists (select * from DiemThi where DiemThi.MaMon = SinhVien.MaSV and DiemThi.Diem<3.5)
		then N'Còn nợ môn'
		else N'Đã qua hết'
	end
)
from SinhVien
 --cách khác dùng ALL
 select MaSV, HoDem, Ten, KetQua = 
 (
	case
		when 3.5 >= all (select Diem from DiemThi where DiemThi.MaSV = SinhVien.MaSV) 
		then N'Còn nợ môn'
		else N'Đã qua môn'
	end
 )
 from SinhVien
 -- cách khác dùng ANY
 select MaSV, HoDem, Ten, KetQua = 
 (
	case
		when 3.5<=any (select Diem from DiemThi where DiemThi.MaSV = SinhVien.MaSV)
		then N'Đã qua môn'
		else N'Còn nợ môn'
	end
 )
 from SinhVien
 -- cách khác dùng IN  select MaSV, HoDem, Ten, KetQua = 
 (
	case
		when MaSV in (select MaSV from DiemThi where DiemThi.MaSV = SinhVien.MaSV and DiemThi.Diem>3.5)
		then N'Dã qua môn'
		else N'Còn nợ môn'
	end
 )
 from SinhVien

--try catch
declare @i_01 float
begin try
	set @i_01=10/0
end try

begin catch
	select ERROR_MESSAGE() as errorMessage, ERROR_SEVERITY()
end catch

--Hãy viết thủ tục hiển thị MaSV, HoTen, TenMon, 
--Diem của tất cả sinh viên.create procedure thongtinSVasbegin	select SinhVien.MaSV, HoDem, Ten, TenMonHoc, Diem	from SinhVien, DiemThi, MonHoc	where SinhVien.MaSV = DiemThi.MaSV and MonHoc.MaMon = DiemThi.MaMonendthongtinSV--Bổ sung thêm môn học Lập trình web có mã Web và số
--đơn vị học trình là 2 vào bảng MONHOCcreate proc sp_LenDSachDiem (@mamonhoc nvarchar(10), @tenmonhoc nvarchar(30), @sodvht int)asbegin	insert into MonHoc values	(@mamonhoc, @tenmonhoc, @sodvht)end sp_LenDSachDiem 'MH10', 'Tiếng anh chuyên ngành', 3--: Viết thủ tục không có tham số hiển thị MaSV, HoTen, Diem của 
--những sinh viên có điểm cao nhất môn Cơ sở dữ liệu 
create proc sp_maxdiemCSDL
as
begin
	declare @csdl nvarchar(30)
	select @csdl = (select MaMon from MonHoc where TenMonHoc = N'Cơ sở dữ liệu')

	declare @maxDiem as float
	select @maxDiem = max(DiemThi.Diem) from DiemThi where DiemThi.MaMon = @csdl
	
	select SinhVien.MaSV, HoDem, Ten, Diem from SinhVien, DiemThi where SinhVien.MaSV=DiemThi.MaSV
	and DiemThi.Diem = @maxDiem
end
sp_maxdiemCSDL

--Viết thủ tục hiển thị MaSV, HoTen, Diem của những sinhviên cóđiểm cao
--nhất một môn học với tên môn là tham sốtruyền vào
create proc sp_maxDiemCoThamSo (@tenMon nvarchar(30))
as
begin
	declare @maMon as nvarchar(10)
	select @maMon = (select MaMon from MonHoc where TenMonHoc = @tenMon)
	declare @maxDiem as float
	select @maxDiem = max(DiemThi.Diem) from DiemThi where MaMon = @maMon

	select SinhVien.MaSV, HoDem, Ten, Diem from SinhVien, DiemThi
	where SinhVien.MaSV = DiemThi.MaSV and DiemThi.MaMon = @maMon and DiemThi.Diem = @maxDiem
end
sp_maxDiemCoThamSo N'Cơ sở dữ liệu'

select * from SinhVien
select * from MonHoc
select * from DiemThi

-- Xây dựng thủ tục hiển thị danh sách sinh viên theo mã lớp
create proc sp_displaySV @lop nvarchar(10) = '61TH%'
as
begin
	select MaSV, HoDem, Ten from SinhVien where MaLop like @lop
end
sp_displaySV '61THNB'