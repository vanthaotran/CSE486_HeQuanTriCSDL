--Tạo SQL Server login --
exec sp_addlogin 'ttv','ttv' -- tendn mk
--sp_droplogin 'van'
exec sp_addlogin 'tuan','tuan'
exec sp_addlogin 'vu','vu'

use QLCHBanSach
exec sp_grantdbaccess 'ttv', 'Vann' -- loginname, username
exec sp_grantdbaccess 'tuan', 'Tuann'
exec sp_grantdbaccess 'vu', 'Vuu'

-- Xóa  user trong csl
use QLCHBanSach
exec sp_revokedbaccess 'van'


-- PHÂN QUYỀN CHO TẤT CẢ THÀNH VIÊN!
sp_addrole 'admin10'
grant all on SACH to admin10
grant all on CHITIETDATSACH to admin10
grant all on DONDATSACH to admin10
grant all on KHACHHANG to admin10
grant all on NHANVIEN to admin10
grant all on NHAXUATBAN to admin10
grant all on TACGIA to admin10
grant all on THELOAISACH to admin10
sp_addrolemember 'admin10', 'Vann'
sp_addrolemember 'admin10', 'Tuann'
sp_addrolemember 'admin10', 'Vuu'
--sp_droprolemember 'admin', 'van'
--sp_droprole 'admin'



-- PHÂN QUYỀN CHO TỪNG THÀNH VIÊN!

-- PHÂN QUYỀN CHO VÂN
sp_addrole 'vantv'
sp_addrolemember 'vantv', 'Vann'
-- view ok
grant all on dbo.v_thongke to vantv
grant all on dbo.v_info to vantv
grant all on dbo.v_salaryNV to vantv
--function
grant all on f_nvlv to vantv
grant all on f_nvtime to vantv
grant all on f_khmax to vantv
-- procedure
grant all on p_SLDaBan to vantv
grant all on p_sosanh to vantv
grant all on p_theloai to vantv




-- PHÂN QUYỀN CHO TỪNG THÀNH VIÊN!
-- PHÂN QUYỀN CHO TUẤN
sp_addrole 'tuankieu'
sp_addrolemember 'tuankieu', 'Tuann'
-- view
grant all on dbo.View_thong_tin_sach_trong_kho to tuankieu
grant all on dbo.View_sach_chua_duoc_mua to tuankieu
grant all on dbo.View_tien_lai_tung_loai_sach to tuankieu
--function
grant all on f_tong_so_sach to tuankieu

grant all on f_ngay_sinh_nhan_vien_trong_tuan to tuankieu
grant all on f_sach_duoc_ua_thich_nhat to tuankieu
-- procedure
grant all on pc_so_don_cua_nhan_vien to tuankieu
grant all on sp_so_sanh_sach to tuankieu
grant all on sp_thong_ke_theo_thu to tuankieu




-- PHÂN QUYỀN CHO TỪNG THÀNH VIÊN!
-- PHÂN QUYỀN CHO VŨ
sp_addrole 'vulonely'
sp_addrolemember 'vulonely', 'Vuu'
-- function
grant all on danh_sach_cac_sach_cua_the_loai to vulonely
grant all on Khach_hang_mua_nhieu_sach_nhat to vulonely
grant all on tong_so_don_dat_hang_cua to vulonely
-- p
grant all on thu_nhap_cua_cua_hang_trong_khoang_tg to vulonely
grant all on So_dau_sach_cua_tac_gia to vulonely
grant all on Bo_sung_cho_bang_SACH_du_lieu to vulonely
-- view
grant all on dbo.Tong_hop_thong_tin to vulonely
grant all on dbo.So_don_dat_sach_nhan_vien_da_lap to vulonely
grant all on dbo.Thong_ke_so_luong_sach_da_ban to vulonely
