IF OBJECT_ID('[dbo].getResult','P') IS NOT NULL
    DROP PROCEDURE [dbo].getResult
GO
CREATE procedure getResult 
  @eventNo int,
  @prgNo int = NULL,
  @kumi int = NULL
as
begin
if exists (select 1 from クラス where 大会番号 = @eventNo and クラス番号<100)
begin
 select * from v記録リレークラスあり
  where 大会番号=@eventNo and (@prgNo IS NULL OR PRGNO=@prgNo)
                         and (@kumi IS NULL OR 組=@kumi)
union all 
 select * from v記録個人クラスあり
  where 大会番号=@eventNo and (@prgNo IS NULL OR PRGNO=@prgNo)
                         and (@kumi IS NULL OR 組=@kumi)
 order by PRGNO, 組, 水路
end
else begin
 select * from v記録リレークラスなし
  where 大会番号=@eventNo and (@prgNo IS NULL OR PRGNO=@prgNo)
                         and (@kumi IS NULL OR 組=@kumi)
union all 
 select * from v記録個人クラスなし
  where 大会番号=@eventNo and (@prgNo IS NULL OR PRGNO=@prgNo)
                         and (@kumi IS NULL OR 組=@kumi)
 order by PRGNO, 組, 水路
end
end
