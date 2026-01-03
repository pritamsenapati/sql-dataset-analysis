# Smartwatch SQL Analysis — Complete SQL Project

**Project Title**: SmartWatch Analysis  
**Level**: Beginner  
**Database**: smartwatches  

## Description  
This project focuses on exploring and analyzing a dataset of smartwatches using SQL. The goal is to understand pricing patterns, brand performance, customer preferences, and discount trends within the smartwatch market.

## Objectives  
1. Set up a retail sales database: Create and populate a retail sales database with the provided sales data.  
2. Data Cleaning: Identify and remove any records with missing or null values.  
3. Exploratory Data Analysis (EDA): Perform basic exploratory data analysis to understand the dataset.  
4. Business Analysis: Use SQL to answer specific business questions and derive insights from the sales data.  

## Project Structure  

### 1. Database Setup  
- **Database Creation**: The project starts by creating a database named fitness.  
- **Table Creation**: A table named smartwatches is created to store smartwatch product information. The table structure includes columns for brand name, model name, current price, original price, discount percentage, rating, battery life, display size, strap material, touchscreen availability, Bluetooth support, weight, and other key specifications used for analyzing smartwatch features, pricing, and performance.

```sql
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
```

### 2. Data Analysis & Findings  
The following SQL queries were developed to answer specific business questions:  

#### **BEGINNER LEVEL SQL BASICS**  

1. **Write an SQL query to display all the columns from the table smartwatches.**  
   ```sql
   SELECT * FROM smartwatches;
   ```

2. **Write a query to find the total number of products for each brand.**  
   ```sql
   SELECT Brand, COUNT(*) FROM smartwatches GROUP BY Brand;
   ```

3. **List all unique brands available.**  
   ```sql
   SELECT DISTINCT Brand FROM smartwatches;
   ```

4. **Display all smartwatches where the Rating > 4.**  
   ```sql
   SELECT * FROM smartwatches WHERE Rating > 4;
   ```

5. **Find smartwatches brand and its rating whose Current Price < 2000.**  
   ```sql
   SELECT Brand, Rating, Current_Price FROM smartwatches WHERE Current_Price < 2000 ORDER BY Rating DESC;
   ```

6. **Show only the columns Brand, Model Name, and Current Price.**  
   ```sql
   SELECT Brand, Model_name, Current_Price FROM smartwatches;
   ```

7. **Sort smartwatches by Discount Percentage in descending order.**  
   ```sql
   SELECT * FROM smartwatches ORDER BY Discount_Percentage DESC;
   ```

8. **Count how many smartwatches are there for each brand.**  
   ```sql
   SELECT Brand, COUNT(*) total_smartwatches FROM smartwatches GROUP BY Brand;
   ```

9. **Display smartwatches that have Touchscreen = 'Yes' and Bluetooth = 'Yes'.**  
   ```sql
   SELECT * FROM smartwatches WHERE Touchscreen = "Yes" AND Bluetooth = "Yes";
   ```

10. **Find the minimum and maximum price in the dataset according to brand.**  
    ```sql
    SELECT Brand, MIN(Current_Price) minimum_price, MAX(Current_Price) AS maximum_price FROM smartwatches GROUP BY Brand;
    ```

11. **List smartwatches with a battery life greater than 7 days.**  
    ```sql
    SELECT * FROM smartwatches WHERE Battery_Life > 7;
    ```

#### **INTERMEDIATE LEVEL**  

12. **Find the average price and rating for each brand.**  
    ```sql
    SELECT Brand, AVG(Current_Price) Avg_Price, AVG(Rating) Avg_rating FROM smartwatches GROUP BY Brand;
    ```

13. **Get the top 5 most expensive smartwatches.**  
    ```sql
    SELECT * FROM smartwatches ORDER BY Current_Price DESC LIMIT 5;
    ```

14. **Find the brand with the most models.**  
    ```sql
    SELECT Brand, COUNT(*) total_model FROM smartwatches GROUP BY Brand ORDER BY total_model DESC LIMIT 1;
    ```

15. **Calculate the average discount percentage per brand.**  
    ```sql
    SELECT Brand, AVG(Discount_Percentage) avg_Discount FROM smartwatches GROUP BY Brand;
    ```

16. **Display smartwatches where the discount is above 70% and rating > 4.**  
    ```sql
    SELECT * FROM smartwatches WHERE Discount_Percentage > 70 AND Rating > 4;
    ```

