/*
 vWinnerList (class あり優勝者リスト)

*/
-- クラスが存在する場合
IF OBJECT_ID('[dbo].v優勝者リストクラスあり', 'V') IS NOT NULL
	DROP VIEW v優勝者リストクラスあり
GO
CREATE VIEW v優勝者リストクラスあり AS

with myresult as (
     SELECT 
    	記録.大会番号,
        記録.競技番号,
	rank() over (partition by 記録.大会番号, 記録.競技番号, 記録.新記録判定クラス ORDER BY 記録.ゴール ASC) AS 順位 ,
        プログラム.性別コード as 性別コード ,
        記録.新記録判定クラス , 
        プログラム.距離コード, 
        プログラム.種目コード, 
        記録.ゴール, 
        記録.新記録印刷マーク, 
        中間新記録マーク,
        選手.氏名 as 氏名, 
        選手.所属名称1 as 所属 

   from 記録 
    left JOIN 選手 ON 選手.選手番号 = 記録.選手番号 
	     and 選手.大会番号=記録.大会番号
    LEFT join プログラム on プログラム.競技番号=記録.競技番号 
         and プログラム.大会番号=記録.大会番号
 WHERE 記録.事由表示 = 0 
    　　and プログラム.種目コード<6 
        and 記録.ゴール <> '' 
        and 記録.オープン=0
        and (プログラム.予決コード=6 or プログラム.予決コード=3) 
       Union ALL 
    SELECT 
    	記録.大会番号,
        記録.競技番号,
        rank() over (partition by 記録.大会番号, 記録.競技番号, 記録.新記録判定クラス
			 ORDER BY 記録.ゴール ASC) AS 順位 , 
	プログラム.性別コード as 性別コード,     
        記録.新記録判定クラス, 
        プログラム.距離コード, 
        プログラム.種目コード, 
        記録.ゴール, 
        記録.新記録印刷マーク,
        中間新記録マーク,
        concat (選手1.氏名, ' ・ ', 選手2.氏名,' ・ ',  選手3.氏名,' ・ ',  選手4.氏名 ) as 氏名,
   リレーチーム.チーム名 as 所属
   from 記録 
    left join リレーチーム on リレーチーム.チーム番号 = 記録.選手番号 and リレーチーム.大会番号 =記録.大会番号
    LEFT JOIN 選手 as 選手1 ON 選手1.選手番号 = 記録.第１泳者 and 選手1.大会番号=記録.大会番号
    LEFT join 選手 as 選手2 on 選手2.選手番号 = 記録.第２泳者 and 選手2.大会番号=記録.大会番号
    LEFT join 選手 as 選手3 on 選手3.選手番号 = 記録.第３泳者 and 選手3.大会番号=記録.大会番号
    LEFT join 選手 as 選手4 on 選手4.選手番号 = 記録.第４泳者 and 選手4.大会番号=記録.大会番号
    LEFT join プログラム on プログラム.競技番号=記録.競技番号 and プログラム.大会番号=  記録.大会番号
    WHERE 記録.事由表示 = 0 
    　　and プログラム.種目コード>5 
        and 記録.ゴール <> '' 
        and 記録.オープン=0
        and (プログラム.予決コード=6 or プログラム.予決コード=3) 
    ) 
    select 
    	myresult.大会番号,
        myresult.競技番号,
        myresult.順位,
	myresult.新記録判定クラス as クラス番号,
	case myresult.性別コード　
	  when 1 then '男子'
	  when 2 then '女子'
	  when 3 then '混成'
	  when 4 then '混合'
	  end as 性別,
	距離.距離, 
	種目.種目, 
	myresult.ゴール as 記録, 
	myresult.氏名, 
	myresult.所属, 
	myresult.新記録印刷マーク,
	myresult.中間新記録マーク
     from myresult 
	inner join クラス on クラス.クラス番号=myresult.新記録判定クラス 
        and クラス.大会番号=myresult.大会番号
	inner join 距離 on 距離.距離コード = myresult.距離コード
	inner join 種目 on 種目.種目コード = myresult.種目コード
	where myresult.順位=1 
--	order by クラス.クラス番号,性別, myresult.種目コード, myresult.距離コード
