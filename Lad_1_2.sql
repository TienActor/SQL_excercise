--- su dung co so du lieu 
use qltv
go
/*
select * from TuaSach
select * from DocGia

select * from NguoiLon
select * from TreEm

select * from DauSach
select * from CuonSach

select * from DangKy
select * from Muon
select * from QuaTrinhMuon
*/
--sp_columns quatrinhmuon
--sp_helpconstraint quatrinhmuon
/*create proc sp_traSach @isbn int,@ma_cuonsach int,@ma_docgia int
as
begin
	if not exists (select * from muon where where isbn=@isbn and ma_cuonsach=@ma_cuonsach and ma_docgia=@ma_docgia)
	begin
		raiserror('khong co',16,1)
		return
	end
	declare @soNgayQuanHan int
	select @soNgayQuanHan=datediff(d,ngay_hethan,getdate())
	from muon
	where isbn=@isbn
	and ma_cuonsach=@ma_cuonsach and ma_docgia=@ma_docgia
	begin tran
		insert into QuaTrinhMuon(isbn,ma_cuonsach,ngayGio_muon,ma_docgia,ngay_hethan,ngayGio_tra)
			select isbn,ma_cuonsach,ngayGio_muon,ma_docgia,ngay_hethan, getdate()
			from muon
			where isbn=@isbn and ma_cuonsach=@ma_cuonsach and ma_docgia=@ma_docgia
		if @@ERROR<>0
		begin
			raiserror('loi them vao qua trinh',16,1)
			rollback tran
		end
		update QuaTrinhMuon
		set tien_muon=@soNgayQuanHan*1000
		where isbn=@isbn and ma_cuonsach=@ma_cuonsach and ma_docgia=@ma_docgia

		delete from muon
		where isbn=@isbn and ma_cuonsach=@ma_cuonsach and ma_docgia=@ma_docgia
		if @@ERROR<>0
		begin
			raiserror('loi xóa muon',16,1)
			rollback tran
		end
	commit tran
end
select * from muon 
exec sp_traSach 1,3,5
select * from QuaTrinhMuon

*/



------------------Cau 1

create proc sp_thongtinDocGia @madg int
as
begin 
	if not exists(select*from DocGia where ma_docgia=@madg)
	raiserror ('khong ton tai doc gia nay',16,1)
	else if exists(select * from NguoiLon where ma_docgia=@madg)

		select  DocGia.ma_docgia,ho,ten,sonha,duong,quan
		from DocGia join NguoiLon on DocGia.ma_docgia = NguoiLon.ma_docgia
		where DocGia.ma_docgia=@madg


		else

		select ho,tenlot,ten
		from DocGia join TreEm on DocGia.ma_docgia=TreEm.ma_docgia
		where DocGia.ma_docgia=@madg

end


exec sp_thongtinDocGia 21







--Câu 2. Thông tin đầu sách:
--Tên: sp_ThongtinDausach
--Nội dung: Liệt kê những thông tin của đầu sách, thông tin tựa sách và số lượng
--sách hiện chưa được mượn của một đầu sách cụ thể (ISBN). 


select *from Muon
select*from DauSach

create proc sp_dausachchuamuon @maisbn int 
as
begin 
	if not exists(select *from DauSach where isbn=@maisbn and trangthai =N'Y')
	raiserror('dau sach nay da duoc muon',16,1)

	else 
		select TuaSach.TuaSach,DauSach.isbn,count (*) as slcs
		from DauSach join TuaSach on DauSach.ma_tuasach=TuaSach.ma_tuasach
		join CuonSach on DauSach.isbn=CuonSach.isbn
		and TinhTrang='Y'
		and DauSach.isbn=@maisbn
		group by TuaSach.TuaSach,DauSach.isbn

		end



exec sp_dausachchuamuon 1




--Câu 3. Liệt kê những độc giả người lớn đang mượn sách:
--Tên: sp_ThongtinNguoilonDangmuon
--Nội dung: Liệt kê những thông tin của tất cả độc giả đang mượn sách của thư
--viện. 

select*from Muon
select*from DocGia

create proc sp_ThongtinNguoilonDangmuon  @madg1 int
as
begin 
	if not exists(select *from DocGia where ma_docgia=@madg1)
	raiserror('Khong ton tai doc gia nay',16,1)
	else 
		select isbn as N'Ma cuon sach ',ma_cuonsach,Muon.ma_docgia,ho,ten,tenlot
		from Muon join DocGia on Muon.ma_docgia=DocGia.ma_docgia
		and Muon.ma_docgia=@madg1

end





exec sp_ThongtinNguoilonDangmuon  5

drop proc sp_ThongtinNguoilonDangmuon 



