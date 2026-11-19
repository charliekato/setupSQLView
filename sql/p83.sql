select a.account_id ACID, a.cust_id CID, e.emp_id EMPID, a.open_date, a.product_cd
  from account a, branch b, employee e
  where a.open_emp_id = e.emp_id
  and e.start_date <= '2003-01-01'
  and e.assigned_branch_id = b.branch_id
  and (e.title = 'Teller' or e.title = 'Head Teller')
  and b.name = 'Woburn Branch';
