--ALTER TABLE KULLANIMLARI TAHSILAT TABLOSU İLE BİRLİKTE BAŞLIYOR.

USE GAMES_SALES_PLATFORM
GO

--E Maili MAIL 1 olan kişinin E Maili UPDATED MAIL 1 olarak güncellendi.
UPDATE KULLANICI SET EMAIL = 'UPDATED MAIL 1' WHERE EMAIL = 'MAIL 1' 
--Adı UĞUR olan kişinin Adı HAKAN UĞUR KAYA olarak güncellendi.
UPDATE KULLANICI SET ADI = 'HAKAN UĞUR KAYA' WHERE ADI = 'UĞUR' AND EMAIL= 'MAIL 2'
--Kullanıcı Id'si 9 olan kullanıcının E Maili UPDATED MAIL 9 olarak güncellendi.
UPDATE KULLANICI SET EMAIL = 'UPDATED MAIL 9' WHERE KULLANICI_ID = 9
--E maili 'UPDATED MAIL 1' ve adı Faruk olan kullanıcının adı Faruk Aygün olarak güncellendi. 
UPDATE KULLANICI SET ADI = 'FARUK AYGÜN' WHERE ADI = 'FARUK' AND EMAIL = 'UPDATED MAIL 1'
--Tüm kullanıcıların E Mailleri ALL MAIL 2 olarak güncellendi.
UPDATE KULLANICI SET EMAIL = 'ALL MAIL 2'

--id si 1 olan yayımcının e mail adresi updated yayımcı e mail olarak güncellendi.
UPDATE YAYIMCI SET EMAIL = 'UPDATED YAYIMCI EMAIL 1' WHERE YAYIMCI_ID = 1
--kurulus tarihi 1992-03-12 olan yayımcının adı new yayımcı 2 olarak güncellendi.
UPDATE YAYIMCI SET ADI = 'NEW YAYIMCI 2' WHERE KURULUS_TARIHI = '1992-03-12'
--websitesi yayımcı site 3 olan yayımcının kurulus tarihi anlık tarih olarak güncellendi.
UPDATE YAYIMCI SET KURULUS_TARIHI = GETDATE() WHERE WEBSITE = 'YAYIMCI SITE 3'
--websitesi yayımcı site 4 olan yayımcının websitesi updated yayımcı website 4 olarak güncellendi.
UPDATE YAYIMCI SET WEBSITE = 'UPDATED YAYIMCI WEBSITE 4' WHERE WEBSITE = 'YAYIMCI SITE 4'
--tüm yayımcıların websiteleri website olaran güncellendi.
UPDATE YAYIMCI SET WEBSITE = 'WEBSITE'

--id si 1 olan yapımcının e mail adresi mail 1 olarak güncellendi.
UPDATE YAPIMCI SET EMAIL = 'MAIL 1', ADI = 'UPDATED YAPIMCI 1' WHERE YAPIMCI_ID = 1
--id si 2 olan yapımcının adı yapımcı 2 olarak güncellendi
UPDATE YAPIMCI SET ADI = 'YAPIMCI 2' WHERE YAPIMCI_ID = 2
--kuruluş tarihi 1989-03-11 tarihinden eski olan yapımcıların kuruluş tarihleri anlık tarih olarak güncellendi.
UPDATE YAPIMCI SET KURULUS_TARIHI = GETDATE() WHERE KURULUS_TARIHI < '1989-03-11'
--tüm yapımcıların websitesi website olarak güncellendi.
UPDATE YAPIMCI SET WEBSITE = 'WEBSITE'
--idsi 5 olan websitesi website olan yayımcının adı updated yapımcı 5 olarak güncellendi.
UPDATE YAPIMCI SET ADI = 'UPDATED YAPIMCI 5' WHERE YAPIMCI_ID = 5 AND WEBSITE = WEBSITE

--tüm bundle adları updated bundle olarak güncellendi
UPDATE BUNDLE SET ADI = 'UPDATED BUNDLE' 
--id si 2 olan bundle'ın adı updated bundle 2 olarak güncellendi.
UPDATE BUNDLE SET ADI = 'UPDATED BUNDLE 2', FIYAT = 199.99 WHERE BUNDLE_ID = 2
--idsi 3 olan bundle'ın fiyatı 1 olarak güncellendi.
UPDATE BUNDLE SET FIYAT = 1 WHERE BUNDLE_ID = 3
--fiyatı 100 birimden küçük olan tüm bundle fiyatları 49.99 olarak güncellendi.
UPDATE BUNDLE SET FIYAT = 49.99 WHERE FIYAT < 100
--tüm bundle isimleri all bundle updated olarak güncellendi.
UPDATE BUNDLE SET ADI = 'ALL BUNDLE UPDATED'


