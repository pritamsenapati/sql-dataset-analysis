# Smartwatch SQL Analysis — Complete SQL Project

** Project Title : SmartWatch Analysis
** Level : Beginner
** Database : smartwatches


## description 
This project focuses on exploring and analyzing a dataset of smartwatches using SQL. The goal is to understand pricing patterns, brand performance, customer preferences, and discount trends within the smartwatch market.



# Objectives
Set up a retail sales database: Create and populate a retail sales database with the provided sales data.
Data Cleaning: Identify and remove any records with missing or null values.
Exploratory Data Analysis (EDA): Perform basic exploratory data analysis to understand the dataset.
Business Analysis: Use SQL to answer specific business questions and derive insights from the sales data.

# Project Structure

 1. Database Setup

  . Database Creation: The project starts by creating a database named fitness.
  . Table Creation : A table named smartwatches is created to store smartwatch product information. The table structure includes columns for brand name, model name, current price, original price, discount percentage, rating, battery life, display size, strap material, touchscreen availability, Bluetooth support, weight, and other key specifications used for analyzing smartwatch features, pricing, and performance.



CREATE TABLE smartwatches (
    Watch_ID INT AUTO_INCREMENT PRIMARY KEY,
    Brand VARCHAR(100),
    Model_name VARCHAR(100),
    Current_Price DECIMAL(10,2),
    original_price BIGINT,
    Discount_Percentage VARCHAR(100),
    Rating DECIMAL(3,1),
    Battery_Life VARCHAR(100),
    Strap_Material VARCHAR(36),
    Display_Size VARCHAR(36),
    Touchscreen VARCHAR(10),
    Bluetooth VARCHAR(10),
    Weight VARCHAR(50)
);

 # BEGINNER LEVEL SQL BASICS
    2 . Data Analysis & Findings
       The following SQL queries were developed to answer specific business questions:
    
       1 .1 Write an SQL query to display all the columns from the table smartwatches.
       
            select * from smartwatches;
      2 Write a query to find the total number of products for each brand.
             select Brand,count(*) from smartwatches group by Brand;
    
      3 .cList all unique brands available.
         select distinct brand from smartwatches;
      4 .Display all smartwatches where the Rating > 4.
         select * from smartwatches where Rating >4; 
     5 . Find smartwatches brand and it's rating  whose Current Price < 2000.
         select brand,Rating,Current_Price from smartwatches where Current_Price <2000 order by Rating desc;
     6 .Show only the columns Brand, Model Name, and Current Price.
        SELECT Brand, Model_name, Current_Price
        FROM smartwatches;
     7 .Sort smartwatches by Discount Percentage in descending order.
         select * from smartwatches order by Discount_Percentage desc;
     8 .Count how many smartwatches are there for each brand.
        select brand,count(*) total_smartwatches from smartwatches group by brand;
     9 .Display smartwatches that have Touchscreen = 'Yes' and Bluetooth = 'Yes'.
         select * from smartwatches where Touchscreen= "yes" and Bluetooth="Yes";
     10 .Find the minimum and maximum price in the dataset according to brand.
        select brand, min(Current_Price) minimun_price,max(Current_Price) as maximum_price from smartwatches group by brand; 
     11 .List smartwatches with a battery life greater than 7 days.
         select * from smartwatches where Battery_Life >7;


   # INTERMEDIATE LEVEL
 
11 .Find the average price and rating for each brand.
     select brand,avg(Current_Price) Avg_Price,avg(Rating) Avg_rating from smartwatches group by  brand;
12 .Get the top 5 most expensive smartwatches.
 select * from smartwatches order by Current_Price desc limit 5;
13 . Find the brand with the most models.
   select brand,count(*) total_model from smartwatches group by brand order by total_model desc limit 1;
14 . Calculate the average discount percentage per brand.
    select brand , avg(Discount_Percentage) avg_Disscount from smartwatches group by brand;
