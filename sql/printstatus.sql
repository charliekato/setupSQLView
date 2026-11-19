update プログラム set 進行フラグ=1 where 大会番号=2

/*
update 印刷状況 set 印刷状況=0 

select 印刷状況, 競技番号 from 印刷状況 where 大会番号=2

select 表示用競技番号, 進行フラグ from プログラム where 大会番号=2 order by 表示用競技番号
*/
SELECT 印刷状況, 印刷状況.競技番号, プログラム.表示用競技番号 
             FROM 印刷状況 
             INNER JOIN プログラム ON プログラム.競技番号 = 印刷状況.競技番号 
             WHERE  プログラム.大会番号 = 2
              and 印刷状況.大会番号 = 2
			  order by プログラム.表示用競技番号
