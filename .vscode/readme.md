

# 预定义变量 Predefined variables

${userHome} - /home/your-username  - the path of the user's home folder
${workspaceFolder} - /home/your-username/your-project - 当前工作目录(根目录) the path of the folder opened in VS Code
${workspaceFolderBasename} - your-project - 当前文件的父目录 the name of the folder opened in VS Code without any slashes (/)
${file} - /home/your-username/your-project/folder/file.ext - 当前打开的文件名(完整路径) the current opened file
${fileWorkspaceFolder}  - /home/your-username/your-project - the current opened file's workspace folder
${relativeFile}  - folder/file.ext - 当前根目录到当前打开文件的相对路径(包括文件名) the current opened file relative to workspaceFolder
${relativeFileDirname} - folder - 当前根目录到当前打开文件的相对路径(不包括文件名) the current opened file's dirname relative to workspaceFolder
${fileBasename} - file.ext - 当前打开的文件名(包括扩展名) the current opened file's basename
${fileBasenameNoExtension}  - file - 当前打开的文件名(不包括扩展名) the current opened file's basename with no file extension
${fileExtname} - .ext - 当前打开文件的扩展名 the current opened file's extension
${fileDirname} - /home/your-username/your-project/folder - 当前打开文件的目录  the current opened file's folder path
${fileDirnameBasename} - the current opened file's folder name
${cwd} - 启动时task工作的目录 the task runner's current working directory upon the startup of VS Code
${lineNumber} - line number of the cursor - 当前激活文件所选行 the current selected line number in the active file
${selectedText}  - text selected in your code editor - 当前激活文件中所选择的文本 the current selected text in the active file
${execPath} - location of Code.exe - vscode执行文件所在的目录 the path to the running VS Code executable
${defaultBuildTask} - 默认编译任务(build task)的名字 the name of the default build task
${pathSeparator}  - / on macOS or linux, \ on Windows - the character used by the operating system to separate components in file paths


# cpp debug

## task.json
```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "type": "shell",
            "label": "g++ build active file",
            "command": "/usr/bin/g++",
            "args": [
                "-g",
                "${file}",
                "-lpthread", 
                "-o",
                "${fileDirname}/${fileBasenameNoExtension}"
            ],
            "options": {
                "cwd": "/usr/bin"
            },
            "problemMatcher": [
                "$gcc"
            ],
            "group": {
                "kind": "build",
                "isDefault": true
            }
        }
    ]
}

```

## launch.json
```json
{
    "version": "0.2.0",
    "configurations": [
        {
        "name": "g++ build and debug active file",
        "type": "cppdbg",
        "request": "launch",
        "program": "${fileDirname}/${fileBasenameNoExtension}",
        "args": [],
        "stopAtEntry": false,
        "cwd": "${workspaceFolder}",
        "environment": [],
        "externalConsole": false,
        "MIMode": "gdb",
        "setupCommands": [
            {
            "description": "Enable pretty-printing for gdb",
            "text": "-enable-pretty-printing",
            "ignoreFailures": true
            }
        ],
        "preLaunchTask": "g++ build active file",
        "miDebuggerPath": "/usr/bin/gdb"
        }
    ]
}

```
