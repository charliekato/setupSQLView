/*
 pgetOpen失格
 */
 if OBJECT_ID('[dbo].getOpen失格','P') is not null 
    drop procedure [dbo].getOpen失格
 Go
Create procedure getOpen失格
@eventNo int
as
begin

select プログラム.表示用競技番号,距離,種目, 組, 水路, 氏名,　
  棄権印刷マーク,オープン from 記録 
  inner join プログラム on プログラム.競技番号=記録.競技番号
                       and プログラム.大会番号=記録.大会番号
  inner join 選手 on 選手.選手番号=記録.選手番号
                  and 選手.大会番号=記録.大会番号
  inner join 距離 on 距離.距離コード=プログラム.距離コード
  inner join 種目 on 種目.種目コード=プログラム.種目コード
                 
  where 記録.大会番号=@eventNo and 棄権印刷マーク like '失格%' and オープン=1
    and プログラム.種目コード<6
union all
select プログラム.表示用競技番号,距離,種目, 組, 水路, チーム名,　棄権印刷マーク,記録.オープン 
　from 記録
  inner join プログラム on プログラム.競技番号=記録.競技番号
                      and プログラム.大会番号=記録.大会番号
  inner join リレーチーム on リレーチーム.チーム番号= 記録.選手番号
                      and リレーチーム.大会番号=記録.大会番号
    inner join 距離 on 距離.距離コード=プログラム.距離コード
  inner join 種目 on 種目.種目コード=プログラム.種目コード
  where 記録.大会番号=@eventNo and 棄権印刷マーク like '失格%'  and 記録.オープン=1
    and プログラム.種目コード>5
  order by 表示用競技番号
end