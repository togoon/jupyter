#!/bin/bash

ps aux | grep s_rsrs | grep -v grep | awk '{print $2}'| xargs kill -9
