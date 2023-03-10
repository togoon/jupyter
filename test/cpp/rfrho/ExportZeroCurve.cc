#include "ExportZeroCurve.h"

using namespace std;

/***********************************************************
FUNCTION    main
PURPOSE     Export SOFR ZeroCurve data from v6.2 to v5.5
SYNTAX      int main(int argc, char* argv[])
RETURNS     sSUCCESS - on Success
            sERROR - on Failure
NOTES       None.
*************************************************************/

#define HELP_REQUEST 1

void FreeMemory(sENTITY *Entity, sCURVELIST *Instancel);
bool IsFileExists(const string sFilePath);
bool IsDirExists(const char *dirName);
int ParseParameters(int argc, char **argv, char *sql, char *outDirPath, string &cfgFilePath, vector<string> &vRFRDESK);
int ReadExportRFRCfg(map<string, map<string, string>> &mmRFRCfg, const string &cfgFilePath);
void WriteRFRdat(const char *outDirPath, const map<stirng, string> mRFROut);
void DumpHelpMessage(void);
void SplitString(const string &s, vector<string> &v, const string &c);
int WriteALLMD5File(const char *outDirPath, const map<stirng, string> mRFROut);
int WriteMD5File(const char *outDirPath, const map<string, string> mRFROut);

//const char* RFRDESK[3] = {"RFRHO", "RFRHK", "RFRFTZ"}
const char *MD5 = "RFRMD5";

int main(int argc, char ** argv)
{
    int err;
    sENTITY *curEnt;
    sERRMSGLIST messages;
    sCURVELIST *curList;

    string cfgFilePath;
    char sql[sTEST100_LEN] = {0};
    vector<string> vRFRDESK;

    map<string, map<string, string>> mmRFRCfg;
    map<string, string> mFRFOut;
    
    if(ParseParameters(argc,argv,sql, outDirPath, cfgFilePath,vRFRDESK))
    {
        sLogMessage("Error parsing paramters", sLOG_ERROR, 0);
        exit(sERROR);
    }

    if(ReadExportRFRCfg(mmRFRCfg, cfgFilePath))
    {
        sLogMessage("Error Read ExportZeroCurveCfg", sLOG_ERROR, 0);
        exit(sERROR);
    }

    if(err = sStandardInit(argc,argv, DumpHelpMessage, 01)) //DumnHelpMessage NULL
    {
        if(err != HELP_PEQUEST)
            sLogMessage("sStandardInit failed", sLOG_ERROR, 0);
        exit(err);
    }

    if(sInitList(&message.List, "sERRMSG"))
    {
        sLogMessage("Error initializing error message list", sLOG_ERROR, 0);
        exit(sERROR);
    }

    if(!(curEnt = sGetEntityByName("CURVEHEAD")))
    {
        sLogMessage("Error getting_curEnt", sLOG_ERROR, 0);
        exit(sERROR);
    }

    if(sEntityCreate(curEnt,(void**)&curList))
    {
        sLogMessage("Error allocating curList structure", sLOG_ERROR, 0);
        exit(sEEROR);
    }

    while(!(err = sEntityDBRead(curEnt,(void*)curList, sql,00))) //ALL sql
    {
        sSDATE AsOfDate = sISDate(curList->Char.AsOfDate);
        string MCType(sMCTYPE_short[curList->Char.MCType]);

        // char srcValue[32];
        // strcpy(srcValue, sICEnum("sTERM", curList->Char.MCType, sMCTYPE_short)); // sLONG_ENUM sSHORT_ENUM
        // sEditString(srcValue, sICEnum("sTERM", curList->Char.MCType, sSHORT_ENUM), sNO_LEADING_SPACES | sNO_TRAILING_SPACES );
        // printf("MCType %s\n", srcValue);

        size_t lPos = MCType.find_first_not_of(' ');
        size_t rPos = MCType.find_last_not_of(' ');
        MCType = MCType.substr(lPos, rPos - lPos + 1);

        for (map<string, map<string, string>>::iteraor it = mmRFRCfg.begin(); it != mmRFRCfg.end(); it++)
        {
            if(strcmp(ito->first.c_str(),"Ccy5") == 0)
            {
                Ccy5 = ito->second;
            }

            if(strcmp(ito->first.c_str(),"Index5") ==0)
            {
                Index5 = ito->second;
            }

            if(strcmp(ito->first.c_str(),"IRCD5") ==0)
            {
                IRCD5 = ito->second;
            }

            if(strcmp(ito->first.c_str(), "CurveID5") ==0)
            {
                CurveID5 = ito->second;
            }

            if(strcmp(curList->Char.Index.Name, ito->second.c_src()) == 0 && strcmp(ito->first.c_str(), "Index6") ==0)
            {
                isIndexExist = true;
            }
        }

        if(isCcyExist && isCurveIDExist && isIndexExist)
        {
            ostringstream oss;
            oss.prcision(12);
            oss.setf(ios::fixed);

            oss << "CCY" << Ccy5 << endl; // curList->Char.Ccy.Name  Ccy5
            oss << "INDEX" << Index5 << endl; // curList->Char.Index.Name Index5

            if(CurveID6.compare("RFRHK")==0) //RFRDESK
            {
                oss << "DATE" << AsOfDate.Day << "/" << AsOfDate.Month << "/" << AsOfDate.Year << endl;
            }
            else
            {
                oss << "DATE" << AsOfDate.Month << "/" << AsOfDate.Day << "/" << AsOfDate.Year << endl;
            }

            oss << "ID" << CurveID5 << endl; // curList->Char.Id.ID
            // oss << curList->Char.Ccy.Name << " " << curList->char.Index.Name << " " << MCType << endl;
            oss << Ccy5 << " " << Index5 << " " << IRCD5 << endl;

            for (int i = 0; i < curList->List.ItemsUsed; i++)
            {
                sCURVE *curve = (sCURVE *)sGetListItem(&curList->List, i);
                sSDATE Date = sISDate(curve->Date);

                if(CurveID6.compare("RFRHK") == 0) //RFRDESK
                {
                    oss << Date.Day << "/" << Date.Month << "/" << Date.Year << " " << curve->Rate * 100 << endl;
                }
                else
                {
                    oss << Date.Month << "/" << Date.Day << "/" << Date.Year << " " << curve->Rate * 100 << endl;
                }
            }
        }
    }
}
