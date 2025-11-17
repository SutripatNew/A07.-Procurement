USE [TNTL_PUR]
GO

/****** Object:  View [dbo].[VW_FORM_05_CALCULATE_WEIGHT]    Script Date: 18/2/2568 9:06:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[VW_FORM_05_CALCULATE_WEIGHT] AS 

SELECT 
F.*,
Q.Max_Response_Value,
CAST(F.Response_Value / Q.Max_Response_Value AS DECIMAL(9,4)) AS Raw_Score,
Q.YEAR as Question_Year,
Q.Group_Question,
-- COUNT(F.Response_Value) OVER (PARTITION BY F.UniqueID, Group_Question) Total_Answer_In_Group,

Q.Weight_Source,
SUM(Q.Weight_Source) OVER (PARTITION BY F.UniqueID) 
AS WeightTotal_Source,

Q.Weight_100,
CAST(CASE 
WHEN F.Function_Name = 'RM&PKG' THEN 100
ELSE SUM(Q.Weight_100) OVER (PARTITION BY F.UniqueID) 
END AS DECIMAL(9,4))
AS WeightTotal_100,

CASE 
WHEN Response_Value IS NOT NULL
THEN Q.Weight_100 ELSE NULL END
AS Weight_100_NonNull,


CASE 
WHEN Response_Value IS NOT NULL
THEN 
	SUM(
	CASE 
	WHEN Response_Value IS NOT NULL
	THEN Q.Weight_100 ELSE NULL END 
	) OVER (PARTITION BY F.UniqueID)
ELSE NULL END
AS WeightTotal_100_NonNull

FROM ( 

SELECT * FROM VW_FORM_02_UNION_VALUE_MAP


) F
LEFT JOIN VW_FORM_04_WEIGHT Q
ON F.Function_Name = Q.Function_Name
AND F.Function_SubType = Q.Function_SubType
AND F.Question_Name = Q.Question_Name
AND F.FormYear = Q.[YEAR]
GO


