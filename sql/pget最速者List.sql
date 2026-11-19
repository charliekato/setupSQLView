  /*
     種目別、クラス別, 最速者list
     予選・決勝を通じての最速のタイム。
  */
IF OBJECT_ID('[dbo].get最速者リスト','P') IS NOT NULL
    DROP PROCEDURE [dbo].get最速者リスト
GO
CREATE PROCEDURE get最速者リスト
@eventNo int
AS
Begin
 
  with myresult as (
        SELECT 
            rank() over (partition by 種目コード , 距離コード,
                  記録.新記録判定クラス 
                  ORDER BY 記録.ゴール ASC) AS 順位,
            プログラム.性別コード as 性別コード, 
            記録.新記録判定クラス, 
            プログラム.距離コード,
            プログラム.種目コード,
            記録.ゴール,
            選手.氏名 as 氏名,
            選手.所属名称1 as 所属,
            プログラム.日付,
　　　　　　大会設定.大会名１ as 競技会名,
            大会設定.開催地
        from 記録
            inner join 選手 on 選手.選手番号 = 記録.選手番号
                and 選手.大会番号 = 記録.大会番号
            inner join プログラム on プログラム.競技番号 = 記録.競技番号
                and プログラム.大会番号 = 記録.大会番号
            inner join 大会設定 on 大会設定.大会番号 = 記録.大会番号
        where 記録.事由表示 = 0 
          and プログラム.種目コード < 6
          and 記録.オープン=0
          and 記録.ゴール <> ''
          and 記録.大会番号=@eventNo
        union all

        SELECT
            rank() over (partition by 記録.競技番号, 記録.新記録判定クラス ORDER BY 記録.ゴール ASC) AS 順位,
            プログラム.性別コード as 性別コード,
                    記録.新記録判定クラス,
            プログラム.距離コード,
            プログラム.種目コード,
            記録.ゴール,
            concat(
                選手1.氏名, ' ・ ',
                選手2.氏名, ' ・ ',
                選手3.氏名, ' ・ ',
                選手4.氏名
            ) as 氏名,
            リレーチーム.チーム名 as 所属,
            プログラム.日付,
            大会設定.大会名１ as 競技会名,
            大会設定.開催地
        from 記録
            inner join リレーチーム on リレーチーム.チーム番号 = 記録.選手番号
                and リレーチーム.大会番号 = 記録.大会番号
            inner join 選手 as 選手1 on 選手1.選手番号 = 記録.第１泳者
                and 選手1.大会番号 = 記録.大会番号
            inner join 選手 as 選手2 on 選手2.選手番号 = 記録.第２泳者
                and 選手2.大会番号 = 記録.大会番号
            inner join 選手 as 選手3 on 選手3.選手番号 = 記録.第３泳者
                and 選手3.大会番号 = 記録.大会番号
            inner join 選手 as 選手4 on 選手4.選手番号 = 記録.第４泳者
                and 選手4.大会番号 = 記録.大会番号
            inner join プログラム on プログラム.競技番号 = 記録.競技番号
                and プログラム.大会番号 = 記録.大会番号
            inner join 大会設定 on 大会設定.大会番号 = 記録.大会番号
        where 記録.事由表示 = 0
          and 記録.大会番号 = @eventNo
          and プログラム.種目コード > 5
          and 記録.オープン=0
          and 記録.ゴール <> ''
    )
    select 
        myresult.性別コード,
        myresult.距離コード,
        myresult.種目コード,
        myresult.ゴール as 記録,
　　　　myresult.新記録判定クラス,
        myresult.氏名,
        myresult.所属,
        myresult.競技会名,
        myresult.日付,
        myresult.開催地
    from myresult
    where myresult.順位 = 1   order by 
         --クラス.クラス番号, 
          性別コード, myresult.種目コード, myresult.距離コード; 
end