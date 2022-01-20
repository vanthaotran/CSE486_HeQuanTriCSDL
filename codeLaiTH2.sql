use QuanLyCuaHang
--1) Bổ sung ràng buộc thiết lập giá trị mặc định bằng 1 cho cột SOLUONG và bằng 0 cho cột
--MUCGIAMGIA trong bảng CHITIETDATHANG.

--2) Bổ sung cho bảng DONDATHANG ràng buộc kiểm tra ngày giao hàng và ngày chuyển
--hàng phải sau hoặc bằng với ngày đặt hàng.

--3) Bổ sung ràng buộc cho bảng NHANVIEN để đảm bảo rằng một nhân viên chỉ có thể làm
--việc trong công ty khi đủ 18 tuổi và không quá 60 tuổi
alter table NhanVien
add check ((datediff(year, year(NgayLamViec), year(NgaySinh))) >= 18)
alter table NhanVien
add check ((datediff(year, year(NgaySinh), year(getdate()))) < 60)
--4) Cho biết danh sách các đối tác cung cấp hàng cho công ty.
select * from NhaCungCap
--5) Cho biết mã hàng, tên hàng và số lượng của các mặt hàng hiện có trong công ty.

--6) Cho biết Họ tên và địa chỉ và năm bắt đầu làm việc của các nhân viên.

--7) Cho biết Địa chỉ và điện thoại của nhà cung cấp có tên giao dịch VINAMILK là gì?

--8) Cho biết mã và tên của các mặt hàng có giá lớn hơn 100000 và số lượng hiện có ít hơn 50.

--9) Cho biết mỗi mặt hàng trong công ty do ai cung cấp.
select TenHang, TenCongTy
from MatHang join NhaCungCap
on MatHang.MaCongTy = NhaCungCap.MaCongTy
select * from NhaCungCap
select * from MatHang
--10)Công ty Việt Tiến đã cung cấp những mặt hàng nào?
--11) Loại hàng thực phẩm do những công ty nào cung cấp và địa chỉ của các công ty đó là gì?

--12)Những khách hàng nào (tên giao dịch) đã đặt mua mặt hàng Sữa hộp XYZ của công ty?

--13) Đơn đặt hàng số 1 do ai đặt và do nhân viên nào lập, thời gian và địa điểm giao hàng là ở
--đâu?

--14) Hãy cho biết số tiền lương mà công ty phải trả cho mỗi nhân viên là bao nhiêu
--(lương = lương cơ bản + phụ cấp)
select (LuongCoBan*PhuCap) as Luong, Ten
from NhanVien
--15)Trong đơn đặt hàng số 3 đặt mua những mặt hàng nào và số tiền mà khách hàng phải trả
--cho mỗi mặt hàng là bao nhiêu? Số tiền phải trả được tính theo công thức:
--SOLUONG×GIABAN – SOLUONG×GIABAN×MUCGIAMGIA/100).
select distinct (ChiTietDatHang.SoLuong*GiaBan - ChiTietDatHang.SoLuong*GiaBan*MucGiamGia/100) as TienPhaiTra, TenHang
from ChiTietDatHang join MatHang
on MatHang.MaHang = ChiTietDatHang.MaHang
--16) Hãy cho biết có những khách hàng nào lại chính là đối tác cung cấp hàng của công ty (tức
--là có cùng tên giao dịch).
select MaKhachHang, MaCongTy, NhaCungCap.TenGiaoDich
from KhachHang join NhaCungCap
on KhachHang.TenGiaoDich = NhaCungCap.TenGiaoDich
select * from NhaCungCap
select * from KhachHang
--17) Trong công ty có những nhân viên nào có cùng ngày sinh?
select * from NhanVien
where NgaySinh in (
	select NgaySinh from NhanVien
	group by NgaySinh having count(*)>1
)
--18) Những đơn đặt hàng nào yêu cầu giao hàng ngay tại công ty đặt hàng và những đơn đó là
--của công ty nào?
select * from DonDatHang
join KhachHang on DonDatHang.MaKhachHang = KhachHang.MaKhachHang
where NoiGiaoHang = TenCongTy
--19) Cho biết tên công ty, tên giao dịch, địa chỉ và điện thoại của các khách hàng và các nhà
--cung cấp hàng cho cửa hàng.