--Câu 4. Liệt kê những độc giả người lớn đang mượn sách quá hạn:
--Tên: sp_ThongtinNguoilonQuahan
--Nội dung: Liệt kê những thông tin của tất cả độc giả đang mượn sách của thư
--viện đang trong tình trạng mượn quá hạn 14 ngày. 

select *
from QuaTrinhMuon qtm
where DATEDIFF(DAY,qtm.ngayGio_tra,qtm.ngayGio_muon)>14


create proc sp_ThongtinNguoilonQuahan @madg2 int 
as
begin 
	if not exists(select *from DocGia where ma_docgia=@madg2)
	raiserror('Khong ton tai doc gia nay',16,1)
	else 
		select isbn as N'Ma cuon sach ',ma_cuonsach,Muon.ma_docgia,ho,ten,tenlot
		from DocGia join NguoiLon on DocGia.ma_docgia=NguoiLon.ma_docgia
		join Muon on Muon.ma_docgia=NguoiLon.ma_docgia
		and DATEDIFF(DAY,Muon.ngay_hethan,GETDATE())>14

end





--Câu 5. Liệt kê những độc giả người lớn đang mượn sách có trẻ em cũng đang mượn
--sách:
--Tên: sp_DocGiaCoTreEmMuon
--Nội dung: Liệt kê những những độc giả đang trong tình trạng mượn sách và
--những trẻ em độc giả này đang bảo lãnh cũng đang trong tình trạng mượn sách.


select *from NguoiLon
select*from TreEm


--Câu 6. Cập nhật trạng thái của đầu sách: 

create proc sp_CapnhatTrangthaiDausach @isbn int 

as

	begin 
	declare @dem int 
	select @dem = count(*)
	from CuonSach
	where TinhTrang='Y' and isbn=@isbn

	if @dem=0
	update DauSach
	set trangthai='N'
	where isbn=@isbn

	else

update DauSach
set trangthai='y'
where isbn=@isbn

end



select*from CuonSach where isbn=1
select*from DauSach where isbn=1
update DauSach 
where isbn=1 and Ma_CuonSach in (1,2)

exec sp_CapnhatTrangthaiDausach 1



--- proceduce de su dung voi winform  trung voi cau 8 buoi 1

create proc sp_ThemCuonSach (@isbn int)
As begin --Transaction
declare @count int
set @count = 1
if not exists (select DS.isbn from dausach DS
where DS.isbn = @isbn)
begin
raiserror ('Không tồn tại đầu sách này ',16,1)
return
end
else begin
while (exists (select CS.ma_cuonsach from cuonsach CS
where CS.ma_cuonsach = @count and CS.isbn = @isbn))
set @count = @count + 1
insert into cuonsach(isbn,ma_cuonsach,tinhtrang)
values(@isbn,@count,'Y')
update dausach set trangthai = 'Y' where isbn=@isbn
end
end--Viết store procedure tra cứu đọc giả đang mượn sách
create proc sp_tracuu_docgia_dang_muonsach @madg int
as
select isbn,ma_cuonsach,ngaygio_muon,ngay_hethan
from muon
where ma_docgia=@madg--Viết store procedure Trả sách: Create proc sp_trasach @isbn int, @ma_cuonsach int
As
begin
	declare @so_ngay_qua_han int, @tien_phat int,
	 @ngaygio_muon smalldatetime,
	 @ngay_hethan smalldatetime, @ma_docgia int
	if not exists(select * from muon
	where @isbn=isbn
	and @ma_cuonsach=ma_cuonsach)
	raiserror('Xem lại, thông tin này không đúng',16,1)
	else
	begin
	set @so_ngay_qua_han=datediff("d",(select ngay_hethan
	from muon
	where @isbn=isbn
	and @ma_cuonsach=ma_cuonsach), getdate())
	set @tien_phat=0
	if @so_ngay_qua_han>0
	set @tien_phat=3000*@so_ngay_qua_han
	select @ngaygio_muon=ngaygio_muon,
	 @ngay_hethan=ngay_hethan, @ma_docgia=ma_docgia
	from muon
	where @isbn=isbn and @ma_cuonsach=ma_cuonsach
	insert into quatrinhmuon(isbn, ma_cuonsach,
	ngaygio_muon,ma_docgia,ngay_hethan,ngayGio_tra,
	tien_muon,tien_datra, tien_datcoc,ghichu)
	values(@isbn,@ma_cuonsach,@ngaygio_muon,@ma_docgia,
	@ngay_hethan, getdate(),null,@tien_phat,null,null)
	delete from muon
	where isbn=@isbn
	and ma_cuonsach=@ma_cuonsach
end
end