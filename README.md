# Customer Funnel & Revenue Analysis with SQL

## Objective
This project analyzes e-commerce performance using SQL, focusing on revenue, profitability, customer behavior, cohorts, and payment performance.

## Dataset
The dataset contains:
- customers
- orders
- order_items
- payments
- products

## SQL Highlights
- Joins across multiple tables
- Reusable business views
- Window functions
- Cohort analysis
- LTV analysis
- Channel and category performance

## How to run

1. Run sql/schema.sql
2. Load CSV files
3. Run sql/views.sql
4. Run sql/analysis.sql

## Business Questions Answered
- What is the monthly revenue and gross margin?
- Which sales channel has the highest AOV?
- Which product categories generate the most profit?
- What is the share of cancelled and completed orders?
- How do new and returning customers behave over time?
- Who are the top customers by lifetime value?
- Which payment methods perform best?

## Key Insights

- Revenue decreased from April to May, but gross margin increased from 36% to 42%, indicating improved profitability despite lower sales volume.

- The increase in gross margin suggests better cost efficiency or a shift towards higher-margin products.

- Channel performance analysis shows that some channels generate higher average order value (AOV), even if total revenue is lower, highlighting opportunities for optimization.

- Returning customers contribute significantly to total orders, reinforcing the importance of customer retention strategies.

- Category performance reveals that not all high-revenue categories are the most profitable, emphasizing the need to focus on margin, not just sales volume.

- Cohort analysis indicates that customer activity declines over time, which suggests opportunities to improve retention through marketing or engagement strategies.

- Payment method analysis shows differences in revenue contribution and order volume, which can guide optimization of payment options.

## Project Structure
- `sql/schema.sql`: table definitions
- `sql/views.sql`: reusable business logic
- `sql/analysis.sql`: final business analysis queries

## Sample Results
Monthly revenue, gross profit and gross margin
<img width="695" height="155" alt="image" src="https://github.com/user-attachments/assets/10446197-ff52-40f4-a808-46cc8b4779dd" />

Channel performance or category performance
<img width="698" height="145" alt="image" src="https://github.com/user-attachments/assets/d0c26401-16bf-431c-ad28-a10a1f5e680f" />
