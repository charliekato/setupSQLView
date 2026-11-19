/*  発生大会記録 */
IF OBJECT_ID('[dbo].p発生大会記録','P') IS NOT NULL
    DROP PROCEDURE [dbo].p発生大会記録
GO


Create procedure p発生大会記録
 @eventNo INT 
 AS
 begin
if Exists (select 1 from クラス where 大会番号=@eventNo and クラス番号<100)
BEGIN
 SELECT * from v発生大会記録個人クラスあり 
        WHERE 大会番号 = @eventNo
UNION all
 SELECT * from v発生大会記録リレークラスあり 
        WHERE 大会番号 = @eventNo
      	  ORDER BY No
END
ELSE BEGIN
    -- class does not exist
 SELECT * from v発生大会記録個人クラスなし 
        WHERE 大会番号 = @eventNo
	  UNION all
  SELECT * from v発生大会記録リレークラスなし
        WHERE 大会番号 = @eventNo
       	  ORDER by No
END
end

/* how to run */
-- exec 発生大会記録 @eventNo=49
