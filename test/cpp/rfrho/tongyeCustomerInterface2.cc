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
    
}