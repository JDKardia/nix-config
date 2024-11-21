#!/usr/bin/env bash
set -euo pipefail
cmd="echo fix and check files;
statix check;
echo ;
sleep 0.5;
echo autoformatting;
alejandra --quiet .;
echo; 
echo build:;
nixos-rebuild build --show-trace --flake .#naga;
echo;
echo ------------------------------------------------;
"

fd | entr bash -c "$cmd"
