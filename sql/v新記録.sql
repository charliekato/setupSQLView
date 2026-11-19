IF OBJECT_ID('[dbo].v新記録', 'V') IS NOT NULL
    DROP VIEW [dbo].v新記録
GO
CREATE VIEW v新記録
AS
select 新記録.大会番号 ,
       新記録名称.記録名称番号,
       記録名称 ,
       新記録.記録区分番号 ,
       クラス名称,
       性別コード,
       case 性別コード
         when 1 then '男子'
         when 2 then '女子'
         when 3 then '混成'
         else '混合'
       end as 性別,
       距離.距離コード,
       距離,
       種目.種目コード, 
       種目, 
       記録,
       日付,
       記録保持者,
       所属,
       競技会名,
       会場
   from 新記録 
inner join 新記録名称 
  on 新記録名称.記録名称番号=新記録.記録名称番号
  and 新記録名称.記録区分番号=新記録.記録区分番号
  and 新記録名称.大会番号=新記録.大会番号
inner join 距離 
  on 距離.距離コード=新記録.距離コード
inner join 種目 
  on 種目.種目コード=新記録.種目コード
left join クラス 
  on クラス.クラス番号=新記録.記録区分番号
  and クラス.大会番号=新記録.大会番号
