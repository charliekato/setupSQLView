select a.cust_id from account a inner join branch b
on a.open_branch_id = b.branch_id
where b.name = 'Woburn Branch'

union all


select cust_id from account a
where avail_balance between 500 and 2500


;
