----------------------------------------------------BÀI THỰC HÀNH 2 NGÀY 06/12/2021----------------------------------------------------
--1) Bổ sung ràng buộc thiết lập giá trị mặc định bằng 1 cho cột SOLUONG và bằng 0 cho cột 
--MUCGIAMGIA trong bảng CHITIETDATHANG.
alter table ChiTietDatHang 
add constraint df_SoLuong
default 0 for SoLuong

alter table ChiTietDatHang 
add constraint df_MucGiamGia
default 0 for MucGiamGia

--2) Bổ sung cho bảng DONDATHANG ràng buộc kiểm tra ngày giao hàng và ngày chuyển 
--hàng phải sau hoặc bằng với ngày đặt hàng. not yet\

--declare @ngaygiaohang date
--set @ngaygiaohang = (select NgayGiaoHang from DonDatHang)
--declare @ngaychuyenhang date
--set @ngaychuyenhang = (select NgayChuyenHang from DonDatHang)
--declare @ngaydathang date
--set @ngaydathang = (select NgayDatHang from DonDatHang)
--declare @sqlcmd_02 nvarchar(1000), @tableNameDonDatHang nvarchar(100)
--set @tableNameDonDatHang = 'DonDatHang'
--set @sqlcmd_02 = 'alter table ' + @tableNameDonDatHang + 
--'add constraint checkdate check (
--	cast('+ cast(@ngaychuyenhang as char(100)) + 'as date) <= cast(' + cast(@ngaydathang as char(100)) + 'as date)
--	and
--	cast(' + cast(@ngaygiaohang as char(100)) + 'as date) <= cast(' + cast(@ngaydathang as char(100)) + 'as date)
--)'
--exec(@sqlcmd_02)

alter table DonDatHang
add constraint chkday check 
(	
	day(NgayGiaoHang) >= day(NgayDatHang)				
	and day(NgayChuyenHang) >= day(NgayDatHang)	
	and month(NgayGiaoHang) >= month(NgayDatHang)				
	and month(NgayChuyenHang) >= month(NgayDatHang)
	and year(NgayGiaoHang) >= year(NgayDatHang)				
	and year(NgayChuyenHang) >= year(NgayDatHang)
)
--3) Bổ sung ràng buộc cho bảng NHANVIEN để đảm bảo rằng một nhân viên chỉ có thể làm 
--việc trong công ty khi đủ 18 tuổi và không quá 60 tuổi
--declare @ngaysinh as date
--set @ngaysinh = (select NgaySinh from NhanVien)
--declare @18years as int
--set @18years = (select datediff(year, @ngaysinh, GETDATE() ) )
--declare @60years as int
--set @60years = (select datediff(year, @ngaysinh, GETDATE() ) )
--declare @sqlcmd_checkage as nvarchar(1000), @tableNameNhanVien nvarchar(100)
--set @tableNameNhanVien = 'NhanVien'
--set @sqlcmd_checkage = 'alter table' + @tableNameNhanVien +
--'add check (
--	' + @18years + '>= 18
--	and 
--	' + @60years + '<= 60
--)'
--exec(@sqlcmd_checkage)

alter table NhanVien
add constraint check_age check 
(	
	year(NgayLamViec) - year(NgaySinh) >= 18
	or
	year(NgayLamViec) - year(NgaySinh) <= 60
)
select * from NhanVien

