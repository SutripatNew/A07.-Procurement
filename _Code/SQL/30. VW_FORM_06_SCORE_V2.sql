USE [TNTL_PUR_DEV]
GO

/****** Object:  View [dbo].[VW_FORM_06_SCORE_V2]    Script Date: 21/5/2568 16:34:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_FORM_06_SCORE_V2] AS
SELECT	[UniqueID],
		[Function_Name],
		[Function_SubType],
		[Scoring_Group],
		[FormYear],
		[RoundYear],
		[SharePoint_List],
		[Item_ID],
		[Title],
		[Pur_Grp],
		[SubmissionTime],
		[ResponderEmail],
		[Level1],
		[Level2],
		[Level3],
		[Plant],
		[Product],
		[Vendor_Name],
		[Comment1],
		[Comment2],
		[Comment3],
		[Comment4],
		[Above1MB],
		DENSE_RANK() OVER (PARTITION BY Function_Name, Function_SubType, SharePoint_List ORDER BY Question_Order ASC) AS Question_Order,
		[Group_Question],
		'Q'+RIGHT(CAST(100+ DENSE_RANK() OVER (PARTITION BY Function_Name, Function_SubType, SharePoint_List ORDER BY Question_Order ASC) AS NVARCHAR(10)),2) AS Question_Number,
		[Question_Name],
		CAST(LTRIM(RTRIM(COALESCE(Comment1,'')+' '+COALESCE(Comment2,'')+' '+COALESCE(Comment3,'')+' '+COALESCE(Comment4,''))) AS NVARCHAR(1000)) AS Comment,
		[Response],
		[Response_Value],
		[Max_Response_Value],
		CAST(Response_Value / Max_Response_Value AS DECIMAL(9,4))					AS Raw_Score,
		[Weight_Source],
		CAST(Response_Value / Max_Response_Value AS DECIMAL(9,4)) *	[Weight_Source]	AS Score,
		Weight_Source AS Weight_Total_Line,
		CASE WHEN Weight_100_NonNull IS NOT NULL THEN SUM(Weight_100_NonNull) OVER (PARTITION BY UniqueID)  ELSE NULL END AS WeightTotal
FROM VW_FORM_05_CALCULATE_WEIGHT
GO


