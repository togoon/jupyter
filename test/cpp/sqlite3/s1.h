_Pragma("once")

#include <cstring>
#include <string>
#include <vector>
#include <map>

#include <sqlite3.h>

using namespace std;

const string KFEILD[] = { "index","SecurityID","TradeDate","Open","Close","High","Low","Vol","Amt","Amp","Increase","Chg","Tor" };

typedef struct sKdata
{
    vector<int> index;
    vector<string> SecurityID;
    vector<string> TradeDate;
    vector<float> Open;
    vector<float> Close;
    vector<float> High;
    vector<float> Low;
    vector<long> Vol;
    vector<float> Amt;
    vector<float> Amp;
    vector<float> Increase;
    vector<float> Chg;
    vector<float> Tor;
} sKdata;

class Khist
{
public:

    Khist(const string strDb, const string strTab, const string strCode);

    Khist(const Khist&) {};
    Khist& operator=(const Khist&) { return *this; };

    ~Khist();

    int OpenDb();
    int QueryDB(const string strSql);
    int QueryFieldType(const string strTab);


    map<string, string> GetFiledType();
    sKdata GetKData();
    vector<string> split(string str, string separator);

private:
    string m_strDb;
    string m_strTab;
    string m_strCode;

    sqlite3* m_pDb;

    map<string, string> m_mFieldType;
    vector<string> m_vField, m_vType;
    sKdata m_sKdata;

    map<string, vector<float> > m_mapVect;

};