15 . Display smartwatches where the discount is above 70% and rating > 4.
    select * from smartwatches where Discount_Percentage >70 and Rating >4;
 16 . Count how many smartwatches have battery life ≥ 7 days per brand.
     select brand , count(Battery_Life) Days from smartwatches where Battery_Life >=7 group by brand;

17 . Find which strap material is most commonly used.
   select count(*) Count_material,Strap_Material from smartwatches group by Strap_Material order by Count_material limit 1 ;
 18 . Get smartwatches where weight is “75g +”.
   select * from smartwatches where weight = "75g +";
19 . Display models with a Display Size > 1.7 inches
 select * from smartwatches where Display_size >1.7; 
 20 .Total number of watches with touchscreen
     select Touchscreen, count(*) as total_Touchscreen from smartwatches group by Touchscreen;



# Advanced Level (Subqueries, Window Functions, Case, Data Cleaning)

21 .Show the brand(s) with the highest average rating.
select brand,avg(Rating) avg_rating from smartwatches group by brand order by avg_rating desc limit 1;  
22 .Find the model with the largest discount percentage in each brand.
  SELECT Brand, 
       Model_name, 
       Discount_Percentage
FROM smartwatches s1
WHERE Discount_Percentage = (
    SELECT MAX(Discount_Percentage)
    FROM smartwatches s2
    WHERE s1.Brand = s2.Brand
);

23 .Create a new column Price_Difference = Original Price - Current Price.
select *,(original_price - Current_Price) Price_Difference from smartwatches;

24 . Create a new column to indicate price range of each smartwatches 
-- Categorize smartwatches as:
-- “Premium” if Current Price > 10000
-- “Mid-range” if Current Price between 5000–10000
-- “Budget” if Current Price < 5000

select *,
         case
            when Current_Price > 10000 then 'Premium'
            when Current_Price between 5000 and 10000 then 'Mid-range'
            when Current_Price <5000 then 'Budget'
            end as Category
            from smartwatches;
25 .Find brands that offer both touchscreen and non-touchscreen watches.
   SELECT Brand
FROM smartwatches
WHERE Touchscreen IN ('Yes', 'No')
GROUP BY Brand
HAVING COUNT(DISTINCT Touchscreen) > 1;

26 . Rank all smartwatches by discount percentage (use RANK()).
select *, rank() over(order by  Discount_Percentage desc ) Discount_Rank
from smartwatches;

27 .Find the top 3 most rated watches (by number of ratings) per brand.
 SELECT Brand, 
       Model_name, 
      Rating
FROM (
    SELECT Brand, 
           Model_name, 
          Rating,
           RANK() OVER (PARTITION BY Brand ORDER BY Rating DESC) AS rank_by_brand
    FROM smartwatches
) ranked
WHERE rank_by_brand <= 3;

28 .Identify outliers in pricing (e.g., those above Q3 + 1.5×IQR).
WITH price_stats AS (
    SELECT 
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY "Current Price") AS Q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY "Current Price") AS Q3
    FROM smartwatches
)
SELECT s.*
FROM smartwatches s, price_stats p
WHERE s."Current Price" > (p.Q3 + 1.5 * (p.Q3 - p.Q1));

29 .Find the brand with the best rating-to-price ratio.
SELECT Brand, 
       AVG(Rating / "Current Price") AS avg_rating_to_price
FROM smartwatches
GROUP BY Brand
ORDER BY avg_rating_to_price DESC
LIMIT 1;

30 .Display models that are cheaper than the average price of their brand.
 
 SELECT s.Brand, 
       s.Model_name, 
       s.Current_Price
FROM smartwatches s
JOIN (
    SELECT Brand, 
           AVG("Current Price") AS avg_brand_price
    FROM smartwatches
    GROUP BY Brand
) avg_tbl
ON s.Brand = avg_tbl.Brand
WHERE s.Current_Price < avg_tbl.avg_brand_price;

