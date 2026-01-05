USE [TNTL_PUR]
GO

/****** Object:  View [dbo].[VW_FORM_06_SCORE]    Script Date: 18/2/2568 9:09:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[VW_FORM_06_SCORE] AS

SELECT 
F.*,

CAST( F.Raw_Score * F.Weight_100_NonNull AS DECIMAL(9,4)) AS Score,
F.Weight_100_NonNull AS Weight,
CASE WHEN F.Weight_100_NonNull IS NOT NULL THEN 
SUM(F.Weight_100_NonNull) OVER (PARTITION BY UniqueID) 
ELSE NULL END AS WeightTotal
/*
CAST( F.Raw_Score * F.Weight_100_NonNull AS DECIMAL(9,4)) AS Score_UniqueID,
F.Weight_100_NonNull AS Weight_UniqueID,
CASE WHEN F.Weight_100_NonNull IS NOT NULL THEN 
SUM(F.Weight_100_NonNull) OVER (PARTITION BY UniqueID) 
ELSE NULL END AS WeightTotal_UniqueID
*/
FROM VW_FORM_05_CALCULATE_WEIGHT F
GO


