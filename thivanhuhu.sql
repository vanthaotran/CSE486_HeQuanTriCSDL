-- đưa ra nhwuxng thông tin của những kh đã mua sách 
--thoogn tin những khách hàng có số lần mua sách nhiều nhất trong quý 1
alter function thongitnkh ()
returns @bang table (tenkh nvarchar(30), solanmua int)
as
begin
	insert into @bang
	select HoTenKH, COUNT(DONDATSACH.MaKH) as solan
	from KHACHHANG, DONDATSACH, CHITIETDATSACH
	where KHACHHANG.MaKH=DONDATSACH.MaKH and DONDATSACH.MaHoaDon=CHITIETDATSACH.MaHoaDon
	and month(NgayDat) between 10 and 11
	group by HoTenKH, DONDATSACH.MaKH
	order by COUNT(SoLuong) desc
	return
end
select * from thongitnkh()