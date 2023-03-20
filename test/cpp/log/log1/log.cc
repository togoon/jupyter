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

static int printfToBuffer(char* buffer, int size, char* format, ...)
{
    va_list ap;
    va_start(ap, format);
    int ret = vsnprintf(buffer, 100, format, ap);
    va_end(ap);
    return ret;
}

static int getSystemTime(char* timeBuffer)
{
    if(!timeBuffer)
    {
        return -1;
    }

    SYSTEMTIME localTime;
    GetLocalTime(&localTime);
    char *format = "[%04d-%02d-%02d %02d:%02d:%02d.%03d]";
    int ret = printfToBuffer(timeBuffer, 100, format, localTime.wYear, localTime.wMonth, localTime.wDay, localTime.wHour, localTime.wMinute, localTime.wSecond, localTime.wMilliseconds);
    return ret;
}

int LOG::writeLog(LOGLEVEL loglevel, unsigned char *fileName, unsigned char* function, int lineNumber, char* format, ...)
{
    int ret = 0;
    EnterCriticalSection(&criticalSection);
    char timeBuffer[100];
    ret = getSystemTime(timeBuffer);
    logBuffer += string(timeBuffer);

    char *logLevel;
    if(loglevel == LOG_LEVEL_DEBUG)
    {
        logLevel = "DEBUG";
    }
    else if(loglevel == LOG_LEVEL_INFO)
    {
        logLevel = "INFO";
    }
    else if(loglevel == LOG_LEVEL_WARNING)
    {
        logLevel = "WARNING";
    }
    else if(loglevel == LOG_LEVEL_ERROR)
    {
        logLevel = "ERROR";
    }

    char locInfo[100];
    char *format2 = "[PID:%4d][TID:%4d][%s][%-s][%s:%4d]";
    ret = printfToBuffer(locInfo, 100, format2, GetCurrentProccessId(), GetCurrentThreadId(), logLevel, fileName, function, lineNumber);
    logBuffer += string(locInfo);

    char logInfo2[256];
    va_list ap;
    va_start(ap, format);
    ret = vsnprintf(logInfo2, 256, format, ap);
    va_end(ap);

    logBuffer += string(logInfo2);
    logBuffer += string("\n");
    writtenSize += logBuffer.length();
    outputToTarget();
    LeaveCriticalSection(&criticalSection);

    return 0;
}

void LOG::outputToTarget()
{
    if(LOG::getInstance()->getLogTarget() & LOG_TARGET_FILE)
    {
        SetFilePointer(mFileHandle, 0, NULL, FILE_END);
        DWORD dwBytesWritten = 0;
        WriteFile(mFileHandle, logBuffer.c_str(), logBuffer.length(), &dwBytesWritten, NULL);
        FLushFileBuffers(mFileHandle);
    }

    if(LOG::getInstance()->getLogTarget() & LOG_TARGET_CONSOLE)
    {
        printf("%s", logBuffer.c_str());
    }

    logBuffer.clear();
}

