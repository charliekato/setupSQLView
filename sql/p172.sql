/* original sql */
use bank;


select /*distinct*/ d.dept_id, d.name, e_cnt.how_many num_employees
from department d inner join
( select dept_id, count(*) how_many
    from employee
    group by dept_id) e_cnt
using (dept_id);
/* this(above) works find... without using distinct */
/* but below does not work unless using distinct */

use swim0087;
/* I don't know why but the keyword 'distict' needed....*/

select distinct  選手マスター.所属名称１ チーム名, e_cnt.how_many 登録選手数
from 選手マスター inner join ( select 所属名称１, count(*) how_many 
    from 選手マスター group by 所属名称１) e_cnt using (所属名称１);


