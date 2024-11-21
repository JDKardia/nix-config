#!/usr/bin/env bash
set -euo pipefail
cmd="echo fix and check files;
statix check;
echo ;
echo autoformatting;
alejandra --quiet .;
echo; 
echo build:;
nixos-rebuild build --flake .#naga;
echo;
echo ------------------------------------------------;
"

fd | entr bash -c "$cmd"
