USE [TNTL_PUR_DEV]
GO

/****** Object:  View [dbo].[VW_STG_MS_FORM_ENERGY_CHEMICAL]    Script Date: 20/5/2568 9:10:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO














CREATE VIEW [dbo].[VW_STG_MS_FORM_ENERGY_CHEMICAL] AS 

-- Vendor Evaluation Dashboard V1.
--SELECT *
--FROM
--(
--	SELECT 
--	N'ENEG_CHEM' as Function_Name,
--	CAST('' AS NVARCHAR(100)) as Function_SubType,
--	A.SharePoint_List+'_'+RIGHT(CAST(10000+A.Item_ID AS NVARCHAR(10)),4) AS UniqueID,
--	A.*,
--	C.Question_Order,
--	D.Question_DISPLAY AS Question_Name,
--	B.Response,
--	TRY_CAST(B.Response as DECIMAL(25,4)) AS Response_Value
--	FROM
--	(
--		SELECT 
--		CASE 
--		WHEN [ปีที่ประเมิน] IS NULL THEN CAST(YEAR([Submission Time]) as NVARCHAR(20))
--		ELSE REPLACE(CAST([ปีที่ประเมิน] as NVARCHAR(20)),'Y','') END AS FormYear,
--		LEFT([รอบการประเมิน],1) AS RoundYear,
--		SharePoint_List,
--		Item_ID,Title,
--		DATEADD("hour",7,TRY_CAST([Submission Time] AS DATETIME2(0))) AS SubmissionTime,
--		[Responder Email] AS ResponderEmail,
--		Level1,Level2, 
--		CAST(NULL AS NVARCHAR(100)) AS Level3,
--		CAST(NULL AS NVARCHAR(100)) AS Pur_Grp,
--		CAST(NULL AS NVARCHAR(100)) AS Plant,
--		CAST(NULL AS NVARCHAR(100)) AS Product,
--		COALESCE([ผู้รับการประเมิน ALL],'') AS Vendor_Name,
--		[ข้อเสนอแนะเพื่อการปรับปรุง] as Comment1,
--		CAST(NULL AS NVARCHAR(1000))  AS Comment2,
--		CAST(NULL AS NVARCHAR(1000))  AS Comment3,
--		CAST(NULL AS NVARCHAR(1000))  AS Comment4,
--		CAST(NULL AS NVARCHAR(100)) AS Above1MB
--		FROM  
--		(
--			SELECT SHAREPOINT_LIST,ITEM_ID,Title,QUESTION_NAME,RESPONSE FROM STG_MS_FORM_ENERGY_CHEMICAL
--			WHERE QUESTION_NAME IN ('ปีที่ประเมิน','Submission Time','Responder Email','Level1','Level2','ผู้รับการประเมิน ALL','ข้อเสนอแนะเพื่อการปรับปรุง','รอบการประเมิน', 'Pur_Grp')
--		) AS F
--		PIVOT  
--		(  
--		MIN(RESPONSE) FOR QUESTION_NAME IN ([ปีที่ประเมิน],[Submission Time],[Responder Email],[Level1],[Level2],[ผู้รับการประเมิน ALL],[ข้อเสนอแนะเพื่อการปรับปรุง],[รอบการประเมิน], [Pur_Grp])
--		) AS P
--	) A 
--	LEFT JOIN (
--		SELECT SHAREPOINT_LIST,ITEM_ID,QUESTION_NAME,RESPONSE FROM STG_MS_FORM_ENERGY_CHEMICAL
--		WHERE QUESTION_NAME NOT IN ('ปีที่ประเมิน','Submission Time','Responder Email','Level1','Level2','ผู้รับการประเมิน ALL','ข้อเสนอแนะเพื่อการปรับปรุง','รอบการประเมิน', 'Pur_Grp')
--	) B
--	ON A.ITEM_ID = B.ITEM_ID
--	LEFT JOIN (
--		SELECT DISTINCT QUESTION_NAME,QUESTION_ORDER FROM STG_MS_FORM_ENERGY_CHEMICAL
--	) C
--	ON B.QUESTION_NAME = C.QUESTION_NAME

--	LEFT JOIN (
--		SELECT DISTINCT [YEAR],FUNCTION_NAME,LEVEL1,QUESTION,QUESTION_DISPLAY FROM STG_QUESTION
--	) D
--	ON A.formyear = D.[YEAR] AND C.question_name = D.QUESTION AND N'ENEG_CHEM' = D.LEVEL1


--	-- SELECT DISTINCT QUESTION_NAME FROM STG_MS_FORM_AGILE ORDER BY 1
--) M
--WHERE M.[FormYear] > 1999

--UNION ALL

-- Vendor Evaluation Dashboard V2.
SELECT *
FROM
(
	SELECT 
	N'ENEG_CHEM' as Function_Name,
	CAST('' AS NVARCHAR(100)) as Function_SubType,
	A.SharePoint_List+'_'+RIGHT(CAST(10000+A.Item_ID AS NVARCHAR(10)),4) AS UniqueID,
	A.*,
	C.Question_Order,
	D.Question_DISPLAY AS Question_Name,
	B.Response,
	TRY_CAST(B.Response as DECIMAL(25,4)) AS Response_Value
	FROM
	(
		SELECT 
		CASE 
		WHEN [ปีที่ประเมิน] IS NULL THEN CAST(YEAR([Submission Time]) as NVARCHAR(20))
		ELSE REPLACE(CAST([ปีที่ประเมิน] as NVARCHAR(20)),'Y','') END AS FormYear,
		LEFT([รอบการประเมิน],1) AS RoundYear,
		SharePoint_List,
		Item_ID,Title,
		DATEADD("hour",7,TRY_CAST([Submission Time] AS DATETIME2(0))) AS SubmissionTime,
		[Responder Email] AS ResponderEmail,
		Level1,Level2, 
		CAST(NULL AS NVARCHAR(100)) AS Level3,
		Pur_Grp AS Pur_Grp,
		CAST(NULL AS NVARCHAR(100)) AS Plant,
		CAST(NULL AS NVARCHAR(100)) AS Product,
		COALESCE([ผู้รับการประเมิน ALL],'') AS Vendor_Name,
		[ข้อเสนอแนะเพื่อการปรับปรุง] as Comment1,
		CAST(NULL AS NVARCHAR(1000))  AS Comment2,
		CAST(NULL AS NVARCHAR(1000))  AS Comment3,
		CAST(NULL AS NVARCHAR(1000))  AS Comment4,
		CAST(NULL AS NVARCHAR(100)) AS Above1MB
		FROM  
		(
			SELECT SHAREPOINT_LIST,ITEM_ID,Title,QUESTION_NAME,RESPONSE FROM STG_MS_FORM_ENERGY_CHEMICAL
			WHERE QUESTION_NAME IN ('ปีที่ประเมิน','Submission Time','Responder Email','Level1','Level2','ผู้รับการประเมิน ALL','ข้อเสนอแนะเพื่อการปรับปรุง','รอบการประเมิน', 'Pur_Grp')
		) AS F
		PIVOT  
		(  
		MIN(RESPONSE) FOR QUESTION_NAME IN ([ปีที่ประเมิน],[Submission Time],[Responder Email],[Level1],[Level2],[ผู้รับการประเมิน ALL],[ข้อเสนอแนะเพื่อการปรับปรุง],[รอบการประเมิน], [Pur_Grp])
		) AS P
	) A 
	LEFT JOIN (
		SELECT SHAREPOINT_LIST,ITEM_ID,QUESTION_NAME,RESPONSE FROM STG_MS_FORM_ENERGY_CHEMICAL
		WHERE QUESTION_NAME NOT IN ('ปีที่ประเมิน','Submission Time','Responder Email','Level1','Level2','ผู้รับการประเมิน ALL','ข้อเสนอแนะเพื่อการปรับปรุง','รอบการประเมิน', 'Pur_Grp')
	) B
	ON A.ITEM_ID = B.ITEM_ID
	LEFT JOIN (
		SELECT DISTINCT QUESTION_NAME,QUESTION_ORDER FROM STG_MS_FORM_ENERGY_CHEMICAL
	) C
	ON B.QUESTION_NAME = C.QUESTION_NAME

	LEFT JOIN (
		SELECT DISTINCT [YEAR],FUNCTION_NAME,LEVEL1,QUESTION_CODE,QUESTION_DISPLAY FROM STG_QUESTION
	) D
	ON A.formyear = D.[YEAR] AND LEFT(C.question_name,4) = D.QUESTION_CODE AND N'ENEG_CHEM' = D.LEVEL1


	-- SELECT DISTINCT QUESTION_NAME FROM STG_MS_FORM_AGILE ORDER BY 1
) M
WHERE M.[FormYear] <= 1999 or M.[FormYear] >= 2025


GO


