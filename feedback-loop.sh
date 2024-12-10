#!/usr/bin/env bash
set -euo pipefail
cmd="echo format, fix, and check files;
nix fmt
echo ;
sleep 0.5;
echo; 
echo build:;
nixos-rebuild build --show-trace --flake .#naga;
echo;
echo ------------------------------------------------;
"

fd | entr bash -c "$cmd"
