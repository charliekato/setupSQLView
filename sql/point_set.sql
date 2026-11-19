/*
大会番号を正しく入れる事
*/
UPDATE プログラム
SET ポイント設定番号 = CASE
    WHEN 種目コード >= 6 THEN 2
    ELSE 1
END 
WHERE 大会番号 = 11;
