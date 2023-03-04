#!/bin/bash

ps aux | grep amihud | grep -v grep | awk '{print $2}'| xargs kill -9
