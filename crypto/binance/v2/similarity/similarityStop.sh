#!/bin/bash

ps aux | grep testStrategy | grep -v grep | awk '{print $2}'| xargs kill -9
