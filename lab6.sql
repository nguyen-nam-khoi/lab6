--câu 1a
create trigger checkluongnv on nhanvien for insert as
if (select luong from inserted) < 15000
begin
print'Tien luong toi thieu phai hon 15000'
rollback transaction
end
SELECT * FROM NHANVIEN
INSERT INTO [dbo].[NHANVIEN] ([HONV],[TENLOT],[TENNV],[MANV],[NGSINH],[DCHI],[PHAI],[LUONG],[MA_NQL],[PHG])
VALUES(N'Bui',N'Quang',N'Huy','098','09-13-2020','Le Duan - HCM','Nam',6000,'005',1)
GO
--cau 1b
CREATE TRIGGER trg_CheckValidAge
   on NHANVIEN
   FOR INSERT
AS
   DECLARE @age INT;
   SELECT @age = DATEDIFF(YEAR, NGSINH, GETDATE())+1 FROM inserted;
   IF @age <18 or @age >65
   BEGIN
      PRINT N'Tuổi của nhân viên không hợp lệ 18<= tuổi <= 65';
	  ROLLBACK TRANSACTION;
   END
---kiểm tra câu lệnh
INSERT INTO [dbo].[NHANVIEN] ([HONV],[TENLOT],[TENNV] ,[MANV] ,[NGSINH],[DCHI],[PHAI],[LUONG],[MA_NQL],[PHG])
     VALUES(N'Bui',N'Duc',N'Danh','098','09-13-2020','Le Duan - HCM','Nam',90000,'005',1)
GO
---câu 1c
CREATE TRIGGER trg_CheckUpdateOnAddress
   ON NHANVIEN
   FOR UPDATE
AS
   IF EXISTS (SELECT DCHI FROM inserted where DCHI LIKE '%HCM%')
   BEGIN
      PRINT N'Không thể cập nhật nhân viên ở HCM';
	  ROLLBACK TRAN;
   END;
---câu lệnh kiểm tra
UPDATE [dbo].[NHANVIEN]
   SET [PHAI] = 'Nam'
 WHERE MaNV = '001';
GO


--caau 2a
CREATE TRIGGER trg_SumEmps
   ON NHANVIEN
   AFTER INSERT
AS
   DECLARE @male INT, @female INT;
   SELECT @female = count(Manv) FROM NHANVIEN WHERE PHAI = N'Nữ';
   SELECT @male = count(Manv) FROM NHANVIEN WHERE PHAI = N'Nam';
   PRINT N'Tổng số nhân viên là nữ: ' + cast(@female as varchar);
   PRINT N'Tổng số nhân viên là nam: ' + cast(@male as varchar);

---CÂU LỆNH KIỂM TRA
INSERT INTO [dbo].[NHANVIEN]([HONV],[TENLOT],[TENNV],[MANV],[NGSINH],[DCHI],[PHAI],[LUONG],[MA_NQL],[PHG])
VALUES ('A','B','C','345','7-12-1999','HCM','Nam',600000,'005',1)
GO
 --BÀI 2B
CREATE TRIGGER trg_SumEmpsForUpdate
ON NHANVIEN
AFTER update
AS
IF (select top 1 PHAI FROM deleted) != (select top 1 PHAI FROM inserted)
   BEGIN
      Declare @male int, @female int;
      SELECT @female = count(Manv) from NHANVIEN where PHAI = N'Nữ';
      SELECT @male = count(Manv) from NHANVIEN where PHAI = N'Nam';
      PRINT N'Tổng số nhân viên là nữ: ' + cast(@female as varchar);
      PRINT N'Tổng số nhân viên là nam: ' + cast(@male as varchar);
   END;
--câu lệnh kiểm tra
UPDATE [dbo].[NHANVIEN]
   SET [HONV] = 'Tín'
      ,[PHAI] = N'Nữ'
 WHERE  MaNV = '345'
GO
---BÀI 2C
CREATE TRIGGER trg_SumForDelete
   on DEAN
   AFTER DELETE
AS
   SELECT MA_NVIEN, COUNT(MaDA) as 'Tổng sô đề án đã tham gia' from PHANCONG
      GROUP BY MA_NVIEN
go

--BÀI 3A
CREATE TRIGGER deleteNhanThanNV ON NHANVIEN
INSTEAD OF DELETE 
AS
BEGIN
   DELETE FROM THANNHAN WHERE MA_NVIEN IN (SELECT MANV FROM deleted)
   DELETE FROM NHANVIEN WHERE MANV IN (SELECT MANV FROM deleted)
END

DELETE NHANVIEN WHERE MANV='001'
SELECT * FROM THANNHAN
go
