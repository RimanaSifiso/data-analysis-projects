USE motus; -- name of the database where i stored the files receivced as tables

SELECT 
	DealershipName,
    SUM(SaleAmount) AS TotalSalesAmount
FROM analysis_ready
WHERE SaleDate >= '2025-01-01' -- I am adding these for 'completeness' sake, the dataset contains entries for 2025 only
  AND SaleDate < '2026-01-01'
GROUP BY DealershipName
ORDER BY TotalSalesAmount DESC
LIMIT 5;


-- Part 2.2
WITH MonthlySales AS (
    SELECT
        SaleYear,
        SaleMonth,
        SUM(SaleAmount) AS TotalSalesAmount
    FROM analysis_ready
    GROUP BY SaleYear, SaleMonth
)
SELECT
    SaleYear,
    SaleMonth,
    TotalSalesAmount,
    ROUND(
        (TotalSalesAmount - LAG(TotalSalesAmount) OVER (
            ORDER BY SaleYear, SaleMonth
        ))
        / NULLIF(LAG(TotalSalesAmount) OVER (
            ORDER BY SaleYear, SaleMonth
        ), 0) * 100,
        2
    ) AS GrowthPct
FROM MonthlySales
ORDER BY SaleYear, SaleMonth;



-- Part 2.3
SELECT
    Region,
    ROUND(AVG(DaysInStock), 1) AS AverageDaysInStock
FROM analysis_ready
GROUP BY Region
ORDER BY AverageDaysInStock;


--  Part 2.4

SELECT
    SaleID,
    Make,
    Model,
    Year,
    CostAmount,
    SaleAmount,
    Profit
FROM analysis_ready
WHERE Profit < 0
ORDER BY Profit ASC;

-- Part 2.5 
SELECT
    Make,
    Model,
    COUNT(*) AS UnitsSold,
    SUM(Profit) AS TotalProfit,
    ROUND(AVG(Profit), 2) AS AverageProfitPerUnit
FROM analysis_ready
GROUP BY Make, Model
ORDER BY TotalProfit DESC;

