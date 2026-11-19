  /*
     大会別、競技番号別、クラス別, ランキングlist
  */
IF OBJECT_ID('[dbo].vランキング2','V') IS NOT NULL
    DROP VIEW [dbo].vランキング2
GO
CREATE VIEW vランキング2
AS

    SELECT
	記録.大会番号,
	記録.競技番号,
	記録.組,
	rank() over (partition by 記録.大会番号 , 記録.競技番号, 
	      記録.組
	      ORDER BY 記録.ゴール ASC) AS 順位,
	記録.ゴール,
	選手.氏名 as 氏名,

	選手.所属名称1 as 所属
    from 記録
	inner join 選手 on 選手.選手番号 = 記録.選手番号
	    and 選手.大会番号 = 記録.大会番号
	inner join プログラム on プログラム.競技番号 = 記録.競技番号
	    and プログラム.大会番号 = 記録.大会番号
	
    where 記録.事由表示 = 0 
      and プログラム.種目コード < 6
--      and 記録.オープン=0
      and 記録.ゴール <> ''

UNION ALL

    SELECT
		記録.大会番号,
		記録.競技番号,
		記録.組,
	rank() over (partition by 記録.大会番号, 記録.競技番号, 
	   記録.新記録判定クラス ORDER BY 記録.ゴール ASC) AS 順位,
	記録.ゴール,

	リレーチーム.チーム名 as 氏名,
	'' as 所属

    from 記録

	inner join リレーチーム on リレーチーム.チーム番号 = 記録.選手番号
	    and リレーチーム.大会番号 = 記録.大会番号
	inner join プログラム on プログラム.競技番号 = 記録.競技番号
	    and プログラム.大会番号 = 記録.大会番号
	
    where 記録.事由表示 = 0
      and プログラム.種目コード > 5
      and 記録.オープン=0
      and 記録.ゴール <> ''

