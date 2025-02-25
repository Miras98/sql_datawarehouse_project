# Data Dictionary for Gold Layer
----

**OverView**

The Gold Layer is the Business-ready data representation, structured to support analytical and reporting use cases. it consists 
of **dimension tables** and **fact tables** for specific business metrics.

----

1. ## gold.dim_customers

-**Purpose**: Stores customers details enriched with demographics and geographic data.
-**Columns** : 

| Column Name   | Data Type   | Description                                                                                  |
|:--------------|:-----------:| :-----------------------------------------------------------------------------------         |
|customer_key   | INT         | Surrogate key uniquely identifying each customer record in the customer dimension table.     |
|customer_id    | INT         | Unique numerical identifier assigned to each customer.                                       |
|customer_number| NVARCHAR(50)| Alphanumeric identifier representing the customer .                                          |
|firstname      | NVARCHAR(50)| Customer's first name.                                                                       |
|lastname       | NVARCHAR(50)| Customer's last name or family name.                                                         |
|country        | NVARCHAR(50)| the Country of residence for each customer.                                                  |
|marital_status | NVARCHAR(50)| the marital status of the customer (e.g.,'Married','single').                                |
|gender         | NVARCHAR(50)| The gender of the customer  (e.g.,'Female', 'Male').                                         |
|birthdate      | DATE        | The birthdate of the customer, formated as YYYY-MM-DD (e.g. '2022-12-31')                    |
|create_date    | DATE        | The date when the customer record was created in the system.                                 |

----

2. ## gold.dim_product

-**Purpose**: Provides info about the products and their attributes.
-**Columns**: 

| Column Name   | Data Type   | Description                                                                                  |
|:--------------|:-----------:|:----------------------------------------------------------------------------------           |
|product_key    | INT         | Surrogate key uniquely identifying each product record in the product dim table.             |
|product_id     | INT         | Unique numerical identifier assigned to each product for internal tracking.                  |
|product_number | NVARCHAR(50)| Alphanumeric code representing the product, often used for categorization .                  |
|product_name   | NVARCHAR(50)| Descriptive name of the product including key details such as type, color and size.          |
|category_id    | NVARCHAR(50)| Unique identifier for the products category, linking to its high-level classification        |
|category       | NVARCHAR(50)| The braoder classification of the produ t                                                    |
|subcategory    | NVARCHAR(50)| A more detailed classification of the product within the category                            |
|maintenance    | NVARCHAR(50)| Indicates whether the product requires mainteneance  (e.g.,'Yes', 'No').                     |
|cost           | INT         | The cost or base price of the product                                                        |
|product_line   | NVARCHAR(50)| The specific product line or series to which the product belongs                             |
|start_date     | DATE        | The date when the product became available for sale or use                                   |

----

3. ## gold.fact_Sales
-**Purpose**: Provides info about the products and their attributes.
-**Columns**: 

| Column Name   | Data Type   | Description                                                                                  |
|:--------------|:-----------:|:----------------------------------------------------------------------------------           |
|order_numer    | NVARCHAR(50)| Unique alphanumeric identifier for each sales order.                                         |
|product_key    | INT         | Surrogate key linking the order table to the product dimension table.                        |
|customer_key   | INT         | Surrogate key linking the order table to the customer dimension table.                       |
|order_date     | DATE        | The date when the order was placed                                                           |
|shipping_date  | DATE        | The date when the order was shipped                                                          |
|due_date       | DATE        | The date when the order payment was due                                                      |
|sales_amount   | INT         | The total monetary value of the sale for the line item                                       |
|quantity       | INT         | The number of units of the product ordered for the line item                                 |
|price          | INT         | The price per unit of the product for the line item                                          |







