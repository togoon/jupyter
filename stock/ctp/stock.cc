#include "stock.h"

int main(int argc, char* argv[])
{
    int ret = 0;

    // stock* pStock = new stock();
    stock* pStock = new stock(100, 30);

    pStock->setVecPrice(1.01, 1.2);
    pStock->setVecPrice(2.01, 2.0);
    pStock->setVecPrice(3.01, 3.0);

    double dAvg = pStock->getAvg();

    cout << "dAvg: " << dAvg << endl;

    vector<double> vPrice = pStock->getVecPrice();
    vector<double> vTimeStamp = pStock->getVecTimeStamp();

    cout << "vPrice size: " << vPrice.size() << endl;
    cout << "vTimeStamp size: " << vTimeStamp.size() << endl;

    for (int i = 0; i < vPrice.size(); i++)
    {
        cout << "vTimeStamp[" << i << "]: " << vTimeStamp[i] << ": vPrice[" << i << "]: " << vPrice[i] << endl;
    }

    delete pStock;

    return 0;
}

stock::stock()
{
    num_bin = 100;
    window = 30.0;
    m_dSum = 0.0;
    m_dAvg = 0.0;
    m_vPrice.clear();
    m_vTimeStamp.clear();
}

stock::stock(int num_bin, double window)
{
    this->num_bin = num_bin;
    this->window = window;
    m_dSum = 0.0;
    m_dAvg = 0.0;
    m_vPrice.clear();
    m_vTimeStamp.clear();
}

void stock::setSum()
{
    if (m_vPrice.empty())
    {
        m_dSum = 0.0;
    }
    else
    {
        m_dSum = accumulate(begin(m_vPrice), end(m_vPrice), 0.0);
    }
}

double stock::getSum()
{
    return m_dSum;
}

void stock::setAvg()
{
    if (m_vPrice.empty())
    {
        m_dAvg = 0.0;
    }
    else
    {
        m_dAvg = m_dSum / m_vPrice.size();
    }
}

double stock::getAvg()
{
    return m_dAvg;
}

void stock::setMinDif()
{
    m_dMinDif = m_dAvg;
    m_index = 0;

    for (int i = 0; i < m_vPrice.size() - 1; i++)
    {
        double dif = abs(m_vPrice[i] - m_dAvg);
        if (dif < m_dMinDif)
        {
            m_dMinDif = dif;
            m_index = i;
        }

    }
}

void stock::setVecPrice(double dTimestamp, double dPrice)
{
    if (m_vPrice.empty())
    {
        m_vPrice.push_back(dPrice);
        m_vTimeStamp.push_back(dTimestamp);

        m_dSum = dPrice;
        m_dAvg = dPrice;

        setMinDif();
    }
    else
    {

        for (int i = 0; i < m_vPrice.size(); i++)
        {
            if (m_vTimeStamp[i] < dTimestamp - window)
            {
                m_vPrice.erase(m_vPrice.begin() + i);
                m_vTimeStamp.erase(m_vTimeStamp.begin() + i);
                i--;
            }
        }

        if (m_vPrice.empty())
        {
            m_vPrice.push_back(m_dAvg);
            m_vTimeStamp.push_back(dTimestamp);
        }

        if (m_vPrice.size() >= num_bin)
        {
            m_vPrice.erase(m_vPrice.begin() + m_index);
            m_vTimeStamp.erase(m_vTimeStamp.begin() + m_index);
        }

        m_vPrice.push_back(dPrice);
        m_vTimeStamp.push_back(dTimestamp);

        setSum();
        setAvg();
        setMinDif();
    }
}

vector<double> stock::getVecPrice()
{
    return m_vPrice;
}

vector<double> stock::getVecTimeStamp()
{
    return m_vTimeStamp;
}
