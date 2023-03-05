#include <iostream>
#include <math.h>
#include <stdio.h>
#include <cstring>
#include <string>
#include <vector>
#include <stdlib.h> 
#include <fstream> 

using namespace std;

int main()
{

    ifstream configFile;
    string path = "ZeroCurve.txt";
    configFile.open(path.c_str());
    string strLine;
    string filepath;
    if(configFile.is_open())
    {
        while (!configFile.eof())
        {
            getline(configFile, strLine);


            cout << "strLine :" << strLine << endl;

            // size_t pos = strLine.find('=');
            // string key = strLine.substr(0, pos);
                    
            // if(key == "filepath")
            // {
            //     filepath = strLine.substr(pos + 1);            
            // }            
        }
    }
    else
    {
        cout << "Cannot open config file!" << endl;
    }



    printf("已输出到文件 ZeroCurve.txt，结束！\n");
    return 0;
}