--idsi 1 olan oyunun adı football manager 2019 olarak güncellendi.
UPDATE OYUN SET ADI = 'FOOTBALL MANAGER 2019' WHERE OYUN_ID = 1
--idsi 1 olan oyunun yapımcı idsi 4 ve yayımcı idsi 3 olarak güncellendi.
UPDATE OYUN SET YAPIMCI_ID = 4, YAYIMCI_ID = 3 WHERE YAYIMCI_ID = 1
--yayımcı idsi dörtten büyük olan tüm oyunların bundle id leri 2, yayımcı idleri 1, yapımcı idleri 3 olarak güncellendi.
UPDATE OYUN SET BUNDLE_ID = 2, YAYIMCI_ID = 1, YAPIMCI_ID = 3 WHERE YAYIMCI_ID > 4
--yayımcı idsi 3 olan ve idsi 6 olan oyunun adı overwatch game of the year edition olarak güncellendi.
UPDATE OYUN SET ADI = 'OVERWATCH GAME OF THE YEAR EDITION', YAPIMCI_ID = 2 WHERE YAYIMCI_ID = 3 AND OYUN_ID = 6
--bundle idsi 5 olan oyunun bundle idsi 1 olarak güncellendi.
UPDATE OYUN SET BUNDLE_ID = 1 WHERE BUNDLE_ID = 5

--anahtar idsi 1 olan anahtarın fiyatı 250 birim, kullanıcı idsi 1 ve oyun idsi 1 olarak güncellendi.
UPDATE ANAHTAR SET FIYAT = 250, KULLANICI_ID = 1, OYUN_ID = 1 WHERE ANAHTAR_ID = 1
--kullanıcı idleri beşten küçük olan anahtarların fiyatları 599.99 birim olarak değiştirildi.
UPDATE ANAHTAR SET FIYAT = 599.99 WHERE KULLANICI_ID < 5
--kullanıcı idsi 2 olan anahtarın oyun idsi 3 olarak güncellendi.
UPDATE ANAHTAR SET OYUN_ID = 3 WHERE KULLANICI_ID = 2
--fiyatı 100 birim olan ve kullanıcı idsi 8 olan anahtarın fiyatı 200 birim olarak güncellendi.
UPDATE ANAHTAR SET FIYAT = 200 WHERE FIYAT = 100 AND KULLANICI_ID = 8
--fiyatı 99.99 ve 100 birim olan anahtarların kullanıcı idleri 1 olarak güncellendi.
UPDATE ANAHTAR SET KULLANICI_ID = 1 WHERE FIYAT = 99.99 AND FIYAT = 100

--türü yarış olan kategorinin türü futbol olarak güncellendi.
UPDATE KATEGORILER SET TUR = 'FUTBOL' WHERE TUR = 'YARIS'
--idsi 2 olan kategorinin türü yarış olarak güncellendi.
UPDATE KATEGORILER SET TUR = 'YARIS' WHERE KATEGORI_ID = 2
--idsi 2 ve 5 arasında olan kategorilerin türü strateji olarak güncellendi.
UPDATE KATEGORILER SET TUR = 'STRATEJI' WHERE KATEGORI_ID < 5 AND KATEGORI_ID > 2
--idsi 11 olan kategorinin türü rpg olarak güncellendi.
UPDATE KATEGORILER SET TUR = 'RPG' WHERE KATEGORI_ID = 11
--tüm kategorilerin türü null olarak güncellendi.
UPDATE KATEGORILER SET TUR = NULL

--odeme idsi 1 olan ödeme türünün adı banka kartı olarak güncellendi.
UPDATE ODEMETURU SET ADI = 'BANKA KARTI' WHERE ODEME_ID = 1
--adı paypal olan ödeme türünün adı cüzdan olarka güncellendi.
UPDATE ODEMETURU SET ADI = 'CUZDAN' WHERE ADI = 'PAYPAL'

--oyun idsi 5 olan başarımın adı başarım olarak güncellendi.
UPDATE BASARIMLAR SET ADI = 'BASARIM' WHERE OYUN_ID = 5
--oyun  idsi üçten büyük olan ve ondan küçük olan basarımların oyun idleri 1 olarak güncellendi
UPDATE BASARIMLAR SET OYUN_ID = 1 WHERE BASARIM_ID < 10 AND  OYUN_ID >= 4
--tüm başarımların adı başarım olarak güncellendi.
UPDATE BASARIMLAR SET ADI = 'BASARIM'
--başarım idleri 6 dan küçük olan başarımların adı başarımlar ve oyun idleri 4 olarak güncellendi.
UPDATE BASARIMLAR SET ADI = 'BASARIMLAR', OYUN_ID = 4 WHERE BASARIM_ID < 6
--adı başarımlar olan başarımların oyun idleri 6 olarak güncellendi.
UPDATE BASARIMLAR SET OYUN_ID = 6 WHERE ADI = 'BASARIMLAR'

