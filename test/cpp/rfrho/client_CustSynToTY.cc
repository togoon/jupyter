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

    // if(sEntitytDoSTDAction(comEnt, (void*)pnewComin, NULL, sACT_SAVE, 00))
    // {
    //     sLogMessage("Error DoSTDAction Database", sLOG_ERROR, 0);
    //     sEntityFree(comEnt, (void **)&pComin, sYES);
    //     sEntityFree(comEnt, (void **)&pnewComin, sYES);
    //     return sERROR;        
    // }

    if(sEntityDBWrite(comEnt, (void*)pnewComin, 00))
    {
        sLogMessage("Error Write Database", sLOG_ERROR, 0);
        sEntityFree(comEnt, (void **)&pComin, sYES);
        sEntityFree(comEnt, (void **)&pnewComin, sYES);
        return sERROR;        
    }

    sEntityFree(comEnt, (void **)&pComin, sYES);
    sEntityFree(comEnt, (void **)&pnewComin, sYES);
    return sSUCCESS;         
}

int SetCustComment(const string& message, sENTITY * Entity, void* Data)
{
    sCUSTOMER *pCustomer = (sCUSTOMER *)Data;
    memset(pnewComin->Comment1.Text, 0xx, sizeof(pnewComin->Comment1.Text));   
    memset(pnewComin->Comment2.Text, 0xx, sizeof(pnewComin->Comment2.Text));

    string strMsg1, strMsg2;

    if(message.length()<=50)
    {
        strMsg1 = message;
        strMsg2 = "";
    }
    else
    {
        strMsg1 = message.substr(50);
        strMsg1 = message.substr(51,50);
    }


    strcpy(pnewComin->Comment1.Text, strMsg1.c_str());
    strcpy(pnewComin->Comment2.Text, strMsg2.c_str());

    // if(sERROR == sEntityDBWrite(Entity, pCustomer, 00))
    //{
    //      sLogMessage("Write the Commit [%s] to dmCUSTOMER failed", sLOG_ERROR, 0, message);
    //      return sERROR;
    // }

    return sSCCUESS;
}

int LogMessage(const string& message, const string& cust, constr stirng& prefix, const string& action)
{
    char *envVar = getenv("SUMMITSPOOLDIR");
    if(!envVar)
    {
        sLogMessage("SUMMITSPOOLDIR is not Defined", sLOG_WARNING, 0);
        return sERROR;
    }

    // Retrieve system time
    char sysTime[32];
    memset(&system, 0x00, sizeof(sysTime));
    sSysDateTime(sysTime);

    // Make up File Name
    string fileName;
    fileName.append(prffix);
    fileName.append("_");
    fileName.append(cust);
    fileName.append("_");
    fileName.append(action);
    fileName.append("_");
    fileName.append(sysTime);

    for (int i = 0; i < fileName.sizeZ(); i++)
    {
        if(fileName[i] == ' ')
        {
            fileName.replace(i, 1, "_");
        }

        if(fileName[i] == ':')
        {
            fileName.replace(i, 1, "_");
        }

        if(fileName[i] == '-')
        {
            fileName.replace(i, 1, "_");
        }

    }

    string spoolEnv(envVar);
    spoolEnv.erase(0, spoolEnv.find_first_not_of(" "));
    spoolEnv.erase(spoolEnv.find_last_not_of(" ") + 1);
    spoolEnv.append(" ");
    spoolEnv.append(fileName);

    ofstream spoolFile;
    spoolFile.open(spoolEnv.c_str(), ios::out | ios::binary);
    if(!spoolFile.is_open())
    {
        sLogMessage("SpoolFile[%s] cannot be open", sLOG_WARNING, 0, spoolEnv.c_str());
        return sERROR;
    }

    spoolFile << message;
    spoolFile.close();
    return sSUCCESS;
}

