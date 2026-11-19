If OBJECT_ID('[dbo].resetHangumi','P') IS NOT NULL
	Drop Procedure [dbo].resetHangumi
GO

Create Procedure resetHangumi
 @eventNo int
AS
Begin

delete 記録 where 大会番号=@eventNo;
delete ラップ where 大会番号=@eventNo;
end