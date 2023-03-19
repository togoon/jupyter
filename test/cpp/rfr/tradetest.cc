#include "precompiled.h"

#define HELP_REQUEST 1

int ParseParameters(int argc, char **argv, char *filterId, sIDATE *histDate);
void DumpHelpMessage(void);
void FreeMemory(sENTITY *Entity, sTRADELIST *Instance1, sTRADELIST *Instance2, stFILTER *Filter);
int PrintPortfolio(sTRADELIST *TradList);
int CompPortfolio(sTRADELIST *CurrTrades, sTRADELIST *HistTrades);

int main(int argc, char **argv)
{
    int err = sSUCCESS, i, j;
    stFILTER *filter;
    sENTITY *tradesEnt;
    sTRADELIST *currTradList, *histTradList;
    sIDATE histDate;
    char filterId[sMIN_STRING];

    if (err = sStandardInit(argc, argv, DumpHelpMessage, 00))
    {
        if (err != HELP_REQUEST)
            sLogMessage("sStandardInit failed", sLOG_ERROR, 0);
        exit(err);
    }

    if (ParseParameters(argc, argv, filterId, &histDate))
    {
        sLogMessage("Error parsing parameters", sLOG_ERROR, 0);
        exit(sERROR);
    }

    if (sEntityCreate(sGetEntityByName("FILTER"), (void **)&filter))
    {
        sLogMessage("Error initializing filter", sLOG_ERROR, 0);
        exit(sERROR);
    }

    strcpy(filter->Name.Name, filterId);

    if (sEntityDBRead(sGetEntityByName("FILTER"), (void *)filter,
                      "EQUAL", 00))
    {
        sLogMessage("Error loading filter", sLOG_ERROR, 0);
        exit(sERROR);
    }

    if (!(tradesEnt = sGetEntityByName("TRADELIST")))
    {
        sLogMessage("Error getting entity", sLOG_ERROR, 0);
        exit(sERROR);
    }

    if (sEntityCreate(tradesEnt, (void **)&currTradList) ||
        sEntityCreate(tradesEnt, (void **)&histTradList))
    {
        sLogMessage("Error initializing trade list", sLOG_ERROR, 0);
        exit(sERROR);
    }

    if (sReadTradeList(currTradList, filter, 02))
    {
        sLogMessage("Error loading trades", sLOG_ERROR, 0);
        FreeMemory(tradesEnt, currTradList, histTradList, filter);
        exit(sERROR);
    }

    if (sAsOfReadTrades(histTradList, NULL, histDate, histDate,
                        filter, 00))
    {
        sLogMessage("Error loading trades", sLOG_ERROR, 0);
        FreeMemory(tradesEnt, currTradList, histTradList, filter);
        exit(sERROR);
    }

    if (PrintPortfolio(currTradList))
    {
        sLogMessage("Error printing trades", sLOG_ERROR, 0);
        FreeMemory(tradesEnt, currTradList, histTradList, filter);
        exit(sERROR);
    }

    if (CompPortfolio(currTradList, histTradList))
    {
        sLogMessage("Error comparing trades", sLOG_ERROR, 0);
        FreeMemory(tradesEnt, currTradList, histTradList, filter);
        exit(sERROR);
    }

    /* Program termination */

    FreeMemory(tradesEnt, currTradList, histTradList, filter);
    sFreeGlobal();

    exit(sSUCCESS);
}

/****************************************************************************/

int ParseParameters(int argc, char **argv, char *FilterId, sIDATE *Date)
{
    int bools[5], i;
    char *flags[] = {"H", "F", "HDATE", NULL};
    char *values[5], date[sMIN_STRING];

    for (i = 0; i < 5; i++)
    {
        values[i] = NULL;
        bools[i] = sFALSE;
    }

    *date = EOS;

    values[1] = FilterId;
    values[2] = date;

    if (sGetArgs(argc, argv, flags, values, bools))
    {
        sLogMessage("Trouble in get_args", sLOG_WARNING, 0);
        return (sERROR);
    }

    if (!*FilterId)
    {
        sLogMessage("Filter is required", sLOG_ERROR, 0);
        return (sERROR);
    }

    sEditString(NULL, FilterId, sUPPER_CASE);

    if (!*date)
    {
        sLogMessage("Historic Date is required", sLOG_ERROR, 0);
        return (sERROR);
    }

    *Date = sVerifyDate(date, sMAXUS, sFULL_DATE | sGENERIC_DATE);

    if (*Date == sMAXUS)
    {
        sLogMessage("Invalid Historic Date.", sLOG_ERROR, 0);
        return (sERROR);
    }

    return (sSUCCESS);
}

/****************************************************************************/

