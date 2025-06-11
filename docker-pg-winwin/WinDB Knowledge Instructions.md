# WinWin Knowledge Instructions



## 销售汇总数据表整体说明

数据库中有4个级别的月度销售汇总表，粒度从粗到细分别是：
- “类目”月度销售汇总数据表 category_sales_monthly
- “集团”月度销售汇总数据表 group_sales_monthly
- “品牌”月度销售汇总数据表 brand_sales_monthly
- “商品”月度销售汇总数据表 product_sales_monthly

注意：
- 要仔细分析用户的原始问题，准确判断出用户希望在哪个粒度上进行数据统计分析，从而选择合适的销售汇总表进行查询。这个判断是所有逻辑的出发点，非常重要！
- 如果用户的一个问题，同时包括了两个粒度的统计分析需求。可以立即反馈用户，请求将复合问题拆分为两个问题，分别提问。



## 可查询维度说明

- 时间：monthly后缀的数据表中的 biz_date 字段，都是用“一个月第一天0点”表示当月，所以时间查询的最小颗粒是“月(month)”。如果用户问题要求“季度”、“半年”、“整年”或者“今年”的粒度，需要根据具体的需求，对相关的月度数据进行“求和(SUM)”操作。
- 区域 region：中国的7个地域大区，包括：华北地区 华东地区 西南地区 西北地区 华南地区 华中地区 东北地区。
- 省份 province：中国的省、自治区和直辖市，包括：青海省 安徽省 云南省 重庆市 内蒙古自治区 湖北省 天津市 新疆维吾尔自治区 辽宁省 河北省 浙江省 吉林省 西藏自治区 江苏省 贵州省 广西壮族自治区 陕西省 湖南省 上海市 山西省 黑龙江省 甘肃省 山东省 福建省 广东省 河南省 北京市 海南省 江西省 宁夏回族自治区 四川省。
- 渠道 channel：超市业态，包括：便利店 大卖场 小超市 大超市 食杂店。
- 类目 category：商品所属类目，例如：即饮茶 碳酸饮料 常温酸奶 ……
- 集团 group：商品所属集团，例如：农夫山泉 伊犁 康师傅 ……
- 品牌 brand：商品所属品牌，例如：农夫山泉 安慕希 可口可乐 ……
- 商品 product：商品汇总信息分别保存在两个维度表中：dim_product 和 dim_product_attributes。其中商品的“常用属性”放在dim_product表中，包括：商品名(product_name) 类目名(category)  集团名(group_name) 品牌名(brand_name) 厂商名(manufacturer_name) 单位(unit) 规格(spec) 包装(package) 上市时间(launch_time) 价格(price) 口味(flavor)。而商品的其他属性以Key-Value的形式保存在dim_product_attributes表中的 attribute_name 和 attribute_value中。

注意：
- 如果用户的问题中，既不包括“区域”也不包括“省份”描述的约束条件，默认指“全国”或“全中国”，这时查询条件Where中需要加入“ region_name is null AND province_name is null ”。
- 如果用户的问题中，不包括“超市业态”描述的约束条件，默认指“全渠道”或“全业态”，这时查询条件Where中需要加入“ channel is null ”。
- 存在“集团名(group_name) ”和“品牌名(brand_name)”相同的情况，通常情况下，用户的问题中会在名称后面加上“集团”或“品牌”的文字以示区分，例如：“农夫山泉集团”或“农夫山泉品牌”。
- 如果用户的问题中，包括商品常用属性之外的属性，比如”茶种”、”含糖情况”，此时需要在dim_product_attributes中查询attribute_name字段，并根据用户实际问题组合”类目名(category)  集团名(group_name) 品牌名(brand_name)”字段查询出product_id，然后展开后续的查询逻辑。
- 需要强调的是：dim_product 和 dim_product_attributes 两张表基于product_id关联，并且是一对多的关系。



## 计算指标说明

- 销售额 amount
- 销量 quantity
- 在售门店数 branch_count
- 在售门店的类目销售额 category_branch_amount

   注意：
   - amount, quantity, branch_count, category_branch_amount 这四个指标都支持“同比”和“环比”计算。
   - “同比”指标计算时，选择对应的增加了"last_year" 后缀字段进行计算。例如：销售额同比 = (amount - amount_last_year) / amount_last_year
   - “环比”指标计算时，选择对应的增加了"last_month" 后缀字段进行计算。例如：销量环比 = (quantity - quantity_last_month) / quantity_last_month



- 销售额市占率 = (集团销售额 / 集团所属类目销售额) \* 100%
   注意：
   - 销售额市占率，只支持集团粒度的查询。
   - 集团所属类目销售额，是由 group_sales_monthly 表中符合条件的集团记录的 group_sales_key 关联到的 category_sales_key 去 category_sales_monthly 表中查询到的 amount 数值。

- 数值铺市率 = (在售门店数 / 所属类目在售门店数) \* 100%
   注意：
   - 数值铺市率，支持集团、品牌和商品粒度的查询。
   - 所属类目在售门店数，是由指定粒度(集团、品牌、商品)的monthly后缀数据表中符合条件的记录的sales_key(group_sales_key, brand_sales_key, product_sales_key)关联到的 category_sales_key 去 category_sales_monthly 表中查询到的 branch_count 数值。

- 加权铺市率 = (在售门店的类目销售额 / 所有门店中的类目总销售额) \* 100%
   注意：
   - 加权铺市率，支持集团、品牌和商品粒度的查询。
   - 在售门店的类目销售额，是 category_branch_amount 字段
   - 所有门店中的类目总销售额，是由指定粒度(集团、品牌、商品)的monthly后缀数据表中符合条件的记录的sales_key(group_sales_key, brand_sales_key, product_sales_key)关联到的 category_sales_key 去 category_sales_monthly 表中查询到的 amount 数值。

- 单点卖力 = 销售额 / 加权铺市率
   注意：
   - 单点卖力，支持集团、品牌和商品粒度的查询。

- 店均卖力(销量) = amount / branch_count
- 店均卖力(销售额) = quantity / branch_count
- 商品平均价格 = amount / quantity


- 商品售价中位数：商品所有售价的中位数？
