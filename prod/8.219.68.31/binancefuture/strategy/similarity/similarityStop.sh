#!/bin/bash

ps aux | grep similarity | grep binancefuture | grep -v grep | awk '{print $2}'| xargs kill -9
