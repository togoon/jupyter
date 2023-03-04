#!/bin/sh
#------------------------------------------
#[Author] LeiXueWei@JueJin/CSDN
#         OneScriptToEnsurePython&StartHTTPServer to serve 'ui' folder
#------------------------------------------

DIR=$(cd "$(dirname "$0")"; pwd)

export WEB=${DIR}/ui
export PY_VERSION=$(python -c 'import sys; print(sys.version_info[:1])')

function ensurePythonForCentos8(){
    if [ "${PY_VERSION}" == "" ] ; then
        echo "[Python检查] 没有找到python，设置python3"
        sudo dnf install python3
        sudo alternatives --set python /usr/bin/python3
        export PY_VERSION=$(python -c 'import sys; print(sys.version_info[:1])')
        echo "PY_VERSION: ${PY_VERSION}"
    else
        echo "Current python: ${PY_VERSION}"
    fi
}

function makeWeb(){
    echo "[默认站点生成] will genearte a default site"
    #web变量值为目标ui文件的目录（即包含index.html)目录
    if [ ! -e "${WEB}" ] ; then
        mkdir -p ${WEB}    
    fi
    echo "Generating index page"
    index=${WEB}/index.html
    if [ -f "${index}" ] ; then
        echo "locate ${index}"
        return
    fi
    cat > ${index} <<EOF
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>持续学习持续开发，我是雷学委</title>
     </head>
     <body>
         <h1>我是雷学委，我在CSDN/JueJin/知乎/B站！</h1>
         <h2><a href='file://${WEB}'>${WEB}</a></h2>
     </body>
</html>
EOF
}

function ensureStopSh(){
    leiXueWeiStopSh=${DIR}/stop.sh
    cat > ${leiXueWeiStopSh}<<EOF
#!/bin/sh
#--created by LeiXueWei@CSDN/JUEJIN/BILIBILI
#--------------

ps -ef|grep -i python|grep 'server'
ps -ef|grep -i python|grep 'server'|awk -F" " '{print \$2}'|xargs kill -9
EOF
    chmod 744 ${leiXueWeiStopSh} 
}

echo "Create logs dir ${DIR}/logs"
mkdir -p "${DIR}/logs"
log=${DIR}/logs/server.log
#备份日志
TIMESTAMP=`date +'%Y-%M-%d_%H%M%S'`
mv ${log} ${log}${TIMESTAMP}
echo "backup logs ${log}"

#检查并设置默认python
ensurePythonForCentos8
#生成默认的首页
makeWeb

cd ${WEB}

#判断当前python 版本
if [ "${PY_VERSION}" == "(3,)" ] ; then
    nohup python -m http.server 80 > ${log} 2>&1 &
else
    nohup python -m SimpleHTTPServer 80 > ${log} 2>&1 &
fi
