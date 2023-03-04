
#include <stdio.h>
#include <stdlib.h>
#include <iostream>


#include "s1.h"

// #include <boost/algorithm/string.hpp>

using namespace std;

vector<string> split(string str, string separator);

int main()
{

    int ret = 0;

    string strDb = "stock.db";
    string strTab = "khist";
    string strCode = "300942";

    Khist Kh(strDb, strTab, strCode);

    cout << "--Field--Type:--" << endl;
    for (auto m : Kh.GetFiledType())
    {
        cout << "--" << m.first << "--" << m.second << "--; ";
    }
    cout << endl;


    cout << "--m_sKdata--SecurityID--:--" << endl;

    sKdata Kdata = Kh.GetKData();
    for (auto m : Kdata.SecurityID)
    {
        cout << "--" << m << "--; ";
    }
    cout << endl;


    return ret;
}


Khist::Khist(const string strDb, const string strTab, const string strCode) :m_strDb(strDb), m_strTab(strTab), m_strCode(strCode)
{
    OpenDb();

    QueryFieldType(m_strTab);

    string strSql("");
    strSql.append("select * from ")
        .append(strTab)
        .append(" where SecurityID = '").append(strCode).append("' ")
        .append(" limit 2 ");

    QueryDB(strSql);

}

Khist::~Khist()
{
    sqlite3_close(m_pDb);
}

int Khist::OpenDb()
{
    int ret = sqlite3_open(m_strDb.c_str(), &m_pDb);//创建或打开数据库
    if (ret != SQLITE_OK)
    {
        cout << "Error: sqlite3_open Failed to open: " << m_strDb << endl;
        sqlite3_close(m_pDb);
        return -1;
    }

    return ret;
}

int Khist::QueryFieldType(const string strTab)
{
    char* pErr;
    char** pRes;
    int nRow, nCol;

    string res = "";
    string strSql("");
    strSql.append("select sql from sqlite_master where type = 'table' and tbl_name = '").append(strTab).append("' ");

    int ret = sqlite3_get_table(m_pDb, strSql.c_str(), &pRes, &nRow, &nCol, &pErr);
    if (ret != SQLITE_OK)
    {
        cout << "Error: sqlite3_get_table ret: " << ret << ", msg: " << pErr << ", sql: " << strSql << endl;
        sqlite3_free(pErr);
        sqlite3_close(m_pDb);
        return -1;
    }
    else
    {
        if (nRow >= 1)
        {
            res = pRes[nCol];
        }
    }
    sqlite3_free_table(pRes);

    m_mFieldType.clear();
    m_vField.clear();
    m_vType.clear();

    vector<string> vRes = split(res, ",");

    for (int i = 0; i < vRes.size(); i++)
    {
        vector<string> vSp = split(vRes[i], "\"");
        if (vSp.size() == 2)
        {
            m_vField.push_back(vSp[0]);
            m_vType.push_back(vSp[1]);
            m_mFieldType[vSp[0]] = vSp[1];
        }
        else if (vSp.size() == 3)
        {
            m_vField.push_back(vSp[1]);

            vSp[2].erase(0, vSp[2].find_first_not_of(" ")); //trim start space
            vSp[2].erase(vSp[2].find_last_not_of(" ") + 1); //trim end space
            vSp[2].erase(vSp[2].find_last_not_of(")\n") + 1);
            m_vType.push_back(vSp[2]);
            m_mFieldType[vSp[1]] = vSp[2];
        }
        else if (vSp.size() == 5)
        {
            m_vField.push_back(vSp[3]);

            vSp[4].erase(0, vSp[4].find_first_not_of(" ")); //trim start space
            vSp[4].erase(vSp[4].find_last_not_of(" ") + 1); //trim end space
            vSp[4].erase(vSp[4].find_last_not_of(")\n") + 1);
            m_vType.push_back(vSp[4]);
            m_mFieldType[vSp[3]] = vSp[4];

            m_vType.push_back(vSp[4]);
            m_mFieldType[vSp[3]] = vSp[4];
        }
    }

    // cout << "--Field--Type:--" << endl;
    // for (auto m : m_mFieldType)
    // {
    //     cout << "--" << m.first << "--" << m.second << "--; ";
    // }
    // cout << endl;

    return ret;
}

int Khist::QueryDB(const string strSql)
{
    char* pErr;
    char** pRes;
    int nRow, nCol;

    int ret = sqlite3_get_table(m_pDb, strSql.c_str(), &pRes, &nRow, &nCol, &pErr);
    if (ret != SQLITE_OK)
    {
        cout << "Error: sqlite3_get_table ret: " << ret << ", msg: " << pErr << ", sql: " << strSql << endl;

        sqlite3_free(pErr);
        sqlite3_close(m_pDb);
        return -1;
    }

    memset(&m_sKdata, 0, sizeof(m_sKdata));

    //打印 0,600201,1999-01-15,-0.49,-0.44,-0.43,-0.5,231403,327418000.0,-7.53,52.69,0.49,66.12,
    int index = 0;  //0+1 col
    for (int i = 0; i < nRow + 1; i++)
    {
        for (int j = 0; j < nCol; j++)
        {
            switch (j)
            {
            case 0:
            {
                m_sKdata.index.push_back(atoi(pRes[index]));
                break;
            }
            case 1:
            {
                m_sKdata.SecurityID.push_back(pRes[index]);
                break;
            }
            case 2:
            {
                m_sKdata.TradeDate.push_back(pRes[index]);
                break;
            }
            case 3:
            {
                m_sKdata.Open.push_back(atof(pRes[index]));
                break;
            }
            case 4:
            {
                m_sKdata.Close.push_back(atof(pRes[index]));
                break;
            }
            case 5:
            {
                m_sKdata.High.push_back(atof(pRes[index]));
                break;
            }
            case 6:
            {
                m_sKdata.Low.push_back(atof(pRes[index]));
                break;
            }
            case 7:
            {
                m_sKdata.Vol.push_back(atoi(pRes[index]));
                break;
            }
            case 8:
            {
                m_sKdata.Amt.push_back(atof(pRes[index]));
                break;
            }
            case 9:
            {
                m_sKdata.Amp.push_back(atof(pRes[index]));
                break;
            }
            case 10:
            {
                m_sKdata.Increase.push_back(atof(pRes[index]));
                break;
            }
            case 11:
            {
                m_sKdata.Chg.push_back(atof(pRes[index]));
                break;
            }
            case 12:
            {
                m_sKdata.Tor.push_back(atof(pRes[index]));
                break;
            }
            default:
            {
                break;
            }
            }

            // printf("%d:%s,", index, pRes[index++]);

            index++;
        }
        // printf("\n");
    }
    sqlite3_free_table(pRes);

    // cout << "--m_sKdata--TradeDate--:--" << endl;
    // for (auto m : m_sKdata.TradeDate)
    // {
    //     cout << "--" << m << "--; ";
    // }
    // cout << endl;

    return ret;
}

map<string, string> Khist::GetFiledType()
{
    return m_mFieldType;
}

sKdata Khist::GetKData()
{
    return m_sKdata;
}

//解析字符串函数
vector<string> Khist::split(string str, string separator)
{
    vector<string> result;
    int cutAt;
    while ((cutAt = str.find_first_of(separator)) != str.npos)
    {
        if (cutAt > 0)
        {
            result.push_back(str.substr(0, cutAt));
        }
        str = str.substr(cutAt + 1);
    }
    if (str.length() > 0)
    {
        result.push_back(str);
    }
    return result;
}