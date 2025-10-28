#!/bin/sh
printf '\033c\033]0;%s\a' RPGC
base_path="$(dirname "$(realpath "$0")")"
"$base_path/RPGC.x86_64" "$@"
