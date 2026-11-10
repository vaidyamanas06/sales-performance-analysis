# Sales Performance Analysis

## Data Quality Notes

Before analyzing anything, I checked the data for problems. Here's what I found and how I handled it.

### Loading the data
I used the Sample Superstore dataset from Kaggle (9,994 rows, 19 columns) and loaded it into PostgreSQL. I first brought it in as plain text, then converted it to proper types (dates and numbers) in a cleaned table called `superstore_clean`.

My first import failed because my table had columns the CSV doesn't contain (customer name and postal code). Once I rebuilt the table to match the file's 19 columns, it loaded fine.

### What's in the data
- Orders from January 3, 2014 to December 30, 2017
- 793 customers, 1,862 products, 5,009 orders
- 4 regions and 49 states
- $2,297,200.86 in total sales and $286,397.02 in total profit

### What I checked and found
- **Missing values:** none.
- **Dates:** the file mixes two formats (`MM-DD-YYYY` and `M/D/YYYY`), but both are month-first, so one `TO_DATE` pattern handled them. No order shipped before it was placed.
- **Duplicates:** one pair of rows is identical except for the Row ID (order US-2014-150119). I kept both, since they could be genuine repeat line items.
- **Losses:** 1,871 rows (about 18.7%) have negative profit, and another 65 break even. Nothing has zero or negative sales.
- **Product ID quirk:** 32 product IDs are linked to more than one product name. I kept one row per ID using `DISTINCT ON`, so for those products the name shown is one of the variants.

### Checking my work
I split the flat file into four tables (`customers`, `orders`, `products`, `order_items`) and rebuilt the full dataset with a view called `orders_full`. It matches the cleaned table on row count (9,994) and on total sales and profit, so nothing was lost or duplicated along the way.
