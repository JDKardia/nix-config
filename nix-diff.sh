#!/usr/bin/env bash

hostname="$(hostname)"

case "$(uname)" in
  Linux)
    flake="$HOME/.config/nix#nixosConfigurations.\"$hostname\".config.system.build.toplevel"
    ;;
  Darwin)
    flake="git+file://$HOME/.config/nixpkgs#darwinConfigurations.\"$hostname\".system"
    ;;
  *)
    echo "System not supported"
    exit 1
    ;;
esac

built="$(nix build --no-link --print-out-paths "$flake")"

nix store diff-closures /run/current-system/ "$built"

nix run nixpkgs#nix-diff -- --character-oriented /run/current-system/ "$built"
