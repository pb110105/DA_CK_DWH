-- Tạo Database
USE master;
GO
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'DVMCAR_DWH')
BEGIN
    ALTER DATABASE DVMCAR_DWH SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DVMCAR_DWH;
END
GO

CREATE DATABASE DVMCAR_DWH;
GO

USE DVMCAR_DWH;
GO

-- 1. TẠO CÁC BẢNG DIMENSION
CREATE TABLE Dim_Date (
    Date_Key    INT PRIMARY KEY,
    [Year]        INT,
    [Month]       INT,       
);

CREATE TABLE Dim_Maker (
    Maker_Key   INT PRIMARY KEY,
    Maker_Name  NVARCHAR(255)
);

CREATE TABLE Dim_GenModel (
    GenModel_Key    INT PRIMARY KEY,
    Maker_Key       INT,    
    GenModel_ID     NVARCHAR(100),
    GenModel_Name   VARCHAR(255)
);

CREATE TABLE Dim_Trim (
    Trim_Key        INT PRIMARY KEY,
    GenModel_Key    INT,    
    Trim_Name       NVARCHAR(255),
    Fuel_type       NVARCHAR(100),
    Gearbox         NVARCHAR(50),
    Bodytype        NVARCHAR(100),
    Gas_emission    FLOAT,
    Seat_num        INT,
    Door_num        INT
);

CREATE TABLE Dim_Ad_Vehicle (
    Ad_Vehicle_Key  INT PRIMARY KEY,
    GenModel_Key    INT,    
    Color           NVARCHAR(100),
    Reg_year        INT,
    Bodytype        NVARCHAR(100),
    Fuel_type       NVARCHAR(100),
    Gearbox         NVARCHAR(100),
    Seat_num        INT,
    Door_num        INT
);

-- 2. TẠO CÁC BẢNG FACT
CREATE TABLE Fact_Sales (
    Sales_Key       INT PRIMARY KEY,
    Date_Key        INT,    
    GenModel_Key    INT,
    Maker_Key       INT,
    Units_Sold      INT     
);

CREATE TABLE Fact_New_Car_Pricing (
    Pricing_Key     INT PRIMARY KEY,
    Date_Key        INT,    
    Trim_Key        INT,
    Entry_Price     DECIMAL(18,2),  
    Engine_size     FLOAT,  
    Gas_emission    FLOAT   
);

CREATE TABLE Fact_Used_Car_Ads (
    Ad_Key          INT PRIMARY KEY,
    Date_Key        INT,
    Ad_Vehicle_Key  INT,
    Listed_Price    DECIMAL(18,2),  
    Runned_Miles    INT,    
    Annual_Tax      DECIMAL(18,2),  
    Average_mpg     FLOAT   
);