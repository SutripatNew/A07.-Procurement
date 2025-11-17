USE [TNTL_PUR_DEV]
GO

/****** Object:  View [dbo].[VW_FACT_MS_FORM_REPORT_V2]    Script Date: 23/5/2568 11:40:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[VW_FACT_MS_FORM_REPORT_V2] AS 

SELECT
    '10_QUESTION' AS QueryPart,
	COALESCE(Function_Name,'') + '_' + COALESCE(Function_SubType,'') + '_'  + CAST(Vendor_Name AS NVARCHAR(100)) + '_'  + COALESCE(CAST(Level1 AS NVARCHAR(100)),'') + '_'  + COALESCE(CAST(Plant AS NVARCHAR(100)),'') +'_'  + CAST(FormYear AS NVARCHAR(100)) +'_'  + COALESCE(CAST(RoundYear AS NVARCHAR(100)),'') AS JoinKey,
	UniqueID,
	FormYear,
	Function_Name,
	Function_SubType,
    Scoring_Group,	
	[RoundYear],
	SharePoint_List,
	SubmissionTime,
	ResponderEmail,
	Level1,
	Level2,
	Level3,
	Vendor_Name,
	Plant,
	Product,
	Comment,
	Above1MB,
	Pur_Grp,
	Group_Question,
	Question_Number,
	Question_Number AS Question_Number_Sort,
	Question_Name,
    Response_Value AS Cell_Value,	
	Response_Value,
	Max_Response_Value,
	Weight_Source,
    Weight_Calc,
    Weight_Total_Line
FROM
	dbo.FACT_MS_FORM_GROUPING_V2
	
UNION ALL

SELECT
    '11_QUESTION_SUM' AS QueryPart,
	COALESCE(Function_Name,'') + '_' + COALESCE(Function_SubType,'') + '_'  + CAST(Vendor_Name AS NVARCHAR(100)) + '_'  + COALESCE(CAST(Level1 AS NVARCHAR(100)),'') + '_'  + COALESCE(CAST(Plant AS NVARCHAR(100)),'') +'_'  + CAST(FormYear AS NVARCHAR(100)) +'_'  + COALESCE(CAST(RoundYear AS NVARCHAR(100)),'') AS JoinKey,
	UniqueID,
	FormYear,
	Function_Name,
	Function_SubType,
    Scoring_Group,	
	[RoundYear],
	SharePoint_List,
	max(SubmissionTime) as SubmisstionTime,
	ResponderEmail,
	Level1,
	Level2,
	Level3,	
	Vendor_Name,
	Plant,
	Product,
	string_agg(CAST(Comment AS NVARCHAR(MAX)),'') as Comment,
	Above1MB,
	Pur_Grp,
	'' AS Group_Question,
	'Question Total' AS Question_Number,
	'Question Total' AS Question_Number_Sort,
	'TOTAL_QUESTION' Question_Name,
	SUM(Response_Value) AS Cell_Value,
	SUM(Response_Value) AS Response_Value,
	MAX(Max_Response_Value) AS Max_Response_Value,
	MAX(Weight_Source) AS Weight_Source,
    MAX(Weight_Calc) AS Weight_Calc,
    MAX(Weight_Total_Line) AS Weight_Total_Line    
FROM
	dbo.FACT_MS_FORM_GROUPING_V2
	-- Edit WHERE Function_Name <> 'Manufacturing'

GROUP BY
	JoinKey,
	UniqueID,
	FormYear,
	Function_Name,
	Function_SubType,
    Scoring_Group,	
	[RoundYear],
	SharePoint_List,
	--SubmissionTime,
	ResponderEmail,
	Level1,
	Level2,
	Level3,	
	Vendor_Name,
	Plant,
	Product,
	--Comment,
	Above1MB,
	Pur_Grp

UNION ALL

SELECT
    '20_SCORE' AS QueryPart,
	COALESCE(Function_Name,'') + '_' + COALESCE(Function_SubType,'') + '_'  + CAST(Vendor_Name AS NVARCHAR(100)) + '_'  + COALESCE(CAST(Level1 AS NVARCHAR(100)),'') + '_'  + COALESCE(CAST(Plant AS NVARCHAR(100)),'') +'_'  + CAST(FormYear AS NVARCHAR(100)) +'_'  + COALESCE(CAST(RoundYear AS NVARCHAR(100)),'') AS JoinKey,
	UniqueID,
	FormYear,
	Function_Name,
	Function_SubType,
    Scoring_Group,	
	[RoundYear],
	SharePoint_List,
	SubmissionTime,
	ResponderEmail,
	Level1,
	Level2,
	Level3,		
	Vendor_Name,
	Plant,
	Product,
	Comment,
	Above1MB,
	Pur_Grp,
	Group_Question,
	REPLACE(Question_Number,'Q','S') AS Question_Number,
	REPLACE(Question_Number,'Q','S') AS Question_Number_Sort,
	Question_Name,
	Score AS Cell_Value,	
	Response_Value,
	Max_Response_Value,
	Weight_Source,
    Weight_Calc,
    Weight_Total_Line 
FROM
	dbo.FACT_MS_FORM_GROUPING_V2

	--WHERE Function_Name = 'RM&PKG'
	

UNION ALL

SELECT
    '21_SCORE_WEIGHT_SUM' AS QueryPart,
	COALESCE(Function_Name,'') + '_' + COALESCE(Function_SubType,'') + '_'  + CAST(Vendor_Name AS NVARCHAR(100)) + '_'  + COALESCE(CAST(Level1 AS NVARCHAR(100)),'') + '_'  + COALESCE(CAST(Plant AS NVARCHAR(100)),'') +'_'  + CAST(FormYear AS NVARCHAR(100)) +'_'  + COALESCE(CAST(RoundYear AS NVARCHAR(100)),'') AS JoinKey,
	UniqueID,
	FormYear,
	Function_Name,
	Function_SubType,
    Scoring_Group,	
	[RoundYear],
	SharePoint_List,
	max(SubmissionTime) as SubmisstionTime,
	ResponderEmail,
	Level1,
	Level2,
	Level3,		
	Vendor_Name,
	Plant,
	Product,
	string_agg(CAST(Comment AS NVARCHAR(MAX)),'') as Comment,
	Above1MB,
	Pur_Grp,
	'' AS Group_Question,
	'Score Total' AS Question_Number,
	'Score Total' AS Question_Number_Sort,
	'TOTAL_SCORE' Question_Name,
	SUM(Score) AS Cell_Value,
	SUM(Response_Value) AS Response_Value,
	MAX(Max_Response_Value) AS Max_Response_Value,
	SUM(Weight_Source) AS Weight_Source,
    MAX(Weight_Calc) AS Weight_Calc,
    MAX(Weight_Total_Line) AS Weight_Total_Line
FROM
	dbo.FACT_MS_FORM_GROUPING_V2
    -- Edit WHERE Function_Name <> 'Manufacturing'
	--WHERE Function_Name <> 'RM&PKG' --Edit

GROUP BY 
    JoinKey,
	UniqueID,
	FormYear,
	Function_Name,
	Function_SubType,
    Scoring_Group,	
	[RoundYear],
	SharePoint_List,
	SubmissionTime,
	ResponderEmail,
	Level1,
	Level2,
	Level3,		
	Vendor_Name,
	Plant,
	Product,
	--Comment,
	Above1MB,
	Pur_Grp

UNION ALL 

SELECT
    '30_SCORE_PCT' AS QueryPart,
    COALESCE(Function_Name,'') + '_' + COALESCE(Function_SubType,'') + '_'  + CAST(Vendor_Name AS NVARCHAR(100)) + '_'  + COALESCE(CAST(Level1 AS NVARCHAR(100)),'') + '_'  + COALESCE(CAST(Plant AS NVARCHAR(100)),'') +'_'  + CAST(FormYear AS NVARCHAR(100)) +'_'  + COALESCE(CAST(RoundYear AS NVARCHAR(100)),'') AS JoinKey,
	UniqueID,
	FormYear,
	Function_Name,
	Function_SubType,
    Scoring_Group,	
	[RoundYear],
	SharePoint_List,
	max(SubmissionTime) as SubmisstionTime,
	ResponderEmail,
	Level1,
	Level2,
	Level3,		
	Vendor_Name,
	Plant,
	Product,
	string_agg(CAST(Comment AS NVARCHAR(MAX)),'') as Comment,
	Above1MB,
	Pur_Grp,
	'' AS Group_Question,
	'Total Grade' AS Question_Number,
	'Total Grade' AS Question_Number_Sort,
	'TOTAL_GRADE' Question_Name,
	SUM(Score) AS Cell_Value,
	SUM(Response_Value) AS Response_Value,
	MAX(Max_Response_Value) AS Max_Response_Value,
	SUM(Weight_Source) AS Weight_Source,
    MAX(Weight_Calc) AS Weight_Calc,
    MAX(Weight_Total_Line) AS Weight_Total_Line    
FROM
	dbo.FACT_MS_FORM_GROUPING_V2
	-- Edit WHERE Function_Name <> 'Manufacturing'


GROUP BY 
    JoinKey,
	UniqueID,
	FormYear,
	Function_Name,
	Function_SubType,
    Scoring_Group,	
	[RoundYear],
	SharePoint_List,
	--SubmissionTime,
	ResponderEmail,
	Level1,
	Level2,
	Level3,		
	Vendor_Name,
	Plant,
	Product,
	--Comment,
	Above1MB,
	Pur_Grp

UNION ALL

SELECT
    'ZZ_Comment' AS QueryPart,
	COALESCE(Function_Name,'') + '_' + COALESCE(Function_SubType,'') + '_'  + CAST(Vendor_Name AS NVARCHAR(100)) + '_'  + COALESCE(CAST(Level1 AS NVARCHAR(100)),'') + '_'  + COALESCE(CAST(Plant AS NVARCHAR(100)),'') +'_'  + CAST(FormYear AS NVARCHAR(100)) +'_'  + COALESCE(CAST(RoundYear AS NVARCHAR(100)),'') AS JoinKey,
	UniqueID,
	FormYear,
	Function_Name,
	Function_SubType,
    Scoring_Group,	
	[RoundYear],
	SharePoint_List,
	max(SubmissionTime) as SubmisstionTime,
	ResponderEmail,
	Level1,
	Level2,
	Level3,		
	Vendor_Name,
	Plant,
	Product,
	string_agg(CAST(Comment AS NVARCHAR(MAX)),'') as Comment,
	Above1MB,
	Pur_Grp,
	'' AS Group_Question,
	'Comment' AS Question_Number,
	'Z-Comment' AS Question_Number_Sort,
	'TOTAL_RAW_SCORE' Question_Name,
	SUM(Score) AS Cell_Value,
	SUM(Response_Value) AS Response_Value,
	MAX(Max_Response_Value) AS Max_Response_Value,
	MAX(Weight_Source) AS Weight_Source,
    MAX(Weight_Calc) AS Weight_Calc,
    MAX(Weight_Total_Line) AS Weight_Total_Line    
FROM
	dbo.FACT_MS_FORM_GROUPING_V2
GROUP BY 
    
	UniqueID,
	FormYear,
	Function_Name,
	Function_SubType,
    Scoring_Group,
	[RoundYear],
	SharePoint_List,
	--SubmissionTime,
	ResponderEmail,
	Level1,
	Level2,
	Level3,		
	Vendor_Name,
	Plant,
	Product,
	--Comment,
	Above1MB,
	Pur_Grp
GO


