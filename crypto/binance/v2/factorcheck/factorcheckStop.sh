#!/bin/bash

ps aux | grep factorcheck | grep -v grep | awk '{print $2}'| xargs kill -9
