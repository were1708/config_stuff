#!/bin/bash

WALLPAPER_DIR="$HOME/wallpapers"
WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) | shuf -n 1)

if [ -z "$WALLPAPER" ]; then
    echo "No jpgs found in $WALLPAPER_DIR"
    exit 1
fi

for MONITOR in $(hyprctl monitors -j | jq -r '.[].name'); do
    hyprctl hyprpaper preload "$WALLPAPER"
    hyprctl hyprpaper wallpaper ",$WALLPAPER"
    # hyprctl hyprpaper reload "$MONITOR,$WALLPAPER"
done
