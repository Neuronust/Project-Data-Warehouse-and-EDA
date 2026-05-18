# End-to-End-E-Commerce-ETL-and-Sales-Analysis
## Project Overview

This project demonstrates an end-to-end modern data analytics workflow using Medallion Architecture (Bronze, Silver, and Gold layers). The project focuses on building a scalable data warehouse, performing ETL processes, transforming raw transactional data into analytical datasets, and generating business insights through exploratory data analysis and Advance Analysis.

Key components of this project include:

- **Data Architecture:** Designing a modern data warehouse using Bronze, Silver, and Gold layers.
- **ETL Pipelines:** Extracting, cleaning, transforming, and loading data into the warehouse.
- **Data Modeling:** Building fact and dimension tables optimized for analytical queries.
- **Exploratory Data Analysis (EDA):** Analyzing sales performance, customer behavior, and product trends using Python.
- **Advanced Analysis:** Performing Year-over-Year (YoY) analysis and RFM analysis to identify sales trends and classify customers into business-value segments.

## Building the Data Warehouse (Data Engineering)

### Objective

Develop a modern data warehouse using SQL Server to consolidate sales data and support analytical reporting and business decision-making.

### Specifications

- **Data Sources:** Import data from ERP and CRM systems provided as CSV files.
- **Data Quality:** Clean and resolve data quality issues before analysis.
- **Data Integration:** Combine multiple data sources into a unified analytical data model.
- **Data Modeling:** Design fact and dimension tables optimized for analytical queries.
- **Scope:** Focus only on the latest available dataset; historization is not required.
- **Documentation:** Provide clear and maintainable documentation for business stakeholders and analytics teams.
  
## Data Architecture
The data architecture for this project follows the Medallion Architecture approach, consisting of Bronze, Silver, and Gold layers to ensure scalable, organized, and analytics-ready data processing.
<img width="1441" height="726" alt="Data architecture" src="https://github.com/user-attachments/assets/4a64a6cc-5f59-4d93-881d-209b0bc48763" />

- **Bronze Layer :** The Bronze layer stores raw data ingested directly from source systems without modification. In this project, transactional data from CSV files is loaded into the SQL Server database as the initial staging layer.
- **Silver Layer :** The Silver layer focuses on data cleansing, standardization, normalization, and transformation processes. This layer improves data quality and prepares structured datasets for downstream analytical use cases.
- **Gold Layer :** The Gold layer contains business-ready data modeled using a star schema design optimized for reporting, dashboarding, and analytical queries. This layer includes fact and dimension tables used for sales analysis and customer segmentation.
### ETL Workflow

Raw CSV Files → Bronze Layer → Silver Layer → Gold Layer → Analytics & Reporting

## Data Structure

The analytical data model in the Gold layer is designed using a star schema approach to support efficient reporting, business intelligence, and analytical queries.

The model consists of fact tables that store transactional metrics and dimension tables that provide descriptive business context.
<img width="661" height="331" alt="data model drawio" src="https://github.com/user-attachments/assets/bc9a854a-4ae4-430f-936d-0dfc218694a8" />

## Data Analysis

### Exploratory Data Analysis (EDA)

Exploratory Data Analysis (EDA) was conducted to understand overall sales performance, customer purchasing behavior, and product trends within the dataset. The Analysis focused on :
- Data Exploration
- Dimensional Exploration
- Measure Exploration
- Magnitude Analysis
- Ranking Analysis

Detailed analysis and visualizations are available in:
'notebooks/EDA.ipynb'

### Advanced Analysis

Advanced analysis was performed to generate deeper business insights and support data-driven decision making. The Analsis included:
- Year-over-Year (YoY) sales analysis
- Year-over-Year (YoY) by Product
- RFM customer segmentation
- Customer value classification
## Key Findings
- The dataset contains **18,484 customers**, **295 products**, and **27,657 orders**, generating total sales of approximately **$29.35M** with an average product price of **$486.11**.
- The **United States** generated the highest sales revenue at approximately **$9.16M** and recorded the highest quantity sold with **20,474 units**, followed closely by Australia.
- Product sales were heavily dominated by the **Mountain-200 series**, which occupied all top 5 sales positions across the dataset.
- The **Bikes** category recorded the highest average product cost at approximately **$949.44**, significantly outperforming other product categories.
- Sales performance showed strong business growth between **2011 and 2013**, with **2013** achieving the highest sales revenue of approximately **$16.34M** and the highest customer count of **17,427 customers**.
- Sales activity demonstrated clear seasonality patterns, with **December** recording the highest monthly sales and customer activity.
- Year-over-Year (YoY) analysis revealed fluctuating growth patterns, including a sharp decline in 2012 followed by a strong recovery in 2013 with approximately **179.8% sales growth**.
- Product-level YoY analysis showed exceptionally high growth among several accessory products, while the **Mountain, Road, and Touring series** consistently dominated overall sales contribution.
- RFM segmentation analysis showed that the majority of customers belong to the **Mid-value segment** *(10,396 customers)*, primarily categorized as Potential Loyal customers.
- The business maintains a strong base of **4,821 VIP/Loyal customers**, although the presence of **4,969 At Risk and Can't Lose customers** indicates potential customer retention challenges that require strategic attention.
- Data quality analysis identified **4,569 customers with unknown gender information**, indicating incomplete categorical data that may affect demographic analysis accuracy.
- The 2014 dataset was excluded from YoY and MoM analysis because it only contained one month of transactional records, which could lead to misleading trend interpretation.

## Recommendations
- Focus customer retention strategies on the **At Risk** and **Can't Lose** customer segments, which together account for nearly 5,000 customers with declining engagement or purchasing activity.
- Develop loyalty programs and personalized marketing campaigns to strengthen relationships with the **VIP/Loyal customer segment**, which represents a significant source of revenue contribution.
- Increase marketing and promotional efforts for high-performing product categories such as the **Mountain, Road, and Touring series** to maximize sales growth opportunities.
- Evaluate underperforming products such as *Racing Socks* and *Patch Kit/8 Patches* to determine whether pricing adjustments, bundling strategies, or product discontinuation should be considered.
- Expand sales and marketing strategies in high-performing markets such as the **United States** and **Australia**, while identifying opportunities to improve performance in lower-performing regions.
- Leverage seasonal sales patterns by increasing inventory preparation and promotional campaigns ahead of **December**, which consistently records the highest sales performance.
- Improve data quality management processes, particularly for missing customer demographic attributes such as gender information, to enhance the accuracy of customer analysis and segmentation.
- Implement continuous product performance monitoring to identify emerging high-growth products and changing customer purchasing trends.
