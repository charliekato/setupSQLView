select account_id 口座id, product_cd 口座種類 , cust_id 顧客番号, avail_balance 残高 
from account 
where product_cd in (select product_cd from product
  where product_type_cd = 'ACCOUNT');

