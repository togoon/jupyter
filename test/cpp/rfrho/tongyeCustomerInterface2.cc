// #include "tongyeCustomerInterface2.h"
#include <string>

using namespace std;

int cUpdateCust(SU_ValueList *pSrcVL, string &outXml, string &errorXml, const string &inXml);
int LogMessage(const string &message, const string &oust, const string &prefix, const string &action);
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

        // update pCustomer, pxmlCust;

        // memset(pCustomer->Id.Name, 0x00, sizeof(pCustomer->Id.Name));
        // strcpy(pCustomer->Id.Name, pxmlCust->Id.Name);

        pCustomer->ConfirmReq = sYES;
        pCustomer->PaymentReq = sYES;

        memset(pCustomer->Parent.Name, 0x00, sizeof(pCustomer->Parent.Name));
        strcpy(pCustomer->Parent.Name, pxmlCust->Parent.Name);

        memset(pCustomer->ShortName.Text, 0x00, sizeof(pCustomer->ShortName.Text));
        strcpy(pCustomer->ShortName.Text, pxmlCust->ShortName.Text);

        memset(pCustomer->Address.FullName.Name, 0x00, sizeof(pCustomer->Address.FullName.Name));
        strcpy(pCustomer->Address.FullName.Name, pxmlCust->Address.FullName.Name);

        pCustomer->Audit.EntityState = pxmlCust->Audit.EntityState;

        memset(pCustomer->LegalName.Name, 0x00, sizeof(pCustomer->LegalName.Name));
        strcpy(pCustomer->LegalName.Name, pxmlCust->LegalName.Name);

        memset(pCustomer->ContactName.Name, 0x00, sizeof(pCustomer->ContactName.Name));
        strcpy(pCustomer->ContactName.Name, pxmlCust->ContactName.Name);

        memset(pCustomer->Address.Country.Name, 0x00, sizeof(pCustomer->Address.Country.Name));
        strcpy(pCustomer->Address.Country.Name, pxmlCust->Address.Country.Name);

        memset(pCustomer->City.Name, 0x00, sizeof(pCustomer->City.Name));
        strcpy(pCustomer->City.Name, pxmlCust->City.Name);

        memset(pCustomer->Address.AddressLine1.Name, 0x00, sizeof(pCustomer->Address.AddressLine1.Name));
        strcpy(pCustomer->Address.AddressLine1.Name, pxmlCust->Address.AddressLine1.Name);

        memset(pCustomer->Address.AddressLine2.Name, 0x00, sizeof(pCustomer->Address.AddressLine2.Name));
        strcpy(pCustomer->Address.AddressLine2.Name, pxmlCust->Address.AddressLine2.Name);

        memset(pCustomer->Address.AddressLine3.Name, 0x00, sizeof(pCustomer->Address.AddressLine3.Name));
        strcpy(pCustomer->Address.AddressLine3.Name, pxmlCust->Address.AddressLine3.Name);

        memset(pCustomer->Address.AddressLine4.Name, 0x00, sizeof(pCustomer->Address.AddressLine4.Name));
        strcpy(pCustomer->Address.AddressLine4.Name, pxmlCust->Address.AddressLine4.Name);

        memset(pCustomer->Address.AddressLine5.Name, 0x00, sizeof(pCustomer->Address.AddressLine5.Name));
        strcpy(pCustomer->Address.AddressLine5.Name, pxmlCust->Address.AddressLine5.Name);

        memset(pCustomer->Address.ZipCode.Name, 0x00, sizeof(pCustomer->Address.ZipCode.Name));
        strcpy(pCustomer->Address.ZipCode.Name, pxmlCust->Address.ZipCode.Name);

        memset(pCustomer->FaxNo.Name, 0x00, sizeof(pCustomer->FaxNo.Name));
        strcpy(pCustomer->FaxNo.Name, pxmlCust->FaxNo.Name);

        memset(pCustomer->TelexNumber.Name, 0x00, sizeof(pCustomer->TelexNumber.Name));
        strcpy(pCustomer->TelexNumber.Name, pxmlCust->TelexNumber.Name);

        memset(pCustomer->TelexAnswerBack.Name, 0x00, sizeof(pCustomer->TelexAnswerBack.Name));
        strcpy(pCustomer->TelexAnswerBack.Name, pxmlCust->TelexAnswerBack.Name);        

        memset(pCustomer->PhoneNumber.Name, 0x00, sizeof(pCustomer->PhoneNumber.Name));
        strcpy(pCustomer->PhoneNumber.Name, pxmlCust->PhoneNumber.Name);

        memset(pCustomer->Department.Name, 0x00, sizeof(pCustomer->Department.Name));
        strcpy(pCustomer->Department.Name, pxmlCust->Department.Name);

        memset(pCustomer->Email.Name, 0x00, sizeof(pCustomer->Email.Name));
        strcpy(pCustomer->Email.Name, pxmlCust->Email.Name);

        pCustomer->InputDate = pxmlCust->InputDate;

        for (int i = 0; i < pCustomer->ClassifList.List.ItemsUsed;i++)
        {
            sCUSTCLAS *pClas = (sCUSTCLAS *)sGetListItem((void *)&pCustomer->ClassifList, i);
            sDeleteListItem(&pCustomer->ClassifList, i);
            i--;
        }
        for (int i = 0; i < pCustomer->ClassifList.List.ItemsUsed;i++)
        {
            sCUSTCLAS *pClas = (sCUSTCLAS *)sGetListItem((void *)&pxmlCust->ClassifList, i);
            sInsertListItem(&pCustomer->ClassifList, pCustomer->ClassifList.List.ItemsUsed, pClas);
        }

        for (int i = 0; i < pCustomer->CustRoleList.List.ItemsUsed;i++)
        {
            sCUSTROLE *pRole = (sCUSTROLE *)sGetListItem((void *)&pCustomer->CustRoleList, i);
            sDeleteListItem(&pCustomer->CustRoleList, i);
            i--;
        }
        for (int i = 0; i < pCustomer->CustRoleList.List.ItemsUsed;i++)
        {
            sCUSTROLE *pRole = (sCUSTROLE *)sGetListItem((void *)&pxmlCust->CustRoleList, i);
            sInsertListItem(&pCustomer->CustRoleList, pCustomer->CustRoleList.List.ItemsUsed, pRole);
        }

        for (int i = 0; i < pCustomer->BKCodeList.List.ItemsUsed;i++)
        {
            sCUSTBKCD *pBkcode = (sCUSTBKCD *)sGetLIstItem((void *)&pCustomer->BKCodeList, i);
            sDeleteListItem(&pCustomer->BKCodeList, i);
            i--;
        }
        for (int i = 0; i < pCustomer->BKCodeList.List.ItemsUsed;i++)
        {
            sCUSTBKCD *pBkcode = (sCUSTBKCD *)sGetLIstItem((void *)&pxmlCust->BKCodeList, i);
            sInsertListItem(&pCustomer->BKCodeList, pCustomer->BKCodeList.List.ItemsUsed, pBkcode);
        }

        for (int i = 0; i < pCustomer->ExtAppList.List.ItemsUsed;i++)
        {
            sCUST_EXT_APP *pExtApp = (sCUST_EXT_APP *)sGetLIstItem((void *)&pCustomer->ExtAppList, i);
            sDeleteListItem(&pCustomer->ExtAppList, i);
            i--;
        }
        for (int i = 0; i < pCustomer->ExtAppList.List.ItemsUsed;i++)
        {
            sCUST_EXT_APP *pExtApp = (sCUST_EXT_APP *)sGetLIstItem((void *)&pxmlCust->ExtAppList, i);
            sInsertListItem(&pCustomer->ExtAppList, pCustomer->ExtAppList.List.ItemsUsed, pExtApp);
        }



    }

    if(err && err != sDB_FAIL)
    {
        errorXml = "Abnormal DBRead, cancel, CUSTID: ";
    }
}