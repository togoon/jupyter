#include <sqlite3.h>
#include <stdio.h>
#include <stdlib.h>
#include <iostream>

#include <string>
#include <vector>
#include <map>

#include "s1.h"

// #include <boost/algorithm/string.hpp>

using namespace std;


struct table
{
    string name;
    string createSQL;
};

vector<string> DB_GetKeyFieldName(string res);
vector<string> split(string str, string separator);
string DB_GetFigureCreateSql();
bool GetColType(vector<int>& vecType, string strTableName, sqlite3* m_pDb);
bool GetColName(vector<string>& vecColName, string strTableName, sqlite3* m_pDb);
void GetTables(vector<table>& vecTable, sqlite3* m_pDb);

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

//获取上图Figures表中create sql语句
string DB_GetFigureCreateSql()
{
    string res = "";
    sqlite3* db;
    int rc = sqlite3_open("stock.db", &db);
    if (rc == SQLITE_OK)
    {
        string sql = "select sql from sqlite_master where tbl_name = 'khist' and type = 'table' ";
        char** pResult;
        int nRow;
        int nCol;
        rc = sqlite3_get_table(db, sql.c_str(), &pResult, &nRow, &nCol, NULL);
        if (rc == SQLITE_OK)
        {
            if (nRow >= 1)
            {
                res = pResult[nCol];
            }
        }
        sqlite3_free_table(pResult);
    }
    sqlite3_close(db);

    cout << endl << res << endl;
    return res;
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

//获取表中字段名
vector<string> DB_GetKeyFieldName(string res)
{
    vector<string> r = split(res, ",");

    cout << endl << "---split:------- " << endl;
    for (auto i : r)
    {
        cout << i << "--- ";
    }
    cout << endl << "-----r---- " << endl;

    vector<string> keyField;
    for (int i = 0; i < r.size(); i++)
    {
        vector<string> tp = split(r[i], "\"");

        cout << endl << r[i] << "--tp-split:---- " << tp.size() << endl;
        for (auto i : tp)
        {
            cout << i << "--- ";
        }
        cout << endl << "-----tp---- " << endl;

        if (tp.size() == 2)
        {
            keyField.push_back(tp[0]);
        }
        else if (tp.size() == 3)
        {
            keyField.push_back(tp[1]);
        }
        else if (tp.size() == 5)
        {
            keyField.push_back(tp[3]);
        }

    }



    return keyField;
}

// vector<string> FieldName = DB_GetKeyFieldName(DB_GetFigureCreateSql());



//获取表信息
void GetTables(vector<table>& vecTable, sqlite3* m_pDb)
{
    char* szError = new char[256];
    sqlite3_stmt* stmt = NULL;
    sqlite3_prepare(m_pDb, "select name,sql from sqlite_master where tbl_name = 'khist' and type='table'  order by name", -1, &stmt, 0);
    vector<string> vecTables;
    if (stmt)
    {
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
            table tb;
            tb.name = (char*)sqlite3_column_text(stmt, 0);
            tb.createSQL = (char*)sqlite3_column_text(stmt, 1);
            vecTable.push_back(tb);
        }
        sqlite3_finalize(stmt);
        stmt = NULL;
    }
}

//获取列名
bool GetColName(vector<string>& vecColName, string strTableName, sqlite3* m_pDb)
{
    sqlite3_stmt* stmt = NULL;
    char sql[200];
    sprintf(sql, "SELECT * FROM %s limit 0,1", strTableName.c_str());
    char** pRes = NULL;
    int nRow = 0, nCol = 0;
    char* pErr = NULL;

    //第一行是列名称
    sqlite3_get_table(m_pDb, sql, &pRes, &nRow, &nCol, &pErr);
    for (int i = 0; i < nRow; i++)
    {
        for (int j = 0; j < nCol; j++)
        {
            char* pv = *(pRes + nCol * i + j);
            vecColName.push_back(pv);
        }
        break;
    }

    if (pErr != NULL)
    {
        sqlite3_free(pErr);
    }
    sqlite3_free_table(pRes);
    return true;
}


//获取列类型
bool GetColType(vector<int>& vecType, string strTableName, sqlite3* m_pDb)
{
    sqlite3_stmt* stmt = NULL;
    char sql[200];
    sprintf(sql, "SELECT * FROM %s limit 0,1", strTableName.c_str());
    sqlite3_prepare(m_pDb, sql, -1, &stmt, 0);
    if (stmt)
    {
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
            int nCount = sqlite3_column_count(stmt);
            for (int i = 0; i < nCount; i++)
            {
                int nValue = sqlite3_column_int(stmt, 0);
                int nType = sqlite3_column_type(stmt, i);
                vecType.push_back(nType);
                switch (nType)
                {
                case 1:
                    //SQLITE_INTEGER
                    break;
                case 2:
                    //SQLITE_FLOAT
                    break;
                case 3:
                    //SQLITE_TEXT
                    break;
                case 4:
                    //SQLITE_BLOB
                    break;
                case 5:
                    //SQLITE_NULL
                    break;
                }
            }
            break;
        }
        sqlite3_finalize(stmt);
        stmt = NULL;
    }
    return true;
}


