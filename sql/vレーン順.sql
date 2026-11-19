IF OBJECT_ID('[dbo].vレーン順', 'V') IS NOT NULL
	DROP VIEW vレーン順
go

CREATE VIEW vレーン順 as
    SELECT 
	r.大会番号,
	p.表示用競技番号 as 表示用競技番号,
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
  p.時間,
	case 予決.予決
	　when '予選' then e.使用水路予選
	  when 'タイム決勝' then e.使用水路タイム決勝
	  when '準決勝' then e.使用水路準決勝
	  else e.使用水路タイム決勝
	end as MAXLANE,
	case e.ゼロコース使用
    when 0 then r.水路
    else r.水路-1
  end as レーン,
	r.組,
	r.水路,
	case r.新記録判定クラス
	    when 0 then ''
		else 	クラス.クラス名称
	end as クラス名称,
	リレーチーム.チーム名 as 氏名,

	選手1.氏名 as 第1泳者, 
	選手2.氏名 as 第2泳者,
	選手3.氏名 as 第3泳者,
	選手4.氏名 as 第4泳者, 
	所属.所属名 as 所属名,
  '' as St,
  '' as CoE,
  学種.学種
   from 記録 r 
    inner join 大会設定 e on  e.大会番号=r.大会番号
    inner join プログラム p on p.競技番号=r.競技番号
                          and p.大会番号=r.大会番号
    inner join リレーチーム on リレーチーム.チーム番号 = r.選手番号 and リレーチーム.大会番号 =r.大会番号
    LEFT JOIN 選手 as 選手1 ON 選手1.選手番号 = r.第１泳者 and 選手1.大会番号=r.大会番号
    LEFT join 選手 as 選手2 on 選手2.選手番号 = r.第２泳者 and 選手2.大会番号=r.大会番号
    LEFT join 選手 as 選手3 on 選手3.選手番号 = r.第３泳者 and 選手3.大会番号=r.大会番号
    LEFT join 選手 as 選手4 on 選手4.選手番号 = r.第４泳者 and 選手4.大会番号=r.大会番号
    inner join ラップ l on l.大会番号=r.大会番号　
	     and l.競技番号=r.競技番号
	     and l.組=r.組
	     and l.水路=r.水路
    LEFT join クラス on クラス.大会番号=r.大会番号
	     and クラス.クラス番号=r.新記録判定クラス
    inner join 所属 on 所属.所属番号= リレーチーム.所属番号
       and 所属.大会番号=r.大会番号
    inner join 学種 on 学種.学種コード=リレーチーム.学校コード
    inner join 距離 on 距離.距離コード = p.距離コード
    inner join 種目 on 種目.種目コード = p.種目コード
    inner join 予決 on 予決.予決コード = p.予決コード    
    WHERE 
    　　p.種目コード>5 
	 and l.ラップ区分=0
union all
SELECT 
	r.大会番号,
	p.表示用競技番号 as 表示用競技番号, 
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
  p.時間,
	case 予決.予決
	　when '予選' then e.使用水路予選
	  when 'タイム決勝' then e.使用水路タイム決勝
	  when '準決勝' then e.使用水路準決勝
	  else e.使用水路タイム決勝
	end as MAXLANE,
	case ゼロコース使用
	  when 0 then r.水路
	  else r.水路 - 1
	end as レーン,
	r.組,
	r.水路,
  case r.新記録判定クラス
	    when 0 then ''
		else 	クラス.クラス名称
	end as クラス名称,
	選手.氏名  as 氏名,
	'' as 第1泳者,
	'' as 第2泳者,
	'' as 第3泳者,
	'' as 第4泳者,
	case 選手.主所属
	    when 2 then 選手.所属名称2
	    when 3 then 選手.所属名称3
	    else 選手.所属名称1
	end as 所属 ,
  選手.所属名称3 as St,
  選手.所属名称3カナ as CoE,
  学種.学種
       from 記録 r
        inner join 大会設定 e on e.大会番号=r.大会番号
        INNER JOIN 選手 ON 選手.選手番号 = r.選手番号 
             and 選手.大会番号=r.大会番号
        inner join プログラム p on p.競技番号=r.競技番号 
             and p.大会番号=r.大会番号
        inner join ラップ l on l.大会番号=r.大会番号　
           and l.競技番号=r.競技番号
           and l.組=r.組
           and l.水路=r.水路
        inner join 学種 on 学種.学種コード = 選手.学校コード

        LEFT join クラス on クラス.大会番号=r.大会番号       
	     and クラス.クラス番号=r.新記録判定クラス  
		 inner join 距離 on 距離.距離コード=p.距離コード
    inner join 種目 on 種目.種目コード=p.種目コード
    inner join 予決 on 予決.予決コード = p.予決コード    
     WHERE   
        l.ラップ区分=0
	 and p.種目コード<6 
            


