#include <stdio.h>
#include <string>
#include <vector>
#include <iostream>

// #include <iostream>

using namespace std;

void SplitString(const string &s, vector<string> &v, const string &c)
{
	string::size_type pos1, pos2;
	pos2 = s.find(c);
	pos1 = 0;
	while (string::npos != pos2)
	{
		v.push_back(s.substr(pos1, pos2 - pos1));

		pos1 = pos2 + c.size();
		pos2 = s.find(c, pos1);
	}
	if (pos1 != s.length())
		v.push_back(s.substr(pos1));
}

int getFileMD5(string strFpath, string &strMD5)
{
	string cmd = "certutil -hashfile  \""; //chcp 65001 &&
	cmd += strFpath + "\" MD5";

	string strBuf;

	FILE *pipe = popen(cmd.c_str(), "r");
	if (!pipe)
		return 0;
	char buffer[128] = {0};

	while (!feof(pipe))
	{
		if (fgets(buffer, 128, pipe))
			strBuf += buffer;
		// strcat(strMD5, buffer);
	}
	pclose(pipe);

	vector<string> vBuf;
	SplitString(strBuf, vBuf, "\n"); //可按多个字符来分隔;

	strMD5 = vBuf[1];

	// for (vector<string>::size_type i = 0; i != vBuf.size(); ++i)
	// 	cout << i << vBuf[i] << " " << endl;

	return 0;
}

int writeMD5(string &strMD5, string &strPath, string &strfile)
{
	string strMD5Path = strPath + "MD5.txt";
	FILE *fp = fopen(strMD5Path.c_str(), "w");
	if (fp == NULL)
	{
		printf("文件不存在，结束");
		exit(0);
	}
	else
	{

		fprintf(fp, "\n%s \t%s\n", strMD5.c_str(), strMD5Path.c_str());
	}

	return 0;
}

int main()
{
	string strMD5;
	string strPath = "C:/notes/c";
	string strFile = "c1.cc";
	string strFpath = strPath + "/" + strFile;

	// printf("\n%s \n", strFpath);
	getFileMD5(strFpath, strMD5);

	printf("\n%s \t%s\n", strMD5.c_str(), strFile.c_str());

	return 0;
}
