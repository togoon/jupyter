#!/bin/bash

ps aux | grep logic | grep -v grep | awk '{print $2}'| xargs kill -9
