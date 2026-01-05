USE [TNTL_PUR]
GO

/****** Object:  View [dbo].[VW_STG_MS_FORM_LOGISTIC]    Script Date: 18/2/2568 8:42:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE VIEW [dbo].[VW_STG_MS_FORM_LOGISTIC] AS 

SELECT 
N'Logistic' as Function_Name,

CAST('' AS NVARCHAR(100)) as Function_SubType,
A.SharePoint_List+'_'+RIGHT(CAST(10000+A.Item_ID AS NVARCHAR(10)),4) AS UniqueID,
A.*,
C.Question_Order,
--C.Question_Name,
D.Question_DISPLAY AS Question_Name,
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
	LTRIM(RTRIM(Level1)) AS Level1,
	LTRIM(RTRIM(Level2)) AS Level2,
	LTRIM(RTRIM(Level3)) AS Level3,
	CAST(NULL AS NVARCHAR(100)) AS Pur_Grp,
	[โรงงาน] as Plant,
	CAST(NULL AS NVARCHAR(100)) AS Product,
	COALESCE([ผู้รับการประเมิน ALL],'') AS Vendor_Name,
	[ข้อเสนอแนะ เพื่อปรับปรุงการบริการของ Vendor] as Comment1,
	CAST(NULL AS NVARCHAR(1000))  AS Comment2,
	CAST(NULL AS NVARCHAR(1000))  AS Comment3,
	CAST(NULL AS NVARCHAR(1000))  AS Comment4,
	Above1MB
	FROM  
	(
		SELECT SHAREPOINT_LIST,ITEM_ID,Title,QUESTION_NAME,RESPONSE FROM STG_MS_FORM_LOGISTIC
		WHERE QUESTION_NAME IN ('ปีที่ประเมิน','Submission Time','Responder Email','Level1','Level2','Level3','ผู้รับการประเมิน ALL','ข้อเสนอแนะ เพื่อปรับปรุงการบริการของ Vendor','โรงงาน','Above1MB','รอบการประเมิน','BelowThreshold')
	) AS F
	PIVOT  
	(  
	MIN(RESPONSE) FOR QUESTION_NAME IN ([ปีที่ประเมิน], [Submission Time],[Responder Email],[Level1],[Level2],[Level3],[ผู้รับการประเมิน ALL],[ข้อเสนอแนะ เพื่อปรับปรุงการบริการของ Vendor],[โรงงาน],[Above1MB],[รอบการประเมิน],[BelowThreshold])
	) AS P
) A 
LEFT JOIN (
	SELECT SHAREPOINT_LIST,ITEM_ID,QUESTION_NAME,RESPONSE FROM STG_MS_FORM_LOGISTIC
	WHERE QUESTION_NAME NOT IN ('ปีที่ประเมิน','Submission Time','Responder Email','Level1','Level2','Level3','ผู้รับการประเมิน ALL','ข้อเสนอแนะ เพื่อปรับปรุงการบริการของ Vendor','โรงงาน','Above1MB','รอบการประเมิน','BelowThreshold')
) B
ON A.ITEM_ID = B.ITEM_ID
LEFT JOIN (
	SELECT DISTINCT QUESTION_NAME,QUESTION_ORDER FROM STG_MS_FORM_LOGISTIC
) C
ON B.QUESTION_NAME = C.QUESTION_NAME
LEFT JOIN (
	SELECT DISTINCT [YEAR],FUNCTION_NAME,LEVEL1,QUESTION,QUESTION_DISPLAY FROM STG_QUESTION
) D
ON A.formyear = D.[YEAR] AND C.question_name = D.QUESTION AND  N'Logistic' =  D.LEVEL1



GO


