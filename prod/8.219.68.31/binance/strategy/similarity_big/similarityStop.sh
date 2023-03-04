#!/bin/bash

ps aux | grep similarity_big | grep binance | grep -v grep | awk '{print $2}'| xargs kill -9
