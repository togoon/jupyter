#include "log.h"

LOG *LOG::Log = NULL;
string LOG::logBuffer = "";
HANDLE LOG::mFileHandle = INVAILD_HANDLE_VALUE;
muter LOG::log_mutex;
CRITICAL_SECTION LOG::criticalsection;
int LOG::writtenSize = 0;

LOG::LOG()
{
    init(LOG_LEVEL_NONE, LOG_TARGET_FILE);
}

void LOG::init(LOGLEVEL loglevel, LOGTARGET logtarget)
{
    setLogLevel(loglevel);
    setLogTarget(logtarget);
    InitializeCriticalSection(&criticalSection);
    createFile();
}

void LOG::uninit()
{
    if(INVALID_HANDLE_VALUE != mFileHandle)
    {
        CloseHandle(mFileHandle);
    }
    DeleteCriticalSection(&criticalSection);
}

LOG* LOG::getInstance()
{
    if(NULL == Log)
    {
        log_mutex.lock();
        if(NULL == Log)
        {
            Log = new LOG();
        }
        log_mutex.unlock();
    }
    return Log;
}

LOGLEVEL LOG::getLogLevel()
{
    return this->LogLevel;
}

void LOG::setLogLevel(LOGLEVEL iLogLevel)
{
    this->logLevel = iLogLevel;
}

LOGTARGET LOG::getLogTarget()
{
    return this->logTarget;
}

void LOG::setLogTarget(LOGTARGET iLogTarget)
{
    this->logTarget = iLogTarget;
}

int LOG::createFile()
{
    TCHAR fileDirectory[MAX_PATH];
    GetCurrentDirectory(MAX_PATH, fileDirectory);

    TCHAR logFileDirectory[256];
    _stprintf_s(logFileDirectory, _T("%s\\Log\\"), fileDirectory);

    if(_taccess(logFileDirectory,0) == -1)
    {
        _tmkdir(logFileDirectory);
    }

    WCHAR moduleFileName[MAX_PATH];
    GetModuleFileName(NULL, moduleFileName, MAX_PATH);
    PWCHAR p = wcsrchr(moduleFileName, _T('\\'));
    p++;

    for (int i = _tcslen(p); i > 0; i--)
    {
        if(p[i]==_T('.'))
        {
            p[i] = _T('\0');
            break;
        }
    }
    WCHAR pszLogFileName[MAX_PATH];
    _stprintf_s(pszLogFileName, _T("%s%s.log"), logFileDirectory, p);

    mFileHandle = CreateFile(pszLogFileName, GENERIC_READ | GENERIC_WRITE, FILE_SHARE_READ, NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);

    if(INVALID_HANDLE_VALUE==mFileHandle)
    {
        return -1;
    }
    return 0;
}