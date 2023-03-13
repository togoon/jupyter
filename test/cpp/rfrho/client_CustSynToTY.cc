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
        
    }
}
