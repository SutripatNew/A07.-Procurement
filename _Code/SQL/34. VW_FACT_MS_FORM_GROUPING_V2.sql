USE [TNTL_PUR_DEV]
GO

/****** Object:  View [dbo].[VW_FACT_MS_FORM_GROUPING_V2]    Script Date: 21/4/2568 13:18:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[VW_FACT_MS_FORM_GROUPING_V2] AS
SELECT
    JoinKey,
	UniqueID,
	FormYear,
	Function_Name,
	Function_SubType,
    Scoring_Group,
	RoundYear,
	SharePoint_List,
	SubmissionTime,
	ResponderEmail,
	Plant,
    Pur_Grp,	
	Level1,
	Level2,
	Level3,
	Vendor_Name,
	Product,
	Comment,
	Above1MB,
	Group_Question,
	Question_Number,
	Question_Name,
	Response_Value,
	Weight_Source,
    MAX(Response_Value) OVER (PARTITION BY Function_Name,FormYear) AS Max_Response_Value,
	CAST(Response_Value / MAX(Response_Value) OVER (PARTITION BY Function_Name,FormYear) AS decimal(20,4)) AS Raw_Score,
	Score,
    COUNT(*) OVER (PARTITION BY UniqueID, Group_Question,formyear) AS Total_Question_In_Group,
    Weight_Calc,
	Weight_Source AS Weight_Total_Line
FROM
	dbo.VW_FACT_MS_FORM_V2
GO


