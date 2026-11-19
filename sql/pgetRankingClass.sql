USE [sw]
GO
/****** Object:  StoredProcedure [dbo].[getRankingClass]    Script Date: 2026/11/15 20:33:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID('[dbo].getRankingClass', 'P') IS NOT NULL
	DROP PROCEDURE [dbo].getRankingClass
go


CREATE PROCEDURE [dbo].[getRankingClass]
@eventNo int,
@prgNo int = NULL
AS
Begin


 select 
   rank() over (partition by 表示用競技番号, クラス番号
		      ORDER BY オープン, 事由表示 , ゴール ASC ) as 順位, 
　 大会番号, 表示用競技番号, 組, 水路, クラス番号, クラス名称, FINAポイント, 資格級,性別,性別コード,距離,距離コード,種目, 種目コード, 予決, 事由表示,
   オープン, 棄権印刷マーク,氏名, 第1泳者,第2泳者,第3泳者,第4泳者, 所属名, ゴール, 新記録印刷マーク, 
   [25m], [50m], [75m], [100m], [125m], [150m],[175m], [200m],
   [225m],[250m],[275m],[300m], [325m], [350m],[375m], [400m],
   [425m],[450m],[475m],[500m], [525m], [550m],[575m], [600m],
   [625m],[650m],[675m],[700m], [725m], [750m],[775m], [800m],
   [825m],[850m],[875m],[900m], [925m], [950m],[975m], [1000m],
   [1025m],[1050m],[1075m],[1100m], [1125m], [1150m],[1175m], [1200m],
   [1125m],[1150m],[1175m],[1200m], [1225m], [1250m],[1275m], [1300m],
   [1325m],[1350m],[1375m],[1400m], [1425m], [1450m],[1475m], [1500m]
 from v記録with競技情報
 where 大会番号=@eventNo and (@prgNo IS NULL OR 表示用競技番号=@prgNo)
 order by 表示用競技番号, クラス番号, 順位
end
