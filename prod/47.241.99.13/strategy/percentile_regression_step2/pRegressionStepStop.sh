#!/bin/bash

ps aux | grep percentile_regreession_step2 | grep -v grep | awk '{print $2}'| xargs kill -9
