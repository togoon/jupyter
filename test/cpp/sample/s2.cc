#include <sqlite3.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <iostream>
using namespace std;
int main()
{
    sqlite3* db;
    char buff[100];
    char* errmsg;
    char** result;
    int row, col, i, j;
    int ret;
    ret = sqlite3_open("user.db", &db);//创建或打开数据库
    if (ret != SQLITE_OK)
    {
        cout << "Failed to open " << endl;
    }
    //建表
    const char* creat_UserTabSql = "create table if not exists user_table(\
        user_id varchar(16) primary key,\
        user_name varchar(10) not NULL,\
        user_pass varchar(10) not NULL); ";
    ret = sqlite3_exec(db, creat_UserTabSql, NULL, NULL, &errmsg);
    //插入
    const char* insert_UserTabSql_1 = "insert into user_table(user_id,user_name,user_pass) values ('1234','czx','5678');";
    const char* insert_UserTabSql_2 = "insert into user_table(user_id,user_name,user_pass) values ('1235','ccc','6666');";
    ret = sqlite3_exec(db, insert_UserTabSql_1, NULL, NULL, &errmsg);
    ret = sqlite3_exec(db, insert_UserTabSql_2, NULL, NULL, &errmsg);
    //查询
    const char* select_UserTabSql = "select * from user_table;";
    ret = sqlite3_get_table(db, select_UserTabSql, &result, &row, &col, &errmsg);
    if (ret != SQLITE_OK)
    {
        sprintf(buff, "getData查询  错误编码%d 错误信息%s %s", ret, errmsg, select_UserTabSql);
        cout << buff << endl;
        return -1;
    }
    //打印
    int index = col;
    for (i = 0; i < row; i++)
    {
        for (j = 0; j < col; j++)
        {
            printf("%s", result[index]);
            index++;
        }
        printf("\n");
    }
    sqlite3_close(db);
    return 0;
}