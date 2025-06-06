\connect winwin;

COPY category_sales_monthly(
    category_sales_key,biz_date,region_name,province_name,channel,category,amount,quantity,branch_count,amount_last_month,quantity_last_month,branch_count_last_month,amount_last_year,quantity_last_year,branch_count_last_year)
FROM '/data/category_sales_monthly.csv'
WITH (FORMAT csv, HEADER true);

COPY group_sales_monthly(
    group_sales_key,category_sales_key,biz_date,region_name,province_name,channel,category,group_id,group_name,amount,quantity,branch_count,category_branch_amount,amount_last_month,quantity_last_month,branch_count_last_month,category_branch_amount_last_month,amount_last_year,quantity_last_year,branch_count_last_year,category_branch_amount_last_year)
FROM '/data/group_sales_monthly.csv'
WITH (FORMAT csv, HEADER true);

COPY brand_sales_monthly(
    brand_sales_key,group_sales_key,category_sales_key,biz_date,region_name,province_name,channel,category,group_id,group_name,brand_id,brand_name,amount,quantity,branch_count,category_branch_amount,amount_last_month,quantity_last_month,branch_count_last_month,category_branch_amount_last_month,amount_last_year,quantity_last_year,branch_count_last_year,category_branch_amount_last_year)
FROM '/data/brand_sales_monthly.csv'
WITH (FORMAT csv, HEADER true);

COPY product_sales_monthly(
    product_sales_key,category_sales_key,group_sales_key,brand_sales_key,biz_date,region_name,province_name,channel,category,group_id,group_name,brand_id,brand_name,product_id,amount,quantity,branch_count,category_branch_amount)
FROM '/data/product_sales_monthly_1.csv'
WITH (FORMAT csv, HEADER true);

COPY product_sales_monthly(
    product_sales_key,category_sales_key,group_sales_key,brand_sales_key,biz_date,region_name,province_name,channel,category,group_id,group_name,brand_id,brand_name,product_id,amount,quantity,branch_count,category_branch_amount)
FROM '/data/product_sales_monthly_2.csv'
WITH (FORMAT csv, HEADER true);


COPY dim_product(
    product_id,product_name,manufacturer_code,manufacturer_name,brand_id,brand_name,category,cls_1,cls_2,cls_3,group_id,group_name,unit,spec,package,launch_time,price,flavor)
FROM '/data/dim_product.csv'
WITH (FORMAT csv, HEADER true);

COPY dim_product_attributes(
    product_id,product_name,brand_id,brand_name,group_id,group_name,category,attribute_value,attribute_name )
FROM '/data/dim_product_attributes.csv'
WITH (FORMAT csv, HEADER true);

