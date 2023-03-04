#include <iostream>
#include <math.h>
#include <stdio.h>
#include <cstring>
#include <string>
#include <vector>
#include <stdlib.h> 
using namespace std;

int main()
{

    FILE *fp; 
    fp=fopen("ZeroCurve.txt","w"); 
    if(fp==NULL){ 
        printf("Error, 文件不存在，结束!");
        exit(0);
    }
    else{

        char  aCCY[20], aINDEX[20], aID[20], aDATE[20]; // sTEXT20_LEN

        strcpy( aCCY, "USD" );
        strcpy( aINDEX, "SOFR" );
        strcpy( aDATE, "4/2/2021" );
        strcpy( aID, "MASTER" );
        strcpy( aCCY, "USD" );

// CCY USD
// INDEX SOFR
// DATINDEXE 4/2/2021
// ID MASTER
// USD SOFR ZERO

// 1/20/1997 0.709701522795
// 1/21/1997 0.709701522795
// 1/30/1997 2.036539981528
// 2/25/1997 2.385908288716
// 4/23/1997 2.755504614461
// 1/23/1998 2.846573810299
// 1/25/2000 2.961601436523

        vector<string> vStr1;
        vector<vector<string>> vZeroIR;

        vStr1.push_back("1/20/1997");
        vStr1.push_back("0.709701522795");
        vZeroIR.push_back(vStr1);
        vStr1.clear();

        vStr1.push_back("1/21/1997");
        vStr1.push_back("0.709701522795");
        vZeroIR.push_back(vStr1);
        vStr1.clear();

        vStr1.push_back("1/30/1997");
        vStr1.push_back("2.036539981528");
        vZeroIR.push_back(vStr1);
        vStr1.clear();

        vStr1.push_back("2/25/1997");
        vStr1.push_back("2.385908288716");
        vZeroIR.push_back(vStr1);
        vStr1.clear();

        vStr1.push_back("4/23/1997");
        vStr1.push_back("2.755504614461");
        vZeroIR.push_back(vStr1);
        vStr1.clear();

        vStr1.push_back("1/23/1998");
        vStr1.push_back("2.846573810299");
        vZeroIR.push_back(vStr1);
        vStr1.clear();

        vStr1.push_back("1/25/2000");
        vStr1.push_back("2.961601436523");
        vZeroIR.push_back(vStr1);
        vStr1.clear();

        fprintf(fp,"CCY %s\n", aCCY);
        fprintf(fp,"INDEX %s\n", aINDEX);
        fprintf(fp,"DATE %s\n", aDATE);
        fprintf(fp,"ID %s\n", aID);
        fprintf(fp,"%s %s ZERO\n", aCCY, aINDEX );


        // for (std::vector<std::vector<string> >::iterator i = vZeroIR.begin(); i != vZeroIR.end();) { 
        //     for (std::vector<string>::iterator j = i->begin(); j != i->end(); ) { 
        //         fprintf(fp,"%s", j.c_str());
        //     } 
        //     fprintf(fp,"\n");
        // }

        for(int i=0; i< vZeroIR.size(); i++)
        {
            for(int j=0;j<vZeroIR[i].size();j++)
            {
                if(j==vZeroIR[i].size()-1){
                    fprintf(fp,"%s", vZeroIR[i][j].c_str() );
                }
                else{
                    fprintf(fp,"%s ", vZeroIR[i][j].c_str() );
                }
            }
            
            fprintf(fp,"\n");
        }
 	}

    fclose (fp);
    printf("已输出到文件 ZeroCurve.txt，结束！\n");
    return 0;
}
