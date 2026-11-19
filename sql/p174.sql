/* virtual table...*/



/* original query...

select sum(a.avail_balance) cust_balance
from account a inner join product p
on a.product_cd = p.product_cd
where p.product_type_cd = 'ACCOUNT'
group by a.cust_id;
*/

/* use 'using' keyword instead ... 

select sum(a.avail_balance) cust_balance
from account a inner join product p
using( product_cd )
where p.product_type_cd = 'ACCOUNT'
group by a.cust_id;

*/

/* add cust_id

select a.cust_id, sum(a.avail_balance) cust_balance
from account a inner join product p
using( product_cd )
where p.product_type_cd = 'ACCOUNT'
group by a.cust_id;

 */



select a.cust_id, sum(a.avail_balance) cust_balance
from account a inner join product p
using( product_cd )
where p.product_type_cd = 'ACCOUNT'
group by a.cust_id;


