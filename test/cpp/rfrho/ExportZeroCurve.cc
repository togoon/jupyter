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



