
-- ====================================================================
-- SCRIPT KHỞI TẠO CƠ SỞ DỮ LIỆU KHO (DATA WAREHOUSE) - DVMCAR_DWH
-- Phiên bản: Chuẩn Kimball (Có Surrogate Key & Audit Column)
-- ====================================================================

USE master;
GO

-- 1. Xóa Database cũ nếu đã tồn tại
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'DVMCAR_DWH')
BEGIN
    ALTER DATABASE DVMCAR_DWH SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DVMCAR_DWH;
END
GO

-- 2. Tạo Database mới
CREATE DATABASE DVMCAR_DWH;
GO

USE DVMCAR_DWH;
GO

-- ====================================================================
-- PHẦN A: TẠO CÁC BẢNG DIMENSION (BẢNG CHIỀU)
-- ====================================================================

CREATE TABLE Dim_Date (
    Date_Key        INT IDENTITY(1,1) PRIMARY KEY, 
    [Year]          INT,                           
    [Month]         INT,                           
    ETL_LoadDate    DATETIME DEFAULT GETDATE()     
);

CREATE TABLE Dim_Maker (
    Maker_Key       INT IDENTITY(1,1) PRIMARY KEY, 
    Maker_Name      NVARCHAR(255),                 
    ETL_LoadDate    DATETIME DEFAULT GETDATE()
);

CREATE TABLE Dim_GenModel (
    GenModel_Key    INT IDENTITY(1,1) PRIMARY KEY, 
    Maker_Key       INT,                           
    GenModel_ID     NVARCHAR(100),                 
    GenModel_Name   VARCHAR(255),                  
    ETL_LoadDate    DATETIME DEFAULT GETDATE()
);

CREATE TABLE Dim_Trim (
    Trim_Key        INT IDENTITY(1,1) PRIMARY KEY, 
    GenModel_Key    INT,                           
    Trim_Name       NVARCHAR(255),                 
    Fuel_type       NVARCHAR(100),                 
    Gearbox         NVARCHAR(50),                  
    Bodytype        NVARCHAR(100),                 
    Gas_emission    FLOAT,                         
    Seat_num        INT,
    Door_num        INT,
    ETL_LoadDate    DATETIME DEFAULT GETDATE()
);

CREATE TABLE Dim_Ad_Vehicle (
    Ad_Vehicle_Key  INT IDENTITY(1,1) PRIMARY KEY, 
    GenModel_Key    INT,                           
    Color           NVARCHAR(100),                 
    Reg_year        INT,                           
    Bodytype        NVARCHAR(100),
    Fuel_type       NVARCHAR(100),
    Gearbox         NVARCHAR(100),
    Seat_num        INT,
    Door_num        INT,
    ETL_LoadDate    DATETIME DEFAULT GETDATE()
);

-- ====================================================================
-- PHẦN B: TẠO CÁC BẢNG FACT (BẢNG SỰ KIỆN)
-- ====================================================================

CREATE TABLE Fact_Sales (
    Sales_Key       INT IDENTITY(1,1) PRIMARY KEY,
    Date_Key        INT,                           
    GenModel_Key    INT,                           
    Maker_Key       INT,                           
    Units_Sold      INT,                           
    ETL_LoadDate    DATETIME DEFAULT GETDATE()
);

CREATE TABLE Fact_New_Car_Pricing (
    Pricing_Key     INT IDENTITY(1,1) PRIMARY KEY,
    Date_Key        INT,                           
    Trim_Key        INT,                           
    Entry_Price     DECIMAL(18,2),                 
    Engine_size     FLOAT,  
    Gas_emission    FLOAT,
    ETL_LoadDate    DATETIME DEFAULT GETDATE()
);

CREATE TABLE Fact_Used_Car_Ads (
    Ad_Key          INT IDENTITY(1,1) PRIMARY KEY,
    Date_Key        INT,                           
    Ad_Vehicle_Key  INT,                           
    Listed_Price    DECIMAL(18,2),                 
    Runned_Miles    INT,                           
    Annual_Tax      DECIMAL(18,2),                 
    Average_mpg     FLOAT,                         
    ETL_LoadDate    DATETIME DEFAULT GETDATE()
);
GO