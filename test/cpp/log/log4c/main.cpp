#include "MyLogger.h"

int main(int argc, char *argv[])
{
    MyLogger * myLoger = NULL;
    myLoger = MyLogger::getInstance();

    LOG4CPLUS_FATAL(myLoger->m_loggerYW, "DeleteService failed,errCode=[" << 2 << "]");
    LOG4CPLUS_DEBUG(myLoger->m_loggerWJ, " Service is removed");
    LOG4CPLUS_DEBUG(myLoger->m_loggerUI, " Service ");
    
    return 0;
}