--4) Cho biết danh sách các đối tác cung cấp hàng cho công ty.
select TenCongTy from NhaCungCap
--5) Cho biết mã hàng, tên hàng và số lượng của các mặt hàng hiện có trong công ty.
select MaHang, TenHang, SoLuong from MatHang
--6) Cho biết Họ tên và địa chỉ và năm bắt đầu làm việc của các nhân viên.
select Ho, Ten, DiaChi, year(NgayLamViec) as NgayBatDauLamViec from NhanVien
--7) Cho biết Địa chỉ và điện thoại của nhà cung cấp có tên giao dịch VINAMILK là gì?
select DiaChi, DienThoai from NhaCungCap 
where TenGiaoDich = 'VINAMILK'
--8) Cho biết mã và tên của các mặt hàng có giá lớn hơn 100000 và số lượng hiện có ít hơn 50.
select MaHang, TenHang 
from MatHang
where (GiaHang > 100000) and (SoLuong < 50)
--9) Cho biết mỗi mặt hàng trong công ty do ai cung cấp.
select TenHang, TenCongTy
from MatHang, NhaCungCap
where MatHang.MaCongTy = NhaCungCap.MaCongTy
--10)Công ty Việt Tiến đã cung cấp những mặt hàng nào?
select TenHang from MatHang, NhaCungCap
where (MatHang.MaCongTy = NhaCungCap.MaCongTy) and (TenCongTy = N'Việt Tiến')
--11) Loại hàng thực phẩm do những công ty nào cung cấp đó là gì?
select TenCongTy from NhaCungCap, LoaiHang, MatHang
where (LoaiHang.MaLoaiHang = MatHang.MaLoaiHang) and (MatHang.MaCongTy = NhaCungCap.MaCongTy)
and (TenLoaiHang = N'Thực Phẩm') or (TenLoaiHang = N'thực phẩm')
--12)Những khách hàng nào (tên giao dịch) đã đặt mua mặt hàng Sữa hộp XYZ của công ty?
select TenGiaoDich from KhachHang, DonDatHang, ChiTietDatHang, MatHang
where KhachHang.MaKhachHang = DonDatHang.MaKhachHang and DonDatHang.SoHoaDon = ChiTietDatHang.SoHoaDon
and ChiTietDatHang.MaHang = MatHang.MaHang and (TenHang = N'Sữa hộp XYZ')
--13)Đơn đặt hàng số 1 do ai đặt và do nhân viên nào lập, thời gian và địa điểm giao
--hàng là ở đâu?
select SoHoaDon, TenCongTy, Ten, NgayDatHang, NgayGiaoHang, NgayChuyenHang, NoiGiaoHang
from DonDatHang, KhachHang, NhanVien
where DonDatHang.MaKhachHang = KhachHang.MaKhachHang and DonDatHang.MaNhanVien = NhanVien.MaNhanVien
and SoHoaDon = 'HD01'
--14) Hãy cho biết số tiền lương mà công ty phải trả cho mỗi nhân viên là bao nhiêu
--(lương = lương cơ bản * phụ cấp)
alter table NhanVien
add Luong float

update NhanVien set Luong = LuongCoBan*PhuCap
select * from NhanVien
--15)Trong đơn đặt hàng số 3 đặt mua những mặt hàng nào và số tiền mà khách hàng
--phải trả cho mỗi mặt hàng là bao nhiêu? Số tiền phả trả được tính theo công thức: 
--SOLUONG×GIABAN – SOLUONG×GIABAN×MUCGIAMGIA/100).
alter table ChiTietDatHang
add TongTienPhaiTra float

update ChiTietDatHang set TongTienPhaiTra = (SoLuong*GiaBan) - (SoLuong*GiaBan*MucGiamGia/100)
select * from ChiTietDatHang
select DonDatHang.SoHoaDon, TenHang, TongTienPhaiTra
from DonDatHang, MatHang, ChiTietDatHang
where DonDatHang.SoHoaDon = ChiTietDatHang.SoHoaDon and MatHang.MaHang = ChiTietDatHang.MaHang
and DonDatHang.SoHoaDon = 'HD03'
--16) Hãy cho biết có những khách hàng nào lại chính là đối tác cung cấp hàng của
--công ty (tức là có cùng tên giao dịch).
select KhachHang.TenCongTy, KhachHang.TenGiaoDich, NhaCungCap.TenGiaoDich
from KhachHang, NhaCungCap
where KhachHang.TenGiaoDich = NhaCungCap.TenGiaoDich
--17) Trong công ty có những nhân viên nào có cùng ngày sinh?
select * from NhanVien
where NgaySinh in (
	select NgaySinh from NhanVien
	group by NgaySinh having count(*)>1
)
--18) Những đơn đặt hàng nào yêu cầu giao hàng ngay tại công ty đặt hàng và những đơn đó là 
--của công ty nào? tencongty trung voi noi giao hang
select SoHoaDon, NoiGiaoHang, TenCongTy 
from KhachHang, DonDatHang
where DonDatHang.MaKhachHang = KhachHang.MaKhachHang and
NoiGiaoHang = TenCongTy
--19) Cho biết tên công ty, tên giao dịch, địa chỉ và điện thoại của các khách hàng và các nhà 
--cung cấp hàng cho cửa hàng.
select KhachHang.TenCongTy, KhachHang.TenGiaoDich, KhachHang.DiaChi, KhachHang.DienThoai,
	NhaCungCap.TenCongTy, NhaCungCap.TenGiaoDich, NhaCungCap.DiaChi, NhaCungCap.DienThoai