--20) Những mặt hàng nào chưa từng được khách hàng đặt mua?
select MaHang, TenHang
from MatHang
where not exists (select MaHang from ChiTietDatHang where MatHang.MaHang = ChiTietDatHang.MaHang)
--21) Những nhân viên nào của công ty chưa từng lập bất kỳ một hoá đơn đặt hàng nào?
select MaNhanVien, Ten
from NhanVien
where not exists (
select MaNhanVien from DonDatHang where DonDatHang.MaNhanVien = NhanVien.MaNhanVien
)
--22) Những nhân viên nào của công ty có lương cơ bản cao nhất?

--23)Tổng số tiền mà khách hàng phải trả cho mỗi đơn đặt hàng là bao nhiêu?
--24) Năm 2020, những mặt hàng nào chỉ được đặt mua đúng một lần.
--25) Hãy cho biết tổng số tiền của mỗi khách hàng đã bỏ ra để mua hàng của công ty.
--26) Mỗi một nhân viên của công ty đã lập bao nhiêu đơn đặt hàng (nếu nhân viên chưa từng
--lập hóa đơn nào thì trả về kết quả bằng 0).
--27) Cho biết tổng số tiền hàng mà cửa hàng thu được trong mỗi tháng của năm 2020.
--28) Cho biết tổng số tiền lãi mà công ty thu được từ mỗi mặt hàng trong năm 2020. (thời gian
--được tính theo ngày đặt hàng)
--29) Cho biết tổng số lượng hàng của mỗi mặt hàng mà công ty đã có (gồm tổng số lượng hàng
--đã bán và lượng hàng hiện có).
--30)Nhân viên nào của công ty bán được số lượng hàng nhiều nhất và số lượng hàng bán được
--của các nhân viên này là bao nhiêu?
--31) Đơn đặt hàng nào có số lượng hàng được đặt mua ít nhất?

--32) Số tiền nhiều nhất mà mỗi khách hàng đã từng bỏ ra để đặt hàng trong các đơn đặt hàng là
--bao nhiêu?
--33) Mỗi một đơn đặt hàng đặt mua những mặt hàng nào và tổng số tiền mà mỗi đơn đặt hàng
--phải trả bao nhiêu?

--34) Hãy cho biết mỗi loại hàng bao gồm những mặt hàng nào, tổng số lượng hàng của mỗi
--loại và tổng số lượng của tất cả các mặt hàng hiện có trong công ty là bao nhiêu?
--35) Thống kê xem trong năm 2020 mỗi một mặt hàng trong mỗi tháng và trong cả năm bán
--được với số lượng bao nhiêu?
--(yêu cầu: Kết quả được hiển thị dưới dạng bảng, hai cột đầu là mã hàng và tên hàng, các
--cột còn lại tương ứng với các tháng từ 1 đến 12 và cả năm).
select ChiTietDatHang.MaHang, TenHang, 
	sum(case month(NgayDatHang) when 1 then ChiTietDatHang.SoLuong else 0 end) as Thang1,
	sum(case month(NgayDatHang) when 2 then ChiTietDatHang.SoLuong else 0 end) as Thang2,
	sum(case month(NgayDatHang) when 3 then ChiTietDatHang.SoLuong else 0 end) as Thang3,
	sum(case month(NgayDatHang) when 4 then ChiTietDatHang.SoLuong else 0 end) as Thang4,
	sum(case month(NgayDatHang) when 5 then ChiTietDatHang.SoLuong else 0 end) as Thang5,
	sum(case month(NgayDatHang) when 6 then ChiTietDatHang.SoLuong else 0 end) as Thang6,
	sum(case month(NgayDatHang) when 7 then ChiTietDatHang.SoLuong else 0 end) as Thang7,
	sum(case month(NgayDatHang) when 8 then ChiTietDatHang.SoLuong else 0 end) as Thang8,
	sum(case month(NgayDatHang) when 9 then ChiTietDatHang.SoLuong else 0 end) as Thang9,
	sum(case month(NgayDatHang) when 10 then ChiTietDatHang.SoLuong else 0 end) as Thang10,
	sum(case month(NgayDatHang) when 11 then ChiTietDatHang.SoLuong else 0 end) as Thang11,
	sum(case month(NgayDatHang) when 12 then ChiTietDatHang.SoLuong else 0 end) as Thang12,
	sum(ChiTietDatHang.SoLuong) as canam
from MatHang inner join ChiTietDatHang on MatHang.MaHang = ChiTietDatHang.MaHang
inner join DonDatHang on DonDatHang.SoHoaDon = ChiTietDatHang.SoHoaDon
