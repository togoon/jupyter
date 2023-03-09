# echo `date '+%Y-%m-%d %H:%M:%S'` >> /workspaces/jupyter/tmp/test.log 2>&1

# if ps -elf | grep -w jupyter | grep -v grep > /dev/null ; then # 检测进程是否存在 $? 1存在 0不存在
#   echo "jupyter进程存在"
# else
#   echo "jupyter进程不存在"
# fi

# if ps -elf | grep -w notebook | grep -v grep > /dev/null  ; then  # 检测进程是否存在 $? 1存在 0不存在
#   echo "notebook进程存在"
# else
#   echo "notebook进程不存在"
# fi

