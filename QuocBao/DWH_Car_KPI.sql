--1. Top 5 hãng xe có tổng doanh số cao nhất
SELECT TOP 5
    dm.Maker_Name,
    SUM(fs.Units_Sold) AS Total_Units_Sold
FROM Fact_Sales fs
INNER JOIN Dim_Maker dm ON fs.Maker_Key = dm.Maker_Key
GROUP BY dm.Maker_Name
ORDER BY Total_Units_Sold DESC;

--2. Giá rao bán xe cũ trung bình theo từng năm hãng xe
SELECT 
    dm.Maker_Name,
    COUNT(fa.Ad_Key) AS Total_Ads,
    ROUND(AVG(fa.Listed_Price), 2) AS Avg_Listed_Price
FROM Fact_Used_Car_Ads fa
INNER JOIN Dim_Ad_Vehicle dav ON fa.Ad_Vehicle_Key = dav.Ad_Vehicle_Key
INNER JOIN Dim_GenModel dg ON dav.GenModel_Key = dg.GenModel_Key
INNER JOIN Dim_Maker dm ON dg.Maker_Key = dm.Maker_Key
GROUP BY dm.Maker_Name
HAVING COUNT(fa.Ad_Key) > 100 
ORDER BY Avg_Listed_Price DESC;

--3. Top 10 dòng xe chạy ít hao xăng nhất và đóng thuế ít nhất
SELECT TOP 10
    dm.Maker_Name,
    dg.GenModel_Name,
    ROUND(AVG(fa.Average_mpg), 2) AS Avg_MPG,
    ROUND(AVG(fa.Annual_Tax), 2) AS Avg_Annual_Tax
FROM Fact_Used_Car_Ads fa
INNER JOIN Dim_Ad_Vehicle dav ON fa.Ad_Vehicle_Key = dav.Ad_Vehicle_Key
INNER JOIN Dim_GenModel dg ON dav.GenModel_Key = dg.GenModel_Key
INNER JOIN Dim_Maker dm ON dg.Maker_Key = dm.Maker_Key
WHERE fa.Average_mpg IS NOT NULL AND fa.Annual_Tax IS NOT NULL
GROUP BY dm.Maker_Name, dg.GenModel_Name
ORDER BY Avg_MPG DESC, Avg_Annual_Tax ASC;

--4. Phân khúc số dặm ảnh hưởng đến giá xe cũ
SELECT 
    CASE 
        WHEN Runned_Miles < 10000 THEN '1. Under 10k Miles'
        WHEN Runned_Miles BETWEEN 10000 AND 50000 THEN '2. 10k - 50k Miles'
        WHEN Runned_Miles BETWEEN 50001 AND 100000 THEN '3. 50k - 100k Miles'
        ELSE '4. Over 100k Miles'
    END AS Mileage_Bucket,
    COUNT(*) AS Total_Vehicles,
    ROUND(AVG(Listed_Price), 2) AS Avg_Price
FROM Fact_Used_Car_Ads
WHERE Runned_Miles IS NOT NULL
GROUP BY 
    CASE 
        WHEN Runned_Miles < 10000 THEN '1. Under 10k Miles'
        WHEN Runned_Miles BETWEEN 10000 AND 50000 THEN '2. 10k - 50k Miles'
        WHEN Runned_Miles BETWEEN 50001 AND 100000 THEN '3. 50k - 100k Miles'
        ELSE '4. Over 100k Miles'
    END
ORDER BY Mileage_Bucket;

--5. Biến động giá niêm yết xe mới theo năm
SELECT 
    dd.[Year],
    ROUND(AVG(fnp.Entry_Price), 2) AS Avg_New_Car_Price,
    ROUND(AVG(fnp.Engine_size), 2) AS Avg_Engine_Size
FROM Fact_New_Car_Pricing fnp
INNER JOIN Dim_Date dd ON fnp.Date_Key = dd.Date_Key
GROUP BY dd.[Year]
ORDER BY dd.[Year] ASC;

--6. Phân tích xu hướng ưa thích xe cũ theo kiểu dáng và nhiên liệu
SELECT 
    dav.Bodytype,
    dav.Fuel_type,
    COUNT(fa.Ad_Key) AS Total_Ads,
    ROUND(AVG(fa.Listed_Price), 2) AS Avg_Market_Price
FROM Fact_Used_Car_Ads fa
INNER JOIN Dim_Ad_Vehicle dav ON fa.Ad_Vehicle_Key = dav.Ad_Vehicle_Key
GROUP BY dav.Bodytype, dav.Fuel_type
ORDER BY Total_Ads DESC;