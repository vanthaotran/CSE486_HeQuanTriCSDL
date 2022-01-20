--Câu 1: Cho bảng NHANVIEN (MaNV, Hoten, Ngaysinh,…).Viết một trigger để đảm 
--bảo rằng khi thêm một nhân viên mới vào thì tuổi của nhân viên không được >=45 --- ok
create trigger t_checkAge
on NhanVien
after insert 
as
begin
	declare @tuoimoi int
	set @tuoimoi = (select year(getdate()) - year(NgaySinh) as tuoinhanvien from inserted) 
	if (@tuoimoi > 45)
		begin
			rollback
			raiserror(N'Nhân viên không được quá 45 tuổi!', 16,1);
		end
end
drop trigger t_checkAge
insert into NhanVien values ('NV0155', 'Linda', 'Tran', '1932-12-21', '2120-12-21', 'England', '03432432423', 39434324, 43432)
--Câu 2: Tạo trigger để tránh xoá 2 bản ghi trong bảng Nhanvien đồng thời.
-- https://dba.stackexchange.com/questions/29763/trigger-in-mysql-to-disallow-multiple-row-deletions-at-a-time-on-a-table
-- SELECT @@SPID as SessionID: sessionID in sql ???
create table trigger_check_deletes 
(
	delete_count int default 0,
	conn_id int not null primary key,
)

create trigger t_no_delete2row
on NhanVien
for delete
as
begin
	declare @count int
	insert into trigger_check_deletes (conn_id) values (connectionid())
	select @count = (select delete_count from trigger_check_deletes where conn_id = connectionid())
	set @count = @count+1
	update trigger_check_deletes set delete_count = @count where conn_id = connectionid()

	if @count > 1 
	begin
		print 'khong the xoa 2 ban ghi cung 1 luc'
	end
end

select connection_id from sys.dm_exec_connections
select * from sys.dm_exec_connections

------------------------------------------------------------------------------------------------------------------bài chữa
create trigger t_no_delete2row_1
on NhanVien
for delete
as
begin
	declare @dem as int
	set @dem = (select count(*) from deleted)
	if(@dem>1)
		begin
			rollback transaction
			raiserror 'Khong the xoa 2 ban ghi cung 1 luc!'
		end
end
drop trigger t_no_delete2row

--Câu 3: Tạo UPDATE trigger đảm bảo rằng cột lương cơ bản không được lớn hơn 
--1000000 và ngày sinh không lớn hơn ngày hiện tại. -- ok
create trigger t_update
on NhanVien
for update
as
begin
	declare @luongcoban as float, @ngaysinh as date
	select @luongcoban = (select LuongCoBan from inserted)
	select @ngaysinh = (select NgaySinh from inserted)
	if (@luongcoban > 1000000 and @ngaysinh>GETDATE())
		begin
			rollback
			raiserror( N'lương cơ bản không được lớn hơn 1000000 và ngày sinh không lớn hơn ngày hiện tại.', 16,1)
		end
end
drop trigger t_update
update NhanVien set NgaySinh = '2021-12-23', LuongCoBan=5000000000 where MaNhanVien='NV01'


--Câu 4: Tạo một trigger không cho phép cập nhật cột Ngaysinh trong bảng Nhanvien. -- ok
create trigger t_updateNgaysinh
on NhanVien
for update 
as
begin
	if update (NgaySinh)
		begin
			rollback
			raiserror(N'Không được sửa!',16,1)
		end
end
drop trigger t_updateNgaysinh
update NhanVien set NgaySinh='2021-12-21' where MaNhanVien='NV01';
--Câu 5: Hiển thị các trigger trong bảng Nhanvien
exec sp_helptrigger 'NhanVien'

--Câu 6: Tạo trigger để kiểm tra dữ liệu nhập vào cột MaLoaiHang trong bảng 
--MatHang phải là dữ liệu đã tồn tại trong cột MaLoaiHang của bảng LoaiHang ---ok
create trigger t_check_data
on MatHang
for insert
as
begin
	if not exists (select inserted.MaLoaiHang from inserted inner join MatHang on MatHang.MaLoaiHang = inserted.MaLoaiHang)
		begin
			rollback
			raiserror(N'dữ liệu không tồn tại',16,1)
		end
end
insert into MatHang values ('MH111', 'hello', 'CT01', 'LH02', 1, 3000, 10000, 0)

--Câu 7: Tạo một cascade trigger để khi xóa một loại hàng trong bảng LoaiHang thì 
--toàn bộ các mặt hàng tương ứng với loại hàng đó cũng bị xóa. Sau đó trigger này sẽ 
--kích hoạt hoạt hành động hiển thị thông tin của những mặt hàng còn lại. ??? chưa được
create trigger t_cascade
on LoaiHang
after delete
as
begin
	--delete from LoaiHang where MaLoaiHang in (select MaLoaiHang from MatHang)
	delete from MatHang where MatHang.MaLoaiHang in (select MaLoaiHang from deleted)
	select * from MatHang
end
drop trigger t_cascade
delete from LoaiHang where MaLoaiHang='LH01'

exec sp_helpconstraint 'ChiTietDatHang'

