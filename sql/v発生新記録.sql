IF OBJECT_ID('[dbo].v発生新記録','V') IS NOT NULL
    DROP VIEW [dbo].v発生新記録
GO
CREATE VIEW v発生新記録
AS
SELECT 
    記録.大会番号 as 大会番号,
    表示用競技番号 as No,
    記録.新記録判定クラス,
    記録.第一泳者新記録判定クラス,
    case 記録.新記録判定クラス
      when 0 then ''
      else   クラス.クラス名称   
    end as クラス名称,
    プログラム.性別コード,
    CASE プログラム.性別コード
	  WHEN 1 THEN '男子'
	  WHEN 2 THEN '女子'
	  WHEN 3 THEN '混成'
	  ELSE '混合'
    END AS 性別,
    プログラム.距離コード,
    距離, 
    プログラム.種目コード,
    種目, 
    ゴール, 
    新記録印刷マーク,
    case 
      when プログラム.種目コード<6 then 選手.氏名
      else 選手1.氏名
    end as 第1泳者,
    case
      when プログラム.種目コード<6 then ''
      else 選手2.氏名
    end as 第2泳者,
    case
      when プログラム.種目コード<6 then ''
      else 選手3.氏名
    end as 第3泳者,
    case
      when プログラム.種目コード<6 then ''
      else 選手4.氏名
    end as 第4泳者,
    case 
      when プログラム.種目コード<6 then 
          case 選手.主所属 
            when 2 then 選手.所属名称２
            when 3 then 選手.所属名称３
            else 選手.所属名称１
          end 
      else
         リレーチーム.チーム名 
    end AS 所属・チーム名, 
    case 中間新記録マーク　
        　when '' then        ''
    else 中間記録 end as 中間記録,
	中間新記録マーク,
    プログラム.日付
    FROM 記録
    INNER JOIN プログラム ON プログラム.競技番号 = 記録.競技番号
         and プログラム.大会番号=記録.大会番号
    left JOIN クラス on クラス.クラス番号 = 記録.新記録判定クラス
        and クラス.大会番号=記録.大会番号
    left JOIN リレーチーム ON リレーチーム.チーム番号 = 記録.選手番号
        and リレーチーム.大会番号=記録.大会番号
    left join 選手 on 選手.選手番号=記録.選手番号
        and 選手.大会番号=記録.大会番号
    left JOIN 選手 as 選手1 ON 選手1.選手番号 = 記録.第１泳者
        and 選手1.大会番号=記録.大会番号
    left JOIN 選手 as 選手2 ON 選手2.選手番号 = 記録.第２泳者
        and 選手2.大会番号=記録.大会番号
    left JOIN 選手 as 選手3 ON 選手3.選手番号 = 記録.第３泳者
        and 選手3.大会番号=記録.大会番号
    left JOIN 選手 as 選手4 ON 選手4.選手番号 = 記録.第４泳者
        and 選手4.大会番号=記録.大会番号
    INNER JOIN 距離 ON 距離.距離コード = プログラム.距離コード
    INNER JOIN 種目 ON 種目.種目コード = プログラム.種目コード
    WHERE 
      (新記録印刷マーク <> '' OR 中間新記録マーク <> '' )
      AND プログラム.競技番号 = 記録.競技番号
      
