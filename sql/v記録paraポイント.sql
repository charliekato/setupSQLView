IF OBJECT_ID('[dbo].v記録paraポイント', 'V') IS NOT NULL
	DROP VIEW v記録paraポイント
GO

CREATE  VIEW v記録paraポイント AS
SELECT
    r.*,
    
    b.B as B,
    c.C as C,

    FLOOR(   1200 * EXP(　-EXP(  b.B - (c.C / r.タイム秒) ) ) ) AS paraポイント

FROM v記録 r
inner join プログラム p on r.大会番号= p.大会番号
　　　　　　　　　　　and r.競技番号= p.競技番号
left JOIN ポイントB b
    ON p.距離コード = b.距離コード
   AND p.種目コード = b.種目コード
   AND p.性別コード = b.性別コード
  AND r.大会番号 = b.大会番号
left JOIN ポイントC c
    ON p.距離コード = c.距離コード
   AND p.種目コード = c.種目コード
   AND r.クラス名称 = c.クラス名称
   AND p.性別コード = c.性別コード
   and r.大会番号 = c.大会番号
