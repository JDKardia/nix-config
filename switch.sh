#!/usr/bin/env bash
set -euo pipefail
alejandra . 
cur_gen="$(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | grep current | awk '{print $1}')"
base_msg="update $cur_gen -> $((cur_gen+1))"
git commit --all --message "(+) $base_msg"
sudo nixos-rebuild switch --flake .#naga || git commit --amend --message "(-) $base_msg"
git push
