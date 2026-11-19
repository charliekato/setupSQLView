select distinct open_emp_id emp_id
from account
where open_branch_id=2
intersect 
select emp_id
from employee
where assigned_branch_id=2
and (title='Teller' or title='Head Teller');

