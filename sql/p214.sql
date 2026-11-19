/* */

select c.cust_id, c.fed_id, c.cust_type_cd,
(select count(*) from account a
    where a.cust_id = c.cust_id) as num_accounts
from customer c;
