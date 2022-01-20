--Tạo trigger hiển thị thông báo mỗi khi thực hiện chèn thành công
--một bản ghi vào bảng KhachHang của CSDL QuanLyKhachHang

create trigger trig_insert_KH
on KhachHang
for insert
as print N'Bạn đã chèn thành công'
insert into KhachHang values (N'Phạm Văn 
HoàngA','Nam',N' Đống Đa', 'hoang@jhkf', '3545')

--Tạo trigger thực hiện tự động tính trường ThanhTien của bảng
--SP_DonHang(IDDonHang, IDSanPham, SoLuong, ThanhTien) khi thêm
--một bản ghi mới gồm IDDonHang, IDSanPham và SoLuong
create trigger thanhtien
on SP_DonHang
for insert 
as
	if ((select IDSanPham from inserted) is not null)
	begin
		update SP_DonHang
		set thanhtien = soluong*dongia
		from sanpham, (select IDSanPham, IDDonHang from inserted) as I
		where SanPham.IDSanPham=SP_DonHang.IDSanpham and
			SP_DonHang.IDSanpham=I.IDSanpham and
			SP_DonHang.IDDonhang=I.IDDonhang
	end

--Cho bảng NHANVIEN (MaNV, Hoten, Ngaysinh,…).Viết
--một trigger để đảm bảo rằng khi thêm một nhân viên mới vào thì tuổi
--của nhân viên không được >=45
create trigger check_age
on NhanVien
after insert
as
begin
	declare @tuoi_moi int
	set @tuoi_moi = (select year(GETDATE()) - year(NgaySinh) as tuoimoinv from inserted)
	if(@tuoi_moi > 45 )
		begin
			print N'Nhân viên không được phép quá 45 tuổi'
		end
end

--Tạo trigger hiển thị thông báo mỗi khi thực hiện cập nhật thành
--công một bản ghi của bảng KhachHang của CSDL QuanLyKhachHang
create trigger update_trigger_KH
on KhachHang
for update
as
print N'Bạn đã cập nhật thành công bảng KH'

--Tạo trigger kiểm tra nếu người dùng muốn sửa 
--IDKhachHang của bảng khách hàng thì không cho phép và hiển 
--thị thông báo
create trigger t_check_edit
on KhachHang
for update
as
begin
	if update(IDKhachHang)
	begin
		print N'KHông thể thay đổi giá trị của trường ID khach hang'
		rollback transaction
	end
end

--Tạo trigger hiển thị thông báo mỗi khi thực hiện xóa thành công 
--một bản ghi của bảng KhachHang của CSDL QuanLyKhachHang
create trigger t_display_err
on KhachHang
for delete
as
print N'Bạn đã xóa thành công bản ghi của bảng khach hang'

--Tạo trigger sao cho khi xóa 1 đơn hàng trong bảng DonHang, tất 
--cả các dòng tương ứng trong bảng SP_DonHang cũng bị xóa
create trigger t_deleteall
on DonHang
for delete
as
begin
	delete from SP_DonHang
	where IDDonHang = (select IDDonHang from deleted)	
	print N'Xóa thành công bên bảng SP_DonHang'
end