#include <stdio.h>
#include <string.h>

// #include <iostream>

int exec(const char *fpath, char *result)
{
    char cmd[1024] = "chcp 65001 && certutil -hashfile ";
    // strcat(cmd, " \" ");
    strcat(cmd, fpath);
    // strcat(cmd, " \" ");
    strcat(cmd, " MD5");

    FILE *pipe = popen(cmd, "r");
    if (!pipe)
        return 0;
    char buffer[128] = {0};
    while (!feof(pipe))
    {
        if (fgets(buffer, 128, pipe))
            strcat(result, buffer);
    }
    pclose(pipe);

    printf("\n%s \n", cmd);
    return 1;
}

int main()
{
    // setlocale(LC_ALL, "");

    char result[1024];
    // exec("certutil -hashfile c1.cc MD5", result);  C:\notes\c\c1.cc
    char fpath[100] = "\"C:\\notes\\c\\c1.cc\"";
    // char fpath[100] = "C:/notes/c1.cc";

    printf("\n%s \n", fpath);
    // exec(fpath, result);
    exec("certutil -hashfile \"C:\\Users\\u726334\\OneDrive - Finastra\\文档\\Working\\notes\\c\\c1.cc\" MD5", result);
    printf("\n%s \n", result);
    printf("\n%s \n", fpath);
    return 0;
}