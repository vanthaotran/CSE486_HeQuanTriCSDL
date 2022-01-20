create database sql_thao
use sql_thao

create table Sach (
	MaSach nvarchar(10) not null primary key,
	TenSach nvarchar(30),
	TacGia nvarchar(30),
	NhaXB nvarchar(30),
	NamXB date,
	SoTrang int
)
insert into Sach values 
('S01','Hello worldh','john legend','coding','2012-11-2',112),
('S02','Chim tren cay','binh minh','nhi dong','2012-4-2',212),
('S03','May tinh trong cuoc song','huong lan','dai hoc','2011-11-2',119),
('S04','o to trong ta','kho cuc','o to','2010-11-2',122),
('S05','teaching me','nhai nhai','giao duc','2009-11-2',921)
create table DocGia (
	MaDG nvarchar(10) not null primary key,
	TenDG nvarchar(30),
	GioiTinh nvarchar(30),
	NgaySinh date,
	DChi nvarchar(30)
)
insert into DocGia values
('DG01','van','nu','2001-12-25','ha noi'),
('DG02','hung','nam','2000-11-11','ha nam'),
('DG03','lan','nu','2003-1-2','quang ninh'),
('DG04','huong','nam','2005-12-25','thai binh'),
('DG05','phuong','nu','2001-10-25','ha noi'),
('DG06','ha','nam','2001-12-25','ha noi')
create table MuonTra (
	MaDG nvarchar(10) not null foreign key references DocGia(MaDG),
	MaSach nvarchar(10) not null foreign key references Sach(MaSach),
	SoLuong int, 
	NgayMuon date, 
	NgayHen date,
	NgayTra date
)
insert into MuonTra values
('DG06','S01',1,'2021-10-2','2021-11-2','2021-11-3'),
('DG05','S03',2,'2021-9-2','2021-9-7','2021-9-10'),
('DG04','S02',1,'2021-8-2','2021-8-4','2021-11-4'),
('DG06','S02',1,'2021-10-10','2021-10-13','2021-10-13'),
('DG02','S05',4,'2021-10-12','2021-10-15','2021-10-15')
-- cau 2: tổng hợp thông tin về các sách xuất bản anawm 2010 đã có độc giả mượn
create view cau_2 as
select Sach.MaSach, TenSach, TacGia from Sach
where year(NamXB)=2011 and Sach.MaSach in (select MaSach from MuonTra)

-- cau 3: tạo thủ tục tổng số lượng sách của 1 sách nào đó mà các độc giả đã mượn.
-- mặc định tên sách cần xem là sql server 2005 -- ok
create proc cau3 
as
begin
	select Sach.MaSach, TenSach, sum(SoLuong) as SL from Sach, MuonTra
	where Sach.MaSach=MuonTra.MaSach and exists (select MaSach from MuonTra) and TenSach='Chim tren cay'
	group by Sach.MaSach, TenSach, SoLuong
end

select * from Sach
select * from MuonTra
-- câu 4: tạo trigger sao cho khi thêm 1 dòng dữ liệu trong bảng muontra phải ktra các
--cột khóa ngoại: cột madg trong bảng docgia và cột masach trong bảng sach
--nếu không có phải đưa ra thông báo lỗi
--còn thỏa mãn thì báo thành công

create trigger cau4 
on MuonTra
for insert
as
begin
	if exists (select inserted.MaDG from inserted inner join DocGia on DocGia.MaDG=inserted.MaDG 
	) and exists (select inserted.MaSach from inserted inner join Sach on Sach.MaSach=inserted.MaSach)
		begin
			print 'ok dung roi' 
		end
	else
		begin
			raiserror ('sai roif!',16,1)
			rollback transaction
		end
end
drop trigger cau4
insert into MuonTra values ('DG01','S01',1,'2021-1-1','2021-1-1','2021-1-1')

FK__ChiTietHo__MaHan__2B3F6F97sp_helpconstraint 'ChiTietHoaDon'alter table MuonTradrop constraint FK__MuonTra__MaDG__276EDEB3select * from MuonTra