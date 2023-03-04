# Git

Gitlab.myhexin.com huangwenrong Pai6

git clone http://*.git
Git branch feature/dev_hwr
Git checkout origin feature/dev_hwr
Git push origin feature/dev_hwr

Git log --follow -p client/build/mfc.dll

Git add web/tactics/public/新股申购cef/page
Git commit -am  “Quants-30617 新股申购”
Git push origin feature/dev_hwr

Git rever -n 6cb046c81

# git日常操作
一、第一次clone代码

// 新建一个自己的分支，并提交到远程git上
1. git clone 【项目地址】
2. cd 【项目地址】(进入项目)
3. git checkout -b dev_xxx (新建并切换到自己分支)
4. git push origin dev_xxx(把dev_xxx推送到远程)

二、日常开发

1. git pull origin develop(先拉取远程主分支)
2. 开发
3. git checkout -b feature/xxx (新建并切换到自己分支)
4. git add .
5. git commit -m "提交"
6. git push origin feature/xxx(把feature/xxx推送到远程)

三、辅助命令

1. git fetch origin develop # 本地获取远程提交，比pull更友好
2. git cherry-pick commitid # 挑选提交到当前分支
3. git revert commitid # 回退指定提交
4. git checkout . # 丢弃本地工作区所有更改



# git如何新建分支
1) 切换到基础分支，如主干
git checkout master
2）创建并切换到新分支
git checkout -b panda
git branch可以看到已经在panda分支上
3)更新分支代码并提交
git add *
git commit -m "init panda"
git push origin panda


Git命令行添加整个文件夹及目录
git add 文件夹/            添加整个文件夹及内容
git add *.文件类型       添加目录中所有此文件类型的文件
git放弃本地修改：
放弃所有修改
git checkout .
放弃某个文件的修改
git checkout -- filepathname


# Git高级教程，常见工程问题笔记
1、一个分支的内容完全替换成另一个分支的内容
一般来说，我们会在develop开发，master保留干净的发布版本。但是有的时候需要重构代码，老的代码（masger）还在使用，这个时候需要整体上新的重构代码。
git checkout master
git reset --hard develop  //先将本地的master分支重置成develop
git push origin master --force //再推送到远程仓库
2、通过Tag标签回退版本修复bug
中括号里是版本号或者名称，需要自己修改
1.查看标签的版本，即版本回退
git tag 
git show [tag_name]
git reset --hard [commend id]
2.拉取当前分支
git checkout -b [branch_name]
3.主干回复到最新位置
git checkout master
git reflog
git reset --hard [commend id]
4.切换到分支，修改bug,然后再合并到主干，重新打标签
3、git一次性添加所有已经修改的文件
git add -u
-u --update 更新跟踪的文件

4.忽略文件.gitignore
文件 .gitignore 的格式规范如下：
• 所有空行或者以 ＃ 开头的行都会被 Git 忽略。
• 可以使用标准的 glob 模式匹配。
• 匹配模式可以以（/）开头防止递归。
• 匹配模式可以以（/）结尾指定目录。
• 要忽略指定模式以外的文件或目录，可以在模式前加上惊叹号（!）取反。
所谓的 glob 模式是指 shell 所使用的简化了的正则表达式。 星号（*）匹配零个或多个任意字符；[abc] 匹配
25任何一个列在方括号中的字符（这个例子要么匹配一个 a，要么匹配一个 b，要么匹配一个 c）；问号（?
）只匹配一个任意字符；如果在方括号中使用短划线分隔两个字符，表示所有在这两个字符范围内的都可以匹配
（比如 [0-9] 表示匹配所有 0 到 9 的数字）。 使用两个星号（*) 表示匹配任意中间目录，比如`a/**/z` 可以匹
配 a/z, a/b/z 或 `a/b/c/z`等。

