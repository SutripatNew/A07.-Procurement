CREATE TABLE FACT_MS_FORM_SCORE_V2 
(
		UniqueID					nvarchar(1005),
		Function_Name				nvarchar(13),
		Function_SubType			nvarchar(100),
		Scoring_Group				nvarchar(2014),
		FormYear					nvarchar(4000),
		RoundYear					nvarchar(50),
		SharePoint_List				nvarchar(1000),
		Item_ID						int,
		Title						nvarchar(1000),			-- NEW ADD
		Pur_Grp						nvarchar(2000),
		SubmissionTime				datetime2,
		ResponderEmail				nvarchar(2101),
		Level1						nvarchar(2000),
		Level2						nvarchar(2000),
		Level3						nvarchar(2000),
		Plant						nvarchar(2000),
		Product						nvarchar(2000),
		Vendor_Name					nvarchar(2000),
		Comment1					nvarchar(2000),			-- NEW ADD
		Comment2					nvarchar(2000),			-- NEW ADD
		Comment3					nvarchar(2000),			-- NEW ADD
		Comment4					nvarchar(2000),			-- NEW ADD
		Above1MB					int,
		Question_Order				int,
		Group_Question				nvarchar(100),
		Question_Number				nvarchar(3),
		Question_Name				nvarchar(2000),
		Comment						nvarchar(1000),
		Response					nvarchar(2000),
		Response_Value				decimal(25,4),
		Max_Response_Value			decimal(25,4),
		Raw_Score					decimal(9,4),
		Weight_Source				decimal(9,4),
		Score						decimal(9,4),
		Weight_Total_Line			decimal(9,4),
		WeightTotal					decimal(38,4)			-- NEW ADD

)
