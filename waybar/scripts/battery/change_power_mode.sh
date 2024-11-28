#!/bin/bash

power_modes=(performance balance_performance default balance_power power)

# Argument validation
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <power-source: (AC) or (BAT)> <old-mode> <new-mode>"
    exit 1
fi

if [ "$1" != "AC" ] && [ "$1" != "BAT" ]; then
    echo "Invalid power source: $1"
    exit 1
fi

if [[ ! " ${power_modes[@]} " =~ " $2 " ]]; then
    echo "Invalid old mode: $2"
    exit 1
fi

if [[ ! " ${power_modes[@]} " =~ " $3 " ]]; then
    echo "Invalid new mode: $3"
    exit 1
fi

# Change power mode
sed -i "s/CPU_ENERGY_PERF_POLICY_ON_$1=$2/CPU_ENERGY_PERF_POLICY_ON_$1=$3/g" /etc/tlp.conf