--oyun idsi 8 olan odullerın tarihi 2018-1-1 olarak güncellendi.
UPDATE ODULLER SET TARIH = '2018-1-1' WHERE OYUN_ID = 8
-- adı odul_11 olan odulun oyun idsi 5 olarak güncellendi.
UPDATE ODULLER SET OYUN_ID = 5 WHERE ADI = 'ODUL_11'
--2018-1-1 den eski olan odullerin tarihleri anlık olarak güncellendi.
UPDATE ODULLER SET TARIH = GETDATE() WHERE TARIH < '2018-1-1' 
--tarihleri anlık tarihten ileri olan odullerin oyun idleri 10 olarak güncellendi.
UPDATE ODULLER SET OYUN_ID = 10 WHERE TARIH > GETDATE()
--oyun idleri 8 den küçük ve tarihleri 2018-05-10 olan odullerin adı oduller, tarihleri 2005-05-05 ve oyun idleri 6 olarak güncellendi.
UPDATE ODULLER SET ADI = 'ODULLER', TARIH = '2005-05-05', OYUN_ID = 6 WHERE OYUN_ID < 8 AND TARIH = '2018-05-10'

--idsi 1 olan tahsilatın kullanıcı adı faruk aygün olarak güncellendi.
UPDATE TAHSILAT SET KULLANICI_ADI = 'FARUK AYGUN' WHERE TAHSILAT_ID = 1
--son kullanma tarihi null olan tahsilatın son kullanma tarihi anlık olarak güncellendi.
UPDATE TAHSILAT SET SON_KULLANMA_TARIHI = GETDATE() WHERE SON_KULLANMA_TARIHI = NULL
--ad_soyad adında yeni sütun eklendi.
ALTER TABLE TAHSILAT
ADD AD_SOYAD VARCHAR(50)
--idsi 1 olan tahsilatın ad_soyad sütunu faruk aygün olarak güncellendi.
UPDATE TAHSILAT SET AD_SOYAD = 'FARUK AYGUN' WHERE TAHSILAT_ID = 1
--kullanıcı adı ümit olan kullancının ad_soyad sütunu ümit küçük olarak güncellendi.
UPDATE TAHSILAT SET AD_SOYAD = 'ÜMİT KÜÇÜK' WHERE KULLANICI_ADI = 'ÜMİT'
--idsi 2 den büyük olan tahsilatların ad_soyad sütunları bos olarak güncellendi.
UPDATE TAHSILAT SET AD_SOYAD = 'BOS' WHERE TAHSILAT_ID >= 3

--turarı 100 den küçük olan faturaların tutarları 99.99 olarak güncellendi.
UPDATE FATURA SET TUTAR = 99.99 WHERE TUTAR < 100
--2018-05-11 tarihinden sonraki fatularak anlık olarak güncellendi.
UPDATE FATURA SET TARIH = GETDATE() WHERE TARIH > '2018-05-11'

--tarih sütunun türü date yerine datetime olarak güncellendi.
ALTER TABLE FATURA 
ALTER COLUMN TARIH DATETIME
--tutar kolonun adı fiyat olarak güncellendi.
EXEC SP_RENAME 'FATURA.TUTAR',   FIYAT,  'COLUMN'
--fatura_no sütunu unique olarak güncellendi.
ALTER TABLE FATURA ADD CONSTRAINT CONSTRAINT1 UNIQUE (FATURA_NO)

--kullanıcı idleri 1 dışındaki başarımların tarihleri anlık olarak güncellendi.
UPDATE KAZANIR SET TARIH = GETDATE() WHERE KULLANICI_ID <> 1
--tarihleri anlık tarihten sonraki olan başarımların kullanıcı idleri 1 olaran güncellendiç
UPDATE KAZANIR SET KULLANICI_ID = 1 WHERE TARIH >= GETDATE()

--kazanır tablosunun adı kazanırlar olarak güncellendi.
EXEC SP_RENAME 'KAZANIR', KAZANIRLAR
--basarım_adı adında yeni sütun eklendi.
ALTER TABLE KAZANIRLAR
ADD BASARIM_ADI VARCHAR(30)
--basarım_adı null olan basarımların basarım_adı bos olarak güncellendi
UPDATE KAZANIRLAR SET BASARIM_ADI = 'BOS' WHERE BASARIM_ADI = NULL

--2017-05-03 dışındaki yorumların metinleri metin olarak güncellendi.
UPDATE YORUMYAPAR SET METIN = 'METIN' WHERE TARIH <> '2017-05-03'
--beğenmemeleri 0 olan yorumlarım beğenmemeleri null olarak güncellendi.
UPDATE YORUMYAPAR SET BEGENMEME = NULL WHERE BEGENMEME = 0
--metinleri metin olan yorumların kullanıcı idleri ve oyun idleri 1 olarak güncellendi.
UPDATE YORUMYAPAR SET KULLANICI_ID = 1, OYUN_ID = 1 WHERE METIN = 'METIN'

--yorumyapar tablosunun adı yorum yaparlar olarak güncellendi.
EXEC SP_RENAME 'YORUMYAPAR', YORUMYAPARLAR
--metini metin olan yorumların oyun idleri 1 olarak güncellendi.
UPDATE YORUMYAPARLAR SET OYUN_ID = 1 WHERE METIN = METIN




