#!/usr/bin/env bash
sidra &
sleep 2
hyprctl dispatch movetoworkspacesilent special:magic,class:^([Ss]idra)$
