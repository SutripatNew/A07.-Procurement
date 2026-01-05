USE [TNTL_PUR]
GO

/****** Object:  View [dbo].[VW_FACT_MS_FORM]    Script Date: 18/2/2568 9:29:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








CREATE VIEW [dbo].[VW_FACT_MS_FORM] AS 

WITH W_FACT AS (

SELECT 
F.*,

CASE 
WHEN Function_Name IN ('RM&PKG')
THEN F.Weight_RM
WHEN Function_Name IN ('Procurement')
THEN F.Weight_PCM
ELSE F.Weight_Calc END 
AS Weight_Report,

CASE 
WHEN Function_Name IN ('RM&PKG')
THEN F.Score_RM
WHEN Function_Name IN ('Procurement')
THEN F.Score_PCM
ELSE F.Score_Calc END 
AS Score_Report

FROM VW_FORM_07_SCORE_FIX F

)


SELECT 
--TOP 1000000000000
CAST(F.UniqueID AS NVARCHAR(100)) AS UniqueID,
CAST(F.FormYear AS NVARCHAR(100)) AS FormYear,
CAST(F.RoundYear AS NVARCHAR(100)) AS RoundYear,
COALESCE(F.Function_Name,'') + '_' + COALESCE(F.Function_SubType,'') + '_' + CAST(F.Scoring_Group AS NVARCHAR(100)) +'_' + CAST(F.Vendor_Name AS NVARCHAR(100)) +'_' +CAST(COALESCE(F.Level1,'') AS NVARCHAR(500))  +'_' +CAST(COALESCE(F.Level2,'') AS NVARCHAR(100)) + '_' + CAST(F.FormYear AS NVARCHAR(100)) AS UniqueGroupID,
COALESCE(F.Function_Name,'') + '_' + COALESCE(F.Function_SubType,'') + '_'  + CAST(F.Vendor_Name AS NVARCHAR(100)) + '_'  + COALESCE(CAST(F.Level1 AS NVARCHAR(500)),'') + '_'  + COALESCE(CAST(F.Plant AS NVARCHAR(100)),'') +'_'  + CAST(F.FormYear AS NVARCHAR(100)) +'_'  + COALESCE(CAST(F.RoundYear AS NVARCHAR(100)),'') AS JoinKey,
F.Function_Name,
F.Function_SubType,
CAST(F.Scoring_Group AS NVARCHAR(100)) AS Scoring_Group,
CAST(F.SharePoint_List AS NVARCHAR(100)) AS SharePoint_List,
CAST(F.Item_ID AS NVARCHAR(100)) AS Item_ID,
CAST(F.Title AS NVARCHAR(100)) AS Title,
CAST(F.SubmissionTime AS NVARCHAR(100)) AS SubmissionTime,
CAST(F.ResponderEmail AS NVARCHAR(100)) AS ResponderEmail,
CAST(F.Level1 AS NVARCHAR(500)) AS Level1,
CAST(F.Level2 AS NVARCHAR(100)) AS Level2,
CAST(F.Level3 AS NVARCHAR(100)) AS Level3,
CAST(F.Pur_Grp AS NVARCHAR(100)) AS Pur_Grp,
CAST(COALESCE(F.Plant,'') AS NVARCHAR(100)) AS Plant,
CAST(F.Product AS NVARCHAR(100)) AS Product,
CAST(F.Vendor_Name AS NVARCHAR(100)) AS Vendor_Name,
CAST(LTRIM(RTRIM(COALESCE(F.Comment1,'')+' '+COALESCE(F.Comment2,'')+' '+COALESCE(F.Comment3,'')+' '+COALESCE(F.Comment4,''))) AS NVARCHAR(1000)) AS Comment,
CAST(F.Above1MB AS NVARCHAR(100)) AS Above1MB,
F.Group_Question,
F.Question_Order_New AS Question_Order,
'Q'+RIGHT(CAST(100+F.Question_Order_New AS NVARCHAR(10)),2) AS Question_Number,
CAST(F.Question_Name AS NVARCHAR(300)) AS Question_Name,
CAST(F.Response AS NVARCHAR(100)) AS Response,
F.Response_Value,
F.Max_Response_Value,
F.Raw_Score,

F.Weight_UniqueID,
F.Score_UniqueID,

F.Weight_Source,
F.Weight_Report AS Weight,
F.Score_Report AS Score,
F.WeightTotal,

F.Weight_Calc,
F.Score_Calc,
F.Score_Calc_Format,

F.Weight_RM,
F.Score_RM,
F.Score_RM_Format,

F.Weight_PCM,
F.Score_PCM,
F.Score_PCM_Format,

CASE
	WHEN F.SumScoreByUniqueID >= 85 THEN 'A'
	WHEN F.SumScoreByUniqueID >= 68 THEN 'B'
	WHEN F.SumScoreByUniqueID >= 51 THEN 'C'
	WHEN F.SumScoreByUniqueID >= 0 THEN 'D'
	ELSE '-' 
END AS GradeByUniqueID,
F.RawVendorScore,
F.RawVendorFormCount,
F.SumScoreByVendor,
CASE
	WHEN F.SumScoreByVendor >= 85 THEN 'A'
	WHEN F.SumScoreByVendor >= 68 THEN 'B'
	WHEN F.SumScoreByVendor >= 51 THEN 'C'
	WHEN F.SumScoreByVendor >= 0 THEN 'D'
	ELSE '-' 
END AS GradeByVendor,
F.RawVendorLevelScore,
F.RawVendorLevelFormCount,
F.SumScoreByVendorLevel,
/*CASE 
WHEN Function_Name = 'RM&PKG'
THEN
    CASE
        WHEN F.SumScoreByVendorLevel >= 90 THEN 'A'
        WHEN F.SumScoreByVendorLevel >= 80 THEN 'B'
        WHEN F.SumScoreByVendorLevel >= 70 THEN 'C'
        WHEN F.SumScoreByVendorLevel >= 60 THEN 'D'
        ELSE 'F' 
    END
ELSE*/
    CASE
        WHEN F.SumScoreByVendorLevel >= 85 THEN 'A'
        WHEN F.SumScoreByVendorLevel >= 68 THEN 'B'
        WHEN F.SumScoreByVendorLevel >= 51 THEN 'C'
        WHEN F.SumScoreByVendorLevel >= 0 THEN 'D'
        ELSE '-' 
    --END 
