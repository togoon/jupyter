string ConfigFileRead() 
{
    ifstream configFile;
    string path = "../conf/setting.conf";
    configFile.open(path.c_str());
    string strLine;
    string filepath;
    if(configFile.is_open())
    {
        while (!configFile.eof())
        {
            getline(configFile, strLine);
            size_t pos = strLine.find('=');
            string key = strLine.substr(0, pos);
                    
            if(key == "filepath")
            {
                filepath = strLine.substr(pos + 1);            
            }            
        }
    }
    else
    {
        cout << "Cannot open config file!" << endl;
    }
    
    return filepath;
}

void ConfigFileRead( map<string, string>& m_mapConfigInfo )
{
    ifstream configFile;
    string path = "../conf/setting.conf";
    configFile.open(path.c_str());
    string str_line;
    if (configFile.is_open())
    {
        while (!configFile.eof())
        {
            getline(configFile, str_line);
            if ( str_line.find('#') == 0 ) //过滤掉注释信息，即如果首个字符为#就过滤掉这一行
            {
                continue;
            }    
            size_t pos = str_line.find('=');
            string str_key = str_line.substr(0, pos);
            string str_value = str_line.substr(pos + 1);
            m_mapConfigInfo.insert(pair<string, string>(str_key, str_value));
        }
    }
    else
    {    
        cout << "Cannot open config file setting.ini, path: ";
        exit(-1);
    }
}


需要获取配置信息的时候可以通过：

    map<string, string>::iterator iter_configMap;
    iter_configMap = m_mapConfigInfo.find("path");
    m_strBaseInputPath = iter_configMap->second;
-------------------------------------------------------------------------------------------------------------

补充：

后面用CPPcheck检查代码的时候发现提示.find() 函数的效率不高，建议改为.compare()，即:

 if ( str_line.compare(0, 1, "#") == 0 )
 {
      continue;
 }    


  found=str.find(str2);
  if (found!=string::npos)
    cout << "first 'needle' found at: " << int(found) << endl;


一、Windows提供了几种方式对文件和目录进行监控，包括：FindFirstChangeNotification、ReadDirectoryChangesW、变更日志(Change Journal)等。
（1）FindFirstChangeNotification函数，可以监控到目标目录及其子目录中所有文件的变化，但不能监控到具体是哪一个文件发生改变。
（2）ReadDirectoryChangesW 能监控到目标目录下某一文件发生改变，并且可以知道发生变化的是哪一个文件。
注意，FindFirstChangeNotification 和 ReadDirectoryChangesW 是互斥的，不能同时使用。
（3）变更日志(Change Journal)可以跟踪每一个变更的细节，即使你的软件没有运行。很帅的技术，但也相当难用。

二、ReadDirectoryChangesW定义说明

ReadDirectoryChangesW 是Windows提供一个API，用于读取文件夹的磁盘变更。该API很实用，目前市面上已知的所有运行在用户态同步应用，都绕不开这个接口。但正确使用该API相对来说比较复杂，该接口能真正考验一个Windows开发人员对线程、异步IO、可提醒IO、IO完成端口等知识的掌握情况，如果读者还不熟悉这些技术，请先补充一下相关背景知识。

