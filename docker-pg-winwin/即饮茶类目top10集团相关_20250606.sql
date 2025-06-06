-- 类目范围: 即饮茶
-- 集团： top10
-- 销售额top10集团
WITH ranked_data AS (
    SELECT 
        group_id,
        group_name,
        category,
        SUM(amount) AS amount,
        RANK() OVER ( ORDER BY SUM(amount) DESC) AS rk
    FROM public.dws_yy_rulai_group_sales_m
    WHERE category = '即饮茶' 
    AND biz_date >= '20230101'
    GROUP BY group_id, group_name, category
)
SELECT * FROM ranked_data WHERE rk <= 10;


-- 1.category_sales_monthly 
SELECT 
cube_category_sales_key category_sales_key ,
biz_date,     
coalesce(region_name ,'') as region_name,
coalesce(province_name ,'') as province_name,
coalesce(channel ,'') as channel,
category,
coalesce(amount ,0) as amount,
coalesce(quantity ,0) as quantity,
coalesce(branch_count ,0) as branch_count,
coalesce(amount_last_month ,0) as amount_last_month,
coalesce(quantity_last_month ,0) as quantity_last_month,
coalesce(branch_count_last_month ,0) as branch_count_last_month ,
coalesce(amount_last_year ,0) as amount_last_year,
coalesce(quantity_last_year ,0) as quantity_last_year,
coalesce(branch_count_last_year ,0) as branch_count_last_year
FROM public.dws_yy_rulai_category_sales_m
where category = '即饮茶'
and biz_date >= '20230101'
;

-- 2.group_sales_monthly 
with top10 as (
    SELECT 
        group_id,
        group_name,
        category
    from public.temp_top10_group_v2
),
sales as (
    select * from public.dws_yy_rulai_group_sales_m
    where biz_date >= '20230101'
)
SELECT 
cube_group_sales_key as group_sales_key,
cube_category_sales_key as category_sales_key,
biz_date,
coalesce(region_name ,'')region_name,
coalesce(province_name ,'')province_name ,
coalesce(channel ,'')channel ,
top10.category ,
top10.group_id ,
top10.group_name,
coalesce(amount ,0)amount,
coalesce(quantity ,0)quantity,
coalesce(branch_count ,0)branch_count,
coalesce(cls_branch_amount ,0) as category_branch_amount,
coalesce(amount_last_month ,0)amount_last_month,
coalesce(quantity_last_month ,0)quantity_last_month,
coalesce(branch_count_last_month ,0)branch_count_last_month,
coalesce(cls_branch_amount_last_month ,0) as category_branch_amount_last_month ,
coalesce(amount_last_year ,0)amount_last_year,
coalesce(quantity_last_year ,0)quantity_last_year, 
coalesce(branch_count_last_year ,0)branch_count_last_year ,
coalesce(cls_branch_amount_last_year ,0) as category_branch_amount_last_year
from top10 inner join sales
on top10.group_id = sales.group_id
and top10.group_name = sales.group_name
and top10.category = sales.category

;

-- 3.brand_sales_monthly 
with top10 as (
    SELECT 
        group_id,
        group_name,
        category
    from public.temp_top10_group_v2
),
sales as (
    select * from public.dws_yy_rulai_brand_sales_m
    where biz_date >= '20230101'
)
SELECT 
cube_brand_sales_key as brand_sales_key,
cube_group_sales_key as group_sales_key,
cube_category_sales_key as category_sales_key,
biz_date,
coalesce(region_name ,'')region_name,
coalesce(province_name ,'')province_name ,
coalesce(channel ,'')channel ,
top10.category ,
top10.group_id ,
top10.group_name,
brand_id ,
brand_name,
coalesce(amount ,0)amount,
coalesce(quantity ,0)quantity,
coalesce(branch_count ,0)branch_count,
coalesce(cls_branch_amount ,0) as category_branch_amount,
coalesce(amount_last_month ,0)amount_last_month,
coalesce(quantity_last_month ,0)quantity_last_month,
coalesce(branch_count_last_month ,0)branch_count_last_month,
coalesce(cls_branch_amount_last_month ,0) as category_branch_amount_last_month ,
coalesce(amount_last_year ,0)amount_last_year,
coalesce(quantity_last_year ,0)quantity_last_year, 
coalesce(branch_count_last_year ,0)branch_count_last_year ,
coalesce(cls_branch_amount_last_year ,0) as category_branch_amount_last_year
from top10 inner join sales
on top10.group_id = sales.group_id
and top10.group_name = sales.group_name
and top10.category = sales.category

;

