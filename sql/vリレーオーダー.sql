IF OBJECT_ID('[dbo].vリレーオーダー', 'V') IS NOT NULL
	DROP VIEW vリレーオーダー
go

CREATE VIEW vリレーオーダー AS

    SELECT 
	r.大会番号,
	プログラム.表示用競技番号 as PRGNO,
	プログラム.競技番号 as UID,
	r.組,
	case ゼロコース使用　
	    when 1 then r.水路-1
		else r.水路
	end as LaneNo,
	r.水路,
	r.新記録判定クラス as クラス番号,
	case r.新記録判定クラス
	    when 0 then ''
		else 	クラス.クラス名称
	end as クラス名称,
	
	case プログラム.性別コード
	    when 1 then '男子'
	    when 2 then '女子'
	    when 3 then '混成'
	    when 4 then '混合'
	end as 性別,
    距離.距離 ,
    種目.種目,
	予決.予決,
	ゼロコース使用,

	事由表示,
	r.オープン,
	棄権印刷マーク,
	選手1.氏名 as 第1泳者, 
	選手1.氏名カナ as 第1泳者カナ, 
	選手1.選手番号 as 第1泳者番号, 
	選手2.氏名 as 第2泳者,
	選手2.氏名カナ as 第2泳者カナ,
	選手2.選手番号 as 第2泳者番号,
	選手3.氏名 as 第3泳者,
	選手3.氏名カナ as 第3泳者カナ,
	選手3.選手番号  as 第3泳者番号,
	選手4.氏名 as 第4泳者, 
	選手4.氏名カナ as 第4泳者カナ, 
	選手4.選手番号 as 第4泳者番号 ,
	リレーチーム.チーム名 as 所属


   from 記録 r 
    inner join 大会設定 on 大会設定.大会番号=r.大会番号
    inner join リレーチーム on リレーチーム.チーム番号 = r.選手番号 and リレーチーム.大会番号 =r.大会番号
    LEFT JOIN 選手 as 選手1 ON 選手1.選手番号 = r.第１泳者 and 選手1.大会番号=r.大会番号
    LEFT join 選手 as 選手2 on 選手2.選手番号 = r.第２泳者 and 選手2.大会番号=r.大会番号
    LEFT join 選手 as 選手3 on 選手3.選手番号 = r.第３泳者 and 選手3.大会番号=r.大会番号
    LEFT join 選手 as 選手4 on 選手4.選手番号 = r.第４泳者 and 選手4.大会番号=r.大会番号
    inner join プログラム on プログラム.競技番号=r.競技番号 and プログラム.大会番号=  r.大会番号
    inner join 距離 on 距離.距離コード=プログラム.距離コード
    inner join 種目 on 種目.種目コード=プログラム.種目コード
    LEFT join クラス on クラス.大会番号=r.大会番号
	     and クラス.クラス番号=r.新記録判定クラス
    inner join 予決 on 予決.予決コード = プログラム.予決コード
    WHERE /*記録.事由表示 = 0 and*/ 

    　　プログラム.種目コード>5 
            


