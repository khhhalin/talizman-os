#!/bin/sh
printf '\033c\033]0;%s\a' Talizman-OS
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Talizman-OS.x86_64" "$@"