void DumpHelpMessage()
{
    printf("\n\n\n");
    printf("+-------------------------------------------------------------------+\n");
    printf("|             PORTFOLIO VALUATIION TODAY AND ON HISTORIC DATE       |\n");
    printf("|  Flag                  Purpose                         Default    |\n");
    printf("|==================================================================+|\n");
    printf("| -H                 Display This Screen                  <OFF>     |\n");
    printf("| -F    Filter       Process Trades in Filter (required)  <NONE>    |\n");
    printf("| -HDATE             Historic Date            (required)  <NONE>    |\n");
    printf("|                                                                   |\n");
    printf("|  Typical Usage : trdval  -F <filter name>  -HDATE 2/12/94         |\n");
    printf("+-------------------------------------------------------------------+\n");
}

/****************************************************************************/

int PrintPortfolio(sTRADELIST *TradList)
{
    int i;
    sTRADE *trade;
    sENTITY *tradEntity;

    /* To print the contents of the trade portfolio, each trade entity
      is accessed in a loop.

      First, get the trade entity description from the database. It is
      retrieved by providing the entity name to the retrieval function
    */

    if (!(tradEntity = sGetEntityByName("TRADE")))
    {
        sLogMessage("Error getting trade entity", sLOG_ERROR, 0);
        return (sERROR);
    }

    for (i = 0; i < TradList->List.ItemsUsed; i++)
    {
        /* Access each trade entity in the list. It is important to use
         the sGetListItem function for this purpose, rather than access
         the entities as elements of an array, so that any client
         extensions to the trade structure are preserved
       */

        if (!(trade = (sTRADE *)sGetListItem((void *)TradList, i)))
        {
            sLogMessage("Error getting trade", sLOG_ERROR, 0);
            return (sERROR);
        }

        /* Now apply the generic function sEntityPrint to print the
         trade contents
       */

        if (sEntityPrint(tradEntity, (void *)trade, 00))
        {
            sLogMessage("Error printing portfolio", sLOG_ERROR, 0);
            return (sERROR);
        }
    }

    return (sSUCCESS);
}

/****************************************************************************/

int CompPortfolio(sTRADELIST *CurrTrades, sTRADELIST *HistTrades)
{
    int i;
    sTRADE *currTrade, *histTrade;
    sENTITY *currEntity, *histEntity;
    sNODECOMPLIST nodeComp;

    /* To compare the current and historic portfolios, the trades with
      the matching IDs have to be found, and each such pair of trades
      is compared to detect the differences that are printed out.
    */

    /* Initialize storage for comparison output */

    memset((char *)&nodeComp, 0, sizeof(sNODECOMPLIST));
    mSetList(nodeComp.List, sizeof(sNODECOMP), offsetof(sNODECOMPLIST, Data));
    sInitList(&nodeComp.List, "PRESET");

    for (i = 0; i < CurrTrades->List.ItemsUsed; i++)
    {
        nodeComp.List.ItemsUsed = 0;

        /* Access each trade entity in the trade list representing the
         current portfolio. It is important to use the sGetListItem
         function for this purpose, rather than access the entities
         as elements of an array, so that any client extensions to the
         trade structure are preserved
       */

        if (!(currTrade = (sTRADE *)sGetListItem((void *)CurrTrades, i)))
        {
            sLogMessage("Error getting trade", sLOG_ERROR, 0);
            return (sERROR);
        }

        /* Find the trade with the matching ID in the historic portfolio */

        if (!(histTrade = (sTRADE *)sLFind(currTrade, HistTrades->Data,
                                           &HistTrades->List.ItemsUsed,
                                           HistTrades->List.StructSize,
                                           (sCOMPFUNC)sCompTrade)))
        {
            sLogMessage("No trades to compare", sLOG_ERROR, 0);
            return (sSUCCESS);
        }

        /* To perform a valid trade comparison, the trade entities must
         represent the same trade type. Since the trade is defined as
         a union of the available trade types, the trade entity of the
         correct type is retrieved via sTradeGetEntity mechanism
       */

        if (!(currEntity = sTradeGetEntity(currTrade)) ||
            !(histEntity = sTradeGetEntity(histTrade)))
        {
            sLogMessage("Error getting trade entity", sLOG_ERROR, 0);
            return (sERROR);
        }

        /* If both entities are of the same type, apply the generic
         function sEntityCompare to perform the trade comparison
       */

        if (currEntity == histEntity)
        {
            if (sEntityCompare(currEntity, (void *)currTrade,
                               (void *)histTrade, &nodeComp, 00))
            {
                sLogMessage("Error comparing trades", sLOG_ERROR, 0);
                return (sERROR);
            }

            /* Print the output */

            sNodeCompListDump(&nodeComp, currEntity);
        }
    }

    sNodeCompListFree(&nodeComp);

    return (sSUCCESS);
}

/****************************************************************************/

void FreeMemory(sENTITY *Entity, sTRADELIST *Instance1, sTRADELIST *Instance2, stFILTER *Filter)
{
    if (Instance1 && Entity)
        sEntityFree(Entity, (void **)&Instance1, sYES);

    if (Instance2 && Entity)
        sEntityFree(Entity, (void **)&Instance2, sYES);

    if (Filter && Entity)
        sEntityFree(sGetEntityByName("FILTER"), (void **)&Filter, sYES);
}