END AS GradeByVendorLevel
, FormYear- CYEAR AS CURRENT_YEAR_INDEX

FROM(
SELECT 
F.*,
DENSE_RANK() OVER (PARTITION BY F.Function_Name, F.Function_SubType, F.SharePoint_List ORDER BY F.Question_Order ASC) AS Question_Order_New,
SUM(Score_Report) OVER (PARTITION BY UniqueID) AS SumScoreByUniqueID,

C.RawVendorScore,
C.RawVendorFormCount,
C.RawVendorScore / C.RawVendorFormCount AS SumScoreByVendor,

COALESCE(L.RawVendorLevelScore,LP.RawVendorLevelScore) AS RawVendorLevelScore ,
COALESCE(L.RawVendorLevelFormCount,LP.RawVendorLevelFormCount) AS RawVendorLevelFormCount ,  
COALESCE(L.RawVendorLevelScore,LP.RawVendorLevelScore) / 
COALESCE(L.RawVendorLevelFormCount,LP.RawVendorLevelFormCount) AS SumScoreByVendorLevel

FROM W_FACT F

LEFT JOIN (
	SELECT FormYear,Function_Name, Function_SubType, Vendor_Name, SUM(Score_Report) AS RawVendorScore, COUNT(DISTINCT UniqueID) AS RawVendorFormCount
	FROM W_FACT
	GROUP BY FormYear,Function_Name, Function_SubType, Vendor_Name
) C
ON F.FormYear = C.FormYear
AND F.Function_Name = C.Function_Name
AND F.Function_SubType = C.Function_SubType
AND F.Vendor_Name = C.Vendor_Name


LEFT JOIN (	


    SELECT FormYear,Function_Name, Function_SubType, Vendor_Name, /*Level1, Level2, */RoundYear,SUM(RawVendorLevelScore_Weighted) AS RawVendorLevelScore, 1 AS RawVendorLevelFormCount 
    FROM(
        SELECT FormYear,Function_Name, Function_SubType, Vendor_Name, /*Level1, Level2, */ Question_Name, RoundYear,
        SUM(Score_UniqueID) AS RawVendorLevelScore,
        COUNT(DISTINCT UniqueID) AS RawVendorLevelFormCount,
        SUM(Score_UniqueID) / COUNT(DISTINCT UniqueID) AS RawVendorLevelScore_Weighted
        FROM dbo.VW_FORM_07_SCORE_FIX
        WHERE Function_Name NOT IN ('RM&PKG', 'Procurement')        
        GROUP BY FormYear,Function_Name, Function_SubType, Vendor_Name, /*Level1, Level2, */ Question_Name,RoundYear
    ) A
    GROUP BY FormYear,Function_Name, Function_SubType, Vendor_Name, /*Level1, Level2, */RoundYear
	
	UNION ALL 
	
    SELECT FormYear,Function_Name, Function_SubType, Vendor_Name, /*Level1, Level2, */ RoundYear,
    ( SUM(RawVendorLevelScore * Weight_Source / WeightTotal) / SUM(Weight_Source) ) * 100 AS RawVendorLevelScore,
    1 AS RawVendorLevelFormCount
    FROM (
        SELECT FormYear,Function_Name, Function_SubType, Vendor_Name, /*Level1, Level2, */ Group_Question, Weight_Source,RoundYear,
        SUM(RawVendorLevelScore_Weighted) AS RawVendorLevelScore, SUM(Weight)  AS WeightTotal
        FROM(
            SELECT FormYear,Function_Name, Function_SubType, Vendor_Name, /*Level1, Level2, */ Group_Question, Pur_Grp, Question_Name, 
            Weight, Weight_Source,RoundYear,
            SUM(Score_UniqueID) as SumUnique,
             COUNT(DISTINCT UniqueID) as CountUnique ,
            SUM(Score_UniqueID) / COUNT(DISTINCT UniqueID) AS RawVendorLevelScore_Weighted
            FROM dbo.VW_FORM_07_SCORE_FIX
            WHERE Function_Name = 'RM&PKG' 
            GROUP BY FormYear,Function_Name, Function_SubType, Vendor_Name, /*Level1, Level2, */ Group_Question, Pur_Grp, Question_Name,Weight, Weight_Source,RoundYear
        ) A
        GROUP BY FormYear,Function_Name, Function_SubType, Vendor_Name, /*Level1, Level2, */ Group_Question, Weight_Source,RoundYear
    ) B
    GROUP BY  FormYear,Function_Name, Function_SubType, Vendor_Name, /*Level1, Level2, */RoundYear
    
    
) L
ON F.FormYear = L.FormYear
AND F.Function_Name = L.Function_Name
AND F.Function_SubType = L.Function_SubType
AND F.Vendor_Name = L.Vendor_Name
/*AND F.Level1 = L.Level1
AND F.Level2 = L.Level2*/
AND F.RoundYear = L.RoundYear /******Edit***** */

LEFT JOIN (
    
    SELECT FormYear,Function_Name, Function_SubType, ResponderEmail, Vendor_Name, /*Level1, Level2, */ 
    ( SUM(RawVendorLevelScore * Weight_Source / WeightTotal) / SUM(Weight_Source) ) * 100 AS RawVendorLevelScore,
    1 AS RawVendorLevelFormCount
    FROM (
        SELECT FormYear,Function_Name, Function_SubType,  ResponderEmail, Vendor_Name, /*Level1, Level2, */  Group_Question, Weight_Source,
        SUM(RawVendorLevelScore_Weighted) AS RawVendorLevelScore, SUM(Weight)  AS WeightTotal
        FROM(
            SELECT FormYear,Function_Name, Function_SubType,  ResponderEmail, Vendor_Name, /*Level1, Level2, */  Group_Question, Pur_Grp, Question_Name, 
            Weight, Weight_Source,
            SUM(Score_UniqueID) as SumUnique,
             COUNT(DISTINCT UniqueID) as CountUnique ,
            SUM(Score_UniqueID) / COUNT(DISTINCT UniqueID) AS RawVendorLevelScore_Weighted
            FROM dbo.VW_FORM_07_SCORE_FIX
            WHERE Function_Name = 'Procurement'
            GROUP BY FormYear,Function_Name, Function_SubType,  ResponderEmail, Vendor_Name, /*Level1, Level2, */  Group_Question, Pur_Grp, Question_Name,Weight, Weight_Source   
        ) A
        GROUP BY FormYear,Function_Name, Function_SubType,  ResponderEmail, Vendor_Name, /*Level1, Level2, */  Group_Question, Weight_Source
    ) B
    GROUP BY  FormYear,Function_Name, Function_SubType,  ResponderEmail, Vendor_Name /*Level1, Level2, */    
	
) LP
ON F.FormYear = LP.FormYear
AND F.Function_Name = LP.Function_Name
AND F.Function_SubType = LP.Function_SubType
AND F.ResponderEmail = LP.ResponderEmail
/*AND F.Level1 = LP.Level1
AND F.Level2 = LP.Level2*/

) F

  CROSS JOIN 
  (SELECT DATEPART(YY, GETDATE()) AS CYEAR ) A

--ORDER BY Function_Name,Function_SubType,UniqueID,Vendor_Name,Question_Order
GO


