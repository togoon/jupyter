#!/bin/bash

ps aux | grep modifiedmom | grep -v grep | awk '{print $2}'| xargs kill -9
