create database fitness;
use fitness;
select * from smartwatches;

select count(*) from smartwatches;

ALTER TABLE smartwatches
DROP COLUMN `Dial Shape`;

ALTER TABLE smartwatches
DROP COLUMN `Strap Color`;

ALTER TABLE smartwatches 
CHANGE `Current Price` Current_Price DECIMAL(10,2);

ALTER TABLE smartwatches 
CHANGE `Model Name` Model_name VARCHAR(100);

ALTER TABLE smartwatches 
CHANGE `Discount Percentage` Discount_Percentage VARCHAR(100);

ALTER TABLE smartwatches 
CHANGE `Battery Life (Days)` Battery_Life VARCHAR(100);

ALTER TABLE smartwatches 
CHANGE `Strap Material` Strap_Material VARCHAR(36);

ALTER TABLE smartwatches 
CHANGE `Display Size` Display_Size VARCHAR(36);

ALTER TABLE smartwatches 
CHANGE COLUMN `Original Price` original_price BIGINT;







# BEGINNER LEVEL SQL BASICS

#Show all columns from the table smartwatches.
select * from smartwatches;
#List all unique brands available.
select distinct brand from smartwatches;
# Select total Number of product of each brand
 select brand,count(*) from smartwatches group by brand;
#Display all smartwatches where the Rating > 4.
 select * from smartwatches where Rating >4; 
# Find smartwatches brand and it's rating  whose Current Price < 2000.
 select brand,Rating,Current_Price from smartwatches where Current_Price <2000 order by Rating desc;
#Show only the columns Brand, Model Name, and Current Price.
SELECT Brand, Model_name, Current_Price
FROM smartwatches;
#Sort smartwatches by Discount Percentage in descending order.
 select * from smartwatches order by Discount_Percentage desc;
#Count how many smartwatches are there for each brand.
select brand,count(*) total_smartwatches from smartwatches group by brand;
#Display smartwatches that have Touchscreen = 'Yes' and Bluetooth = 'Yes'.
 select * from smartwatches where Touchscreen= "yes" and Bluetooth="Yes";
#Find the minimum and maximum price in the dataset according to brand.
select brand, min(Current_Price) minimun_price,max(Current_Price) as maximum_price from smartwatches group by brand; 
#List smartwatches with a battery life greater than 7 days.
 select * from smartwatches where Battery_Life >7;
 
 
 #INTERMEDIATE LEVEL
 
#Find the average price and rating for each brand.
select brand,avg(Current_Price) Avg_Price,avg(Rating) Avg_rating from smartwatches group by  brand;
#Get the top 5 most expensive smartwatches.
 select * from smartwatches order by Current_Price desc limit 5;
#Find the brand with the most models.
select brand,count(*) total_model from smartwatches group by brand order by total_model desc limit 1;
#Calculate the average discount percentage per brand.
select brand , avg(Discount_Percentage) avg_Disscount from smartwatches group by brand;
#Display smartwatches where the discount is above 70% and rating > 4.
select * from smartwatches where Discount_Percentage >70 and Rating >4;


#Find the correlation between Discount Percentage and Rating (if analyzing in Python).

#Count how many smartwatches have battery life ≥ 7 days per brand.
select brand , count(Battery_Life) Days from smartwatches where Battery_Life >=7 group by brand;

#Find which strap material is most commonly used.
 select count(*) Count_material,Strap_Material 
 from smartwatches group by Strap_Material order by Count_material limit 1 ;
#Get smartwatches where weight is “75g +”.
select * from smartwatches where weight = "75g +";
#Display models with a Display Size > 1.7 inches
 select * from smartwatches where Display_size >1.7; 
 #Total number of watches with touchscreen
 select Touchscreen, count(*) as total_Touchscreen from smartwatches group by Touchscreen;
 
 
 # Advanced Level (Subqueries, Window Functions, Case, Data Cleaning)

#Show the brand(s) with the highest average rating.
select brand,avg(Rating) avg_rating from smartwatches group by brand order by avg_rating desc limit 1;
#Find the model with the largest discount percentage in each brand.
  SELECT Brand, 
       Model_name, 
       Discount_Percentage
FROM smartwatches s1
WHERE Discount_Percentage = (
    SELECT MAX(Discount_Percentage)
    FROM smartwatches s2
    WHERE s1.Brand = s2.Brand
);

#Create a new column Price_Difference = Original Price - Current Price.
select *,(original_price - Current_Price) Price_Difference from smartwatches;

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
#Find brands that offer both touchscreen and non-touchscreen watches.
   SELECT Brand
FROM smartwatches
WHERE Touchscreen IN ('Yes', 'No')
GROUP BY Brand
HAVING COUNT(DISTINCT Touchscreen) > 1;

# Rank all smartwatches by discount percentage (use RANK()).
select *, rank() over(order by  Discount_Percentage desc ) Discount_Rank
from smartwatches;
#Find the top 3 most rated watches (by number of ratings) per brand.
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

#Identify outliers in pricing (e.g., those above Q3 + 1.5×IQR).
WITH price_stats AS (
    SELECT 
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY "Current Price") AS Q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY "Current Price") AS Q3
    FROM smartwatches
)
SELECT s.*
FROM smartwatches s, price_stats p
WHERE s."Current Price" > (p.Q3 + 1.5 * (p.Q3 - p.Q1));

#Find the brand with the best rating-to-price ratio.
SELECT Brand, 
       AVG(Rating / "Current Price") AS avg_rating_to_price
FROM smartwatches
GROUP BY Brand
ORDER BY avg_rating_to_price DESC
LIMIT 1;

#Display models that are cheaper than the average price of their brand.
 
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
