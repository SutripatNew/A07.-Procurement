USE [TNTL_PUR_DEV]
GO

/****** Object:  View [dbo].[VW_STG_MS_FORM_RM]    Script Date: 4/6/2568 10:32:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








ALTER VIEW [dbo].[VW_STG_MS_FORM_RM] AS 

-- Vendor Evaluation Dashboard V1.

--SELECT *
--FROM
--(
--	SELECT 

--	N'RM&PKG' as Function_Name,
--	CAST('' AS NVARCHAR(100)) as Function_SubType,
--	A.SharePoint_List+'_'+RIGHT(CAST(10000+A.Item_ID AS NVARCHAR(10)),4) AS UniqueID,
--	A.*,
--	C.Question_Order,
--	D.Question_DISPLAY AS Question_Name,
--	LTRIM(RTRIM(B.Response)) AS Response,
--	TRY_CAST(B.Response as DECIMAL(25,4)) AS Response_Value
--	FROM
--	(

--		SELECT 
--		CASE 
--		WHEN [ปีประเมิน] IS NULL THEN CAST(YEAR([Submission Time]) as NVARCHAR(20))
--		ELSE REPLACE(CAST([ปีประเมิน] as NVARCHAR(20)),'Y','') END AS FormYear,
--		[รอบการประเมิน] AS RoundYear,
--		SharePoint_List,
--		Item_ID,Title,
--		DATEADD("hour",7,TRY_CAST([Submission Time] AS DATETIME2(0))) AS SubmissionTime,
--		[Responder Email] AS ResponderEmail,
--		CAST([ประเภทสินค้า] AS NVARCHAR(100)) AS Level1,
--		COALESCE(Level2,'') As Level2,
--		CAST(NULL AS NVARCHAR(100)) AS Level3,
--		Level1 AS Pur_Grp ,
--		[โรงงาน] AS Plant,
--		[ประเภทสินค้า] AS Product,
--		COALESCE([ผู้รับการประเมิน ALL],'') AS Vendor_Name,
--		[ข้อเสนอแนะ และคำแนะนำเพิ่มเติม] as Comment1,
--		CAST(NULL AS NVARCHAR(100)) as Comment2,
--		CAST(NULL AS NVARCHAR(100)) as Comment3,
--		CAST(NULL AS NVARCHAR(100)) as Comment4,
--		Above1MB
--		FROM  
--		(
--			SELECT SHAREPOINT_LIST,ITEM_ID,Title,QUESTION_NAME,RESPONSE FROM STG_MS_FORM_RM
--			WHERE QUESTION_NAME IN ('ปีประเมิน', 'ประเภทสินค้า', 'โรงงาน', 'Submission Time','Responder Email','Level1','Level2','ผู้รับการประเมิน ALL','ข้อเสนอแนะ และคำแนะนำเพิ่มเติม','Above1MB','รอบการประเมิน','BelowThreshold', 'Pur_Grp')
--		) AS F
--		PIVOT  
--		(  
--		MIN(RESPONSE) FOR QUESTION_NAME IN ([ปีประเมิน], [ประเภทสินค้า], [โรงงาน], [Submission Time],[Responder Email],[Level1],[Level2],[ผู้รับการประเมิน ALL],
--		[ข้อเสนอแนะ และคำแนะนำเพิ่มเติม],[Above1MB],[รอบการประเมิน],[BelowThreshold], [Pur_Grp])
--		) AS P

--	) A 
--	LEFT JOIN (
--		SELECT SHAREPOINT_LIST,ITEM_ID,QUESTION_NAME,RESPONSE FROM STG_MS_FORM_RM
--		WHERE QUESTION_NAME NOT IN ('ปีประเมิน',  'ประเภทสินค้า', 'โรงงาน', 'Submission Time','Responder Email','Level1','Level2','ผู้รับการประเมิน ALL','ข้อเสนอแนะ และคำแนะนำเพิ่มเติม','Above1MB','รอบการประเมิน','BelowThreshold', 'Pur_Grp')
--	) B
--	ON A.ITEM_ID = B.ITEM_ID
--	LEFT JOIN (
--		SELECT DISTINCT QUESTION_NAME,QUESTION_ORDER FROM STG_MS_FORM_RM
--	) C
--	ON B.QUESTION_NAME = C.QUESTION_NAME
--	LEFT JOIN (
--		SELECT DISTINCT [YEAR],FUNCTION_NAME,QUESTION,QUESTION_DISPLAY FROM STG_QUESTION
--	) D
--	ON A.formyear = D.[YEAR] AND C.question_name = D.QUESTION
--) M
--WHERE M.[FormYear] > 1999

--UNION ALL

-- Vendor Evaluation Dashboard V2.

SELECT *
FROM
(
	SELECT 

	N'RM&PKG' as Function_Name,
	CAST('' AS NVARCHAR(100)) as Function_SubType,
	A.SharePoint_List+'_'+RIGHT(CAST(10000+A.Item_ID AS NVARCHAR(10)),4) AS UniqueID,
	A.*,
	C.Question_Order,
	D.Question_DISPLAY AS Question_Name,
	LTRIM(RTRIM(B.Response)) AS Response,
	TRY_CAST(B.Response as DECIMAL(25,4)) AS Response_Value
	FROM
	(

		SELECT 
		CASE 
		WHEN [ปีประเมิน] IS NULL THEN CAST(YEAR([Submission Time]) as NVARCHAR(20))
		ELSE REPLACE(CAST([ปีประเมิน] as NVARCHAR(20)),'Y','') END AS FormYear,
		[รอบการประเมิน] AS RoundYear,
		SharePoint_List,
		Item_ID,Title,
		DATEADD("hour",7,TRY_CAST([Submission Time] AS DATETIME2(0))) AS SubmissionTime,
		[Responder Email] AS ResponderEmail,
		CAST([ประเภทสินค้า] AS NVARCHAR(100)) AS Level1,
		COALESCE(Level2,'') As Level2,
		CAST(NULL AS NVARCHAR(100)) AS Level3,
		Pur_Grp ,
		[โรงงาน] AS Plant,
		[ประเภทสินค้า] AS Product,
		COALESCE([ผู้รับการประเมิน ALL],'') AS Vendor_Name,
		[ข้อเสนอแนะ และคำแนะนำเพิ่มเติม] as Comment1,
		CAST(NULL AS NVARCHAR(100)) as Comment2,
		CAST(NULL AS NVARCHAR(100)) as Comment3,
		CAST(NULL AS NVARCHAR(100)) as Comment4,
		Above1MB
		FROM  
		(
			SELECT SHAREPOINT_LIST,ITEM_ID,Title,QUESTION_NAME,RESPONSE FROM STG_MS_FORM_RM
			WHERE QUESTION_NAME IN ('ปีประเมิน', 'ประเภทสินค้า', 'โรงงาน', 'Submission Time','Responder Email','Level1','Level2','ผู้รับการประเมิน ALL','ข้อเสนอแนะ และคำแนะนำเพิ่มเติม','Above1MB','รอบการประเมิน','BelowThreshold', 'Pur_Grp')
		) AS F
		PIVOT  
		(  
		MIN(RESPONSE) FOR QUESTION_NAME IN ([ปีประเมิน], [ประเภทสินค้า], [โรงงาน], [Submission Time],[Responder Email],[Level1],[Level2],[ผู้รับการประเมิน ALL],
		[ข้อเสนอแนะ และคำแนะนำเพิ่มเติม],[Above1MB],[รอบการประเมิน],[BelowThreshold], [Pur_Grp])
		) AS P

	) A 
	LEFT JOIN (
		SELECT SHAREPOINT_LIST,ITEM_ID,QUESTION_NAME,RESPONSE FROM STG_MS_FORM_RM
		WHERE QUESTION_NAME NOT IN ('ปีประเมิน',  'ประเภทสินค้า', 'โรงงาน', 'Submission Time','Responder Email','Level1','Level2','ผู้รับการประเมิน ALL','ข้อเสนอแนะ และคำแนะนำเพิ่มเติม','Above1MB','รอบการประเมิน','BelowThreshold', 'Pur_Grp')
	) B
	ON A.ITEM_ID = B.ITEM_ID
	LEFT JOIN (
		SELECT DISTINCT QUESTION_NAME,QUESTION_ORDER FROM STG_MS_FORM_RM
	) C
	ON B.QUESTION_NAME = C.QUESTION_NAME
	LEFT JOIN (
		SELECT DISTINCT [YEAR],FUNCTION_NAME,QUESTION_CODE,QUESTION_DISPLAY FROM STG_QUESTION
	) D
	ON A.formyear = D.[YEAR] AND LEFT(C.question_name,4) = D.QUESTION_CODE
) M
WHERE M.[FormYear] <= 1999 or M.[FormYear] >= 2025

GO


