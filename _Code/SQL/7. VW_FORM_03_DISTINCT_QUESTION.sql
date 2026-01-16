USE [TNTL_PUR]
GO

/****** Object:  View [dbo].[VW_FORM_03_DISTINCT_QUESTION]    Script Date: 18/2/2568 9:03:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO










CREATE VIEW [dbo].[VW_FORM_03_DISTINCT_QUESTION] AS 
SELECT 
DISTINCT 
TOP 10000000
F.FormYear,F.SharePoint_List,Function_Name,Function_SubType,Question_Order,Question_Name, V.Max_Response_Value
FROM VW_FORM_01_UNION F
LEFT JOIN (
	SELECT FormYear,SharePoint_List, MAX(Response_Value) AS Max_Response_Value
	FROM VW_FORM_02_UNION_VALUE_MAP
	GROUP BY FormYear,SharePoint_List
) V
ON F.SharePoint_List = V.SharePoint_List AND F.FormYear = V.FormYear
ORDER BY F.FormYear,F.SharePoint_List,Function_SubType,Question_Order
GO


