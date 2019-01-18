--Kullanýcý ID'si, Oyun ID'si veya yorum türünün opsiyonel olarak verilmesi durumunda,
--Hangi Kullanýcý, Hangi Oyun, Tarih, Yorum Metni ve Yorum Türü þeklinde listeleyen prosedür.
IF OBJECT_ID ('sp_YorumGetir') IS NOT NULL
BEGIN
	DROP PROCEDURE sp_YorumGetir
END
GO

CREATE PROCEDURE sp_YorumGetir(@kullaniciID INT=NULL, @oyunID INT=NULL, @tur int=NULL) AS
	SELECT K.ADI AS HangiKullanici,
		   O.ADI AS HangiOyun,
		   Y.TARIH AS HangiTarih,
		   Y.METIN AS YorumMetni,
		   CASE WHEN Y.TUR = 0 THEN 'Olumsuz' ELSE 'Olumlu' END YorumTürü FROM KULLANICI K 
			INNER JOIN YORUMYAPAR Y ON K.KULLANICI_ID = Y.KULLANICI_ID
			INNER JOIN OYUN O ON Y.OYUN_ID=O.OYUN_ID
			WHERE K.KULLANICI_ID = ISNULL(@kullaniciID, K.KULLANICI_ID) AND 
			  O.OYUN_ID = ISNULL(@oyunID, O.OYUN_ID) AND 
			  Y.TUR = ISNULL(@tur, TUR)
GO

EXEC sp_YorumGetir 2, NULL,1
EXEC sp_YorumGetir
EXEC sp_YorumGetir NULL, 2,0
EXEC sp_YorumGetir NULL,2, NULL
GO

--ID'si verilen kullanýcýnýn kaydýný transaction kullanarak silen Stored Procedure
--NOT:Transaction ve Delete Procedure birleþik yazýldý!!!
IF OBJECT_ID ('sp_KullaniciSil') IS NOT NULL
BEGIN
	DROP PROCEDURE  sp_KullaniciSil
END
GO

CREATE PROCEDURE sp_KullaniciSil(@kullaniciID int) AS

	BEGIN TRANSACTION prosedurKayitNoktasi
	DECLARE @tranCounter int =@@TRANCOUNT;

	IF @tranCounter>0
    SAVE TRANSACTION prosedurKayitNoktasi

	BEGIN TRY
		DELETE FROM KAZANIR WHERE KULLANICI_ID=@kullaniciID;
		DELETE FROM ANAHTAR WHERE KULLANICI_ID=@kullaniciID;
		DELETE FROM YORUMYAPAR WHERE KULLANICI_ID=@kullaniciID;
		DELETE FROM FATURA WHERE KULLANICI_ID=@kullaniciID;
		DELETE FROM KULLANICI WHERE KULLANICI_ID=@kullaniciID;

		COMMIT

	END TRY

	BEGIN CATCH								

		IF @tranCounter=0 AND XACT_STATE() = -1
			ROLLBACK TRANSACTION
		ELSE
			BEGIN
				ROLLBACK TRANSACTION prosedurKayitNoktasi
				COMMIT
			END
		DECLARE @ErrorMessage NVARCHAR(4000)
		SET @ErrorMessage= ERROR_MESSAGE()
		DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
		DECLARE @ErrorState INT = ERROR_STATE()

		RAISERROR(@ErrorMessage,@ErrorSeverity,@ErrorState)
	END CATCH	
GO

SELECT * FROM KULLANICI
GO

EXEC sp_KullaniciSil 11
GO

SELECT * FROM KULLANICI
GO
--ID'si girilen oyunun fiyatýnda, girilen oran kadar indirim yapýp güncelleyen Stored Procedure
IF OBJECT_ID ('sp_IndirimYap') IS NOT NULL
BEGIN
	DROP PROCEDURE  sp_IndirimYap
END
GO

CREATE PROCEDURE sp_IndirimYap(@oyunID INT,@oran FLOAT) AS

UPDATE OYUN SET FIYAT= FIYAT*(1-@oran) WHERE OYUN_ID=@oyunID

GO

SELECT * FROM OYUN
GO

EXEC sp_IndirimYap 1, 0.25
GO

SELECT * FROM OYUN
GO

--Oyun tablosunda herhangi bir oyunun adý güncellenmeye kalktýðýnda çalýþacak Trigger
IF OBJECT_ID ('trgOyunGüncelle') IS NOT NULL
BEGIN
	DROP TRIGGER  trgOyunGüncelle
