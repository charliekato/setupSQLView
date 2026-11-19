select employee.fname First, employee.lname Last,  branch.name 支店名
  from employee, branch
  where employee.assigned_branch_id = branch.branch_id;
  /* 
    will tell you employee's name and assinged branch name
    like below..
+----------+-----------+---------------+
| First    | Last      | 支店名        |
+----------+-----------+---------------+
| Michael  | Smith     | Headquarters  |
| Susan    | Barker    | Headquarters  |
| Robert   | Tyler     | Headquarters  |
| Susan    | Hawthorne | Headquarters  |
| John     | Gooding   | Headquarters  |
| Helen    | Fleming   | Headquarters  |
| Chris    | Tucker    | Headquarters  |
| Sarah    | Parker    | Headquarters  |
| Jane     | Grossman  | Headquarters  |
| Paula    | Roberts   | Woburn Branch |
| Thomas   | Ziegler   | Woburn Branch |
| Samantha | Jameson   | Woburn Branch |
| John     | Blake     | Quincy Branch |
| Cindy    | Mason     | Quincy Branch |
| Frank    | Portman   | Quincy Branch |
| Theresa  | Markham   | So. NH Branch |
| Beth     | Fowler    | So. NH Branch |
| Rick     | Tulman    | So. NH Branch |
+----------+-----------+---------------+
    */
