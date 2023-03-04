#!/bin/bash

ps aux | grep pyemd2 | grep -v grep | awk '{print $2}'| xargs kill -9
