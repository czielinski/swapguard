#!/bin/bash
#
# Watch a command and terminate it if it starts to swap.
# Useful for memory intensive scientific calculations,
# which sometimes do not fit into RAM and cause the
# system to slow down until it is unusable.
#
# Written by Christian Zielinski <email@czielinski.de>
#

# The command to watch, replace by "" to watch all commands
WATCH_COMMAND="python"

# Waiting period between consecutive checks
WATCH_WAIT="10s"

# Main loop
while true; do

    echo
    date

    for PID in `ps -u "${USER}" | grep "${WATCH_COMMAND}" | awk '{print $1}'`; do
        prod_dir="/proc/$PID/smaps"

        total_swap=0
        for swap in `grep "Swap" "${prod_dir}" 2>/dev/null | awk '{print $2}'`; do
            let total_swap=$total_swap+$swap
        done

        echo "PID=${PID} | Swap used: ${total_swap}"

        if [ "${total_swap}" -gt "0" ]; then
            echo "WARNING: Swapping, killing process ..."
            kill "${PID}"
        fi

    done

    sleep "${WATCH_WAIT}"
done
