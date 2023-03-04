SELECT Name From dmTRADE_FILTER WHERE (Name='ALL') and ((dmTRADE_FILTER.Audit_Authorized = 'Y' and dmTRADE_FILTER.Audit_IsHistory = 'N'));

SELECT dmTRADE_FILTER.* FROM dmTRADE_FILTER  WHERE Name='ALL' and  Audit_Current='Y'  ORDER BY dmTRADE_FILTER.Name, dmTRADE_FILTER.Audit_Version ;

SELECT * FROM dmFILTER_TRADE_TYPES  WHERE FilterName='ALL' and Audit_Version= 1 ORDER BY dmFILTER_TRADE_TYPES.FilterName, dmFILTER_TRADE_TYPES.Audit_Version, dmFILTER_TRADE_TYPES.TradeType;

SELECT DISTINCT dmENV.TradeId, 'MM', dmENV.Audit_Version , dmENV.Audit_EntityState||':'||dmENV.Audit_Authorized||':'||dmENV.Audit_PendingAction||':'||dmENV.Audit_PendingState, ' ', dmASSET.Ccy, dmASSET.Notional, dmENV.Broker, dmENV.Cust, dmASSET.Book, dmENV.Portfolio, dmENV.StructureId, dmBACK.ExtTradeId, dmENV.TradeDate, ' ', dmBACK.AmendDate, dmENV.TradeEntryDate, dmENV.Company, dmENV.Desk, dmENV.DealId, dmENV.Trader, dmENV.Comment1||'.'||dmENV.Comment2, dmBACK.CollateralHeld, ' ', ' ', ' ', ' ', dmENV.ViewName, dmENV.Portfolio, dmENV.IBProdType FROM dmENV, dmASSET, dmBACK WHERE dmENV.TradeId = dmASSET.TradeId AND dmENV.dmOwnerTable = dmASSET.dmOwnerTable AND dmENV.Audit_Version = dmASSET.Audit_Version  AND dmENV.TradeId = dmBACK.TradeId AND dmENV.dmOwnerTable = dmBACK.dmOwnerTable AND dmENV.Audit_Version = dmBACK.Audit_Version  AND  1 = 1  AND ( dmENV.TradeStatus IN ('VER','DONE') AND( dmENV.dmOwnerTable = 'MM' and ( dmENV.Audit_Current = 'Y' ) ) )   ORDER BY 1, 3 ;  

SELECT DISTINCT dmENV.TradeId, 'FXSPOT', dmENV.Audit_Version , dmENV.Audit_EntityState||':'||dmENV.Audit_Authorized||':'||dmENV.Audit_PendingAction||':'||dmENV.Audit_PendingState, dmFOREX.BoughtCcy||'/'||dmFOREX.SoldCcy, dmFOREX.BoughtCcy||'/'||dmFOREX.SoldCcy, dmFOREX.BoughtAmt||'/'||dmFOREX.SoldAmt||'/'||dmFOREX.PorS||'/'||dmFOREX.BoughtCcy||'/'||dmFOREX.SoldCcy, dmENV.Broker, dmENV.Cust, dmFX_BOOKDATA.Book, dmENV.Portfolio, dmENV.StructureId, dmBACK.ExtTradeId, dmENV.TradeDate, ' ', dmBACK.AmendDate, dmENV.TradeEntryDate, dmENV.Company, dmFX_BOOKDATA.Desk, dmENV.DealId, dmENV.Trader, dmENV.Comment1||'.'||dmENV.Comment2, dmBACK.CollateralHeld, ' ', ' ', ' ', ' ', dmENV.ViewName, dmENV.Portfolio, dmENV.IBProdType FROM dmENV, dmFOREX, dmFX_BOOKDATA, dmBACK WHERE dmENV.TradeId = dmFOREX.TradeId AND dmENV.dmOwnerTable = dmFOREX.dmOwnerTable AND dmENV.Audit_Version = dmFOREX.Audit_Version  AND dmENV.TradeId = dmFX_BOOKDATA.TradeId AND dmENV.dmOwnerTable = dmFX_BOOKDATA.dmOwnerTable AND dmENV.Audit_Version = dmFX_BOOKDATA.Audit_Version  AND dmENV.TradeId = dmBACK.TradeId AND dmENV.dmOwnerTable = dmBACK.dmOwnerTable AND dmENV.Audit_Version = dmBACK.Audit_Version  AND  1 = 1  AND ( dmENV.TradeStatus IN ('VER','DONE') AND( dmENV.dmOwnerTable = 'FXSPOT' and ( dmENV.Audit_Current = 'Y' ) ) )   ORDER BY 1, 3, 7;

SELECT dmAPP.* FROM dmAPP  WHERE ApplicationId='TRDREAD_TUTOR' and  Audit_Current='Y'  ORDER BY dmAPP.ApplicationId, dmAPP.Audit_Version;

SELECT DISTINCT IslamicUser From dmSECURITY_ROLE WHERE (RoleId IN ('00000001', '0000000F')) and ((dmSECURITY_ROLE.Audit_Authorized = 'Y' and dmSECURITY_ROLE.Audit_IsHistory = 'N'));

select * from dmTRADE_FILTER ; 

SELECT dmTRADE_FILTER.* FROM dmTRADE_FILTER  WHERE Name='MMTEST' and  Audit_Current='Y'  ORDER BY dmTRADE_FILTER.Name, dmTRADE_FILTER.Audit_Version ;

SELECT * FROM dmFILTER_TRADE_TYPES  WHERE FilterName='MMTEST' and Audit_Version= 1 ORDER BY dmFILTER_TRADE_TYPES.FilterName, dmFILTER_TRADE_TYPES.Audit_Version, dmFILTER_TRADE_TYPES.TradeType;

select * from dmTRANS_TYPE; 

select * from dmTRADE_CORP_ACTION; 

select * from dmTRACCT; 

select * from dmTRADELINK; 

select * from dmTRDCRDDET; 

select * from dmTRDORDER; 

select * from dmTRADE_SSI; 

select * from dmTRDSTLDET; 

select * from dmTRDTEMPL; 

select * from dmTRADE_DIARY; 

select * from dmUSER; 

select * from dmBACK; 

select * from dmTRADELINK; 

select * from dmTRADELINK; 

select * from dmTRADELINK; 

select * from dmTRADELINK; 

select * from dmTRADELINK; 

select * from dmTRADELINK; 

select * from dmTRADELINK; 

select * from dmTRADELINK; 






