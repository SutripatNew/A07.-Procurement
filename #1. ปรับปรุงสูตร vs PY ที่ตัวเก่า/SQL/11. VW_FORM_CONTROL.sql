USE [TNTL_PUR]
GO

/****** Object:  View [dbo].[VW_FORM_CONTROL]    Script Date: 18/2/2568 9:21:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[VW_FORM_CONTROL] AS

With Temp as (

select distinct Function_Name,Function_SubType,FormYear,Vendor_Name,RoundYear
  ,COALESCE(Function_Name,'') + '_' + COALESCE(Function_SubType,'') + '_'  + CAST(Vendor_Name AS NVARCHAR(100)) + '_'  + COALESCE(CAST(Level1 AS NVARCHAR(100)),'') + '_'  + COALESCE(CAST(Plant AS NVARCHAR(100)),'') +'_'  + CAST(FormYear AS NVARCHAR(100)) +'_'  + COALESCE(CAST(RoundYear AS NVARCHAR(100)),'') AS JoinKey

  ,  CASE when   MAX(RoundYear) 
           OVER (PARTITION BY Function_Name,Function_SubType,FormYear,Vendor_Name) = 3 then 3 else roundyear end as NewRoundYear
  from [dbo].[VW_FORM_02_UNION_VALUE_MAP]
  --where FormYear = '2022' and Function_Name = 'IT'
  --order by Vendor_Name

  ) 

  select JoinKey,Function_Name,Function_SubType,FormYear,Vendor_Name,RoundYear ,RoundYear AS NewRoundYear

  from Temp


  UNION ALL

  select JoinKey,Function_Name,Function_SubType,FormYear,Vendor_Name ,RoundYear
  , 'All' As NewRoundYear
  from Temp
  where  NewRoundYear <> 3

  UNION ALL

  select JoinKey,Function_Name,Function_SubType,FormYear,Vendor_Name ,RoundYear
  , 'All' As NewRoundYear
  from Temp
  where RoundYear = 3

  /*  UNION ALL

 select JoinKey,Function_Name,Function_SubType,FormYear,Vendor_Name 
  , '1,2' As NewRoundYear
  from Temp
  where RoundYear in ('1','2')
  and Function_Name = 'RM&PKG'*/

  --order by Vendor_Name,NewRoundYear
GO


