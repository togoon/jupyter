#ifndef __LOG_H__
#define  __LOG_H__

#include <stdio.h>
// #include <Windows.h>
#include <iostream>
// #include <TCHAR.H>
#include <mutex>

using namespace std;

enum LOGLEVEL
{
    LOG_LEVEL_NONE,
    LOG_LEVEL_ERROR,
    LOG_LEVEL_WARNING,
    LOG_LEVEL_DEBUG,
    LOG_LEVEL_INFO,
};

enum LOGTARGET
{
    LOG_TARGET_NONE = 0x00,
    LOG_TARGET_CONSOLE = 0x01,
    LOG_TARGET_FILE = 0x10,
};

#define FILENAME(x) strrchr(x,'\\') ? strrchr(x, '\\')+1:x
#define LOG_DEBUG(...)  LOG::writeLog(LOG_LEVEL_DEBUG, (unsigned char*)(FILENAME(__FILE__)), (unsigned char*)(__FUNCTION__), (int)(__LINE__), __VA_ARGS__)
#define LOG_INFO(...)  LOG::writeLog(LOG_LEVEL_INFO, (unsigned char*)(FILENAME(__FILE__)), (unsigned char*)(__FUNCTION__), (int)(__LINE__), __VA_ARGS__)
#define LOG_WARNING(...)  LOG::writeLog(LOG_LEVEL_WARNING, (unsigned char*)(FILENAME(__FILE__)), (unsigned char*)(__FUNCTION__), (int)(__LINE__), __VA_ARGS__)
#define LOG_ERROR(...)  LOG::writeLog(LOG_LEVEL_ERROR, (unsigned char*)(FILENAME(__FILE__)), (unsigned char*)(__FUNCTION__), (int)(__LINE__), __VA_ARGS__)
#define LOG_DEBUG(...)  LOG::writeLog(LOG_LEVEL_DEBUG, (unsigned char*)(FILENAME(__FILE__)), (unsigned char*)(__FUNCTION__), (int)(__LINE__), __VA_ARGS__)

#define ENTER() LOG_INFO("enter")
#define EXIT() LOG_INFO("exit")
#define FAIL() LOG_INFO("fail")

// 单个日志文件最大存储
#define MAX_SIZE 2*1024*1024 //2M

class LOG
{
public:
    void init(LOGLEVEL loglevel, LOGTARGET logtarget);
    void uninit();
    int createFile();
    static LOG *getInstance();
    LOGLEVEL getLogLevel();
    void setLogLevel(LOGLEVEL loglevel);
    LOGTARGET getLogTarget();
    void setLogTarget(LOGTARGET logtarget);
    
}
