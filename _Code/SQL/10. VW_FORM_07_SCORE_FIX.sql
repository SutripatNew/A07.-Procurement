USE [TNTL_PUR]
GO

/****** Object:  View [dbo].[VW_FORM_07_SCORE_FIX]    Script Date: 18/2/2568 9:10:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE VIEW [dbo].[VW_FORM_07_SCORE_FIX] AS 


WITH W_FACT AS (
    SELECT 
    F.*,
    F.Raw_Score AS Raw,
    Score AS Score_UniqueID,
    Weight AS Weight_UniqueID,
    WeightTotal AS WeightTotal_UniqueID     
    FROM FACT_MS_FORM_SCORE F
),

W_FACT2 AS (

SELECT 
F.*,
QG.Weight_UniqueIDQuestionGroup,
--CAST(F.Weight_Source * 100 / QG.Weight_UniqueIDQuestionGroup AS DECIMAL(9,4)) AS Weight_UniqueIDQuestionGroup_100,
SUM(F.Weight_UniqueID) OVER (PARTITION BY F.Function_Name,F.Function_SubType,F.Scoring_Group,F.FormYear,F.SharePoint_List,F.Plant,F.Product,F.Vendor_Name,F.Group_Question ) AS Weight_WithInGroup_Question,
SUM(F.Weight_UniqueID) OVER (PARTITION BY F.Function_Name,F.Function_SubType,F.Scoring_Group,F.FormYear,F.SharePoint_List,F.Plant,F.Product,F.Vendor_Name,F.Pur_Grp/*F.Level1*/,F.Question_Name ) AS Weight_WithInQuestionName,
COUNT(F.Weight_UniqueID) OVER (PARTITION BY F.Function_Name,F.Function_SubType,F.Scoring_Group,F.FormYear,F.SharePoint_List,F.Plant,F.Product,F.Vendor_Name,F.Pur_Grp/*F.Level1*/,F.Question_Name ) AS Count_WithInQuestionName,
Q1.Weight_VendorPlantProduct,
Q2.Weight_Level
--CAST(F.Weight_Source * 100 / Q1.Weight_VendorPlantProduct AS DECIMAL(9,4)) AS Weight_VendorPlantProduct_100


FROM W_FACT F 
LEFT JOIN (
    SELECT  
    UniqueID, SUM(Weight_Source) AS Weight_UniqueIDQuestionGroup
    FROM
    (
        SELECT
       UniqueID,Group_Question,Weight_Source
        FROM FACT_MS_FORM_SCORE
        GROUP BY
       UniqueID,Group_Question,Weight_Source
    ) A
    GROUP BY UniqueID
) QG
ON F.UniqueID = QG.UniqueID 
LEFT JOIN (
    SELECT Function_Name,Function_SubType,Scoring_Group,FormYear,SharePoint_List,Plant,Product,Vendor_Name,
    SUM(Weight_Source) AS Weight_VendorPlantProduct
    FROM 
    (
        SELECT
            Function_Name,Function_SubType,Scoring_Group,FormYear,SharePoint_List,Plant,Product,Vendor_Name,Group_Question,Weight_Source 
        FROM
            FACT_MS_FORM_SCORE 
            WHERE Function_Name = 'RM&PKG'
        GROUP BY
            Function_Name,Function_SubType,Scoring_Group,FormYear,SharePoint_List,Plant,Product,Vendor_Name,Group_Question,Weight_Source
    ) A
    GROUP BY Function_Name,Function_SubType,Scoring_Group,FormYear,SharePoint_List,Plant,Product,Vendor_Name
) Q1
ON F.Function_Name = Q1.Function_Name
AND F.Function_SubType = Q1.Function_SubType
AND F.Scoring_Group = Q1.Scoring_Group
AND F.FormYear = Q1.FormYear
AND F.SharePoint_List = Q1.SharePoint_List
AND F.Vendor_Name = Q1.Vendor_Name
AND F.Plant = Q1.Plant
AND F.Product = Q1.Product
LEFT JOIN (
SELECT Function_Name,Function_SubType,Scoring_Group,FormYear,SharePoint_List,Level1,
SUM(Weight_Source) AS Weight_Level
FROM 
(
    SELECT
        Function_Name,Function_SubType,Scoring_Group,FormYear,SharePoint_List,Level1,Question_Name,Weight_Source 
    FROM
        FACT_MS_FORM_SCORE 
        WHERE Function_Name = 'Procurement'
    GROUP BY
        Function_Name,Function_SubType,Scoring_Group,FormYear,SharePoint_List,Level1,Question_Name,Weight_Source
) A
GROUP BY Function_Name,Function_SubType,Scoring_Group,FormYear,SharePoint_List,Level1
) Q2
ON F.Function_Name = Q2.Function_Name
AND F.Function_SubType = Q2.Function_SubType
AND F.Scoring_Group = Q2.Scoring_Group
AND F.FormYear = Q2.FormYear
AND F.SharePoint_List = Q2.SharePoint_List
AND F.Level1 = Q2.Level1


)

SELECT 
F.*,

F.Weight AS Weight_Calc,
CAST( F.Raw_Score * F.Weight * (100/F.WeightTotal) AS DECIMAL(9,4)) AS Score_Calc,
FORMAT(F.Raw_Score, '0.00')  + ' x ' + FORMAT(F.Weight, '0.00') + ' x ' + ' Weight (100.00/' + FORMAT(F.WeightTotal, '0.00')+')'  AS Score_Calc_Format, 

CAST( F.Weight * ( F.Weight_Source / F.Weight_WithInGroup_Question )  * ( 100.00 / F.Weight_VendorPlantProduct) AS DECIMAL(9,4)) AS Weight_RM,
CAST( F.Raw_Score *  F.Weight * ( F.Weight_Source / F.Weight_WithInGroup_Question )  * ( 100.00 / F.Weight_VendorPlantProduct) AS DECIMAL(9,4))  AS Score_RM,
FORMAT(F.Raw_Score, '0.00')  + ' x ' + FORMAT(F.Weight, '0.00') + ' x ' + ' WithinGroup (' + FORMAT(F.Weight_Source, '0.00') + '/' + FORMAT(F.Weight_WithInGroup_Question, '0.00')+')' +' x ' + 'Weight (100.00/' +  FORMAT(F.Weight_VendorPlantProduct, '0.00')+')' AS Score_RM_Format,

CAST( F.Weight * ( F.Weight_Source / F.Weight_WithInQuestionName )  * ( 100.00 / F.Weight_Level) AS DECIMAL(9,4)) AS Weight_PCM,
CAST( F.Raw_Score *  F.Weight * ( F.Weight_Source / F.Weight_WithInQuestionName )  * ( 100.00 / F.Weight_Level) AS DECIMAL(9,4))  AS Score_PCM,
FORMAT(F.Raw_Score, '0.00')  + ' x ' + FORMAT(F.Weight, '0.00') + ' x ' + ' WithinGroup (' + FORMAT(F.Weight_Source, '0.00') + '/' + FORMAT(F.Weight_WithInQuestionName, '0.00')+' - 1 of '+ FORMAT(Count_WithInQuestionName,'0') +' resp.)' +' x ' + 'Weight (100.00/' +  FORMAT(F.Weight_Level, '0.00')+')' AS Score_PCM_Format

FROM W_FACT2 F
--WHERE Function_Name = 'RM&PKG'
--AND LEVEL1 LIKE '%ป้าย%'

--ORDER BY LEVEL1, Question_Name, UniqueID
GO


