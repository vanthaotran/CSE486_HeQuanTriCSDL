-- viết câu lệnh trích ra phần tên khách hàng từ trường hoten
N'Nguyễn Ngọc Đỗ Phương', left(chuỗi,n); right(chuỗi,n), substring(chuỗi,m,n): tại vị trí m, lấy n ký tự 'Phương Nguyễn Ngọc Đỗ'

-- Hiển thị tên
select HoTen, right(KhachHang.HoTen, charindex(' ', reverse(KhachHang.HoTen)) - 1) as TenKH
from KhachHang

-- Hiển thị họ đệm
select HoTen, substring( HoTen,
			charindex(' ', HoTen)+1,
			len(rtrim(ltrim(HoTen)))-charindex(' ',ltrim(HoTen))-charindex(' ', reverse(rtrim(HoTen)))
			) as HoDem
from KhachHang

-- Hiển thị thông tin Họ, họ đệm và tên
select HoTen,
		left(HoTen, charindex(' ', ltrim(HoTen))-1 as Ho,
		substring (HoTen,
					charindex(' ', HoTen)+1,
					len(rtrim(ltrim(HoTen)))-charindex(' ', ltrim(HoTen))-charindex(' ', reverse(rtrim(HoTen)))
		) as HoDem,
		right (HoTen, charindex('', reverse(rtrim(Hoten))) - 1 ) as TenKH
from KhachHang

-- dùng biến
declare @fullname nvarchar(50), @ho nvarchar(10), @hodem nvarchar(30), @ten nvarchar(10)
select @fullname = N'Nguyễn Ngọc Đỗ Phương'
select @ho = left(@fullname, charindex(' ', ltrim(@fullname))-1
select @ten = right(@fullname, charindex(' ', reverse(rtrim(@fullname)))-1)
select @hodem = substring( @fullname,
							charindex(' ', @fullname)+1,
							len(rtrim(ltrim(@fullname)))-charindex(' ', ltrim(@fullname))-charindex(' ', reverse(rtrim(@fullname)))
)