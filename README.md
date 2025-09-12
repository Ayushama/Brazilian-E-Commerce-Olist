##  Brazilian E-Commerce Olist Analysis

This project analyzes the **Brazilian E-Commerce Public Dataset (Olist)** using **SQL, Python, and Power BI** to uncover insights into sales, customers, sellers, reviews, and payments. The goal is to build a structured **star schema** and create **interactive dashboards** for business intelligence.

---
 
### 📂 Project Structure
 
```
Brazilian-E-Commerce-Olist/
│
├── dataset/                         # Raw datasets (CSV files)
│   ├── olist_customers_dataset.csv
│   ├── olist_geolocation_dataset.csv
│   ├── olist_order_items_dataset.csv
│   ├── olist_order_payments_dataset.csv
│   ├── olist_order_reviews_dataset.csv
│   ├── olist_orders_dataset.csv
│   ├── olist_products_dataset.csv
│   ├── olist_sellers_dataset.csv
│   └── product_category_name_translation.csv
│
├── olist Visual.pbix                # Power BI dashboard
├── olist.ipynb                      # Jupyter Notebook for Python EDA
├── Olist Query.sql                  # SQL scripts for analysis
└── README.md                        # Project documentation
```

---

### 🔑 Key Features 

* **SQL Analysis** – Queries for customer behavior, order performance, payments, and reviews.
* **Python EDA** – Exploratory Data Analysis with pandas, matplotlib, seaborn.
* **Power BI Dashboard** – Multi-dashboard visualization (Sales, Customers, Sellers, Payments).
* **Star Schema** – Modeled fact & dimension tables for optimized reporting.
 
---
### 📊 Dashboards

1. **Orders & Delivery Dashboard**  
   Tracks total orders, delivered vs. canceled orders, freight cost, and delivery time performance.  

2. **Customers & Sellers Dashboard**  
   Highlights customer growth, top customer cities, unique customers, and seller distribution across Brazil.  

3. **Products & Reviews Dashboard**  
   Shows sales by product categories, top-selling products, and customer satisfaction through review scores.  
---

### 📈 Key KPIs

- **Sales & Orders**: Total Sales, Freight, Orders, Delivered Orders  
- **Delivery Performance**: Average Delivery Time, Delayed Orders  
- **Customers & Sellers**: Total Customers, New Customers, Total Sellers, Top Cities  
- **Products & Reviews**: Top Categories, Distinct Products, Average Review Score

---

### ⚙️ Tools & Tech

* **SQL** (MySQL) – Data preparation & queries
* **Python** – Data cleaning & visualization
* **Power BI** – Dashboard creation
* **GitHub** – Project version control

---

### 📌 How to Run

1. Clone this repo:

   ```bash
   git clone https://github.com/Ayushama/Brazilian-E-Commerce-Olist.git
   ```
2. Load datasets from the `dataset/` folder.
3. Run SQL queries from `Olist Query.sql`.
4. Open `olist.ipynb` for Python EDA.
5. Open `olist Visual.pbix` in Power BI for dashboards.

---

### 📢 Credits

* Dataset: [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
* Analysis: By **[Ayush Aman](www.linkedin.com/in/ayush-aman-039817161)**

---
