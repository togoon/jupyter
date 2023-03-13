//----------------------------------------------------------------
//
//      FILE        : client_CustSynToTY.cc
//
//      DATE        : Jan 05, 2022
//
//      PURPOSE     : Sync up Customer infomation to TY system
//
//      AUTHOR      :
//
//---------------------------------------------------------------
/*
SId; $
*/

#include "client/stkpublicapi.h"
#include "dbmappingapi/su_dbmapping.h"
#include "sutools/su_cstring_slist.h"
#include "xml/xml_entity_utils.h"
#include <string>
#include <fstream>
#include <errno.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <stringhelper.h>
#include <boost/locale/encoding.hpp>

using namespace std;

int LogMessage(const string &message, const string &cust, const string &prefix, const string &action);
int PrcessMessage(const string &message, sENTITY *Entity, void Data);
int HandleConnection(const string &message, string &response, sENTITY *Entity, void Data);
int HandleResponse(const string &HandleResponse, sENTITY *Entity, void *Data);
int SetCustComment(const string &message, sENTITY *Entity, void *Data);
int GetNameValue(const string &strNode, const string strName, string &strVal);
int SetNameValue(string &strNode, string &strName, string &strVal);
int setCominflNo(string &strFlwNo);
int DelNameLabel(const string &strName, string &strNode);

extern "c"{
    mDLLEXPORT sINT cSyncToTY(sENTITY *Entity, void *Data, sSTD_TRANSITION *Transition, void *params, sUINT MOde);
};


int SetCominFlwNo(string* strFlwNo)
{
    sENTITY *comEnt;
    cCOMIN *pComin, *pnewComin;
    sERRMSGLIST errMsg;

    // strFlwNo = "10000001";

    if(sInitList(&errMsg.List, "sERRMSG"))
    {
        sLogMessage("Error initializing error message list", sLOG_ERROR, 0);
        return sERROR;
    }

    if(!(comEnt = sGetEntityByName("cCOMIN")))
    {
        sLogMessage("Error getting cCOMIN", sLOG_ERROR, 0);
        reutrn sERROR;
    }

    if(sEntityCreate(comEnt, (void**)& pComin) )
    {
        sLogMessage("Error Create cCOMIN Entity", sLOG_ERROR, 0);
        reutrn sERROR;
    }

    char tmpDT[50] = {0};
    memset(&tmpDT, 0x00, sizeof(tmpDT));
    sSysDateTime(tmpDt); //2022-02-20 14:34:45.789
    string strDateTime(tmpDT);
    string strDate = strDateTime.substr(0, 10);
    string strTime = strDateTime.substr(11);
    string strDT = strDateTime.substr(0, 19);
    StringTrimAll(strDate, '-');
    StringTrimAll(strDT, '-');
    strDT.replace(8, 1, "-"); //20200822-12:56:13

    int err;
    char sql[512] = {0};
    sprintf(sql, " where ctype='CUSOMER207' and substr(clastupdatetime,0,6) >= %s order by clastupdatetime desc", strDate.c_str());

    while(!(err = sEntityDBRead(comEnt, (void*)pComin, sql, 00)))
    {
        string strMid = pComin->cMsgId, Text;
        strMid = strMid.substr(8, 7);
        int iMid = atoi(strMid.c_str());
        char scBuff[8] = {0};
        sprintf(scBuff, "%07d", iMid + 1);
        strFlwNo = scBuff;
        break;
    }

    if(err && (err != sDB_FAIL))
    {
        sLogMessage("Abnormal read termination, cancel read", sLOG_ERROR, 0);
        sEntityDBread(comEnt, (void *)pComin, "CANCEL", 00);
        sEntityFree(comEnt, (void**))&pComin,sYES);
        return sERROR;
    }

    if(sEntityClone(comEnt, (void**)&pnewComin,(void*)pComin))
    {
        sLogMessage("Error Clone cCOMIN Entity", sLOG_ERROR, 0);
        sEntityFree(comEnt, (void**))&pComin,sYES);
        return sERROR;
    }

    string strcMsgId;
    strcMsgId.append(strDate).append(strFlwNo).append("99207");
    memset(pnewComin->cMsgId.Text, 0x00, sizeof(pnewComin->cMsgId.Text));
    strcpy(pnewComin->cMsgId.Text, strcMsgId.c_str());

    memset(pnewComin->cType.Text, 0x00, sizeof(pnewComin->cType.Text));
    strcpy(pnewComin->cType.Text, "CUSTOMER207");

    pnewComin->cVersion = 0;
    pnewComin->cIoInd = 0;

    memset(pnewComin->cRecTime.Text, 0x00, sizeof(pnewComin->cRecTime.Text));
    strcpy(pnewComin->cRecTime.Text, strDT.c_str());

    memset(pnewComin->cLstUpdateTime.Text, 0x00, sizeof(pnewComin->cLstUpdateTime.Text));
    strcpy(pnewComin->cLstUpdateTime.Text, strDT.c_str());

    memset(pnewComin->cTargetSystem.Text, 0x00, sizeof(pnewComin->cTargetSystem.Text));
    strcpy(pnewComin->cTargetSystem.Text, "SUMMIT");

    // pnewComin->cStatus = cNOSTATUS;

    memset(pnewComin->cSourceSysTem.Text, 0x00, sizeof(pnewComin->cSourceSysTem.Text));
    strcpy(pnewComin->cSourceSysTem.Text, "207");

    string strcText2;
    strcText2.append("0040600").append(strDate).append("11").append(strFlwNo);
    memset(pnewComin->cText2.Text, 0xx, sizeof(pnewComin->cText2.Text));
    strcpy(pnewComin->cText2.Text, strcText2.c_str());

    if(sEntityValidate(comEnt,(void*)pnewComin, &errMsg))
    {
        sLogMessage("Invalid cCOMIN recode", sLOG_ERROR, 0);
        sEntityFree(comEnt, (void **)&pComin, sYES);
        sEntityFree(comEnt, (void **)&pnewComin, sYES);
        return sERROR;
    }

    
}