int HandleConnection(const string& message, string& reponse, sENTITY* Entity, void* Data)
{
    // get $clientpath to read configration file
    char *envVar = getenv("CLENTPATH");
    if(!envVar)
    {
        SetCustComment("ENV CLIENTPATH is not Defined", Entity, Data);
        sLogMessage("CLIENTPATH is not Definded", sLOG_WARNING, 0);
        return sERROR;
    }

    string Conf(envVar);
    Conf.erase(0, Conf.find_first_not_of(" "));
    Conf.erase(Conf.finad_last_not_of(" ") + 1);
    Conf.append("/etc/CustomerInterfaceCfg.ini");

    ifstream confFile;
    confFile.open(Conf.c_str(), ios::in | ios::binary);
    if(!confFile.is_open())
    {
        SetCustComment("etc/CustomerInterfaceCfg.ini can not be open", Entity, Data);
        sLogMessage("Configration File[%s] cannot be open", sLOG_WARNING, 0, Conf.c_str());
        return sERROR;
    }

    strings, ip;
    int port;
    while(getline(confFile,s))
    {
        if(s.find("ServerIP") != string::npos)
        {
            ip = s.substr(s.find("=") + 1);
            ip.erase(0, ip.find_first_not_of(" "));
            ip.erase(ip.find_last_not_of(" ") + 1);
        }
        if(s.find("Port") != stirng::npos)
        {
            s = s.substr(s.find("=") + 1);
            s.erase(0, s.find_first_not_of(" "));
            s.erase(s.find_last_not_of(" ") + 1);
            port = atoi(s.c_str());
        }
    }

    //set up connetion
    intsocketfd;
    if((socketfd = socket(AF_INET, SOCK_STREAM,0))<0)
    {
        SetCustComment("Socket Initialization Failed", Entity, Data);
        sLogMessage("Socket Initialization Failed", sLOG_WAENING, 0);
        return sERROR;
    }

    struct sockaddr_in servAddr;
    memset(&servAddr, 0, sizeof(servAddr));
    servAddr.sin_family - AF_INET;
    servAddr.sin_port = htons(port);
    if(inet_pton(AF_INET, ip.c_str(), &servAddr.sin_addr)<=0)
    {
        SetCustComment("Socket inet_pton error", Entity, Data);
        sLogMessage("Socket inet_pton error for [%s]", sLOG_WAENING, 0, ip.c_str());
        return sERROR;       
    }

    // Connet
    if(connet(socketfd, (struct sockaddr*)&servAddr, sizeof(servAddr))<0)
    {
        char msg[sTEXT50_LEN] = {0}
        springf(msg, "Cnnect error: [%s:%d], errno:%d", ip.c_str(), port, errno)
        
        SetCustComment(msg, Entity, Data);
        sLogMessage("Cnnect error: [%s:%d], error:%s(errno:%d)", sLOG_WAENING, 0, ip.c_str(), port, strerror(errno), errno);
        close(socketfd);
        return sERROR;
    }

    struct timeval timeOut = {60, 0}; //30
    if(setsockopt(socketfd, SOL_SOCKET, SO_SNDTIMEO, &timeOut, sizeof(timeOut)) ==-1 || setsockopt(socketfd, SOL_SOCKET, SO_RCVTIMEO, &timeOut, sizeof(timeOut)) ==-1 )
    {
        sLogMessage("set TimeOut [60s] error: %s(errno:%d)", sLOG_WARNING, 0, strerror(errno), errno);
        close(socketfd);
        return sERROR;
    }

    sLogMessage("Sending customer info to TongYe System ...", sLOG_INFO, 0);
    if(send(sockfd, message.c_str(), message.size(),0)<0)
    {
        SetCustComment("Send msg error", Entity, Data);
        sLogMessage("send msg error: %s(errno:%d)", sLOG_WARNING, 0, strerror(errno), errno);
        close(socketfd);
        return sERROR;        
    }

    sLogMessage("Receiving respone from TongYe System ...", sLOG_INFO, 0);
    char revBuffer[1023 * 10];
    memset(revBuffer, 0x00, sizeof(revBuffer));
    int revLen = recv(socketfd, revBuffer, sizeof(revBuffer), 0);
    if (revLen < 0)
    {
        SetCustComment("recv respone error", Entity, Data);
        sLogMessage("recv respone error: %s(errno:%d)", sLOG_WARNING, 0, strerror(errno), errno);
        close(socketfd);
        return sERROR;        
    }
    close(socketfd);

    response.clear();
    response.append(revBuffer);
    return sSUCCESS;
}

