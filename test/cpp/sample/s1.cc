
#include <stdio.h>
#include <stdlib.h>
#include <iostream>


#include "s1.h"

// #include <boost/algorithm/string.hpp>

using namespace std;

vector<string> split(string str, string separator);

int main()
{
    sqlite3* pDb;
    char* pErr;
    char** pRes;
    int nRow, nCol, i, j;
    int ret;

    string strDb = "stock.db";
    string strTab = "khist";
    string strCode = "300942";

    ret = sqlite3_open(strDb.c_str(), &pDb);//创建或打开数据库
    if (ret != SQLITE_OK)
    {
        cout << "Error: sqlite3_open Failed to open: " << strDb << endl;
        sqlite3_close(pDb);
        return -1;
    }


    /*
    //建表
        const char* creat_UserTabSql = "create table if not exists user_table(\
        user_id varchar(16) primary key,\
        user_name varchar(10) not NULL,\
        user_pass varchar(10) not NULL); ";
    ret = sqlite3_exec(db, creat_UserTabSql, NULL, NULL, &errMsg);
    //插入
    const char* insert_UserTabSql_1 = "insert into user_table(user_id,user_name,user_pass) values ('1234','czx','5678');";
    const char* insert_UserTabSql_2 = "insert into user_table(user_id,user_name,user_pass) values ('1235','ccc','6666');";
    ret = sqlite3_exec(db, insert_UserTabSql_1, NULL, NULL, &errMsg);
    ret = sqlite3_exec(db, insert_UserTabSql_2, NULL, NULL, &errMsg);

    /* */


    //查询
    string strSql("");
    strSql.append("select * from ")
        .append(strTab)
        .append(" where SecurityID = '").append(strCode).append("' ")
        .append(" limit 2 ");

    ret = sqlite3_get_table(pDb, strSql.c_str(), &pRes, &nRow, &nCol, &pErr);
    if (ret != SQLITE_OK)
    {
        cout << "Error: sqlite3_get_table ret: " << ret << ", msg: " << pErr << ", sql: " << strSql << endl;
        sqlite3_free(pErr);
        sqlite3_close(pDb);
        return -1;
    }

    //打印 0,600201,1999-01-15,-0.49,-0.44,-0.43,-0.5,231403,327418000.0,-7.53,52.69,0.49,66.12,
    int index = 0;  //0+1 col
    for (i = 0; i < nRow + 1; i++)
    {
        for (j = 0; j < nCol; j++)
        {
            printf("%d:%s,", index, pRes[index]);
            index++;
        }
        printf("\n");
    }
    sqlite3_free_table(pRes);

    string res = "";
    strSql.clear();
    strSql.append("select sql from sqlite_master where type = 'table' and tbl_name = '").append(strTab).append("' ");

    ret = sqlite3_get_table(pDb, strSql.c_str(), &pRes, &nRow, &nCol, &pErr);
    if (ret != SQLITE_OK)
    {
        cout << "Error: sqlite3_get_table ret: " << ret << ", msg: " << pErr << ", sql: " << strSql << endl;
        sqlite3_free(pErr);
        sqlite3_close(pDb);
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

    map<string, vector<float> > mapVect;
    map<string, string> mFieldType;
    vector<string> vRes = split(res, ",");
    vector<string> vField, vType;


    for (int i = 0; i < vRes.size(); i++)
    {
        vector<string> vSp = split(vRes[i], "\"");
        if (vSp.size() == 2)
        {
            vField.push_back(vSp[0]);
            vType.push_back(vSp[1]);
            mFieldType[vSp[0]] = vSp[1];
        }
        else if (vSp.size() == 3)
        {
            vField.push_back(vSp[1]);

            vSp[2].erase(0, vSp[2].find_first_not_of(" ")); //trim start space
            vSp[2].erase(vSp[2].find_last_not_of(" ") + 1); //trim end space
            vSp[2].erase(vSp[2].find_last_not_of(")\n") + 1);
            vType.push_back(vSp[2]);
            mFieldType[vSp[1]] = vSp[2];
        }
        else if (vSp.size() == 5)
        {
            vField.push_back(vSp[3]);
            vType.push_back(vSp[4]);
            mFieldType[vSp[3]] = vSp[4];
        }
    }

    sqlite3_stmt* stmt = NULL;
    strSql.clear();
    strSql.append("select * from ").append(strTab).append(" limit 0,1 ");

    sqlite3_prepare(pDb, strSql.c_str(), -1, &stmt, 0);
    if (stmt)
    {
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
            int nCount = sqlite3_column_count(stmt);
            for (int i = 0; i < nCount; i++)
            {

                int nType = sqlite3_column_type(stmt, i);
                // vecType.push_back(nType);

                cout << "--" << i;

                switch (nType)
                {
                case 1:
                {
                    int nValue = sqlite3_column_int(stmt, i); //SQLITE_INTEGER
                    cout << "--" << nValue;
                    break;
                }
                case 2:
                {
                    double dValue = (double)sqlite3_column_double(stmt, i); //SQLITE_FLOAT
                    cout << "--" << dValue;
                    break;
                }
                case 3:
                {
                    string sValue = (char*)sqlite3_column_text(stmt, i); //SQLITE_TEXT 
                    cout << "--" << sValue;
                    break;
                }
                case 4:
                {
                    //SQLITE_BLOB
                    // const BETY * pb = (const BETY*)sqlite3_column_blob(stmt, i);
                    // int len = *(pb + 1);
                    // string strData = string((char*)(pb + 2, len));
                    // cout << "--" << sValue;
                    break;
                }
                case 5:
                {
                    //SQLITE_NULL
                    break;
                }
                default:
                {
                    break;
                }
                }

                cout << "--" << nType << "--; ";
            }
            cout << endl;
            break;
        }
        sqlite3_finalize(stmt);
        stmt = NULL;
    }





    sqlite3_close(pDb);

    // cout << endl;
    // for (auto i : vRes)
    // {
    //     cout << "--" << i << "--; ";
    // }
    // cout << endl;


    // cout << endl;
    // for (auto member : mFieldType)
    // {
    //     cout << member.first << ":" << member.second << "; ";
    // }
    // cout << endl;

    return 0;
}


//解析字符串函数
vector<string> split(string str, string separator)
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


Khist::Khist(const string strDb, const string strTab, const string strCode) :m_strDb(strDb), m_strTab(strTab), m_strCode(strCode) 
{
    OpenDb();
    QueryDB(const string strSql);
    QueryFieldType(const string strSql);    
}

Khist::~Khist()
{
    sqlite3_close(m_pDb);
}

Khist::OpenDb()
{

}

