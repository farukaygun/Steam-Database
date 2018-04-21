IF DB_ID('GAMES_SALES_PLATFORM') IS NOT NULL
	BEGIN
		ALTER DATABASE [GAMES_SALES_PLATFORM] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
		USE MASTER
		DROP DATABASE GAMES_SALES_PLATFORM
	END
GO

CREATE DATABASE GAMES_SALES_PLATFORM
	ON PRIMARY	(
					NAME = 'GAMES_SALES_PLATFORM_DB',
					FILENAME = 'C:\database\GAMES_SALES_PLATFORM.mdf',
					SIZE = 5MB,
					MAXSIZE = 100MB,
					FILEGROWTH = 5MB
				)
	LOG ON		(
					NAME = 'GAMES_SALES_PLATFORM_DB_LOG',
					FILENAME = 'C:\database\GAMES_SALES_PLATFORM.ldf',
					SIZE = 2MB,
					MAXSIZE = 50MB,
					FILEGROWTH = 1MB
				)
GO

USE GAMES_SALES_PLATFORM

CREATE TABLE OYUN 
(

)
GO

CREATE TABLE KULLANICI
(

)
GO

CREATE TABLE ANAHTAR /* 'KEY' YAZILMIYOR */
(

)
GO

CREATE TABLE FATURA 
(

)
GO

CREATE TABLE ODEME_TURU 
(

)
GO

CREATE TABLE TAHSILAT 
(

)
GO

CREATE TABLE BASARIMLAR 
(

)
GO

CREATE TABLE BUNDLE 
(

)
GO

CREATE TABLE KATEGORILER 
(

)
GO

CREATE TABLE YAPIMCI 
(

)
GO

CREATE TABLE YAYIMCI 
(

)
GO

CREATE TABLE ODULLER 
(

)
GO
