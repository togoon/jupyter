#!/bin/bash

ps aux | grep testmulti | grep -v grep | awk '{print $2}'| xargs kill -9

