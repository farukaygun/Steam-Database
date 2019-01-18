--ID'si verilen kullanýcýnýn yaptýðý toplam harcama miktarý
IF OBJECT_ID ('fn_toplamOyunSayisi') IS NOT NULL
BEGIN
	DROP FUNCTION fn_toplamOyunSayisi
END
GO

CREATE FUNCTION fn_toplamOyunSayisi(@kullaniciID AS INT)
RETURNS INT AS
BEGIN
	DECLARE @toplam AS INT = (
	SELECT SUM(O.FIYAT) FROM OYUN O
	INNER JOIN ANAHTAR A ON A.OYUN_ID = O.OYUN_ID
	WHERE A.KULLANICI_ID = @kullaniciID
	) 
	RETURN @toplam
END 
GO

PRINT dbo.fn_toplamOyunSayisi(5)
GO

--ID si verilen yapýmcýnýn en son ödül alan oyunun adý.
IF OBJECT_ID ('fn_sonOdulAlanOyun') IS NOT NULL
BEGIN
	DROP FUNCTION fn_sonOdulAlanOyun
END
GO

CREATE FUNCTION fn_sonOdulAlanOyun(@yapimciID INT)
RETURNS VARCHAR(50) AS
BEGIN
	DECLARE @oyunAdi VARCHAR(50);

	SELECT @oyunAdi=
	o.ADI FROM OYUN O INNER JOIN ODULLER D ON O.OYUN_ID=D.OYUN_ID
	WHERE YAPIMCI_ID=@yapimciID AND TARIH=(SELECT
	MAX(TARIH) FROM OYUN O INNER JOIN ODULLER D ON O.OYUN_ID=D.OYUN_ID
	WHERE YAPIMCI_ID=@yapimciID)

	RETURN @oyunAdi;
END
GO

PRINT dbo.fn_sonOdulAlanOyun(2)
GO


