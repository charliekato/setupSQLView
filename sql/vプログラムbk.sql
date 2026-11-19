IF OBJECT_ID('[dbo].vプログラム', 'V') IS NOT NULL
    DROP VIEW vプログラム
go
create view vプログラム as

select 
    プログラム.大会番号,
    競技番号 as UID,
    表示用競技番号 as 競技番号,
    組数,
    時間,
   case 性別コード
    when 1 then '男子'
    when 2 then '女子'
    when 3 then '混成'
    else '混合'
   end as 性別,
   クラス名称,
   距離,
   種目,
   種目.リレーフラグ as リレーフラグ,
   予決

   from プログラム
   left join クラス on クラス.クラス番号=プログラム.クラス番号
              and クラス.大会番号=プログラム.大会番号
   inner join 距離 on 距離.距離コード = プログラム.距離コード
   inner join 種目 on 種目.種目コード = プログラム.種目コード
   inner join 予決 on 予決.予決コード = プログラム.予決コード