5.跳过使用暂存区域 
尽管使用暂存区域的方式可以精心准备要提交的细节，但有时候这么做略显繁琐。 Git 提供了一个跳过使用暂
存区域的方式， 只要在提交的时候，给 git commit 加上 -a 选项，Git 就会自动把所有已经跟踪过的文件暂存
起来一并提交，从而跳过 git add 步骤
有时候这个命令很方便，省略了git add 
6.撤消操作
在任何一个阶段，你都有可能想要撤消某些操作。
有时候我们提交完了才发现漏掉了几个文件没有添加，或者提交信息写错了。 此时，可以运行带有 --amend 选
项的提交命令尝试重新提交：
$ git commit --amend
这个命令会将暂存区中的文件提交。
文本编辑器启动后，可以看到之前的提交信息。 编辑后保存会覆盖原来的提交信息。
例如，你提交后发现忘记了暂存某些需要的修改，可以像下面这样操作：
$ git commit -m 'initial commit'
$ git add forgotten_file
$ git commit --amend
最终你只会有一个提交 - 第二次提交将代替第一次提交的结果。
7.远端分支重命名
一、远端分支对应的本地分支名称修改
$ git branch -m 本地分支名称 新的本地分支名称
上面这个指令可以直接修改本地分支名称
二、删除远端分支
$ git push origin :本地分支名称
三、重新推送新的分支名
$ git push origin 新的本地分支名称
还以以使用下面的方法：
$ git remote rename <old_name> <new_name>
8.删除远端分支
$ git branch -r -d origin/分支名称
$ git push origin : 分支名称
还可以使用
$ git push -d origin 分支名称
git push [远程名] :[分支名]
9.还原某一文件
$ git checkout <hash> <filename>
$  git commit -m ""
10、创建空白分支并推送服务器
$ git checkout --orphan gh-pages
#创建一个orphan的分支，这个分支是独立的
11、从命令行创建一个新的仓库
git init 
git add .
git commit -m ""
git remote add origin http://192.168.5.5:30000/name/*.git
git push -u origin master
如果在界面创建的可用命令行直接推送到已经创建的仓库
git remote add origin http://192.168.5.5:30000/name/*.git
git push -u origin master


# git add 文件
方法一 git add 添加多个文件，文件之间以空格隔开
git add file1 file2 file3
方法二 多次git add
git add file1
git add file2
git add file2
方法三 添加指定目录下的文件
config目录下及子目录下所有文件，home目录下的所有.php文件
git config/*
git home/*.php
方法四 git add . 添加所有的文件， 或者 git add --all 添加所有的文件
git add .
git add --all
git add 文件夹
git add 文件夹名
git commit 提交到版本库
git add 目的是将修改文件由工作区提交到暂存区，可以多次提交
然后commit操作，将文件从暂存区提交到版本库
git commit -m "add new file"


# 常用git stash命令：
（1）git stash save "save message"  : 执行存储时，添加备注，方便查找，只有git stash 也要可以的，但查找时不方便识别。
（2）git stash list  ：查看stash了哪些存储
（3）git stash show ：显示做了哪些改动，默认show第一个存储,如果要显示其他存贮，后面加stash@{$num}，比如第二个 git stash show stash@{1}
（4）git stash show -p : 显示第一个存储的改动，如果想显示其他存存储，命令：git stash show  stash@{$num}  -p ，比如第二个：git stash show  stash@{1}  -p
（5）git stash apply :应用某个存储,但不会把存储从存储列表中删除，默认使用第一个存储,即stash@{0}，如果要使用其他个，git stash apply stash@{$num} ， 比如第二个：git stash apply stash@{1} 
（6）git stash pop ：命令恢复之前缓存的工作目录，将缓存堆栈中的对应stash删除，并将对应修改应用到当前的工作目录下,默认为第一个stash,即stash@{0}，如果要应用并删除其他stash，命令：git stash pop stash@{$num} ，比如应用并删除第二个：git stash pop stash@{1}
（7）git stash drop stash@{$num} ：丢弃stash@{$num}存储，从列表中删除这个存储
（8）git stash clear ：删除所有缓存的stash


# commit规范
模板

{任务ID task id} {类型 type} {标题}  // 第一行，以空格分隔
{提交说明 commit explaination} // 第二行及以下

说明

    类型(type)，必填，指的是提交类型，一次commit有且只能填一个类型。分别有以下几类

      feat：增加新功能
      fix：修复bug
      perf：提高性能的改动
      refactor：代码重构
      revert：代码回滚
      style：不影响代码含义的改动，例如去掉空格、改变缩进、增加换行
      docs：改动了文档相关的内容
      test：测试用例修改，包括单元测试、集成测试
      ci：与CI有关的改动
      build：外部依赖的改动，例如webpack，npm
      chore：构建过程或辅助工具的变动

    任务ID(task id)，填写各自部门使用的任务系统ID，一次commit最多只能填一个任务ID。当类型为feat、fix、perf、refactor、revert时，必须要填写任务ID；剩余的类型可以不填写任务ID。
    提交说明(commit explaination)，必填，主要说明清楚本次提交的主要目的等。



git commit -m "QUANTS-12345 feat 任务名          
修复导出数据报错的问题"


QUANTS-12345 feat 任务名          
修复导出数据报错的问题






