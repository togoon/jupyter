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

    while(!(err = sEntityDBRead(curEnt,(void))))




}