END
GO

CREATE TRIGGER trgOyunGüncelle ON OYUN AFTER UPDATE AS
	IF UPDATE(ADI)
	BEGIN 
		RAISERROR('!!! EKLENEN OYUNUN ADI DEÐÝÞTÝRÝLEMEZ. OYUN EKLEMEK ÝÇÝN YENÝ BÝR KAYIT OLUÞTURMANIZ GEREKMEKTEDÝR!!! GÜNCELLEME ÝPTAL EDÝLDÝ!', 16, 1)
		ROLLBACK
	END
GO

SELECT * FROM OYUN

 UPDATE OYUN 
 SET ADI='LEAGUE OF LEGENDS' WHERE OYUN_ID = 10
 GO

SELECT * FROM OYUN

--Yeni oyun kaydý yapan Stored Procedure
IF OBJECT_ID ('sp_oyunEkle') IS NOT NULL
BEGIN
	DROP PROCEDURE  sp_oyunEkle
END
GO

CREATE PROCEDURE sp_oyunEkle 
(@OYUN_ID int, @ADI varchar(50), @BUNDLE_ID int, @YAPIMCI_ID int, @YAYIMCI_ID int, @FIYAT smallmoney)
AS
	IF EXISTS(SELECT * FROM dbo.OYUN WHERE  OYUN_ID = @OYUN_ID)
	BEGIN
		PRINT 'Bu oyun sistemde zaten mevcuttur!'
	END
	ELSE
	BEGIN
		INSERT INTO dbo.OYUN VALUES (@OYUN_ID,@ADI,
		@BUNDLE_ID,@YAPIMCI_ID,@YAYIMCI_ID,@FIYAT)
	END
GO

SELECT * FROM OYUN
GO

EXEC sp_oyunEkle 15, 'DEATH OF MORQUES', 1, 2, 3, 10.00
GO

SELECT * FROM OYUN
GO

EXEC sp_oyunEkle 7, 'DIABLO III', 5, 4, 1, 100.00
GO

SELECT * FROM OYUN
GO
	
--Fatura tutarý en yüksek olan kullanýcýnýn adýný, satýn aldýðý oyunun adýný, satýn aldýðý tarihi,
-- satýn aldýðý tutarý ve ödeme türünü mesaj olarak döndüren Cursor 
DECLARE @ad VARCHAR(MAX), @oyunAdý VARCHAR(MAX), @tarih DATE,
		 @tutar SMALLMONEY, @odemeTuru VARCHAR(MAX)

DECLARE fatura_cursor SCROLL CURSOR FOR 
SELECT K.ADI, O.ADI, F.TARIH, F.TUTAR, OD.ADI FROM FATURA F
	INNER JOIN KULLANICI K ON K.KULLANICI_ID = F.KULLANICI_ID
	INNER JOIN ANAHTAR A ON A.KULLANICI_ID = K.KULLANICI_ID
	INNER JOIN OYUN O ON O.OYUN_ID = A.OYUN_ID 
	INNER JOIN TAHSILAT T ON T.KULLANICI_ADI = K.ADI
	INNER JOIN ODEMETURU OD ON OD.ODEME_ID = T.ODEME_ID
	GROUP BY K.ADI, O.ADI, F.TARIH, F.TUTAR, OD.ADI
	ORDER BY MAX(F.TUTAR) DESC
 
OPEN fatura_cursor
FETCH FIRST FROM fatura_cursor INTO @ad, @oyunAdý, @tarih, @tutar, @odemeTuru
	PRINT @ad + ' - ' +
		  @oyunAdý + ' - ' +
		  CONVERT(VARCHAR, @tarih) + ' - ' +
		  CONVERT(VARCHAR, @tutar) + ' - ' +
		  CONVERT(VARCHAR, @odemeTuru)   
CLOSE fatura_cursor
DEALLOCATE fatura_cursor

--KULLANICI tablosu için tanýmlanan SELECT sorgusundaki hýz kazanýmýný hesaplayan Index
DROP INDEX KULLANICI.idxKullanici

CREATE NONCLUSTERED INDEX idxKullanici on KULLANICI (ADI,EMAIL)
SELECT * FROM KULLANICI WHERE ADI='KULLANICI 435984'
 SET STATISTICS IO ON
 SET STATISTICS TIME ON
