USE [TNTL_PUR_DEV]
GO

/****** Object:  View [dbo].[VW_STG_MS_FORM_EXTERNAL]    Script Date: 21/8/2568 9:11:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO









ALTER VIEW [dbo].[VW_STG_MS_FORM_EXTERNAL] AS 

-- Vendor Evaluation Dashboard V1.
--SELECT *
--FROM
--(
--	SELECT 
--	N'Procurement' as Function_Name,
--	N'External' as Function_SubType,
--	A.SharePoint_List+'_'+RIGHT(CAST(10000+A.Item_ID AS NVARCHAR(10)),4) AS UniqueID,
--	A.*,
--	C.Question_Order,
--	B.Question_Name,
--	B.Response,
--	TRY_CAST(B.Response as DECIMAL(25,4)) AS Response_Value
--	FROM
--	(
--		SELECT 
--		CASE 
--		WHEN [ปีที่ประเมิน] IS NULL THEN CAST(YEAR([Submission Time]) as NVARCHAR(20))
--		ELSE REPLACE(CAST([ปีที่ประเมิน] as NVARCHAR(20)),'Y','') END AS FormYear,
--		[รอบการประเมิน] AS RoundYear,
--		SharePoint_List,
--		Item_ID,Title,
--		DATEADD("hour",7,TRY_CAST([Submission Time] AS DATETIME2(0))) AS SubmissionTime,
--		[Responder Email] AS ResponderEmail,
--		Level1,
--		Level2, 
--		CAST(NULL AS NVARCHAR(100)) AS Level3,
--		CAST(NULL AS NVARCHAR(100)) AS Pur_Grp,
--		CAST(NULL AS NVARCHAR(100)) AS Plant,
--		CAST(NULL AS NVARCHAR(100)) AS Product,
--		COALESCE(NULL,'') AS Vendor_Name,
--		[ข้อเสนอแนะเพื่อการปรับปรุงการให้บริการของเจ้าหน้าที่จัดซื้อ] as Comment1,
--		CAST(NULL AS NVARCHAR(1000))  AS Comment2,
--		CAST(NULL AS NVARCHAR(1000))  AS Comment3,
--		CAST(NULL AS NVARCHAR(1000))  AS Comment4,
--		Above1MB
--		FROM  
--		(
--			SELECT SHAREPOINT_LIST,ITEM_ID,Title,QUESTION_NAME,RESPONSE FROM STG_MS_FORM_EXTERNAL
--			WHERE QUESTION_NAME IN ('ปีที่ประเมิน','Submission Time','Responder Email','Level1','Level2','ผู้รับการประเมิน ALL','ข้อเสนอแนะเพื่อการปรับปรุงการให้บริการของเจ้าหน้าที่จัดซื้อ','Above1MB','รอบการประเมิน','BelowThreshold', 'Pur_Grp')
--		) AS F
--		PIVOT  
--		(  
--		MIN(RESPONSE) FOR QUESTION_NAME IN ([ปีที่ประเมิน],[Submission Time],[Responder Email],[Level1],[Level2],[ผู้รับการประเมิน ALL],[ข้อเสนอแนะเพื่อการปรับปรุงการให้บริการของเจ้าหน้าที่จัดซื้อ],[Above1MB],[รอบการประเมิน],[BelowThreshold], [Pur_Grp])
--		) AS P
--	) A 
--	LEFT JOIN (
--		SELECT SHAREPOINT_LIST,ITEM_ID,QUESTION_NAME,RESPONSE FROM STG_MS_FORM_EXTERNAL
--		WHERE QUESTION_NAME NOT IN ('ปีที่ประเมิน','Submission Time','Responder Email','Level1','Level2','ผู้รับการประเมิน ALL','ข้อเสนอแนะเพื่อการปรับปรุงการให้บริการของเจ้าหน้าที่จัดซื้อ','Above1MB','รอบการประเมิน','BelowThreshold', 'Pur_Grp')
--	) B
--	ON A.ITEM_ID = B.ITEM_ID
--	LEFT JOIN (
--		SELECT DISTINCT QUESTION_NAME,QUESTION_ORDER FROM STG_MS_FORM_EXTERNAL
--	) C
--	ON B.QUESTION_NAME = C.QUESTION_NAME

--	WHERE QUESTION_ORDER IS NOT NULL 
--) M
--WHERE M.[FormYear] > 1999

--UNION ALL

-- Vendor Evaluation Dashboard V2.
--SELECT *
--FROM
--(
--	SELECT 
--	N'Procurement' as Function_Name,
--	N'External' as Function_SubType,
--	A.SharePoint_List+'_'+RIGHT(CAST(10000+A.Item_ID AS NVARCHAR(10)),4) AS UniqueID,
--	A.*,
--	C.Question_Order,
--	B.Question_Name,
--	B.Response,
--	TRY_CAST(B.Response as DECIMAL(25,4)) AS Response_Value
--	FROM
--	(
--		SELECT 
--		CASE 
--		WHEN [ปีที่ประเมิน] IS NULL THEN CAST(YEAR([Submission Time]) as NVARCHAR(20))
--		ELSE REPLACE(CAST([ปีที่ประเมิน] as NVARCHAR(20)),'Y','') END AS FormYear,
--		[รอบการประเมิน] AS RoundYear,
--		SharePoint_List,
--		Item_ID,Title,
--		DATEADD("hour",7,TRY_CAST([Submission Time] AS DATETIME2(0))) AS SubmissionTime,
--		[Responder Email] AS ResponderEmail,
--		Level1,
--		Level2, 
--		CAST(NULL AS NVARCHAR(100)) AS Level3,
--		Pur_Grp AS Pur_Grp,
--		CAST(NULL AS NVARCHAR(100)) AS Plant,
--		CAST(NULL AS NVARCHAR(100)) AS Product,
--		COALESCE(NULL,'') AS Vendor_Name,
--		[ข้อเสนอแนะเพื่อการปรับปรุงการให้บริการของเจ้าหน้าที่จัดซื้อ] as Comment1,
--		CAST(NULL AS NVARCHAR(1000))  AS Comment2,
--		CAST(NULL AS NVARCHAR(1000))  AS Comment3,
--		CAST(NULL AS NVARCHAR(1000))  AS Comment4,
--		Above1MB
--		FROM  
--		(
--			SELECT SHAREPOINT_LIST,ITEM_ID,Title,QUESTION_NAME,RESPONSE FROM STG_MS_FORM_EXTERNAL
--			WHERE QUESTION_NAME IN ('ปีที่ประเมิน','Submission Time','Responder Email','Level1','Level2','ผู้รับการประเมิน ALL','ข้อเสนอแนะเพื่อการปรับปรุงการให้บริการของเจ้าหน้าที่จัดซื้อ','Above1MB','รอบการประเมิน','BelowThreshold', 'Pur_Grp')
--		) AS F
--		PIVOT  
--		(  
--		MIN(RESPONSE) FOR QUESTION_NAME IN ([ปีที่ประเมิน],[Submission Time],[Responder Email],[Level1],[Level2],[ผู้รับการประเมิน ALL],[ข้อเสนอแนะเพื่อการปรับปรุงการให้บริการของเจ้าหน้าที่จัดซื้อ],[Above1MB],[รอบการประเมิน],[BelowThreshold], [Pur_Grp])
--		) AS P
--	) A 
--	LEFT JOIN (
--		SELECT SHAREPOINT_LIST,ITEM_ID,QUESTION_NAME,RESPONSE FROM STG_MS_FORM_EXTERNAL
--		WHERE QUESTION_NAME NOT IN ('ปีที่ประเมิน','Submission Time','Responder Email','Level1','Level2','ผู้รับการประเมิน ALL','ข้อเสนอแนะเพื่อการปรับปรุงการให้บริการของเจ้าหน้าที่จัดซื้อ','Above1MB','รอบการประเมิน','BelowThreshold', 'Pur_Grp')
--	) B
--	ON A.ITEM_ID = B.ITEM_ID
--	LEFT JOIN (
--		SELECT DISTINCT QUESTION_NAME,QUESTION_ORDER FROM STG_MS_FORM_EXTERNAL
--	) C
--	ON B.QUESTION_NAME = C.QUESTION_NAME

--	WHERE QUESTION_ORDER IS NOT NULL 
--) M
--WHERE M.[FormYear] >= 2025

-- Satisfaction

SELECT 
N'Procurement' as Function_Name,
N'External' as Function_SubType,
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
	Level1,
	Level2, 
	CAST(NULL AS NVARCHAR(100)) AS Level3,
	Pur_Grp AS Pur_Grp,
	CAST(NULL AS NVARCHAR(100)) AS Plant,
	CAST(NULL AS NVARCHAR(100)) AS Product,
	COALESCE(NULL,'') AS Vendor_Name,
	[ข้อเสนอแนะเพื่อการปรับปรุงการให้บริการของเจ้าหน้าที่จัดซื้อ] as Comment1,
	CAST(NULL AS NVARCHAR(1000))  AS Comment2,
	CAST(NULL AS NVARCHAR(1000))  AS Comment3,
	CAST(NULL AS NVARCHAR(1000))  AS Comment4,
	Above1MB
	FROM  
	(
		SELECT SHAREPOINT_LIST,ITEM_ID,Title,QUESTION_NAME,RESPONSE FROM STG_MS_FORM_EXTERNAL
		WHERE QUESTION_NAME IN ('ปีที่ประเมิน','Submission Time','Responder Email','Level1','Level2','ผู้รับการประเมิน ALL','ข้อเสนอแนะเพื่อการปรับปรุงการให้บริการของเจ้าหน้าที่จัดซื้อ','Above1MB','รอบการประเมิน','BelowThreshold', 'Pur_Grp')
	) AS F
	PIVOT  
	(  
	MIN(RESPONSE) FOR QUESTION_NAME IN ([ปีที่ประเมิน],[Submission Time],[Responder Email],[Level1],[Level2],[ผู้รับการประเมิน ALL],[ข้อเสนอแนะเพื่อการปรับปรุงการให้บริการของเจ้าหน้าที่จัดซื้อ],[Above1MB],[รอบการประเมิน],[BelowThreshold], [Pur_Grp])
	) AS P
) A 
LEFT JOIN (
	SELECT SHAREPOINT_LIST,ITEM_ID,QUESTION_NAME,RESPONSE FROM STG_MS_FORM_EXTERNAL
	WHERE QUESTION_NAME NOT IN ('ปีที่ประเมิน','Submission Time','Responder Email','Level1','Level2','ผู้รับการประเมิน ALL','ข้อเสนอแนะเพื่อการปรับปรุงการให้บริการของเจ้าหน้าที่จัดซื้อ','Above1MB','รอบการประเมิน','BelowThreshold', 'Pur_Grp')
) B
ON A.ITEM_ID = B.ITEM_ID
LEFT JOIN (
	SELECT DISTINCT QUESTION_NAME,QUESTION_ORDER FROM STG_MS_FORM_EXTERNAL
) C
ON B.QUESTION_NAME = C.QUESTION_NAME

WHERE QUESTION_ORDER IS NOT NULL 


GO