from KhachHang
inner join NhaCungCap on KhachHang.TenCongTy = NhaCungCap.TenCongTy
--20) Những mặt hàng nào chưa từng được khách hàng đặt mua?
(select MaHang from MatHang)
EXCEPT   
(select MaHang from ChiTietDatHang)
--21) Những nhân viên nào của công ty chưa từng lập bất kỳ một hoá đơn đặt hàng
--nào?
select Ho, Ten, SoHoaDon 
from NhanVien
inner join DonDatHang
on NhanVien.MaNhanVien = DonDatHang.MaNhanVien
where SoHoaDon is null
--22) Những nhân viên nào của công ty có lương cơ bản cao nhất?
select Ho, Ten, Luong
from NhanVien
where Luong in
(select max(Luong) from NhanVien)
--23) Năm 2020, những mặt hàng nào chỉ được đặt mua đúng một lần.
select TenHang from MatHang
inner join ChiTietDatHang
on MatHang.MaHang = ChiTietDatHang.MaHang
inner join DonDatHang
on ChiTietDatHang.SoHoaDon = DonDatHang.SoHoaDon
where year(NgayDatHang)=2020
--24) Hãy cho biết tổng số tiền của mỗi khách hàng đã bỏ ra để mua hàng của công ty.
select TenCongTy as TenKH, TongTienPhaiTra
from KhachHang, DonDatHang, ChiTietDatHang
where KhachHang.MaKhachHang = DonDatHang.MaKhachHang 
and DonDatHang.SoHoaDon = ChiTietDatHang.SoHoaDon
--25) Mỗi một nhân viên của công ty đã lập bao nhiêu đơn đặt hàng (nếu nhân viên chưa từng lập 
--hóa đơn nào thì trả về kết quả bằng 0). ??
alter table DonDathang
add SoLanLenDon int
select * from DonDathang

declare @i as int
set @i = 1

--declare @solanlendon int
--select @solanlendon = count(SoHoaDon) from DonDatHang group by MaNhanVien
--print @solanlendon

while @i < (select count(*) from NhanVien)
begin
	 if (select count(SoHoaDon) from DonDatHang group by MaNhanVien > 0)
		update NhanVien set SoLanLenDon = 1
	 else 
		update NhanVien set SoLanLenDon = 0
end
select * from NhanVien
left join DonDatHang
on NhanVien.MaNhanVien = DonDatHang.MaNhanVien
-- chữa
select NhanVien.MaNhanVien, count(DonDatHang.MaNhanVien) as SoLanDatHang
from NhanVien left join DonDatHang
on NhanVien.MaNhanVien = DonDatHang.MaNhanVien
group by DonDatHang.MaNhanVien, NhanVien.MaNhanVien
-- cách khác
select KhachHang.IDKhachHang, sum(TongTien) as TongTien
from ( select KhachHang.IDKhachHang as khachhang, sum(SoLuong*GiaBan - (SoLuong*GiaBan*MucGiamGia)/100) as Tong Tien
		from KhachHang, DonDatHang, ChiTietDatHang
		where KhachHang.IDKhachHang = DonDatHang.IDKhachHang and DonDatHang.SoHoaDon = ChiTietDatHang.SoHoaDon
		group by ChiTietDatHang.SoHoaDon, KhachHang.IDKhachHang, DonDatHang.SoHoaDon
) as KhachHang group by KhachHang.IDKhachHang
--26)ok Cho biết tổng số tiền hàng mà cửa hàng thu được trong mỗi tháng của năm 2020.TongTienPhaiTra in ChiTietDatHang
select month(NgayDatHang) as TheMonth, TongTienPhaiTra
from DonDatHang
inner join ChiTietDatHang
on DonDatHang.SoHoaDon = ChiTietDatHang.SoHoaDon

--27) Cho biết tổng số tiền lãi mà công ty thu được từ mỗi mặt hàng trong năm 2020.
select MatHang.MaHang, 
		(sum(ChiTietDatHang.SoLuong*GiaBan-(ChiTietDatHang.SoLuong*GiaBan*MucGiamGia)/100)
		- sum(ChiTietDatHang.SoLuong*GiaHang)) as TienLai
		from ChiTietDatHang, MatHang, DonDatHang
		where ChiTietDatHang.MaHang = MatHang.MaHang and ChiTietDatHang.MaHang = MatHang.MaHang and year(DonDatHang.NgayDatHang)=2021
		group by ChiTietDatHang.MaHang, MatHang.MaHang
--28) Cho biết tổng số lượng hàng của mỗi mặt hàng mà công ty đã có (gồm tổng số lượng hàng 
--đã bán và lượng hàng hiện có). proc ok, 2 var for quantity of two columns
alter table MatHang
add TongLuongHang int

