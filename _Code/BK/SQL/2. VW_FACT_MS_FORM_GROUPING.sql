USE [TNTL_PUR]
GO

/****** Object:  View [dbo].[VW_FACT_MS_FORM_GROUPING]    Script Date: 18/2/2568 9:29:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[VW_FACT_MS_FORM_GROUPING] AS 

WITH W_FACT AS (

SELECT
     --JoinKey,
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
    CAST(NULL AS INT) AS Total_Question_In_Group,
    CAST(NULL AS DECIMAL(9,4)) AS Weight_Calc 	     	
FROM
	dbo.VW_FACT_MS_FORM
WHERE Function_Name NOT IN ('RM&PKG','Procurement'/*,'Manufacturing'*/)	

UNION ALL

SELECT 
A.*,
MAX(Response_Value) OVER (PARTITION BY Function_Name,FormYear) AS Max_Response_Value,
COUNT(*) OVER (PARTITION BY UniqueID, Group_Question,formyear) AS Total_Question_In_Group,
CAST(CAST(Weight_Source AS decimal(19,4)) / COUNT(*) OVER (PARTITION BY UniqueID, Group_Question,formYear) AS DECIMAL(9,4)) AS Weight_Calc
FROM (
    SELECT
        --C.JoinKey,
		CAST(F.Vendor_Name+'_'+Plant+'_'+Level1+'_'+Level2+'_'+RoundYear AS NVARCHAR(400))  AS UniqueID,
        F.FormYear,
        F.Function_Name,
        F.Function_SubType,
        Scoring_Group, 
		F.RoundYear,
		--NewRoundYear AS RoundYear,
        SharePoint_List,
        max(SubmissionTime) as SubmisstionTime,
        CAST('' AS NVARCHAR(100)) AS ResponderEmail,
        Plant,
        Pur_Grp,
        Level1,
        Level2,
        Level3,
        F.Vendor_Name,
        Product,
        string_agg(Comment,'') as Comment,
        Above1MB,
        Group_Question,
        CASE 
        WHEN Question_Number IN ('Q14','Q15') THEN 
        Question_Number + '(' + Pur_Grp + ')' 
        ELSE Question_Number END AS Question_Number,
        CASE 
        WHEN Question_Number IN ('Q14','Q15') THEN 
        Question_Name + '(' + Pur_Grp + ')' 
        ELSE Question_Name END AS Question_Name,
        SUM(Response_Value) /  COUNT(DISTINCT UniqueID) AS Response_Value,
        Weight_Source
    FROM
        dbo.VW_FACT_MS_FORM F
	--LEFT JOIN VW_FORM_CONTROL C
	--ON F.JoinKey = C.JoinKey

    WHERE F.Function_Name IN ('RM&PKG') 
	--and F.vendor_name = '9000100025 บริษัท แพรกซ์แอร์ (ประเทศไทย)'
 --   and F.FormYear = '2022'


    GROUP BY
		--UniqueID,
		--C.JoinKey,
        F.FormYear,
        F.Function_Name,
        F.Function_SubType,
        Scoring_Group,
		--NewRoundYear,
		F.RoundYear,

        SharePoint_List,
       -- SubmissionTime,
        Pur_Grp,
        Level1,
        Level2,
        Level3,
        F.Vendor_Name,
        Plant,
        Product,
        --Comment,
        Above1MB,
        Group_Question,
        CASE 
        WHEN Question_Number IN ('Q14','Q15') THEN 
        Question_Number + '(' + Pur_Grp + ')' 
        ELSE Question_Number END,
        CASE 
        WHEN Question_Number IN ('Q14','Q15') THEN 
        Question_Name + '(' + Pur_Grp + ')' 
        ELSE Question_Name END,
        Weight,
        Weight_Source
)A

UNION ALL

    SELECT 
    A.*,
    MAX(Response_Value) OVER (PARTITION BY Function_Name,FormYear) AS Max_Response_Value,
    COUNT(*) OVER (PARTITION BY UniqueID, Group_Question) AS Total_Question_In_Group,
    CAST(Weight_Source AS DECIMAL(9,4)) AS Weight_Calc
    FROM (
        SELECT
		   -- JoinKey,
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
            SUM(Response_Value) /  COUNT(DISTINCT UniqueID) AS Response_Value,
            Weight_Source
        FROM
            dbo.VW_FACT_MS_FORM
        WHERE Function_Name IN ('Procurement')
        GROUP BY
		  --  JoinKey,
            FormYear,
            Function_Name,
            Function_SubType,
            Scoring_Group, 
			RoundYear,
            SharePoint_List,
            SubmissionTime,
            ResponderEmail,            
            Pur_Grp,
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
            Question_Name,
            Weight,
            Weight_Source,
            UniqueID
              
    ) A

