#!/bin/bash

ps aux | grep sr_min | grep -v grep | awk '{print $2}'| xargs kill -9
