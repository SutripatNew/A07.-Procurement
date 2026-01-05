USE [TNTL_PUR]
GO

/****** Object:  View [dbo].[VW_FORM_02_UNION_VALUE_MAP]    Script Date: 18/2/2568 9:00:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE VIEW [dbo].[VW_FORM_02_UNION_VALUE_MAP] AS 

SELECT
	UniqueID,
	LTRIM(RTRIM(COALESCE(Function_Name,''))) AS Function_Name,
	LTRIM(RTRIM(COALESCE(Function_SubType,''))) AS Function_SubType,
	CASE 
	WHEN Function_Name = 'Logistic' AND Level1 = 'รถเช่าผู้บริหาร' 
	THEN Function_Name + '-RENTAL'
	WHEN Function_Name = 'Logistic' AND Level1 <> 'รถเช่าผู้บริหาร'
	THEN Function_Name + '-OTHER'
	WHEN Function_Name = 'Commercial'
	THEN Function_Name + '-' + Level1 
	ELSE Function_Name END AS Scoring_Group,
	FormYear,
    RoundYear,
	SharePoint_List,
	Item_ID,
	Title,
	SubmissionTime,
	CASE 
	WHEN LOWER(LTRIM(RTRIM(ResponderEmail))) LIKE '%anonymous%'
	THEN LOWER(LTRIM(RTRIM(ResponderEmail))) + '_' + CAST(Item_ID AS NVARCHAR(100))
	ELSE ResponderEmail END AS ResponderEmail,
	COALESCE(G.NAME_DSP,Level1) AS Level1,
	COALESCE(Level2,'') AS Level2,
	COALESCE(Level3,'') AS Level3,
	COALESCE(Pur_Grp,'') AS Pur_Grp,
	Plant,
	Product,
	COALESCE(M.VENDOR_CN,F.Vendor_name) AS Vendor_Name,
	Comment1,
	Comment2,
	Comment3,
	Comment4,
	Above1MB,
	Question_Order,
	LTRIM(RTRIM(Question_Name)) AS Question_Name,
	--Response,
	--Response_Value,*/
	
	CASE 
		WHEN Function_Name = 'RM&PKG' AND FormYear = '2021'
		THEN 
			CASE
			WHEN Question_Name = '3.2) เครดิตการชำระเงิน'
			THEN 
				CASE 
				WHEN Response = 4 THEN 10
				WHEN Response = 3 THEN 9
				WHEN Response = 2 THEN 8
				WHEN Response = 1 THEN 7
				WHEN Response = '-' THEN NULL
				ELSE Response END 
			ELSE 
				CASE 
				WHEN Response = 4 THEN 10
				WHEN Response = 3 THEN 8
				WHEN Response = 2 THEN 6
				WHEN Response = 1 THEN 4
				WHEN Response = '-' THEN NULL
				ELSE Response END 
			END
		WHEN Response = '-' THEN NULL
		ELSE Response
	END
	Response,
	
	TRY_CAST(
	CASE 
		WHEN Function_Name = 'RM&PKG' AND FormYear = '2021'
		THEN 
			CASE
			WHEN Question_Name = '3.2) เครดิตการชำระเงิน'
			THEN 
				CASE 
				WHEN Response = 4 THEN 10
				WHEN Response = 3 THEN 9
				WHEN Response = 2 THEN 8
				WHEN Response = 1 THEN 7
				WHEN Response = '-' THEN NULL
				ELSE Response END 
			ELSE 
				CASE 
				WHEN Response = 4 THEN 10
				WHEN Response = 3 THEN 8
				WHEN Response = 2 THEN 6
				WHEN Response = 1 THEN 4
				WHEN Response = '-' THEN NULL
				ELSE Response END 
			END
		WHEN Response = '-' THEN NULL
		ELSE Response
	END
	AS DECIMAL(9,4)) AS	
	Response_Value,
	
	/*Response AS Response_Source,
	Response_Value AS Response_Value_Source*/

	CASE 
		WHEN Function_Name = 'RM&PKG' AND FormYear = '2021'
		THEN 
			CASE
			WHEN Question_Name = '3.2) เครดิตการชำระเงิน'
			THEN 
				CASE 
				WHEN Response = 4 THEN 10
				WHEN Response = 3 THEN 9
				WHEN Response = 2 THEN 8
				WHEN Response = 1 THEN 7
				WHEN Response = '-' THEN NULL
				ELSE Response END 
			ELSE 
				CASE 
				WHEN Response = 4 THEN 10
				WHEN Response = 3 THEN 8
				WHEN Response = 2 THEN 6
				WHEN Response = 1 THEN 4
				WHEN Response = '-' THEN NULL
				ELSE Response END 
			END
		WHEN Response = '-' THEN NULL
		ELSE Response
	END
	Response_Source,
	
	TRY_CAST(
	CASE 
		WHEN Function_Name = 'RM&PKG' AND FormYear = '2021'
		THEN 
			CASE
			WHEN Question_Name = '3.2) เครดิตการชำระเงิน'
			THEN 
				CASE 
				WHEN Response = 4 THEN 10
				WHEN Response = 3 THEN 9
				WHEN Response = 2 THEN 8
				WHEN Response = 1 THEN 7
				WHEN Response = '-' THEN NULL
				ELSE Response END 
			ELSE 
				CASE 
				WHEN Response = 4 THEN 10
				WHEN Response = 3 THEN 8
				WHEN Response = 2 THEN 6
				WHEN Response = 1 THEN 4
				WHEN Response = '-' THEN NULL
				ELSE Response END 
			END
		WHEN Response = '-' THEN NULL
		ELSE Response
	END
	AS DECIMAL(9,4)) AS	
	Response_Value_Source

FROM
	VW_FORM_01_UNION F

LEFT JOIN 
	(
		SELECT VENDOR_CODE, VENDOR_NAME, VENDOR_CN
		FROM DIM_VENDOR
) M
	ON LEFT(F.Vendor_Name,10) = M.VENDOR_CODE

LEFT JOIN 
	(
		SELECT [NAME], NAME_DSP
		FROM VW_STG_DIM_GROUP
) G
	ON F.Level1 = G.[NAME]

	  --where SharePoint_List = 'MS_FORM_WASTE'

GO


