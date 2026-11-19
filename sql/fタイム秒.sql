IF OBJECT_ID('[dbo].fn_タイム秒', 'FN') IS NOT NULL
  DROP FUNCTION dbo.fn_タイム秒
GO
CREATE FUNCTION dbo.fn_タイム秒 (@ゴール nvarchar(9))
RETURNS decimal(10,2)
AS
BEGIN
    RETURN
        CASE
            WHEN NULLIF(@ゴール,'') IS NULL THEN NULL
            WHEN CHARINDEX(':', @ゴール) > 0 THEN
                TRY_CAST(LEFT(@ゴール, CHARINDEX(':', @ゴール) - 1) AS decimal(10,2)) * 60
              + TRY_CAST(SUBSTRING(@ゴール, CHARINDEX(':', @ゴール) + 1, 10) AS decimal(10,2))
            ELSE
                TRY_CAST(@ゴール AS decimal(10,2))
        END;
END;

