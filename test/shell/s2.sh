
FILE_THIS="/var/tmp/this.txt"
FILE_LAST="/var/tmp/last.txt"
FOLDER="/var/tmp/aaa/"

while :; do
    if [ -e "$FILE_THIS" ]; then
        mv "$FILE_THIS" "$FILE_LAST"
        ls "$FOLDER" > "$FILE_THIS"
        diff "$FILE_THIS" "$FILE_LAST"
        if [ $? == 0 ]; then
            echo Not changed
        else
            echo Changed
        fi
    else
        ls "$FOLDER" > "$FILE_THIS"
    fi
    # 可以通过调整sleep的时间来更改监控频率
    sleep 5
