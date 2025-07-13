#!/bin/sh
echo -ne '\033c\033]0;RPGC\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/RPGC.x86_64" "$@"
