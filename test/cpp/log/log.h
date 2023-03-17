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
#define LOG_DEBUG(...)  LOG::writeLog(LOG_LEVEL_DEBUG, (unsigned char*)(FILENAME(__FILE__)), (unsigned char*)(__FUNCTION__), (int)(__LINE__), __VA_ARGS__)
#define LOG_DEBUG(...)  LOG::writeLog(LOG_LEVEL_DEBUG, (unsigned char*)(FILENAME(__FILE__)), (unsigned char*)(__FUNCTION__), (int)(__LINE__), __VA_ARGS__)