/* Edit
UNION ALL

    SELECT 
    A.*,
    MAX(Response_Value) OVER (PARTITION BY Function_Name,FormYear) AS Max_Response_Value,
    COUNT(*) OVER (PARTITION BY UniqueID, Group_Question) AS Total_Question_In_Group,
    CAST(Weight_Source AS DECIMAL(9,4)) AS Weight_Calc
    FROM (
        SELECT
            --CAST(Vendor_Name+'_'+Level1+'_'+Level2 AS NVARCHAR(400)) AS UniqueID,
            UniqueID,
            FormYear,
            Function_Name,
            Function_SubType,
            Scoring_Group, 
			RoundYear,
            SharePoint_List,
            max(SubmissionTime) as submission_time,
            string_agg(ResponderEmail, ',') as ResponderEmail,
            Plant,
            Pur_Grp,
            Level1,
            Level2,
            Level3,
            Vendor_Name,
            Product,
            string_agg(Comment,',') as Comment,
            Above1MB,
            Group_Question,
            Question_Number,
            Question_Name,
            SUM(Response_Value) /  COUNT(DISTINCT UniqueID) AS Response_Value,
            Weight_Source
        FROM
            dbo.VW_FACT_MS_FORM
        WHERE Function_Name IN ('Manufacturing')
        GROUP BY
            --UniqueID,        
            FormYear,
            Function_Name,
            Function_SubType,
            Scoring_Group,   
			RoundYear,
            SharePoint_List,
            Pur_Grp,
            Level1,
            Level2,
            Level3,
            Vendor_Name,
            Plant,
            Product,
            Above1MB,
            Group_Question,
            Question_Number,
            Question_Name,
            Weight,
            Weight_Source,
            --CAST(Vendor_Name+'_'+Level1+'_'+Level2 AS NVARCHAR(400))
            UniqueID
              
    ) A


Edit */ 



),

W_FACT2 AS (

SELECT 
F.*,
CAST(CAST(Response_Value AS DECIMAL(9,4)) / Max_Response_Value AS DECIMAL(9,4)) AS Raw_Score, 
CASE 
WHEN Function_Name IN ('RM&PKG','Procurement') THEN 
CAST(Weight_Source / ROUND(SUM(Weight_Calc) OVER (PARTITION BY UniqueID,formYear,roundyear),0) * 100 AS DECIMAL(9,4)) 
ELSE Weight_Source END AS Weight_Proportion
FROM W_FACT F

),  

W_FACT3  AS ( 
SELECT 
--JoinKey,
UniqueID, 
F.FormYear,
F.Function_Name,
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
F.Group_Question,
Question_Number,
Question_Name,
Response_Value,
Max_Response_Value,
Raw_Score,
CASE WHEN F.Function_Name IN ('RM&PKG','Procurement') THEN Weight_Calc ELSE Weight_Source END AS Weight_Calc,
Total_Question_In_Group,
Weight_Source,
CASE
WHEN Weight_Total_Line IS NOT NULL THEN Weight_Total_Line
ELSE Weight_Source END AS Weight_Total_Line,
Weight_Proportion
FROM W_FACT2  F
LEFT JOIN (
    SELECT FormYear,Function_Name,Group_Question,Weight_Source / COUNT(DISTINCT Question_Number)  AS Weight_Total_Line
			--,UniqueID /*Edit*/
    FROM W_FACT2
    WHERE Function_Name IN ('RM&PKG')
    GROUP BY Function_Name,Group_Question,Weight_Source,FormYear--,UniqueID /*Edit*/
) G
ON F.Function_Name = G.Function_Name
AND F.Group_Question = G.Group_Question
AND F.FormYear = G.FormYear
--AND F.UniqueID = G.UniqueID /*Edit*/
)


SELECT 
F.*, 
CAST( Raw_Score * Weight_Calc * ( Weight_Proportion / Weight_Source ) AS DECIMAL(9,4)) AS Score,
'(' + CAST( FORMAT(Response_Value, '#') AS NVARCHAR(10)) +  '/' + CAST( FORMAT(Max_Response_Value, '#') AS NVARCHAR(10)) + ' ได้  ' + FORMAT(Raw_Score,'0.00') + ' คะแนน )'  + 

CASE 
WHEN Function_Name <> ('RM&PKG') 
THEN
' * ( น้ำหนัก ' + FORMAT(Weight_Calc, '#.00') + ' )'
ELSE
' * ( น้ำหนัก ' + FORMAT(Weight_Calc, '#.00') + ' คำนวณมาจาก ' + FORMAT(Weight_Source, '#') + '/' + FORMAT(Total_Question_In_Group, '#') + ' ) '
END
 
 + ' = ' + FORMAT( Raw_Score * CASE WHEN Function_Name IN ('RM&PKG','Procurement') THEN Weight_Calc ELSE Weight_Source END, '0.0000') +
 
CASE 
WHEN Function_Name IN ('RM&PKG','Procurement') AND Weight_Source <> Weight_Proportion THEN
 ' * ตอบไม่ครบ มีการ Adjust ( ' + FORMAT(  Weight_Proportion , '0.00' ) + '/' +    FORMAT( Weight_Source , '0.00') + ' ) ' + ' = ' +  FORMAT( Raw_Score * Weight_Calc * (Weight_Proportion / Weight_Source) , '0.00' ) 
ELSE '' END 

AS TEXT_CHECK
FROM
W_FACT3 F

  --WHERE F.Function_Name = 'RM&PKG'   and F.vendor_name = '9000100025 บริษัท แพรกซ์แอร์ (ประเทศไทย)'
  --and F.FormYear = '2022'
GO


