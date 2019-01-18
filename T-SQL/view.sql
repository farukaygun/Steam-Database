--Kullan�c�lar�n oyunlarda kazand��� ba�ar�mlar�n� kazanma tarihi, isim, kazan�lan ba�ar�, kazand��� oyun �eklinde g�steren View 
IF OBJECT_ID ('vw_kullaniciBasarilari') IS NOT NULL
BEGIN
	DROP VIEW vw_kullaniciBasarilari
END
GO

CREATE VIEW vw_kullaniciBasarilari AS

SELECT K.TARIH AS KAZANMA_TARIHI, U.ADI AS ISIM,B.ADI AS KAZANILAN_BASARI,O.ADI AS KAZANDIGI_OYUN
FROM KULLANICI U INNER JOIN KAZANIR K ON U.KULLANICI_ID=K.KULLANICI_ID
INNER JOIN BASARIMLAR B ON K.BASARIM_ID=B.BASARIM_ID
INNER JOIN OYUN O ON O.OYUN_ID=B.OYUN_ID
GO

SELECT * FROM vw_kullaniciBasarilari

--Yap�mc�lar�n toplam sat�� miktar�n� g�steren View.
IF OBJECT_ID ('vw_toplamKazanc') IS NOT NULL
BEGIN
	DROP VIEW vw_toplamKazanc
END
GO

CREATE VIEW vw_toplamKazanc AS
	SELECT Y.YAPIMCI_ID AS Yap�mc�ID,
		  Y.ADI AS Yap�mc�Ad�,
		  SUM(O.FIYAT) AS ToplamKazanc FROM YAPIMCI Y
		  INNER JOIN OYUN O ON O.YAPIMCI_ID = Y.YAPIMCI_ID
		  GROUP BY Y.YAPIMCI_ID,Y.ADI
GO

SELECT * FROM vw_toplamKazanc
GO

