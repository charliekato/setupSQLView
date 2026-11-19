If Object_ID('[dbo].genRelayEntryList','P') is not NULL
    Drop procedure [dbo].genRelayEntryList
Go
Create Procedure genRelayEntryList
@eventNo int

As Begin
select チーム名, 
   case プログラム.性別コード
        WHEN 1 THEN '男子'
        WHEN 2 THEN '女子'
        WHEN 3 THEN '混成'
        WHEN 4 THEN '混合'
    END AS 性別,
   CONCAT( case プログラム.距離コード when 3 then '4x25m ' 
                          when 4 then '4x50m '
                          when 5 then '4x100m '
                          when 6 then '4x200m ' end , 種目.種目) as 種目, 
    クラス名称 as クラス, 
　　CONCAT(プログラム.表示用競技番号, '-',記録.組, '-',記録.水路) as  [No-組-レーン] 
from リレーチーム 
inner join プログラム on プログラム.種目コード = リレーチーム.種目コード 
  and プログラム.距離コード = リレーチーム.距離コード
   --and プログラム.クラス番号=リレーチーム.新記録判定クラス
inner join 種目 on 種目.種目コード = プログラム.種目コード
inner join 記録 on 記録.競技番号 = プログラム.競技番号 and 記録.選手番号 = リレーチーム.チーム番号
inner join クラス on クラス.クラス番号 = リレーチーム.新記録判定クラス
where リレーチーム.大会番号 = @eventNo 
    and クラス.大会番号 = @eventNo
  and プログラム.大会番号 = @eventNo 
  and 記録.大会番号 = @eventNo 

end