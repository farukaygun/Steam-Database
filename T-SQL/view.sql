--Kullanýcýlarýn oyunlarda kazandýðý baþarýmlarýný kazanma tarihi, isim, kazanýlan baþarý, kazandýðý oyun þeklinde gösteren view 
CREATE VIEW kullaniciBasarilari AS

SELECT K.TARIH AS KAZANMA_TARIHI, U.ADI AS ISIM,B.ADI AS KAZANILAN_BASARI,O.ADI AS KAZANDIGI_OYUN
FROM KULLANICI U INNER JOIN KAZANIR K ON U.KULLANICI_ID=K.KULLANICI_ID
INNER JOIN BASARIMLAR B ON K.BASARIM_ID=B.BASARIM_ID
INNER JOIN OYUN O ON O.OYUN_ID=B.OYUN_ID
go

SELECT * FROM kullaniciBasarilari

DROP VIEW kullaniciBasarilari