--Kullan�c� ID'si, Oyun ID'si veya yorum t�r�n�n opsiyonel olarak verilmesi durumunda,
--Hangi Kullan�c�, Hangi Oyun, Tarih, Yorum Metni ve Yorum T�r� �eklinde listeleyen prosed�r.
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
		   CASE WHEN Y.TUR = 0 THEN 'Olumsuz' ELSE 'Olumlu' END YorumT�r� FROM KULLANICI K 
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

--ID'si verilen kullan�c�n�n kayd�n� transaction kullanarak silen Stored Procedure
--NOT:Transaction ve Delete Procedure birle�ik yaz�ld�!!!
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
--ID'si girilen oyunun fiyat�nda, girilen oran kadar indirim yap�p g�ncelleyen Stored Procedure
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

--Oyun tablosunda herhangi bir oyunun ad� g�ncellenmeye kalkt���nda �al��acak Trigger
IF OBJECT_ID ('trgOyunG�ncelle') IS NOT NULL
BEGIN
	DROP TRIGGER  trgOyunG�ncelle
END
GO

CREATE TRIGGER trgOyunG�ncelle ON OYUN AFTER UPDATE AS
	IF UPDATE(ADI)
	BEGIN 
		RAISERROR('!!! EKLENEN OYUNUN ADI DE���T�R�LEMEZ. OYUN EKLEMEK ���N YEN� B�R KAYIT OLU�TURMANIZ GEREKMEKTED�R!!! G�NCELLEME �PTAL ED�LD�!', 16, 1)
		ROLLBACK
	END
GO

SELECT * FROM OYUN

 UPDATE OYUN 
 SET ADI='LEAGUE OF LEGENDS' WHERE OYUN_ID = 10
 GO

SELECT * FROM OYUN

--Yeni oyun kayd� yapan Stored Procedure
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
	
--Fatura tutar� en y�ksek olan kullan�c�n�n ad�n�, sat�n ald��� oyunun ad�n�, sat�n ald��� tarihi,
-- sat�n ald��� tutar� ve �deme t�r�n� mesaj olarak d�nd�ren Cursor 
DECLARE @ad VARCHAR(MAX), @oyunAd� VARCHAR(MAX), @tarih DATE,
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
FETCH FIRST FROM fatura_cursor INTO @ad, @oyunAd�, @tarih, @tutar, @odemeTuru
	PRINT @ad + ' - ' +
		  @oyunAd� + ' - ' +
		  CONVERT(VARCHAR, @tarih) + ' - ' +
		  CONVERT(VARCHAR, @tutar) + ' - ' +
		  CONVERT(VARCHAR, @odemeTuru)   
CLOSE fatura_cursor
DEALLOCATE fatura_cursor

--KULLANICI tablosu i�in tan�mlanan SELECT sorgusundaki h�z kazan�m�n� hesaplayan Index
DROP INDEX KULLANICI.idxKullanici

CREATE NONCLUSTERED INDEX idxKullanici on KULLANICI (ADI,EMAIL)
SELECT * FROM KULLANICI WHERE ADI='KULLANICI 435984'
 SET STATISTICS IO ON
 SET STATISTICS TIME ON