update MatHang
set TongLuongHang = MatHang.SoLuong + ChiTietDatHang.SoLuong
from MatHang
inner join ChiTietDatHang on MatHang.MaHang = ChiTietDatHang.MaHang  
select * from MatHang
-- bài chữaaaaa
select MatHang.MaHang, TenHang, MatHang.SoLuong +
	case
		when sum(ChiTietDatHang.SoLuong) is null then 0
		else sum(ChiTietDatHang.SoLuong)
	end as tong_so_luong
from MatHang left outer join ChiTietDatHang on MatHang.MaHang=ChiTietDatHang.MaHang
group by MatHang.MaHang, TenHang, MatHang.SoLuong

--29)Nhân viên nào của công ty bán được số lượng hàng nhiều nhất và số lượng hàng bán được proc ok!
select Ten, SoLuong
from NhanVien
inner join DonDatHang
on nhanvien.MaNhanVien = DonDatHang.MaNhanVien
inner join ChiTietDatHang
on DonDatHang.SoHoaDon = ChiTietDatHang.SoHoaDon
where SoLuong = (select sum(SoLuong) from ChiTietDatHang)

create proc maxSLgMua
as
begin	
	declare @maxSLg int
	select @maxSLg = max(SoLuong) from ChiTietDatHang
	print @maxSLg
	select Ten, SoLuong
	from NhanVien
	inner join DonDatHang
	on nhanvien.MaNhanVien = DonDatHang.MaNhanVien
	inner join ChiTietDatHang
	on DonDatHang.SoHoaDon = ChiTietDatHang.SoHoaDon
	where SoLuong = @maxSLg
end
maxSLgMua

-- bài chữa của cô
select NhanVien.MaNhanVien, Ho+' '+ Ten as hoten, sum(SoLuong) as Max_so_luong_hang
from NhanVien inner join DonDatHang on NhanVien.MaNhanVien=DonDatHang.MaNhanVien
				inner join ChiTietDatHang on DonDatHang.SoHoaDon = ChiTietDatHang.SoHoaDon
group by NhanVien.MaNhanVien, NhanVien.Ho, NhanVien.Ten
having sum(SoLuong) >= all (select sum(SoLuong)
							from NhanVien inner join DonDatHang on NhanVien.MaNhanVien = DonDatHang.MaNhanVien
											inner join ChiTietDatHang on DonDatHang.SoHoaDon = ChiTietDatHang.SoHoaDon
							group by NhanVien.MaNhanVien, Ho, Ten)

--30) Đơn đặt hàng nào có số lượng hàng được đặt mua ít nhất? proc okkk!
select DonDatHang.SoHoaDon from DonDatHang
inner join ChiTietDatHang
on DonDatHang.SoHoaDon = ChiTietDatHang.SoHoaDon
where SoLuong = (select min(SoLuong) from ChiTietDatHang)

create proc minSLgMua
as
begin	
	declare @minSLg int
	select @minSLg = min(SoLuong) from ChiTietDatHang
	print @minSLg
	select DonDatHang.SoHoaDon from DonDatHang
	inner join ChiTietDatHang
	on DonDatHang.SoHoaDon = ChiTietDatHang.SoHoaDon
	where SoLuong = @minSLg
end
minSLgMua

-- bài cô chữua
-- như bài trên thay >= bằng <= all.....

--31) Số tiền nhiều nhất mà mỗi khách hàng đã từng bỏ ra để đặt hàng trong các đơn đặt hàng là 
--bao nhiêu? proc??
alter table ChiTietDatHang
add TongTienPhaiTra float
update ChiTietDatHang set TongTienPhaiTra=(GiaBan*SoLuong)-(GiaBan*SoLuong*MucGiamGia)
select * from ChiTietDatHang

select max(TongTienPhaiTra) as TienMax, MaKhachHang from ChiTietDatHang
inner join DonDatHang
on ChiTietDatHang.SoHoaDon = DonDatHang.SoHoaDon
group by MaKhachHang
select * from ChiTietDatHang

create proc sp_maxTienPhaiTra
as
begin 
	declare @maxTien float
	select @maxTien = max(TongTienPhaiTra) from ChiTietDatHang 
	inner join DonDatHang
	on ChiTietDatHang.SoHoaDon = DonDatHang.SoHoaDon
	group by MaKhachHang
	print @maxTien
end
sp_maxTienPhaiTra

