-- PostgreSQL‑ready DDL
-- All key columns are NOT NULL and declared PRIMARY KEY.
-- Monetary fields use float8 for exact precision.
-- COUNT fields use float8.
-- Timestamps use the shorthand TIMESTAMPTZ.

\connect winwin;

-- ===========================
-- 1. Category‑level sales
-- ===========================
CREATE TABLE category_sales_monthly (
    category_sales_key TEXT PRIMARY KEY,
    biz_date TIMESTAMPTZ      NOT NULL,
    region_name TEXT,
    province_name TEXT,
    channel TEXT,
    category TEXT,
    amount float8,
    quantity float8,
    branch_count float8,
    amount_last_month float8,
    quantity_last_month float8,
    branch_count_last_month float8,
    amount_last_year float8,
    quantity_last_year float8,
    branch_count_last_year float8
);

-- ===========================
-- 2. Group‑level sales
-- ===========================
CREATE TABLE group_sales_monthly (
    group_sales_key   TEXT PRIMARY KEY,
    category_sales_key TEXT NOT NULL
        REFERENCES category_sales_monthly (category_sales_key)
        ON DELETE CASCADE,
    biz_date TIMESTAMPTZ      NOT NULL,
    region_name TEXT,
    province_name TEXT,
    channel TEXT,
    category TEXT,
    group_id   float8,
    group_name TEXT,
    amount float8,
    quantity float8,
    branch_count float8,
    category_branch_amount float8,
    amount_last_month float8,
    quantity_last_month float8,
    branch_count_last_month float8,
    category_branch_amount_last_month float8,
    amount_last_year float8,
    quantity_last_year float8,
    branch_count_last_year float8,
    category_branch_amount_last_year float8
);

-- ===========================
-- 3. Brand‑level sales
-- ===========================
CREATE TABLE brand_sales_monthly (
    brand_sales_key    TEXT PRIMARY KEY,
    group_sales_key    TEXT NOT NULL
        REFERENCES group_sales_monthly (group_sales_key)
        ON DELETE CASCADE,
    category_sales_key TEXT NOT NULL
        REFERENCES category_sales_monthly (category_sales_key)
        ON DELETE CASCADE,
    biz_date TIMESTAMPTZ      NOT NULL,
    region_name TEXT,
    province_name TEXT,
    channel TEXT,
    category TEXT,
    group_id   float8,
    group_name TEXT,
    brand_id   float8,
    brand_name TEXT,
    amount float8,
    quantity float8,
    branch_count float8,
    category_branch_amount float8,
    amount_last_month float8,
    quantity_last_month float8,
    branch_count_last_month float8,
    category_branch_amount_last_month float8,
    amount_last_year float8,
    quantity_last_year float8,
    branch_count_last_year float8,
    category_branch_amount_last_year float8
);

-- ===========================
-- 4. Product‑level sales
-- ===========================
CREATE TABLE product_sales_monthly (
    product_sales_key  TEXT PRIMARY KEY,
    category_sales_key TEXT NOT NULL
        REFERENCES category_sales_monthly (category_sales_key)
        ON DELETE CASCADE,
    group_sales_key    TEXT NOT NULL
        REFERENCES group_sales_monthly (group_sales_key)
        ON DELETE CASCADE,
    brand_sales_key    TEXT NOT NULL
        REFERENCES brand_sales_monthly (brand_sales_key)
        ON DELETE CASCADE,
    biz_date TIMESTAMPTZ      NOT NULL,
    region_name TEXT,
    province_name TEXT,
    channel TEXT,
    category TEXT,
    group_id   float8,
    group_name TEXT,
    brand_id   float8,
    brand_name TEXT,
    product_id TEXT NOT NULL,
    amount float8,
    quantity float8,
    branch_count float8,
    category_branch_amount float8
);

-- ===========================
-- 5. Product dimension
-- ===========================
CREATE TABLE dim_product (
    product_id   TEXT PRIMARY KEY,
    product_name TEXT,
    manufacturer_code    TEXT,
    manufacturer_name    TEXT,
    brand_id     float8,
    brand_name   TEXT,
    category     TEXT,
    cls_1        TEXT,
    cls_2        TEXT,
    cls_3        TEXT,
    group_id     float8,
    group_name   TEXT,
    unit         TEXT,
    spec         TEXT,
    package      TEXT,
    launch_time  TIMESTAMPTZ,
    price        float8,
    flavor       TEXT
);

-- ===========================
-- 6. Product attributes
-- ===========================
CREATE TABLE dim_product_attributes (
    product_id   TEXT,
    product_name TEXT,
    brand_id     BIGINT,
    brand_name   TEXT,
    group_id     BIGINT,
    group_name   TEXT,
    category     TEXT,
    attribute_value  TEXT,
    attribute_name   TEXT
);
-- Optional FK from fact table to dimension
-- ALTER TABLE product_sales_monthly
--    ADD CONSTRAINT fk_sales_product
--    FOREIGN KEY (product_id)
--    REFERENCES dim_product (product_id)
--    ON DELETE SET NULL;

