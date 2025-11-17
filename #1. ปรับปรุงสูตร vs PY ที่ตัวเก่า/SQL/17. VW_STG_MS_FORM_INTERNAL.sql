USE [TNTL_PUR]
GO

/****** Object:  View [dbo].[VW_STG_MS_FORM_INTERNAL]    Script Date: 18/2/2568 8:54:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








CREATE VIEW [dbo].[VW_STG_MS_FORM_INTERNAL] AS 

SELECT 
N'Procurement' as Function_Name,
N'Internal' as Function_SubType,
A.SharePoint_List+'_'+RIGHT(CAST(10000+A.Item_ID AS NVARCHAR(10)),4) AS UniqueID,
A.*,
C.Question_Order,
B.Question_Name,
B.Response,
TRY_CAST(B.Response as DECIMAL(25,4)) AS Response_Value
FROM
(
	SELECT 
	CASE 
	WHEN [ปีที่ประเมิน] IS NULL THEN CAST(YEAR([Submission Time]) as NVARCHAR(20))
	ELSE REPLACE(CAST([ปีที่ประเมิน] as NVARCHAR(20)),'Y','') END AS FormYear,
	[รอบการประเมิน] AS RoundYear,
	SharePoint_List,
	Item_ID,Title,
	DATEADD("hour",7,TRY_CAST([Submission Time] AS DATETIME2(0))) AS SubmissionTime,
	[Responder Email] AS ResponderEmail,
	Level1,Level2, 
	CAST(NULL AS NVARCHAR(100)) AS Level3,
	CAST(NULL AS NVARCHAR(100)) AS Pur_Grp,
	CAST(NULL AS NVARCHAR(100))  AS Plant,
	CAST(NULL AS NVARCHAR(100)) AS Product,
	COALESCE(NULL,'') AS Vendor_Name,
	[ข้อเสนอแนะเพื่อการปรับปรุงการให้บริการของ Strategic Team] as Comment1,
	CAST(NULL AS NVARCHAR(1000)) AS Comment2,
	CAST(NULL AS NVARCHAR(1000))  AS Comment3,
	CAST(NULL AS NVARCHAR(1000))  AS Comment4,
	Above1MB
	FROM  
	(
		SELECT SHAREPOINT_LIST,ITEM_ID,Title,QUESTION_NAME,RESPONSE FROM STG_MS_FORM_INTERNAL
		WHERE QUESTION_NAME IN ('ปีที่ประเมิน','Submission Time','Responder Email','Level1','Level2','ผู้รับการประเมิน ALL','ข้อเสนอแนะเพื่อการปรับปรุงการให้บริการของ Strategic Team','Above1MB','รอบการประเมิน','BelowThreshold')
	) AS F
	PIVOT  
	(  
	MIN(RESPONSE) FOR QUESTION_NAME IN ([ปีที่ประเมิน],[Submission Time],[Responder Email],[Level1],[Level2],[ผู้รับการประเมิน ALL],[ข้อเสนอแนะเพื่อการปรับปรุงการให้บริการของ Strategic Team],[Above1MB],[รอบการประเมิน],[BelowThreshold])
	) AS P
) A 
LEFT JOIN (
	SELECT SHAREPOINT_LIST,ITEM_ID,QUESTION_NAME,RESPONSE FROM STG_MS_FORM_INTERNAL
	WHERE QUESTION_NAME NOT IN ('ปีที่ประเมิน','Submission Time','Responder Email','Level1','Level2','ผู้รับการประเมิน ALL','ข้อเสนอแนะเพื่อการปรับปรุงการให้บริการของ Strategic Team','ข้อเสนอแนะ เพื่อปรับปรุงการบริการของ Vendor','ปีที่ประเมิน','Above1MB','รอบการประเมิน','BelowThreshold')
) B
ON A.Item_ID = B.ITEM_ID
LEFT JOIN (
	SELECT DISTINCT QUESTION_NAME,QUESTION_ORDER FROM STG_MS_FORM_INTERNAL
) C

ON B.QUESTION_NAME = C.QUESTION_NAME

WHERE QUESTION_ORDER IS NOT NULL 
GO


