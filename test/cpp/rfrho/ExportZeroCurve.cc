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

            bool isCcyExist = false;
            bool isCurveIDExist = false;
            bool isIndexExist = false;
            // bool isAsOfDateExist = false;
            string CurveID6, Ccy5, Index5, IRCD5, CurveID5;

            for (map<string, string>::iterator ito = it->second.begin(); ito != it->second.end(); ito++)
            {

                if (strcmp(ito->first.c_str(), "Ccy5") == 0)
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

                if(strcmp(curList->Char.Ccy.Name, ito->second.c_src()) == 0 && strcmp(ito->first.c_str(), "Ccy6") ==0)
                {
                    isCcyExist = true;
                }

                if(strcmp((char *)curList->Char.Id.ID, ito->second.c_src()) == 0 && strcmp(ito->first.c_str(), "CurveID6") ==0)
                {
                    iCurveIDExist = true;
                    CurveID6 = ito->second;
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

                for(int i = 0; i < curList->List.ItemsUsed; i++)
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

                oss << endl; //空行mktimp 仅读取最后一段
                string strFRF = oss.str();

                // for(int i=0; i<sizeof(RFRDESK)/sizeof(RFRDESK[0]); i++)
                for (unsigned int i = 0; i < vRFRDESK.size(); ++i) 
                {
                    if(CurveID6.compare(vRFRDESK[i] )==0) // RFRDESK
                    {
                        if(mRFROut.count(CurveID6) > 0)
                        {
                            mRFROut[CurveID6] += strRFR;
                        }
                        else
                        {
                            mRFROut[CurveID6] = strRFR;
                        }
                    }
                }
            }
        }
    }

    WriteRFRdat(outDirPath, mRFROut);

    if(WriteMD5File(outDirPath,mRFROut))
    {
        sLogMessage("Error WriteMD5File", sLOG_ERROR, 0);
        exit(sERROR);
    }
    else
    {
        sLogMessage("ExportZeroCurve -> WriteMD5File : Done. ", sLOG_INFO, 0);
    }

    if(err && (err != sDB_FAIL))
    {
        printf("Error: Abnormal read termination, cancel read. Please Check it!\n");
        sLogMessage("Abnormal read termination, cancel read.", sLOG_ERROR, 0);
        sEntityDBRead(curEnt, curList, "CANCEL", 00);
        FreeMemory(curEnt, curList);
        exit(sERROR);
    }

    FreeMemory(curEnt, curList);
    sFreeGlobal();
    exit(sSUCCESS);
}

void SplitString(const string &s, vector<string>&v, const string &c)
{
    string::size_type pos1, pos2;
    pos2 = s.find(c);
    pos1 = 0;

    while(string::npos != pos2)
    {
        v.push_back(s.substr(pos1, pos2 - pos1));
        pos1 = pos2 + c.size();
        pos2 = s.find(c, pos1);
    }

    if(pos1 != s.length())
        v.push_back(s.substr(pos1));

}

int WriteMD5File(const char* outDirPath, const map<string,string>mRFROut)
{
    FILE *fp;
    map<string, string> mRFRTemp = mRFROut;

    for (map<string, string>::iterator itor = mRFRTemp.begin(); itor != mRFRTemp.end(); itor++)
    {
        string strMD5FilePath = "";
        strMD5FilePath = strMD5FilePath + outDirPath + "/" + itor->first + ".md5"; // +"_md5" +".dat";

        if(fp = fopen(strMD5FilePath.c_str(),"r"))
        {
            fclose(fp);
            remove(strMD5FilePath.c_str());
        }

        fp = fopen(strMD5FilePath.c_str(), "w");
        if(fp == NULL)
        {
            printf("warning: RFRMD5.dat Empty! Please Check it! \n");
            continue;
            // return sERROR;
        }

        string strPathFile = outDirPath;
        string strFileName = itor->first + ".dat";
        strPathFile += "\\" + strFileName;

        string strCMD = "certutil -hashfile \"";
        strCMD += strPathFile + "\" MD5";
        string strBuf;

        FILE *pipe = _Popen(strCMD.c_str(), "r");

        if(!pipe)
            continue;

        char buffer[80] = {0};

        while(!feof(pipe))
        {
            if(fgets(buffer,128,pipe))
                strBuf += buffer;
        }

        _pclose(pipe);

        vector<string> vBuf;
        SplitString(strBuf, vBuf, "\n");
        string strMD5 = vBuf[1];

        fprintf(fp, "%s\t%s\n", strMD5.c_str(), strFileName.c_str());
        printf("%s MD5 Done: %s\n", strFileName.c_str(), strMD5.c_str());
        fclose(fp);
    }
    return sSUCCESS;
}

