#!/bin/bash

if [[ $(amixer get Capture | grep -F "[on]") ]]; then
    echo '{"text": "", "tooltip": "Mic On"}' | jq . --unbuffered --compact-output
else
    echo '{"text": "󰍭", "tooltip": "Mic off"}' | jq . --unbuffered --compact-output
fi