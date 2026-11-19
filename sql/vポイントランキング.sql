  /*
     大会別、競技番号別 ランキングlist
  */
IF OBJECT_ID('[dbo].vポイントランキング','V') IS NOT NULL
    DROP VIEW [dbo].vポイントランキング
GO
CREATE VIEW vポイントランキング
AS
   with ranking as (
    SELECT
	r.*,
	rank() over (partition by r.大会番号 , r.表示用競技番号 
	      ORDER BY r.ポイント DESC) AS 順位
    from v記録ポイント r

)
select * 
    from ranking

