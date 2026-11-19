 WITH 種目一覧 AS ( 
    SELECT エントリー.選手番号, 
        プログラム.表示用競技番号 AS PrgNo, 
        クラス.クラス名称, 
        距離.距離 AS 距離文字列, 
        種目.種目, 
        記録.組, 
        記録.水路,
        ROW_NUMBER() OVER ( 
            PARTITION BY エントリー.選手番号 
            ORDER BY プログラム.表示用競技番号 
        ) AS 種目番号 
    FROM エントリー 
    INNER JOIN 種目 ON 種目.種目コード = エントリー.種目コード 
    INNER JOIN 距離 ON 距離.距離コード = エントリー.距離コード 
    INNER JOIN クラス ON クラス.クラス番号 = エントリー.新記録判定クラス 
    INNER JOIN プログラム ON プログラム.種目コード = エントリー.種目コード -- AND プログラム.クラス番号 = エントリー.新記録判定クラス 
        AND プログラム.距離コード = エントリー.距離コード 
    INNER JOIN 記録 ON 記録.競技番号 = プログラム.競技番号 
        AND 記録.選手番号 = エントリー.選手番号 
    WHERE エントリー.大会番号 = @eventNo 
        AND クラス.大会番号 = @eventNo 
        AND プログラム.大会番号 = @eventNo 
        AND 記録.大会番号 = @eventNo 
 ) 
 SELECT 選手.選手番号, 
     選手.氏名, 
     CASE 選手.性別コード 
         WHEN 1 THEN '男子' 
         WHEN 2 THEN '女子' 
         WHEN 3 THEN '混成' 
         WHEN 4 THEN '混合' 
     END AS 性別, 
    選手.所属名称1, 
     S1.クラス名称 + S1.距離文字列 + S1.種目 AS 種目1, 
    CONCAT(S1.PrgNo, '-', S1.組, '-', S1.水路) AS [競技番号-組-レーン1], 
    S2.クラス名称 + S2.距離文字列 + S2.種目 AS 種目2, 
    CONCAT(S2.PrgNo, '-', S2.組, '-', S2.水路) AS [競技番号-組-レーン2], 
    S3.クラス名称 + S3.距離文字列 + S3.種目 AS 種目3, 
    CONCAT(S3.PrgNo, '-', S3.組, '-', S3.水路) AS [競技番号-組-レーン3] 
    FROM 選手 
    LEFT JOIN (
        SELECT * FROM 種目一覧 WHERE 種目番号 = 1
        ) S1 ON 選手.選手番号 = S1.選手番号 
    LEFT JOIN (SELECT * FROM 種目一覧 
    WHERE 種目番号 = 2) S2 ON 選手.選手番号 = S2.選手番号 
    LEFT JOIN (
    SELECT * FROM 種目一覧 WHERE 種目番号 = 3
    ) S3 
    ON 選手.選手番号 = S3.選手番号 
    WHERE 選手.大会番号 = @eventNo 
    ORDER BY 選手.選手番号
