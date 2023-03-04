#!/bin/bash

ps aux | grep testtrade1 | grep -v grep | awk '{print $2}'| xargs kill -9
