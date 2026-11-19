IF OBJECT_ID('[dbo].v記録ポイント', 'V') IS NOT NULL
	DROP VIEW v記録ポイント
GO
CREATE view v記録ポイント as

select 
  *,
  case 
	  WHEN 事由表示 <> 0 OR オープン <> 0 THEN 0
  　　when paraポイント is NULL then FINAポイント
  　　else paraポイント
  end as ポイント


from v記録paraポイント