int WriteAllMD5File(const char* outDirPath, const map<string,string>mRFROout)
{
    FILE *fp;
    map<string, string> mRFRTemp = mRFROut;

    string strMD5FilePath + outDirPath + "/" + MD5 + ".dat";

    if(fp = fopen(strMD5FilePath.c_str(), "r"))
    {
        fclose(fp);
        remove(strMD5FilePath.c_str());
    }

    fp = fopen(strMD5FilePath.c_str(), "w");
    if(fp == NULL)
    {
        printf("warning: RFRMD5.dat Empty! Please Check it !\n");
        return sERROR;
    }

    for (map<string, string>::itoerator itor = mRFRTemp.begin(); itor != mRFRTemp.end();itor++)
    {
        string strPathFile = outDirPath;
        string strFileName = itor->first + ".dat";
        strPathFile += "\\" + strFileName;

        string strCMD = "certutil -hashfile \"";
        strCMD += strPathFile + "\" MD5";
        string strBuf;

        FILE *pipe = _popen(strCMD.c_str(), "r");

        if(!pipe)
            continue;
        
        char buffer[80] = {0}

        while(!feof(pipe))
        {
            if(fgets(buffer,128,pipe))
                strBuf += buffer;
        }

        _pclose(pipe);

        vector<string> vBuf;
        SplitString(strBuf, vBuf, "\n");
        string strMD5 = vBuf[1];

        fprintf(fp, "%s\t%s\n", strMD5.c_str(), strFileName.c_str());
        print("%s MD5 Done: %s\n", strFileName.c_str(), strMD5.c_str());
    }
    fclose(fp);
    return sSUCCESS;
}

int ReadExportRFRCfg(map<string,map<string,string>> &mmRFRCfg,const string & cfgFilePath)
{
    map<stirng, map<string, string>>::iterator it;
    map<string,string> mTemp;
    map<string, string>::iterator ito;

    mTemp["0"] = "0";
    mTemp.clear();

    string sKey;
    ifstream cfgFile;
    cfgFile.open(cfgFilePath.c_str());
    string strLine;

    if(cfgFile.is_open())
    {
        while(!cfgFile.eof())
        {
            getline(cfgFile, strLine);
            
            if(strLine.find('#')==0)
            {
                contineue;
            }
            else if(strLine.find('[') == 0)
            {
                size_t n2 = strLine.find(']');
                if(n2 != string::npos)
                {
                    sKey = strLine.substr(1, n2 - 1);
                    it = mmRFRCfg.find(sKey);
                    if(it -- mRFRCfg.end())
                    {
                        mTemp.clear();
                        mmRFRCfg[sKey] = mTemp;
                    }
                }
                continue;
            }
            size_t pos = strLine.find('=');
            string strKey = strLinke.substr(0, pos);
            string strValue = strLine.substr(pos + 1);

            mmRFRCfg[sKey][strKey] = strValue;
        }
    }
    else
    {
        return sERROR
    }

    cfgFile.close();
    return sSUCCESS;
}

void WriteRFRdat(const char* outDirPath, const map<stirng,string> mRFROut)
{
    FILE *fp;
    string strPathFile = "";
    map<string, string> mRFRTemp = mRFROut;

    for (map<string, string>::iterator itor = mRFRTemp.begin(); itor != mRFRTemp.end();itor++)
    {
        stringPathFile = outDirPath;
        strPathFile += "\\" + itor->first +.".dat";

        if(fp = fopen(strPathFile.c_str(),"r"))
        {
            fclose(fp);
            remove(strPathFile.c_str());
        }

        if(!itor->second.empty())
        {
            fp = fopen(strPathFile.c_str(), "w");
            fprintf(fp, "%s", itor->second.c_str());
            fclose(fp);

            printf("%s.dat Data Done. \n", itor->first.c_str());
        }
        else
        {
            printf("warning: %s.dat Empty! Please Check it!\n", itor->first.c_str());
        }
    }
}

int ParseParameters(int argc, char **argv, char*sql, char *outDirPath, string &cfgFilePath, vector<string> &vRFRDESK)
{
    char *libvar, *clientPath, *summitHomePath;
    char curDate[sTEXT20_LEN] = {0};
    char company[sTEXT100_LEN] = {0};

    for (int i = 1; i < argc; i++)
    {
        if((strcmp(_strlwr(argv[i]), "-h") ==0) || (strcmp(_strlwr(argv[i]), "-help") ==0))
        {
            DumpHelpMessage();
        }

        if((strcmp(_strlwr(argv[i]), "-d") ==0) || (strcmp(_strlwr(argv[i]), "-date") ==0))
        {
            strcpy(curDate, argv[i+1]);
        }

        if((strcmp(_strlwr(argv[i]), "-o") ==0) || (strcmp(_strlwr(argv[i]), "-out") ==0))
        {
            strcpy(curDirPath, argv[i+1]);
        }

        if((strcmp(_strlwr(argv[i]), "-c") ==0) || (strcmp(_strlwr(argv[i]), "-cfg") ==0))
        {
            cfgFilePath = argv[i + 1];
        }

        if((strcmp(_strlwr(argv[i]), "-com") ==0) )
        {
            strcpy(cp
            ompany, argv[i+1]);
        }
    }

    libvar = getenv("SUMMIRDBNAME");
    if(libvar != NULL)
        printf("Summit Current Environment Name is [%s]\n", libvar);

    clientPath = getenv("CLIENTPATH");
    if(clientPath != NULL)
        printf("Summit Current CLIENTPATH Path: [%s]\n", clientPath);
    summitHomePath = getenv("SUMMITHOME");
    if(summitHomePath != NULL)
        print("Summit Current SUMMITHOME Path: [%s]\n", summitHomePath);
    if(cfgFilePath.empty())
    {
        cfgFile += clientPath;
        cfgFilePath += "\\etc\\ExportZeroCurve.cfg";
    }

    if(IsFileExists(cfgFilePath))
    {
        printf("cfgFilePath: [%s]\n", cfgFilePath.c_str());
    }
    else
    {
        printf("Cannot find [%s] file. Please Check it!\n", cfgFilePath.c_str());
        return sERROR;
    }

    if(sIsBlank(outDirPath))
    {
        strcpy(outDirPath,)
    }
}
