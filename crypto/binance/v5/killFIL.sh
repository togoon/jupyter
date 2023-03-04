ps aux | grep FIL | grep risk | grep -v grep | awk '{print $2}'| xargs kill -9
