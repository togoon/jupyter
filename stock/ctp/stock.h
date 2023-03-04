_Pragma("once")
#include <bits/stdc++.h>

#include <cmath>

using namespace std;

class stock
{
private:

    double timestamp;
    double window;

    vector<double> m_vTimeStamp;
    vector<double> m_vPrice;

    int num_bin;

    double m_dAvg;
    double m_dSum;
    double m_dMinDif;
    int m_index;

public:

    stock();
    stock(int num_bin, double window);
    void setSum();
    double getSum();
    void setAvg();
    double getAvg();
    void setMinDif();

    void setVecPrice(double dTimestamp, double dPrice);
    void setVecTimeStamp(double dTimestamp);

    vector<double> getVecPrice();
    vector<double> getVecTimeStamp();
};





