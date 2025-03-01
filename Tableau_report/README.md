# 📖 Sales Analysis Dashboard

This project performs an in-depth analysis of sales data to uncover key insights and trends, 
Customers behavior and products key metrices.
The analysis is conducted using Tableau Desktop.

---

## 📑 Table of Contents
- [Overview](#overview)
- [Live Dashboard](#live-dashboard)
- [Dashboard Preview](#dashboard-preview)
- [Dataset](#dataset)
- [Business Questions](#business-questions)
- [Key findings](#key-findings)
- [Recommendations](#recommendations)
- [Usage](#usage)

---

## Overview
This project aims to generate insights after building the star schema in SQL Server. 
It analyzes sales performance and total orders across various dimensions such as time,
country, product categories, and customer demographics. 

---

## Live Dashboard
You can explore the interactive Dashboard on Tableau Public:  
[View the Sales Analysis story](https://public.tableau.com/app/profile/amira.saeed/viz/SalesAnalysis_17408325342030/Story1?publish=yes)

---

## Dashboard Preview
Here's a preview of the story created using Tableau:

![Sales Analysis Dashboard](images/dashboard-preview.png)

---

## Dataset
The analysis is performed using the following datasets:
- **fact_sales.xlsx**: Contains transaction details including date, product ID, quantity, and revenue.
- **dim_products.xlsx**: Information about product categories, names, and prices.
- **dim_customers.xlsx**: Customer demographics and geographical details.

---

## ❓ Business Questions
The analysis aims to answer the following key business questions:
- **Sales Analysis:**
  - What are the total sales and Profit trends over time?
  - Which months or seasons generate the highest sales?
  - What is the total order value?
  - What is the sales performance by country or location?

- **Product Analysis:**
  - Which products are the top-sellers?
  - What is the product-wise revenue contribution?
  - Which product line or segments drive the most profit?

- **Customer Analysis:**
  - Who are the most valuable customers (highest profit or purchase frequency)?
  - What is the customer segmentation based on purchase behavior?
  - Are there geographical patterns in customer purchases?

---

##  Key findings
### **Sales Trends**
- **Peak Sales Year:** The year 2013 recorded the highest sales, indicating strong market demand and potential business growth during this period.
- **Peak Sales Day:** Tuesdays experience the highest number of orders, suggesting a potential pattern in customer purchasing behavior.
- **Order Processing Time:** The average order processing time is **7 days**, indicating the standard duration from order placement to fulfillment.
- **Delivery Time:** The average delivery time is **5 days**, reflecting the typical shipping duration.

### **Customer Insights**
- **High-Value Customer Segment:** Customers aged **50 to 60** and those who are **married** contribute the highest sales amount.
- **Gender-Based Ordering Pattern:** Male customers place more orders than female customers.
- **Top Profit-Generating Customer:** Between **2010 and 2014**, **Jordan Turner** and **Willie Xu** generated the highest profit as customers.

### **Product Performance**
- **Top-Selling Products:** The analysis reveals that [Mountain-200 Black- 46], [Mountain-200 Black- 42], and [Mountain-200 Silver- 38]
  are the highest revenue-generating items, showing strong customer demand.
- **Category Trends:** The top 10 selling products fall mainly into the [Mountain Bikes] and [Road Bikes] segments, suggesting a clear customer preference.

## Recommendations
Based on the findings, we recommend the following actions:

1. **Leverage Peak Sales Days:**  
   - Run exclusive discounts or marketing campaigns on Tuesdays to further boost sales.

2. **Optimize Order & Delivery Processes:**  
   - Reduce processing time from **7 days** to improve efficiency.
   - Work with logistics partners to decrease the **5-day** average delivery time.

3. **Enhance Customer Targeting:**  
   - Develop targeted campaigns for customers aged **50 to 60** and married individuals.
   - Introduce special promotions aimed at female customers to encourage higher engagement.

4. **Maximize Product Performance:**  
   - Prioritize high-selling products in inventory and promotions.
   - Consider bundling strategies for top-performing product categories.
---

## Usage
- Open Tableau Desktop and load the datasets.
- Modify or create new visualizations to gain further insights.
