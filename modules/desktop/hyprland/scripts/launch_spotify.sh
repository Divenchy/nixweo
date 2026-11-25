#!/usr/bin/env bash
spotify &
sleep 2
hyprctl dispatch movetoworkspacesilent special:magic,class:^Spotify$
