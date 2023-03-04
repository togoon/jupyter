#！/bin/bash

# echo $1

full2half(){
    # 全角转半角 双字节字符转单字节 full2half
    sed -i 's/：/:/g' $1
    sed -i 's/；/;/g' $1
    sed -i 's/！/!/g' $1
    sed -i 's/。/. /g' $1
    sed -i 's/，/, /g' $1
    sed -i 's/、/, /g' $1
    sed -i 's/？/?/g' $1
    sed -i 's/％/%/g' $1
    sed -i 's/（/(/g' $1
    sed -i 's/）/)/g' $1
    sed -i 's/《/</g' $1
    sed -i 's/》/>/g' $1
    sed -i 's/［/[/g' $1
    sed -i 's/］/]/g' $1
    sed -i 's/【/[/g' $1
    sed -i 's/】/]/g' $1
    sed -i 's/　/ /g' $1
    sed -i 's/“/"/g' $1
    sed -i 's/”/"/g' $1
    sed -i "s/‘/'/g" $1
    sed -i "s/’/'/g" $1

    # 删除 行尾空格 制表符
    sed -i 's/[ \t]*$//g'

    # 删除 行首空格 sed -i 's/^[ \t]*//g'

    # 多个空行合并单个空行
    sed -rni 'h;n;:a;H;n;$!ba;g;s/(\n){2,}/\n\n/g;p' input
}

if [ -d $1 ] ; then
	for file in `ls -A $1` ; do
        if [ -f $1/$file ] ; then
            full2half $1/$file
        fi
	done
else
    if [ -f $1 ] ; then
        full2half $1
    fi
fi