--4.product_sales_monthly_v1
with top10 as (
    SELECT 
        group_id,
        group_name,
        category
    from public.temp_top10_group_v2
),
sales as (
    select * from public.dws_yy_rulai_product_sales_m
    where biz_date >= '20240401'
)
SELECT 
cube_product_sales_key as product_sales_key ,
cube_category_sales_key as category_sales_key,
cube_group_sales_key as group_sales_key,
cube_brand_sales_key as brand_sales_key,
biz_date,
coalesce(region_name ,'') as region_name,
coalesce(province_name ,'') as province_name ,
coalesce(channel ,'')channel ,
top10.category ,
top10.group_id ,
top10.group_name,
brand_id ,
coalesce(brand_name ,'') as brand_name,
product_id,
coalesce(amount ,0)amount,
coalesce(quantity ,0)quantity,
coalesce(branch_count ,0)branch_count,
coalesce(cls_branch_amount ,0) as category_branch_amount
from top10 inner join sales
on top10.group_id = sales.group_id
and top10.group_name = sales.group_name
and top10.category = sales.category;

-- 4.product_sales_monthly_v2
with top10 as (
    SELECT 
        group_id,
        group_name,
        category
    from public.temp_top10_group_v2
),
sales as (
    select * from public.dws_yy_rulai_product_sales_m
    where biz_date >= '20230101' and biz_date < '20240401'
)
SELECT 
cube_product_sales_key as product_sales_key ,
cube_category_sales_key as category_sales_key,
cube_group_sales_key as group_sales_key,
cube_brand_sales_key as brand_sales_key,
biz_date,
coalesce(region_name ,'') as region_name,
coalesce(province_name ,'') as province_name ,
coalesce(channel ,'')channel ,
top10.category ,
top10.group_id ,
top10.group_name,
brand_id ,
coalesce(brand_name ,'') as brand_name,
product_id,
coalesce(amount ,0)amount,
coalesce(quantity ,0)quantity,
coalesce(branch_count ,0)branch_count,
coalesce(cls_branch_amount ,0) as category_branch_amount
from top10 inner join sales
on top10.group_id = sales.group_id
and top10.group_name = sales.group_name
and top10.category = sales.category
;

-- 5.dim_product 
with
  top10 as (
    SELECT
      group_id,
      group_name,
      category
    from
      public.temp_top10_group_v2
  ),
  sales as (
    select
      *
    from
      public.dim_product
  )
SELECT
  product_id,
  coalesce(product_name, '') as product_name,
  coalesce(manu_code, '') as manufacturer_code,
  coalesce(manu_name, '') as manufacturer_name,
  CASE
    WHEN brand_id:: TEXT = '\N' THEN NULL
    else brand_id
  end as brand_id,
  coalesce(brand_name, '') as brand_name,
  top10.category,
  coalesce(cls_1, '') as cls_1,
  coalesce(cls_2, '') as cls_2,
  coalesce(cls_3, '') as cls_3,
  coalesce(top10.group_id, 0) as group_id,
  coalesce(top10.group_name, '') as group_name,
  coalesce(unit, '') as unit,
  coalesce(spec, '') as spec,
  coalesce(package, '') as package,
  CASE
    WHEN launch_time:: TEXT = '\N' THEN NULL
    else launch_time
  end as launch_time,
  CASE
    WHEN price:: TEXT = '\N' THEN NULL
    else price
  end as price,
  CASE
    WHEN flavor:: TEXT = '\N' THEN NULL
    else flavor
  end as flavor
from
  top10
  inner join sales on top10.group_id = sales.group_id
  and top10.group_name = sales.group_name
  and top10.category = sales.category
  
-- 6.temp_product_attributes
with
  product    as (
    select product_id,product_name,brand_id,brand_name,group_id,group_name,cls_4
    from dim_product
    where ds = '20250605' and cls_4 = '即饮茶'
    group by product_id,product_name,brand_id,brand_name,group_id,group_name,cls_4
  ),
  attributes as (
    select
           product_id,product_name,category,attribute_value,attribute_name
    from dim_product_attributes
    where ds >= '20230101'
    and category = '即饮茶'
    group by  product_id,product_name,category,attribute_value,attribute_name
  ),
  group_brand      as (
    select *
    from output
  )

select product.product_id, product.product_name, brand_id, brand_name, group_brand.group_id, group_brand.group_name, group_brand.category,
       coalesce(attribute_value, '') as attribute_value, coalesce(attribute_name, '') as attribute_name
from product
left join attributes
on product.product_id = attributes.product_id and product.product_name = attributes.product_name
inner join group_brand
on product.group_name = group_brand.group_name and product.group_id = group_brand.group_id;