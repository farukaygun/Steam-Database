--ID'si verilen kullan�c�n�n yapt��� toplam harcama miktar�
CREATE FUNCTION toplamOyunSayisi(@kullaniciID AS INT)
RETURNS INT AS
BEGIN
	DECLARE @toplam AS INT = (
	SELECT SUM(FIYAT) FROM ANAHTAR
	WHERE KULLANICI_ID = @kullaniciID
	) 
	RETURN @toplam
END 
GO

PRINT dbo.toplamOyunSayisi(5)
GO

DROP FUNCTION dbo.toplamOyunSayisi
GO

--ID si verilen yap�mc�n�n en son �d�l alan oyunun ad�.
CREATE FUNCTION sonOdulAlanOyun(@yapimciID INT)
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
PRINT dbo.sonOdulAlanOyun(2)
GO

DROP FUNCTION dbo.sonOdulAlanOyun
GO