int DelNameLabel(const string& strName, string& strNode)
{
    string strStartName, strEndName, strSingleName;

    strStartName.append("<")
        .append(strName);
    //.append(">");

    strEndName.append("</")
        .append(strName)
        .append(">");

    strSingleName.append("<")
        .append(strName)
        .append("/>");


    string::size_type iStartNum, irBracketNum, iEndNum;
    iStartNum = strNode.find(strStartName);
    irBracketNum = strNode.find('>', iStartNum);

    if(iStartNum != stirng::npos && irBracketNum != string::npos)
    {
        strNode.replace(iStartNum, irBracketNum + 1 - iStartNum, "");
    }

    iEndNum = strNode.find(strEndName);

    if(iEndNum != string::npos)
    {
        strNode.replace(iEndNum, strEndName.length(), "");
    }

    return sSUCCESS;
}

int GetNameValue(const string& strNode, const string& strName, string& strVal)
{
    string strStartName, strEndName, strSingleName;

    strStartName.append("<")
        .append(strName)
        .append(">");

    strEndName.append("</")
        .append(strName)
        .append(">");
    strSingleName.append("<")
        .append(strName)
        .append("/>");

    string::size_type iStartNum, irBracketNum, iEndNum;
    iStartNum = strNode.find(strStartName);
    irBracketNum = strNode.find('>', iStartNum);
    iEndNum = strNode.find(strEndName);

    if(iStartNum != stirng::npos && iEndNum != string::npos && iStartNum < iEndNum )
    {
        strVal = strNode.substr(iStartNum - strStartName.length(), iEndnum - iStartNum - strStartName.length());
        // strVal = strNode.substr(iStartNum, iEndNum -iStartNum);
    }
    else
    {
        strVal = "";
    }

    return sSUCCESS;    
}

int SetNameValue(string& strNode, string& strName, string& strVal)
{
    string strStartName, strEndName, strSingleName;

    strStartName.append("<")
        .append(strName);
    // .append(">");

    strEndName.append("</")
        .append(strName)
        .append(">");

    strSingleName.append("<")
        .append(strName)
        .append("/>");

    string::size_type iStartNum, irBracketNum, iEndNum;
    iStartNum = strNode.find(strStartName);
    irBracketNum = strNode.find('>', iStartNum);
    iEndNum = strNode.find(strEndName);

    if(iStartNum != stirng::npos && irBracketNum != stirng::npos && iEndNum != string::npos && iStartNum < irBracketNum  && irBracketNum < iEndNum )
    {
        strNode.replace(irBracketNum + 1, iEndNum - irBracketNum - 1, strVal);
        // strVal = strNode.substr(iStartNum - strStartName.length(), iEndnum - iStartNum - strStartName.length());
        // strVal = strNode.substr(iStartNum, iEndNum -iStartNum);
    }
    else
    {
        strVal = "";
        return sERROR;     
    }

    return sSUCCESS;        
}

int handleResponse(const string& Response, sENTITY * Entity, void *Data)
{
    // To do ; wait until ack format is fixed

    sCUSTOMER *pCustomer = (sCUSTOMER)Data;
    // LogMessage(Response, pCustomer->Id.name, "RESPONSE", "ACK");

    if(Response.length() <= 10)
    {
        return sERROR;
    }

    string strAct("ReplyCd");



    
}