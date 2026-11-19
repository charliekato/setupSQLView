IF OBJECT_ID('[dbo].vプログラム', 'V') IS NOT NULL
	DROP VIEW vプログラム
go

CREATE VIEW vプログラム AS
  select 
  p.*,
	case p.性別コード
	    when 1 then '男子'
	    when 2 then '女子'
	    when 3 then '混成'
	    when 4 then '混合'
	end as 性別,
    距離.距離 ,
    種目.種目,
    種目.リレーフラグ as リレーフラグ,
	予決.予決,
	case 予決.予決
	　when '予選' then e.使用水路予選
	  when 'タイム決勝' then e.使用水路タイム決勝
	  when '準決勝' then e.使用水路準決勝
	  else e.使用水路タイム決勝
	end as MAXLANE,
	ゼロコース使用,
		case タッチ板
	  when 2 then 100
	  when 3 then 25
	  else 50
	end as LAPUNIT
  from プログラム p
    inner join 大会設定 e on e.大会番号=p.大会番号
    inner join 距離 on 距離.距離コード=p.距離コード
    inner join 種目 on 種目.種目コード=p.種目コード
    inner join 予決 on 予決.予決コード = p.予決コード