-- bài cô chữa
select top 1
sum(SoLuong*GiaBan-SoLuong*GiaBan*MucGiamGia/100) 
from DonDatHang inner join ChiTietDatHang on DonDatHang.SoHoaDon=ChiTietDatHang.SoHoaDon
order by 1 desc
--32) Mỗi một đơn đặt hàng đặt mua những mặt hàng nào và tổng số tiền mà mỗi đơn đặt hàng 
--phải trả bao nhiêu? no no no
select SoHoaDon, ChiTietDatHang.MaHang, MatHang.TenHang
from MatHang, ChiTietDatHang
where MatHang.MaHang = ChiTietDatHang.MaHang

-- bài cô chữua
select DonDatHang.SoHoaDon, sum(ChiTietDatHang.SoLuong*GiaBan-ChiTietDatHang.SoLuong*GiaBan*MucGiamGia/100) as TongTien, ChiTietDatHang.MaHang
from (DonDatHang inner join ChiTietDatHang on DonDatHang.SoHoaDon = ChiTietDatHang.SoHoaDon)
			inner join MatHang on ChiTietDatHang.MaHang = MatHang.MaHang
group by DonDatHang.SoHoaDon, ChiTietDatHang.MaHang with rollup

compute sum(b.soluong*giaban-b.soluong*giaban*mucgiamgia/100) by a.sohoadon


--33) Hãy cho biết mỗi loại hàng bao gồm những mặt hàng nào, tổng số lượng hàng của mỗi loại 
--và tổng số lượng của tất cả các mặt hàng hiện có trong công ty là bao nhiêu?
select MaHang from MatHang
inner join LoaiHang
on MatHang.MaLoaiHang = LoaiHang.MaLoaiHang
group by TenLoaiHang

select MaHang from MatHang inner join LoaiHang
on MatHang.MaLoaiHang = LoaiHang.MaLoaiHang
group by LoaiHang.MaLoaiHang

--34) Thống kê xem trong năm 2020 mỗi một mặt hàng trong mỗi tháng và trong cả năm bán 
--được với số lượng bao nhiêu
select month(NgayDatHang) as month, ChiTietDatHang.SoLuong, ChiTietDathang.MaHang, TenHang
from ChiTietDatHang
inner join DonDatHang
on ChiTietDatHang.SoHoaDon = DonDatHang.SoHoaDon
inner join MatHang on MatHang.MaHang = ChiTietDatHang.MaHang
where year(NgayDatHang) = 2020
-- khac ? not yet
declare @var as int
set @var = (select month(NgayDatHang) from DonDatHang where year(NgayDatHang)=2020)

select month(NgayDatHang) as month, ChiTietDatHang.SoLuong, ChiTietDathang.MaHang, TenHang
from ChiTietDatHang, DonDatHang, MatHang
where ChiTietDatHang.SoHoaDon = DonDatHang.SoHoaDon and MatHang.MaHang = ChiTietDatHang.MaHang and 


-- bài chữa của cô
select ChiTietDatHang.MaHang, TenHang,
	sum(case month(NgayDatHang) when 1 then ChiTietDatHang.SoLuong else 0 end) as thang1,
	sum(case month(NgayDatHang) when 2 then ChiTietDatHang.SoLuong else 0 end) as thang2,
	sum(case month(NgayDatHang) when 3 then ChiTietDatHang.SoLuong else 0 end) as thang3,
	sum(case month(NgayDatHang) when 4 then ChiTietDatHang.SoLuong else 0 end) as thang4,
	sum(case month(NgayDatHang) when 5 then ChiTietDatHang.SoLuong else 0 end) as thang5,
	sum(case month(NgayDatHang) when 6 then ChiTietDatHang.SoLuong else 0 end) as thang6,
	sum(case month(NgayDatHang) when 7 then ChiTietDatHang.SoLuong else 0 end) as thang7,
	sum(case month(NgayDatHang) when 8 then ChiTietDatHang.SoLuong else 0 end) as thang8,
	sum(case month(NgayDatHang) when 9 then ChiTietDatHang.SoLuong else 0 end) as thang9,
	sum(case month(NgayDatHang) when 10 then ChiTietDatHang.SoLuong else 0 end) as thang10,
	sum(case month(NgayDatHang) when 11 then ChiTietDatHang.SoLuong else 0 end) as thang11,
	sum(case month(NgayDatHang) when 12 then ChiTietDatHang.SoLuong else 0 end) as thang12
from MatHang inner join ChiTietDatHang on ChiTietDatHang.MaHang = MatHang.MaHang
			inner join DonDatHang on DonDatHang.SoHoaDon = ChiTietDatHang.SoHoaDon
