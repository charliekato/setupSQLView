/*--
  inclusive 大会の競技別結果作成用 sql ポイントで順位を決める
  
    前提; 
       次のテーブルを事前に作っておく。
       　　ポイントB  -- 係数B のテーブル  insertPointB.sql を流して作った。
           ポイントC  -- 係数Cのテーブル   insertPointC.sql を流して作った。
       ポイント
       次のviewを使う。
           v記録個人paraポイント -- v記録paraポイント.sql で作った。　(view記録ポイントとは 既存の記録tableと作成したポイントtableをjoinしたもの)
           view記録個人クラスあり秒  (上記 v記録個人paraポイント で必要)     -- view記録秒.sql で作った。        


  使い方
  　exec getRanking4Inclusive @eventNo=56, @prgNo=3
--*/
IF OBJECT_ID('[dbo].getResult4Inclusive','P') IS NOT NULL
    DROP PROCEDURE [dbo].getResult4Inclusive
GO
CREATE PROCEDURE getResult4Inclusive
@eventNo int,
@prgNo int
AS
BEGIN
select 
rank() over ( order by pt.オープン, pt.事由表示 asc, pt.ポイント desc ) as 順位,
*

from v記録個人ポイント pt　


where pt.大会番号=@eventNo and pt.PRGNO=@prgNo
order by 組, 水路

end
