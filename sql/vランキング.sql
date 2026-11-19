  /*
     大会別、競技番号別、クラス別, ランキングlist
  */
IF OBJECT_ID('[dbo].vランキング','V') IS NOT NULL
    DROP VIEW [dbo].vランキング
GO
CREATE VIEW vランキング
AS
   with ranking as (
    SELECT
	記録.大会番号,
	プログラム.競技番号,
	rank() over (partition by 記録.大会番号 , 記録.競技番号, 
	      記録.新記録判定クラス 
	      ORDER BY 記録.ゴール ASC) AS 順位,
	プログラム.性別コード as 性別コード, 
	記録.新記録判定クラス,
	プログラム.距離コード,
	プログラム.種目コード,
	記録.ゴール,
	選手.氏名 as 第1泳者,
	'' as 第2泳者,
	'' as 第3泳者,
	'' as 第4泳者,
	新記録印刷マーク,
	中間新記録マーク,
	選手.所属名称1 as 所属,
	プログラム.予決コード,
	プログラム.日付,
	大会設定.大会名１ as 競技会名,
	大会設定.開催地
    from 記録
	inner join 選手 on 選手.選手番号 = 記録.選手番号
	    and 選手.大会番号 = 記録.大会番号
	inner join プログラム on プログラム.競技番号 = 記録.競技番号
	    and プログラム.大会番号 = 記録.大会番号
	inner join 大会設定 on 大会設定.大会番号 = 記録.大会番号
	
    where 記録.事由表示 = 0 
      and プログラム.種目コード < 6
      and 記録.オープン=0
      and 記録.ゴール <> ''

UNION ALL

    SELECT
	記録.大会番号,
	プログラム.競技番号,
	rank() over (partition by 記録.大会番号, 記録.競技番号, 
	   記録.新記録判定クラス ORDER BY 記録.ゴール ASC) AS 順位,
	プログラム.性別コード as 性別コード,
		記録.新記録判定クラス,
	プログラム.距離コード,
	プログラム.種目コード,
	記録.ゴール,
	選手1.氏名 as 第1泳者, 
	選手2.氏名 as 第2泳者, 
	選手3.氏名 as 第3泳者, 
	選手4.氏名 as 第4泳者,
	新記録印刷マーク,
	中間新記録マーク,
	リレーチーム.チーム名 as 所属,
	プログラム.予決コード,
	プログラム.日付,
	大会設定.大会名１ as 競技会名,
	大会設定.開催地
    from 記録
	left join クラス on クラス.クラス番号=記録.新記録判定クラス
	    and クラス.大会番号=記録.大会番号
	inner join リレーチーム on リレーチーム.チーム番号 = 記録.選手番号
	    and リレーチーム.大会番号 = 記録.大会番号
	inner join 選手 as 選手1 on 選手1.選手番号 = 記録.第１泳者
	    and 選手1.大会番号 = 記録.大会番号
	inner join 選手 as 選手2 on 選手2.選手番号 = 記録.第２泳者
	    and 選手2.大会番号 = 記録.大会番号
	inner join 選手 as 選手3 on 選手3.選手番号 = 記録.第３泳者
	    and 選手3.大会番号 = 記録.大会番号
	inner join 選手 as 選手4 on 選手4.選手番号 = 記録.第４泳者
	    and 選手4.大会番号 = 記録.大会番号
	inner join プログラム on プログラム.競技番号 = 記録.競技番号
	    and プログラム.大会番号 = 記録.大会番号
	inner join 大会設定 on 大会設定.大会番号 = 記録.大会番号
	inner join 予決 on 予決.予決コード=プログラム.予決コード
    where 記録.事由表示 = 0
      and プログラム.種目コード > 5
      and 記録.オープン=0
      and 記録.ゴール <> ''
)
select ranking.* ,
        case 
              when ranking.性別コード=1 then '男子'
              when ranking.性別コード=2 then '女子'
              when ranking.性別コード=3 then '混成'
              when ranking.性別コード=4 then '混合'
              else ''
        end as 性別,
        case  
              when ranking.新記録判定クラス=0 then ''
              else クラス.クラス名称
        end as クラス名称,
        距離.距離,
        種目.種目
    from ranking
    inner join 距離 on 距離.距離コード=ranking.距離コード
    inner join 種目 on 種目.種目コード=ranking.種目コード
    inner join プログラム on プログラム.大会番号=ranking.大会番号
                      and プログラム.競技番号=ranking.競技番号
    left join クラス on クラス.クラス番号=ranking.新記録判定クラス
           and クラス.大会番号=ranking.大会番号
    inner join 予決 on 予決.予決コード=プログラム.予決コード