--Câu 8: Tạo một view View_Cau8 chứa MaHang, TenHang, TenLoaiHang. Thử thực 
--hiện việc thêm/xóa/sửa trên trigger đó. Từ đó viết instead of trigger để thay thế cho 
--những tác insert, update, delete nguyên thủy. ???
drop view View_Cau8
create view View_Cau8
as 
select MaHang, TenHang, LoaiHang.MaLoaiHang, TenLoaiHang from MatHang inner join LoaiHang on MatHang.MaLoaiHang = LoaiHang.MaLoaiHang
---------------------insert into
create trigger t_themxoasua_insert
on View_Cau8
instead of insert
as
begin
	insert into LoaiHang (MaLoaiHang, TenLoaiHang) 
	select MaLoaiHang, TenLoaiHang from inserted

	insert into MatHang (MaHang, TenHang)
	select MaHang, TenHang from inserted
end
drop trigger t_themxoasua_insert

insert into View_cau8 (MaHang, TenHang, TenLoaiHang)
values('MH112', 'Helloworld', 'coding')
------ update
create trigger  t_themxoasua_update
on View_Cau8
instead of update
as
begin
	update LoaiHang set TenLoaiHang = (select TenLoaiHang from deleted)
	update MatHang set MaHang = (select MaHang from deleted), TenHang = (select TenHang from deleted)
end
drop trigger t_cascade
------ delete
create trigger  t_themxoasua_delete
on View_Cau8
for delete
as
begin
	delete from LoaiHang  where MaHang = (select MaHang from deleted)
end

exec sp_helpconstraint 'MatHang' -- hiển thị những ràng buộc trong bảng mặt hàng
--Câu 9: Tạo trigger thực hiện công việc sau:
--- Khi một bản ghi mới được bổ sung vào bảng này thì giảm số lượng hàng (trong bảng mặt hàng )hiện 
--có nếu số lượng hàng hiện có lớn hơn hoặc bằng số lượng hàng được bán ra. 
--Ngược lại thì huỷ bỏ thao tác bổ sung.
--- Khi cập nhật lại số lượng hàng được bán, kiểm tra số lượng hàng được cập 
--nhật lại có phù hợp hay không (số lượng hàng bán ra không được vượt quá số 
--lượng hàng hiện có và không được nhỏ hơn 1). Nếu dữ liệu hợp lệ thì giảm (hoặc
--tăng) số lượng hàng hiện có trong công ty, ngược lại thì huỷ bỏ thao tác cập nhật.
create trigger tg_chitietdathang_insert
on ChiTietDatHang
for insert
as begin
	declare @mahang nvarchar(100)
	declare @soluongban int
	declare @soluongcon int
	select @mahang=MaHang, @soluongban = SoLuong from inserted
	select @soluongcon = SoLuong from MatHang where MaHang=@mahang
	if @soluongcon>=@soluongban update MatHang set SoLuong=SoLuong-@soluongban where MaHang=@mahang
	else rollback transaction
end
------------------------------------------------------------------------------update laị số lượng, khogon biết có giống bài trên hay không ???
create trigger tg_sp_donhang_update_soluong1
on SP_DonHang
for update
as
begin
	if update (SoLuong)
		update SanPham set SanPham.SoLuong = SanPham.SoLuong-(inserted.SoLuong-deleted.SoLuong)
		from (deleted inner join inserted on deleted.IDDonHang=inserted.IDDonHang) inner join SanPham on SanPham.IDSanPham=deleted.IDSanPham
end

update SPDonHang set SoLuong = SoLuong+10 where IDDonHang=2

--Câu 10. Viết trigger cho bảng CHITIETDATHANG để sao cho chỉ chấp nhận giá 
--hàng bán ra phải nhỏ hơn hoặc bằng giá gốc (giá của mặt hàng trong bảng
--MATHANG
create trigger t_hoadonmoi
on ChiTietDatHang
for insert
as
begin
	declare @mahang nvarchar(10) select @mahang = (select MaHang from inserted)
	declare @giaCTDH float select @giaCTDH = (select GiaBan from inserted where MaHang=@mahang)
	declare @giaMH float select @giaMH = (select GiaHang from MatHang where MaHang=@mahang)

	if (@giaCTDH > @giaMH) 
	begin
		raiserror(N'phải nhỏ hơn hoặc bằng giá gốc',16,1);
		rollback transaction
	end

	-- số lượng trong bảng mặt hàng bị trừ bớt đi
	declare @slCTDT int select @slCTDT = (select SoLuong from ChiTietDatHang where MaHang=@mahang)
	declare @slMH int select @slMH = (select SoLuong from MatHang where MaHang=@mahang)
	update MatHang set SoLuong=SoLuong-@slCTDT where MaHang=@mahang
end

create trigger t_hoadonmoi_01
on ChiTietDatHang
for update
as
begin
	declare @mahang nvarchar(10) select @mahang = (select MaHang from inserted)
	-- số lượng trong bảng mặt hàng bị trừ bớt đi
	declare @slCTDT int select @slCTDT = (select SoLuong from ChiTietDatHang where MaHang=@mahang)
	declare @slMH int select @slMH = (select SoLuong from MatHang where MaHang=@mahang)
	update MatHang set SoLuong=SoLuong-@slCTDT where MaHang=@mahang
end

insert into ChiTietDatHang values ('HD111', 'MH01', 12000, 1, 0, 0,0)
insert into ChiTietDatHang values ('HD111', 'MH01', 8000, 2, 0, 0,0)

select * from ChiTietDatHang
select * from MatHang

update ChiTietDatHang set SoLuong=1 where SoHoaDon='HD01'