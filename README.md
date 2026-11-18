# Sales Performance Analysis

*Which products, regions, and discount levels actually make money?*

## Overview

I analyzed 9,994 order lines from a retail store (the Sample Superstore dataset from Kaggle), covering January 2014 to December 2017. I loaded the data into PostgreSQL, cleaned it, split it into four related tables, and answered a set of business questions with SQL. A Power BI dashboard is the next step.

**Tools:** PostgreSQL, SQL (joins, CTEs, window functions), Power BI (dashboard in progress)

## At a glance

| Metric | Value |
| Revenue | $2,297,200.86 |
| Profit | $286,397.02 |
| Profit margin | 12.5% |
| Orders | 5,009 |
| Customers | 793 |
| Products | 1,862 |
| Regions / states | 4 / 49 |

## Key findings

The numbers below come from the queries in `sql/05_business_questions.sql`.

1. **Discounts above 20% lose money.** Order lines with no discount average +$66.90 in profit, and lines with 1 to 20% off still average +$26.50. Past 20%, the average turns negative: -$77.86 per line at 21 to 40% off, and -$106.71 at 40% or more. Those two bands together lost about $135,000, which makes discounting the biggest margin problem in the data.

2. **Three sub-categories lose money overall.** Tables lose $17,725.48, Bookcases lose $3,472.56, and Supplies lose $1,189.10. Tables are by far the largest drag.

3. **West is the strongest region and Central the weakest.** West earns $108,418 in profit at a 14.9% margin. Central earns $39,706 at a 7.9% margin, roughly half of West's.

4. **Revenue dipped in 2015, then grew strongly.** Annual revenue was $484,248 in 2014, fell 2.8% in 2015, then grew 29.5% in 2016 and 20.4% in 2017, reaching $733,215.

5. **Revenue is spread across many customers.** About 396 of 793 customers account for the first 80% of revenue, so no small group drives the business. The top customer (SM-20320) brings in $25,043.

## What I would recommend

- Cap discounts at about 20% unless a product is being cleared on purpose.
- Review pricing and discounting on Tables, Bookcases, and Supplies.
- Find out why Central's margin is so much lower than West's.

## How I prepared the data

Before analyzing anything, I checked the data for problems. Here is what I found and what I did about it.

**Loading**
- I first loaded the CSV into a staging table as plain text, then converted it to proper types (dates and numbers) in a cleaned table called `superstore_clean`.
- My first import failed because my table had two columns the CSV doesn't contain (customer name and postal code). Once I rebuilt the table to match the file's 19 columns, it loaded fine.

**Checks and findings**
- **Missing values:** none.
- **Dates:** the file mixes two formats (`MM-DD-YYYY` and `M/D/YYYY`), but both are month-first, so one `TO_DATE` pattern handled them. No order shipped before it was placed.
- **Duplicates:** one pair of lines is identical except for the Row ID (order US-2014-150119). I kept both, since they could be genuine repeat items. They are included in all totals.
- **Losses:** 1,871 order lines (about 18.7%) have negative profit, and another 65 break even. No line has zero or negative sales.
- **Product ID quirk:** 32 product IDs are linked to more than one product name. I kept one row per ID using `DISTINCT ON`, so for those products the name shown is one of the variants.

**Structure and validation**
- I split the flat file into four tables (`customers`, `orders`, `products`, `order_items`) and rebuilt the full dataset with a view called `orders_full`.
- The view matches the cleaned table on row count (9,994) and on total sales and profit, so nothing was lost or duplicated along the way.

## Repository

- `sql/` : table creation, cleaning, data quality checks, and the business-question queries
- `README.md` : this file
