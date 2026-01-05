USE [TNTL_PUR]
GO

/****** Object:  View [dbo].[VW_FACT_MS_FORM_REPORT]    Script Date: 18/2/2568 9:35:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE VIEW [dbo].[VW_FACT_MS_FORM_REPORT] AS  


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
	dbo.FACT_MS_FORM_GROUPING
	
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
	dbo.FACT_MS_FORM_GROUPING
	-- Edit WHERE Function_Name <> 'Manufacturing'

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
	Above1MB

/* Edit

UNION ALL 


SELECT QueryPart, UniqueID, 	FormYear, 	Function_Name,	Function_SubType,    Scoring_Group,	[RoundYear],	SharePoint_List, 
max(SubmissionTime) as SubmissionTime, max(responderemail) as ResponderEmail,
Level1,Level2,	Level3,Vendor_Name,Plant,Product,	string_agg(Comment,'') as Comment, Above1MB,
'' AS Group_Question, 
'Question Total' AS Question_Number,
'Question Total' AS Question_Number_Sort,
'TOTAL_QUESTION' AS Question_Name,
SUM(Cell_Value) AS Cell_Value,
SUM(Response_Value) AS Response_Value,
MAX(Max_Response_Value) AS Max_Response_Value,
MAX(Weight_Source) AS Weight_Source,
MAX(Weight_Calc) AS Weight_Calc,
MAX(Weight_Total_Line) AS Weight_Total_Line   
 FROM
(
SELECT
    '11_QUESTION_SUM' AS QueryPart,
	Vendor_Name + Level1 + Level2 AS UniqueID,
	FormYear,
	Function_Name,
	Function_SubType,
    Scoring_Group,	
	[RoundYear],
	SharePoint_List,
	max(SubmissionTime) as SubmissionTime,
	ResponderEmail,
	Level1,
	Level2,
	Level3,	
	Vendor_Name,
	Plant,
	Product,
	string_agg(Comment,'') as Comment,
	Above1MB,
	'' AS Group_Question,
	Question_Number AS Question_Number,
	'Question Total' AS Question_Number_Sort,
	'TOTAL_QUESTION' Question_Name,
	SUM(Response_Value) / COUNT(DISTINCT UniqueID) AS Cell_Value,
	SUM(Response_Value) AS Response_Value,
	MAX(Max_Response_Value) AS Max_Response_Value,
	MAX(Weight_Source) AS Weight_Source,
    MAX(Weight_Calc) AS Weight_Calc,
    MAX(Weight_Total_Line) AS Weight_Total_Line    
FROM
	dbo.FACT_MS_FORM_GROUPING
	WHERE Function_Name = 'Manufacturing'
GROUP BY 
	--UniqueID,
    Vendor_Name + Level1 + Level2,	
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
	Question_Number,
	--Comment,
	Above1MB
) A
GROUP BY 
 QueryPart, UniqueID, 	FormYear, 	Function_Name,	Function_SubType,    Scoring_Group,	[RoundYear],SharePoint_List, 
Level1,Level2,	Level3,Vendor_Name,Plant,Product,Above1MB
*/

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
	dbo.FACT_MS_FORM_GROUPING

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
	'' AS Group_Question,
	'Score Total' AS Question_Number,
	'Score Total' AS Question_Number_Sort,
	'TOTAL_SCORE' Question_Name,
	SUM(Score) AS Cell_Value,
	SUM(Response_Value) AS Response_Value,
	MAX(Max_Response_Value) AS Max_Response_Value,
	MAX(Weight_Source) AS Weight_Source,
    MAX(Weight_Calc) AS Weight_Calc,
    MAX(Weight_Total_Line) AS Weight_Total_Line
FROM
	dbo.FACT_MS_FORM_GROUPING
    -- Edit WHERE Function_Name <> 'Manufacturing'
	--WHERE Function_Name <> 'RM&PKG' --Edit

GROUP BY 
    
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
	Above1MB



