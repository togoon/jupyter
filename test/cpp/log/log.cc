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