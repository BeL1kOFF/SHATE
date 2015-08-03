USE [CLIENT_DATA]
GO

/****** Object:  StoredProcedure [dbo].[get_all_stock_qnt]    Script Date: 06.10.2014 12:45:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================


CREATE PROCEDURE [dbo].[get_all_stock_qnt]
	-- Add the parameters for the stored procedure here
	@sklad_retail_Price varchar(15) = 'SHOP-P03'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
  select distinct p.CODE_BRAND, p.PRICE, p.SALE,  

									t16.QUANT as QUANT16, L16.VALUE, 
                                    t5.QUANT as QUANT5,  L5.VALUE,  
                                    t6.QUANT as QUANT6,  L6.VALUE, 
                                    t11.QUANT as QUANT11, L11.VALUE, 
                                    t12.QUANT as QUANT12, L12.VALUE, 
                                    t1.QUANT as QUANT1,  L1.VALUE,  
                                    t8.QUANT as QUANT8,  L8.VALUE, 
                                    t2.QUANT as QUANT2, L2.VALUE,   
                                    t14.QUANT as QUANT14, L14.VALUE, 
                                    t9.QUANT as QUANT9, L9.VALUE,   
                                    t17.QUANT as QUANT17,  L17.VALUE,
                                    t4.QUANT as QUANT4,  L4.VALUE,  
                                    t7.QUANT as QUANT7, L7.VALUE,   
                                    t13.QUANT as QUANT13,  L13.VALUE,
                                    t10.QUANT as QUANT10, L10.VALUE, 
                                    t3.QUANT as QUANT3,L3.VALUE,    
                                    t18.QUANT as QUANT18, L18.VALUE, 
                                    t19.QUANT as QUANT19, L19.VALUE, 
                                    t20.QUANT as QUANT20, L20.VALUE  
								
  FROM [dbo].[prices] p                     
  
		LEFT JOIN (select NO, SKLAD, VALUE FROM [dbo].[limits] WHERE [SKLAD] = 'MARK-M01') as l1 ON (p.NO = l1.NO) 
		LEFT JOIN (select NO, SKLAD, QUANT FROM [dbo].[quants_market] WHERE [SKLAD] = 'MARK-M01') as t1 ON (P.NO = T1.NO) 
		
		LEFT JOIN (select NO, SKLAD, VALUE FROM [dbo].[limits] WHERE [SKLAD] = 'MARK-M02') as l2 ON (p.NO = l2.NO) 
		LEFT JOIN (select NO, SKLAD, QUANT FROM [dbo].[quants_market] WHERE [SKLAD] = 'MARK-M02') as t2 ON (P.NO = T2.NO)   

		LEFT JOIN (select NO, SKLAD, VALUE FROM [dbo].[limits] WHERE [SKLAD] = 'MARK-M03') as l3 ON (p.NO = l3.NO) 
		LEFT JOIN (select NO, SKLAD, QUANT FROM [dbo].[quants_market] WHERE [SKLAD] = 'MARK-M03') as t3 ON (P.NO = T3.NO) 

		LEFT JOIN (select NO, SKLAD, VALUE FROM [dbo].[limits] WHERE [SKLAD] = 'MARK-M04') as l4 ON (p.NO = l4.NO) 
		LEFT JOIN (select NO, SKLAD, QUANT FROM [dbo].[quants_market] WHERE [SKLAD] = 'MARK-M04') as t4 ON (P.NO = T4.NO) 

		LEFT JOIN (select NO, SKLAD, VALUE FROM [dbo].[limits] WHERE [SKLAD] = 'MARK-M05') as l5 ON (p.NO = l5.NO) 
		LEFT JOIN (select NO, SKLAD, QUANT FROM [dbo].[quants_market] WHERE [SKLAD] = 'MARK-M05') as t5 ON (P.NO = T5.NO) 

		LEFT JOIN (select NO, SKLAD, VALUE FROM [dbo].[limits] WHERE [SKLAD] = 'MARK-M06') as l6 ON (p.NO = l6.NO) 
		LEFT JOIN (select NO, SKLAD, QUANT FROM [dbo].[quants_market] WHERE [SKLAD] = 'MARK-M06') as t6 ON (P.NO = T6.NO) 

		LEFT JOIN (select NO, SKLAD, VALUE FROM [dbo].[limits] WHERE [SKLAD] = 'MARK-M07') as l7 ON (p.NO = l7.NO) 
		LEFT JOIN (select NO, SKLAD, QUANT FROM [dbo].[quants_market] WHERE [SKLAD] = 'MARK-M07') as t7 ON (P.NO = T7.NO) 

		LEFT JOIN (select NO, SKLAD, VALUE FROM [dbo].[limits] WHERE [SKLAD] = 'MARK-M08') as l8 ON (p.NO = l8.NO) 
		LEFT JOIN (select NO, SKLAD, QUANT FROM [dbo].[quants_market] WHERE [SKLAD] = 'MARK-M08') as t8 ON (P.NO = T8.NO) 

		LEFT JOIN (select NO, SKLAD, VALUE FROM [dbo].[limits] WHERE [SKLAD] = 'MARK-M09') as l9 ON (p.NO = l9.NO) 
		LEFT JOIN (select NO, SKLAD, QUANT FROM [dbo].[quants_market] WHERE [SKLAD] = 'MARK-M09') as t9 ON (P.NO = T9.NO) 

		LEFT JOIN (select NO, SKLAD, VALUE FROM [dbo].[limits] WHERE [SKLAD] = 'MARK-M10') as l10 ON (p.NO = l10.NO) 
		LEFT JOIN (select NO, SKLAD, QUANT FROM [dbo].[quants_market] WHERE [SKLAD] = 'MARK-M10') as t10 ON (P.NO = T10.NO) 

		LEFT JOIN (select NO, SKLAD, VALUE FROM [dbo].[limits] WHERE [SKLAD] = 'MARK-M11') as l11 ON (p.NO = l11.NO) 
		LEFT JOIN (select NO, SKLAD, QUANT FROM [dbo].[quants_market] WHERE [SKLAD] = 'MARK-M11') as t11 ON (P.NO = T11.NO) 

		LEFT JOIN (select NO, SKLAD, VALUE FROM [dbo].[limits] WHERE [SKLAD] = 'MARK-M12') as l12 ON (p.NO = l12.NO) 
		LEFT JOIN (select NO, SKLAD, QUANT FROM [dbo].[quants_market] WHERE [SKLAD] = 'MARK-M12') as t12 ON (P.NO = T12.NO) 

		LEFT JOIN (select NO, SKLAD, VALUE FROM [dbo].[limits] WHERE [SKLAD] = 'MARK-M13') as l13 ON (p.NO = l13.NO) 
		LEFT JOIN (select NO, SKLAD, QUANT FROM [dbo].[quants_market] WHERE [SKLAD] = 'MARK-M13') as t13 ON (P.NO = T13.NO) 

		LEFT JOIN (select NO, SKLAD, VALUE FROM [dbo].[limits] WHERE [SKLAD] = 'MARK-M14') as l14 ON (p.NO = l14.NO) 
		LEFT JOIN (select NO, SKLAD, QUANT FROM [dbo].[quants_market] WHERE [SKLAD] = 'MARK-M14') as t14 ON (P.NO = T14.NO) 

		LEFT JOIN (select NO, SKLAD, VALUE FROM [dbo].[limits] WHERE [SKLAD] = 'STO-S01') as l16 ON (p.NO = l16.NO) 
		LEFT JOIN (select NO, SKLAD, QUANT FROM [dbo].[quants_market] WHERE [SKLAD] = 'STO-S01') as t16 ON (P.NO = T16.NO) 

		LEFT JOIN (select NO, SKLAD, VALUE FROM [dbo].[limits] WHERE [SKLAD] = 'MARK-M17') as l17 ON (p.NO = l17.NO) 
		LEFT JOIN (select NO, SKLAD, QUANT FROM [dbo].[quants_market] WHERE [SKLAD] = 'MARK-M17') as t17 ON (P.NO = T17.NO) 

		LEFT JOIN (select NO, SKLAD, VALUE FROM [dbo].[limits] WHERE [SKLAD] = 'SHOP-P01') as l18 ON (p.NO = l18.NO) 
		LEFT JOIN (select NO, SKLAD, QUANT FROM [dbo].[quants_market] WHERE [SKLAD] = 'SHOP-P01') as t18 ON (P.NO = T18.NO) 

		LEFT JOIN (select NO, SKLAD, VALUE FROM [dbo].[limits] WHERE [SKLAD] = 'SHOP-P02') as l19 ON (p.NO = l19.NO) 
		LEFT JOIN (select NO, SKLAD, QUANT FROM [dbo].[quants_market] WHERE [SKLAD] = 'SHOP-P02') as t19 ON (P.NO = T19.NO) 

		LEFT JOIN (select NO, SKLAD, VALUE FROM [dbo].[limits] WHERE [SKLAD] = 'SHOP-P03') as l20 ON (p.NO = l20.NO) 
		LEFT JOIN (select NO, SKLAD, QUANT FROM [dbo].[quants_market] WHERE [SKLAD] = 'SHOP-P03') as t20 ON (P.NO = T20.NO) 

   where p.SKLAD = @sklad_retail_Price;	
END

GO
