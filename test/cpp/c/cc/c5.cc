
#include <iostream>
#include <math.h>
#include <stdio.h>
#include <cstring>
#include <string>
#include <vector>
#include <stdlib.h> 
#include <fstream> 
#include <map> 

using namespace std;

int main()
{

    map<int,map<int,int> >multiMap; //对于这样的map嵌套定义，  
    map<int, int> temp;    //定义一个map<int, string>变量，对其定义后在插入multiMap  
    temp[8] = 8;  

    temp.clear();

    // temp[9] = 9;  
    // temp[10] = 10;  
    multiMap[10] = temp;  
    multiMap[10][11]=11;   
    multiMap[5][30]=30;  
    temp.clear();
    multiMap[11] = temp;  
    multiMap[11][12]=12;  
    multiMap[11][13]=13;  

    map<int,map<int,int> >::iterator multitr;  // 以下是如何遍历本multiMap  
    map<int,int>::iterator intertr;  
    for(multitr=multiMap.begin();multitr!=multiMap.end();multitr++)  
    { 
        for(intertr= multitr ->second.begin(); intertr != multitr ->second.end(); intertr ++)  
            cout<< multitr ->first<<" - "<<intertr->first<<" : "<<intertr -> second <<endl;  
    } 

    cout<<multiMap[11][12]<<endl;

    return 0;
}












