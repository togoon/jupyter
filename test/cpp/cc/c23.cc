#include <stdio.h>
#include <string.h>

/**
* @brief 调用终端并获取执行结果
* 
* @param[in] cmd 命令内容
* @param[out] result 保存结果的地址
* @return 0或1 执行状态，失败或成功 
*/
int exec(const char *cmd, char *result)
{
#if defined(_WIN32) || defined(_WIN64)
	char _cmd[1024] = "cd /d C:/Windows/System32&&";
	strcat(_cmd, cmd);
	FILE *pipe = popen(_cmd, "r");
#elif defined(__linux__)
	FILE *pipe = popen(cmd, "r");
#endif
	if(!pipe)
		return 0;
	
	char buffer[128] = {0};
	while(!feof(pipe))
	{
		if(fgets(buffer, 128, pipe))
			strcat(result, buffer);
	}
	pclose(pipe);
	return 1;
}

int main()
{
	char result[1024];
	exec("ping -n 1 wengcx.top", result); // linux下使用-c替换-n  
	printf("%s", result);

	return 0;
}