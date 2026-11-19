IF OBJECT_ID('[dbo].getRanking','P') IS NOT NULL
    DROP PROCEDURE [dbo].getRanking
GO
CREATE PROCEDURE getRanking
@eventNo int,
@prgNo int = NULL
AS
Begin


if exists (select 1 from クラス where 大会番号 = @eventNo and クラス番号<100)
begin
 select * from (
 select 
   rank() over (partition by PRGNO, クラス番号
		      ORDER BY オープン, 事由表示 , ゴール ASC ) as 順位, 
　 * 
 from v記録リレークラスあり )
 where 順位=1 and 大会番号=@eventNo and (@prgNo IS NULL OR PRGNO=@prgNo)
union all
 select * from (
 select 
   rank() over (partition by PRGNO, クラス番号
		      ORDER BY オープン, 事由表示 ASC, ゴール ASC ) as 順位, 
 　* 
 from v記録個人クラスあり)
 where 順位=1 and 大会番号=@eventNo and (@prgNo IS NULL OR PRGNO=@prgNo)
 order by PRGNO, クラス番号, 順位
end
else begin

 select * from (
 select 
   rank() over (partition by PRGNO ORDER By オープン, 事由表示, ゴール ASC ) as 順位 ,
   * 
   from v記録リレークラスなし)
  where 順位=1 and 大会番号=@eventNo and (@prgNo IS NULL OR PRGNO=@prgNo)
union all
 select * from (
 select 
   rank() over (partition by PRGNO ORDER By オープン, 事由表示, ゴール ASC ) as 順位,
   * 
 from v記録個人クラスなし)
 where 順位=1 and 大会番号=@eventNo and (@prgNo IS NULL OR PRGNO=@prgNo)
 order by PRGNO, 順位
end
end