/* Edit
UNION ALL

SELECT QueryPart, UniqueID, 	FormYear, 	Function_Name,	Function_SubType,    Scoring_Group,	[RoundYear],	SharePoint_List, 
max(SubmissionTime) as SubmissionTime, max(responderemail) as ResponderEmail,
Level1,Level2,	Level3,Vendor_Name,Plant,Product,	string_agg(Comment,'') as Comment, Above1MB,
'' AS Group_Question, 
'Score Total' AS Question_Number,
'Score Total' AS Question_Number_Sort,
'TOTAL_SCORE' Question_Name,
SUM(Cell_Value) AS Cell_Value,
SUM(Response_Value) AS Response_Value,
MAX(Max_Response_Value) AS Max_Response_Value,
MAX(Weight_Source) AS Weight_Source,
MAX(Weight_Calc) AS Weight_Calc,
MAX(Weight_Total_Line) AS Weight_Total_Line   
 FROM
(
SELECT
    '21_SCORE_WEIGHT_SUM' AS QueryPart,
	Vendor_Name + Level1 + Level2 AS UniqueID,
	FormYear,
	Function_Name,
	Function_SubType,
    Scoring_Group,
	[RoundYear],
	SharePoint_List,
	max(SubmissionTime) as SubmissionTime,
	string_agg(ResponderEmail,'') as ResponderEmail,
	Level1,
	Level2,
	Level3,	
	Vendor_Name,
	Plant,
	Product,
	string_agg(Comment,'') as Comment,
	Above1MB,
	'' AS Group_Question,
	Question_Number AS Question_Number,
	'Question Total' AS Question_Number_Sort,
	'TOTAL_QUESTION' AS Question_Name,
	SUM(Score) / COUNT(DISTINCT UniqueID) AS Cell_Value,
	SUM(Response_Value) AS Response_Value,
	MAX(Max_Response_Value) AS Max_Response_Value,
	MAX(Weight_Source) AS Weight_Source,
    MAX(Weight_Calc) AS Weight_Calc,
    MAX(Weight_Total_Line) AS Weight_Total_Line    
FROM
	dbo.FACT_MS_FORM_GROUPING
	WHERE Function_Name = 'Manufacturing'
GROUP BY 
	--UniqueID,
    Vendor_Name + Level1 + Level2,	
	FormYear,
	Function_Name,
	Function_SubType,
    Scoring_Group,	
	[RoundYear],
	SharePoint_List,
	--SubmissionTime,
	--ResponderEmail,
	Level1,
	Level2,
	Level3,	
	Vendor_Name,
	Plant,
	Product,
	Question_Number,
	--Comment,
	Above1MB
) A
GROUP BY 
 QueryPart, UniqueID, 	FormYear, 	Function_Name,	Function_SubType,    Scoring_Group,	[RoundYear],SharePoint_List, 
Level1,Level2,	Level3,Vendor_Name,Plant,Product,Above1MB
 
 */

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
	'' AS Group_Question,
	'Total Grade' AS Question_Number,
	'Total Grade' AS Question_Number_Sort,
	'TOTAL_GRADE' Question_Name,
	SUM(Score) AS Cell_Value,
	SUM(Response_Value) AS Response_Value,
	MAX(Max_Response_Value) AS Max_Response_Value,
	MAX(Weight_Source) AS Weight_Source,
    MAX(Weight_Calc) AS Weight_Calc,
    MAX(Weight_Total_Line) AS Weight_Total_Line    
FROM
	dbo.FACT_MS_FORM_GROUPING
	-- Edit WHERE Function_Name <> 'Manufacturing'


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
	Above1MB

	/* Edit

UNION ALL

SELECT QueryPart, UniqueID, 	FormYear, 	Function_Name,	Function_SubType,    Scoring_Group,	[RoundYear],SharePoint_List, 
max(SubmissionTime) as SubmissionTime, max(responderemail) as ResponderEmail,
Level1,Level2,	Level3,Vendor_Name,Plant,Product,	string_agg(Comment,'') as Comment, Above1MB,
'' AS Group_Question, 
'Total Grade' AS Question_Number,
'Total Grade' AS Question_Number_Sort,
'Total Grade' Question_Name,
SUM(Cell_Value) AS Cell_Value,
SUM(Response_Value) AS Response_Value,
MAX(Max_Response_Value) AS Max_Response_Value,
MAX(Weight_Source) AS Weight_Source,
MAX(Weight_Calc) AS Weight_Calc,
MAX(Weight_Total_Line) AS Weight_Total_Line   
 FROM
(
SELECT
    '31_SCORE_PCT_SUM' AS QueryPart,
	Vendor_Name + Level1 + Level2 AS UniqueID,
	FormYear,
	Function_Name,
	Function_SubType,
    Scoring_Group,	
	[RoundYear],
	SharePoint_List,
	max(SubmissionTime) as SubmissionTime,
	ResponderEmail,
	Level1,
	Level2,
	Level3,	
	Vendor_Name,
	Plant,
	Product,
	string_agg(Comment,'') as Comment,
	Above1MB,
	'' AS Group_Question,
	'Total Grade' AS Question_Number,
	'Total Grade' AS Question_Number_Sort,
	'TOTAL_GRADE' AS Question_Name,
	SUM(Score) / COUNT(DISTINCT UniqueID) AS Cell_Value,
	SUM(Response_Value) AS Response_Value,
	MAX(Max_Response_Value) AS Max_Response_Value,
	MAX(Weight_Source) AS Weight_Source,
    MAX(Weight_Calc) AS Weight_Calc,
    MAX(Weight_Total_Line) AS Weight_Total_Line    
FROM
	dbo.FACT_MS_FORM_GROUPING
	WHERE Function_Name = 'Manufacturing'
GROUP BY 
	--UniqueID,
    Vendor_Name + Level1 + Level2,	
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
	Question_Number,
	--Comment,
	Above1MB
) A
GROUP BY 
 QueryPart, UniqueID, 	FormYear, 	Function_Name,	Function_SubType,    Scoring_Group,		[RoundYear],SharePoint_List, 
Level1,Level2,	Level3,Vendor_Name,Plant,Product,Above1MB
 */

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
	dbo.FACT_MS_FORM_GROUPING
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
	Above1MB
GO


