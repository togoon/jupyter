#include <stdio.h>
#include <string>
#include <vector>
#include <iostream>

// #include <iostream>

using namespace std;

void SplitString(const string &s, vector<string> &v, const string &c);
int getFileMD5(string strFpath, string &strMD5);
int writeMD5(string &strMD5, string &strPath, string &strfile, string &strFileMd5);

int main()
{
	string strMD5;
	string strMD5File = "MD5.txt";
	string strPath = "C:/notes/c";
	string strFile = "RFRHO.txt";
	string strFpath = strPath + "/" + strFile;

	string strFileMd5 = "RFRHO.md5";

	getFileMD5(strFpath, strMD5);
	writeMD5(strMD5, strPath, strFile, strFileMd5); // strMD5File  strFileMd5

	cout << "strMD5: " << strMD5 << " strFile: " << strFile << endl;

	return 0;
}

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

int writeMD5(string &strMD5, string &strPath, string &strfile, string &strFileMd5)
{
	string strMD5Path = strPath + "/" + strFileMd5;
	FILE *fp = fopen(strMD5Path.c_str(), "w");
	if (fp == NULL)
	{
		printf("文件不存在，结束");
		exit(0);
	}
	else
	{
		// printf("\n%s \t%s \t%s\n", strMD5.c_str(), strMD5Path.c_str(), strfile.c_str());
		fprintf(fp, "%s\t%s\n", strMD5.c_str(), strfile.c_str());
	}

	return 0;
}
