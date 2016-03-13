#!/bin/bash

HOST=$(hostname)

./swap_guard.sh > "swap_guard_$HOST.log" 2>&1 &
