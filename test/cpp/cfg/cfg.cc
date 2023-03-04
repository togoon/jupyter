
#include "cfg.h"


using namespace std;

std::mutex threadLck;

int ReadCFG(map<string, map<string, string>>& mmCfg, const string& cfgPathFile, string& strCFG);
int SetCFG(map<string, map<string, string>>& mmCfg, const string& cfgPathFile, const string& strCFG, const string& strField, const string& strKey, string& strValue);


int main(int argc, char* argv[])
{
    int ret = 0;

    map<string, map<string, string>> mmCfg;
    string cfgPathFile = "config.ini";
    string strCFG = "";

    ReadCFG(mmCfg, cfgPathFile, strCFG);

    for (auto mem : mmCfg)
    {
        cout << mem.first << ":" << endl;
        for (auto memb : mem.second)
        {
            cout << memb.first << "=" << memb.second << endl;
        }
    }
    cout << endl << "------------------" << endl;
    cout << strCFG << endl;



    return ret;
}


int SetCFG(map<string, map<string, string>>& mmCfg, const string& cfgPathFile, const string& strCFG, const string& strField, const string& strKey, string& strValue)
{
    int ret = 0;

    string sField = "";
    string sKey = "";
    sField.append("[").append(strField).append("]");
    sKey.append(strKey).append("=");

    mmCfg[strField][strKey] = strValue;

    string::size_type nField = strCFG.find(sField);
    if (nField == 0)
    {
        //
    }

    {
        std::lock_guard<std::mutex> lck(threadLck);
        ofstream cfgFile;
        cfgFile.open(cfgPathFile.c_str(), ios::out | ios::binary | ios::trunc);
        if (!cfgFile.is_open())
        {
            ret = -1;
            return ret;
        }
        cfgFile << strCFG;
        cfgFile.close();
    }

    return ret;
}

int ReadCFG(map<string, map<string, string>>& mmCfg, const string& cfgPathFile, string& strCFG)
{
    int ret = 0;

    map<string, string> mConf;
    string strField;

    ifstream cfgFile;
    cfgFile.open(cfgPathFile.c_str());
    string strLine;

    if (cfgFile.is_open())
    {
        while (!cfgFile.eof())
        {
            getline(cfgFile, strLine);
            strCFG.append(strLine).append("\n");

            // strLine.erase(0, strLine.find_first_not_of(" "));
            // strLine.erase(strLine.find_last_not_of(" ")+1);

            string::size_type nFind = 0;
            while ((nFind = strLine.find(' ', nFind)) != string::npos)
            {
                strLine.erase(nFind, 1);
            }

            if (strLine.find('#') == 0)
            {
                continue;
            }
            else if (strLine.find('[') == 0)
            {
                string::size_type irBracketNum = strLine.find("]");
                if (irBracketNum != string::npos)
                {
                    strField = strLine.substr(1, irBracketNum - 1);
                    auto itor = mmCfg.find(strField);
                    if (itor == mmCfg.end())
                    {
                        mConf.clear();
                        mmCfg[strField] = mConf;
                    }
                }
                continue;
            }

            string::size_type nPos = strLine.find("=");
            if (nPos != string::npos)
            {
                string strKey = strLine.substr(0, nPos);
                string strValue = strLine.substr(nPos + 1);
                mmCfg[strField][strKey] = strValue;
            }
        }
    }
    else
    {
        ret = -1;
        return ret;
    }

    cfgFile.close();
    return ret;
}

int DelNameLabel(string& strNode, const string& strName)
{
    int ret = 0;

    string strStartName, strEndName, stringSingleName;
    strStartName.append("<").append(strName); //.append(">");
    strEndName.append("</").append(strName).append(">");
    stringSingleName.append("<").append(strName).append("/>");

    string::size_type iStartNum, irBracketNum, iEndNum;
    iStartNum = strNode.find(strStartName);
    irBracketNum = strNode.find('>', iStartNum);

    if (iStartNum != string::npos && irBracketNum != string::npos)
    {
        strNode.replace(iStartNum, irBracketNum + 1 - iStartNum, "");
    }

    iEndNum = strNode.find(strEndName);
    if (iEndNum != string::npos)
    {
        strNode.replace(iEndNum, strEndName.length(), "");
    }

    return ret;
}

