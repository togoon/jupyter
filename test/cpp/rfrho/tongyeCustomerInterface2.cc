// #include "tongyeCustomerInterface2.h"
#include <string>

using namespace std;

int cUpdateCust(SU_ValueList *pSrcVL, string &outXml, string &errorXml, const string &inXml);
int LogMessage(const string &message, const string &oust, const stirng &prefix, const string &action);
int GetNameValue(const string &strNode, const string &strName, string &strVal);
int SetNamevalue(string &strNode, string &strName, string &strVal);
int DelNameNode(string &strNode, const string &strName);
int DelNameLabel(const string &strName, string &strNode);

int cUpdateCust(SU_ValueList *pSrcVL, string &outXml, string &errorXml, const string &inXml)
{
    string strAct("cAction"), strActVal;
    GetNameValue(inXml, strAct, strActVal);

    stirng strCustID("Id"), strCustIDVal;
    GetNameValue(inXml, strCustID, strCustIDVal);

    LogMessage(inXml, strCustIDVal, "REQUEST-inXml", strActVal);

    char strSql[1024];
    memset(strSql, 0, sizeof(strSql));
    sprintf(strSql, "where AUDIT_CURRENT='Y' and id='%s'", strCustIDVal.c_str());

    sENTITY *custEnt = sGetEntityByName("CUSTOMER");
    if(custEnt == nullptr)
    {
        sLogMessage("Get CUSTOMER Entity failed!", sLOG_ERROR, 0);
        errorXml = "Get CUSTOMER Entity failed!";
        return sERROR;
    }

    sCUSTOMER *pCustomer = NULL;
    if(sSUCCESS != sEntiyCreate(custEnt, (void**)&pCustomer))
    {
        sLogMessage("Create customer structure failed!", sLOG_ERROR, 0);
        errorXml = "Create customer structure failed!";
        return sERROR;       
    }

    string strInXml("");

    strInXml.append(inXml);
    string::size_type iNum;
    iNum = strInXml.find("</cAction>");
    if(iNum != string::npos)
    {
        strInXml.replace(iNum+10, 0, "<ENTITYLIST><CUSTOMER>");
    }

    iNum = strInXml.find("</bizBody>");
    if(iNum != string::npos)
    {
        strInXml.replace(iNum-1, 0, "</CUSTOMER></ENTITYLIST>");
    }    

    iNum = strInXml.find("<CUSTCLAS>");
    if(iNum != string::npos)
    {
        strInXml.replace(iNum-1, 0, "<ClassifList TYPE=\"EntList\" SINGLE=\"N\">");
    }   
    iNum = strInXml.find("</CUSTCLAS>");
    if(iNum != string::npos)
    {
        strInXml.replace(iNum-1, 0, "</ClassifList>");
    }   

    iNum = strInXml.find("<CUSTROLE>");
    if(iNum != string::npos)
    {
        strInXml.replace(iNum-1, 0, "<CustRoleList TYPE=\"EntList\" SINGLE=\"N\">");
    }   
    iNum = strInXml.find("</CUSTROLE>");
    if(iNum != string::npos)
    {
        strInXml.replace(iNum-1, 0, "</CustRoleList>");
    }  

    iNum = strInXml.find("<CUSBKCD>");
    if(iNum != string::npos)
    {
        strInXml.replace(iNum-1, 0, "<BkCodeList TYPE=\"EntList\" SINGLE=\"N\">");
    }   
    iNum = strInXml.find("</CUSBKCD>");
    if(iNum != string::npos)
    {
        strInXml.replace(iNum-1, 0, "</BkCodeList>");
    }  

    iNum = strInXml.find("<CSTEXTAPP>");
    if(iNum != string::npos)
    {
        strInXml.replace(iNum-1, 0, "<ExtAppList TYPE=\"EntList\" SINGLE=\"N\">");
    }  

    iNum = strInXml.find("</CSTEXTAPP>");
    if(iNum != string::npos)
    {
        strInXml.replace(iNum-1, 0, "</ExtAppList>");
    }  

    // Get Country Map
    string SummitCountry;
    char TYCountry[8];
    memset(&TYCountry, 0x00, sizeof(TYCountry));
    SU_DBMapping *dbMapping = SU_DBMapping::GetDBMapping();
    try
    {
        dbMapping->AddMapDefinitions("ECIFCountryMap1", "ALL");
    }
    catch(...)
    {
        sLogMessage("Error read Gateway Data Mapping [ ECIFCountryMap1 ]", sLOG_ERROR, 0);
    }

    GetNameValue(strInXml, "Country", SummitCountry);
    try
    {
        dbMapping->sDataMapNN("ECIFCountryMap1", "ALL", SummitCountry.c_str(), TYCountry);
        string strSMT("Country");
        string strTYC(TYCountry);
        SetNameValue(strInXml, strSMT, strTYC);
    }
    catch(...)
    {
            sLogMessage("Error read Gateway Data Mapping [ ECIFCountryMap1 ] , Source: %s ", sLOG_ERROR, 0,SummitCountry.c_str());
    }

    strInXml.replace(0, 6, ""); //Length6

    DelNameNode(strInXml, "?"); //<? ?>
    DelNameLabel("request", strInXml);
    DelNameNode(strInXml, "sysHeader");
    DelNameNode(strInXml, "bizHeader");
    DelNameLabel("bizBody", strInXml);
    DelNameNode(strInXml, "cAction");

    sCUSTOMER *pxmlCust;
    sENTITY *xmlEnt = sXMLToEntity((char *)strInXml.c_str(), (void **)&pxmlCust, 00);

    if(xmlEnt == NULL)
    {
        errorXml = "error sXMLToEntity, CUSTID: ";
        errorXml += strCustIDVal;
        sLogMessage("%s", sLOG_ERROR, 0, errorXml.c_str());
        sEntityFree(custEnt, (void **)&pCustomer, sYes);
        return sERROR;
    }


    int err;
    bool bExist = false;

    while(!(err=sEntityDBRead(custEnt, (void*)pCustomer, strSql,00)))
    {
        bExit = true;
    }


    
}