17. **Count how many smartwatches have battery life ≥ 7 days per brand.**  
    ```sql
    SELECT Brand, COUNT(Battery_Life) Days FROM smartwatches WHERE Battery_Life >= 7 GROUP BY Brand;
    ```

18. **Find which strap material is most commonly used.**  
    ```sql
    SELECT COUNT(*) Count_material, Strap_Material FROM smartwatches GROUP BY Strap_Material ORDER BY Count_material DESC LIMIT 1;
    ```

19. **Get smartwatches where weight is “75g +”.**  
    ```sql
    SELECT * FROM smartwatches WHERE Weight = "75g +";
    ```

20. **Display models with a Display Size > 1.7 inches.**  
    ```sql
    SELECT * FROM smartwatches WHERE Display_Size > 1.7;
    ```

21. **Total number of watches with touchscreen.**  
    ```sql
    SELECT Touchscreen, COUNT(*) AS total_Touchscreen FROM smartwatches GROUP BY Touchscreen;
    ```

#### **ADVANCED LEVEL (Subqueries, Window Functions, Case, Data Cleaning)**  

22. **Show the brand(s) with the highest average rating.**  
    ```sql
    SELECT Brand, AVG(Rating) avg_rating FROM smartwatches GROUP BY Brand ORDER BY avg_rating DESC LIMIT 1;
    ```

23. **Find the model with the largest discount percentage in each brand.**  
    ```sql
    SELECT Brand, Model_name, Discount_Percentage
    FROM smartwatches s1
    WHERE Discount_Percentage = (
        SELECT MAX(Discount_Percentage)
        FROM smartwatches s2
        WHERE s1.Brand = s2.Brand
    );
    ```

24. **Create a new column Price_Difference = Original Price - Current Price.**  
    ```sql
    SELECT *, (original_price - Current_Price) AS Price_Difference FROM smartwatches;
    ```

25. **Create a new column to indicate price range of each smartwatch.**  
    ```sql
    SELECT *,
        CASE
            WHEN Current_Price > 10000 THEN 'Premium'
            WHEN Current_Price BETWEEN 5000 AND 10000 THEN 'Mid-range'
            WHEN Current_Price < 5000 THEN 'Budget'
        END AS Category
    FROM smartwatches;
    ```

26. **Find brands that offer both touchscreen and non-touchscreen watches.**  
    ```sql
    SELECT Brand
    FROM smartwatches
    WHERE Touchscreen IN ('Yes', 'No')
    GROUP BY Brand
    HAVING COUNT(DISTINCT Touchscreen) > 1;
    ```

27. **Rank all smartwatches by discount percentage (use RANK()).**  
    ```sql
    SELECT *, RANK() OVER (ORDER BY Discount_Percentage DESC) AS Discount_Rank
    FROM smartwatches;
    ```

28. **Find the top 3 most rated watches (by number of ratings) per brand.**  
    ```sql
    SELECT Brand, Model_name, Rating
    FROM (
        SELECT Brand, Model_name, Rating,
               RANK() OVER (PARTITION BY Brand ORDER BY Rating DESC) AS rank_by_brand
        FROM smartwatches
    ) ranked
    WHERE rank_by_brand <= 3;
    ```

29. **Identify outliers in pricing (e.g., those above Q3 + 1.5×IQR).**  
    ```sql
    WITH price_stats AS (
        SELECT 
            PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY "Current Price") AS Q1,
            PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY "Current Price") AS Q3
        FROM smartwatches
    )
    SELECT s.*
    FROM smartwatches s, price_stats p
    WHERE s."Current Price" > (p.Q3 + 1.5 * (p.Q3 - p.Q1));
    ```

30. **Find the brand with the best rating-to-price ratio.**  
    ```sql
    SELECT Brand, AVG(Rating / "Current Price") AS avg_rating_to_price
    FROM smartwatches
    GROUP BY Brand
    ORDER BY avg_rating_to_price DESC
    LIMIT 1;
    ```

31. **Display models that are cheaper than the average price of their brand.**  
    ```sql
    SELECT s.Brand, s.Model_name, s.Current_Price
    FROM smartwatches s
    JOIN (
        SELECT Brand, AVG("Current Price") AS avg_brand_price
        FROM smartwatches
        GROUP BY Brand
    ) avg_tbl
    ON s.Brand = avg_tbl.Brand
    WHERE s.Current_Price < avg_tbl.avg_brand_price;
    ```