int GetNameValue(const string& strNode, const string& strName, string& strVal)
{
    int ret = 0;

    string strStartName, strEndName, stringSingleName;
    strStartName.append("<").append(strName).append(">");
    strEndName.append("</").append(strName).append(">");
    stringSingleName.append("<").append(strName).append("/>");

    string::size_type iStartNum, irBracketNum, iEndNum;
    iStartNum = strNode.find(strStartName);
    irBracketNum = strNode.find('>', iStartNum);
    iEndNum = strNode.find(strEndName);

    if (iStartNum != string::npos && irBracketNum != string::npos)
    {
        strVal = strNode.substr(iStartNum + strStartName.length(), iEndNum - iStartNum - strStartName.length());

    }
    else
    {
        strVal = "";
        ret = -1;
        return ret;
    }

    return ret;
}

int SetNameValue(string& strNode, const string& strName, const string& strVal)
{
    int ret = 0;

    string strStartName, strEndName, stringSingleName;
    strStartName.append("<").append(strName); //.append(">");
    strEndName.append("</").append(strName).append(">");
    stringSingleName.append("<").append(strName).append("/>");

    string::size_type iStartNum, irBracketNum, iEndNum;
    iStartNum = strNode.find(strStartName);
    irBracketNum = strNode.find('>', iStartNum);
    iEndNum = strNode.find(strEndName);

    if (iStartNum != string::npos && irBracketNum != string::npos)
    {
        strNode.replace(irBracketNum + 1, iEndNum - irBracketNum - 1, strVal);
    }
    else
    {
        ret = -1;
        return ret;
    }

    return ret;
}

int DelNameNode(string& strNode, const string& strName)
{
    int ret = 0;

    string strStartName, strEndName, stringSingleName;
    strStartName.append("<").append(strName); //.append(">");
    strEndName.append("</").append(strName).append(">");
    stringSingleName.append("<").append(strName).append("/>");

    string::size_type iStartNum, irBracketNum, iEndNum;
    iStartNum = strNode.find(strStartName);
    irBracketNum = strNode.find('>', iStartNum);
    iEndNum = strNode.find(strEndName);

    if (iStartNum != string::npos && iEndNum != string::npos && irBracketNum != string::npos && iStartNum < irBracketNum && irBracketNum < iEndNum)
    {
        strNode.erase(iStartNum, iEndNum - iStartNum + strEndName.length());
    }
    else
    {
        ret = -1;
        return ret;
    }

    return ret;
}

int CheckNameValueLen(const string& strXml, const string& strNode, int lenLim)
{
    int ret = 0;

    if (strNode.empty() || lenLim < 0)
    {
        ret = -1;
        return ret;
    }

    string strNodeVal;
    GetNameValue(strXml, strNode, strNodeVal);

    if (strNodeVal.length() > lenLim)
    {
        ret = -1;
        return ret;
    }

    return ret;
}

int CheckNameValueLen(const string& strXml)
{
    int ret = 0;

    ret = CheckNameValueLen(strXml, "FullName", 35);

    return ret;
}


void TrimString(string& strSrc, const string& strDest, int iFlag)
{

    if (strSrc.empty() || strDest.empty())
        return;

    string::size_type nFind = 0;

    switch (iFlag)
    {
    case -1:
        strSrc.erase(0, strSrc.find_first_not_of(strDest)); //(" ")
        break;

    case  0:
        while ((nFind = strSrc.find(strDest, nFind)) != string::npos)
        {
            strSrc.erase(nFind, strDest.length());
        }
        break;

    case 1:
        strSrc.erase(strSrc.find_last_not_of(strDest) + strDest.length()); //+1
        break;

    default:

        while ((nFind = strSrc.find(strDest, nFind)) != string::npos)
        {
            strSrc.erase(nFind, strDest.length());
        }
        break;
    }
}


