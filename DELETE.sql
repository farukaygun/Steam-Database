--ANAHTAR_ID ile OYUN_ID'si eþit olan ANAHTAR satýrlarýný sil.
DELETE FROM ANAHTAR WHERE ANAHTAR_ID = OYUN_ID
--FIYAT'ý 50 ile 100 arasýndaki ANAHTAR satýrlarýný sil.
DELETE FROM ANAHTAR WHERE FIYAT BETWEEN 50 AND 100

--OYUN_ID deðeri girilen tarihlerin farkýnýn gün cinsinden deðerine eþit olan YORUMYAPAR satýrlarýný sil.
DELETE FROM YORUMYAPAR WHERE OYUN_ID = DATEDIFF(DD,'2017-8-6','2018-3-13');

--OYUN_ID deðeri mevcut tarihin ay cinsinden deðerine eþit olan ODULLER satýrlarýný sil.
DELETE FROM ODULLER WHERE OYUN_ID = DATEPART(MM,GETDATE());

--BASARIM_ID si 1 ve 12 olarak kayýtlý KAZANIR satýrlarýný sil.
DELETE FROM  KAZANIR WHERE BASARIM_ID = 1 AND BASARIM_ID = 12
