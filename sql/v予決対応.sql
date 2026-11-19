IF OBJECT_ID('[dbo].v予決対応', 'V') IS NOT NULL
	DROP VIEW v予決対応
go

CREATE VIEW v予決対応 AS
SELECT
    F.大会番号,
    Y.表示用競技番号 AS 予選表示用競技番号,
    F.表示用競技番号 AS 決勝表示用競技番号,
    F.競技番号 AS 決勝競技番号,
    Y.競技番号 AS 予選競技番号,
    F.種目コード,
    F.クラス番号,
    F.距離コード,
    F.性別コード
FROM プログラム F
LEFT JOIN プログラム Y
    ON  F.大会番号 = Y.大会番号
    AND F.種目コード = Y.種目コード
    AND F.クラス番号 = Y.クラス番号
    AND F.距離コード = Y.距離コード
    AND F.性別コード = Y.性別コード
    AND Y.予決コード = 1
WHERE
    F.予決コード = 6;
