#!/usr/bin/env bash

# Kill previous running version
PID_COLLECTOR=$( eval ps -A -o pid= -o args= | grep jupyter | grep -v grep | awk -F' ' '{ print $1 }' )
echo $PID_COLLECTOR
if [[ -z "$PID_COLLECTOR" ]]; then
        echo "NO PID! No jupyter instance running"
    else
        echo "$PID_COLLECTOR : jupyter instance killed"
        kill -9 $PID_COLLECTOR
        exit
fi
#