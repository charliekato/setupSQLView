  /* 
  v発生新記録個人クラスあり
  */
  IF OBJECT_ID('[dbo].v発生新記録個人クラスあり', 'V') IS NOT NULL
    DROP VIEW v発生新記録個人クラスあり
  GO
  CREATE VIEW v発生新記録個人クラスあり as 
  --declare @eventNo int=10
  SELECT  
        記録.大会番号 as 大会番号,
		表示用競技番号 as No,
		クラス.クラス名称, 
        CASE プログラム.性別コード
            WHEN 1 THEN '男子'
            WHEN 2 THEN '女子'
            WHEN 3 THEN '混成'
            ELSE '混合'
        END AS 性別,
        CONCAT(距離.距離, ' ', 種目.種目) AS 種目, 
        記録.ゴール AS タイム, 
        記録.新記録印刷マーク as マーク,
        選手.氏名 AS 泳者, 
        選手.所属名称1 AS 所属・チーム名, 
         case 中間新記録マーク　
        　when '' then        ''
          else 中間記録 end as 中間記録,
		記録.中間新記録マーク as 中間マーク

    FROM 記録
    INNER JOIN プログラム ON プログラム.競技番号 = 記録.競技番号
    　　　and プログラム.大会番号=記録.大会番号
	INNER JOIN クラス on クラス.クラス番号 = 記録.新記録判定クラス
    　　　and クラス.大会番号=記録.大会番号
    INNER JOIN 選手 ON 選手.選手番号 = 記録.選手番号
          and 選手.大会番号=記録.大会番号
    INNER JOIN 距離 ON 距離.距離コード = プログラム.距離コード
    INNER JOIN 種目 ON 種目.種目コード = プログラム.種目コード
    WHERE 
      プログラム.種目コード < 6
      AND ( 新記録印刷マーク <> '' OR 中間新記録マーク <> '' )
      AND プログラム.競技番号 = 記録.競技番号
