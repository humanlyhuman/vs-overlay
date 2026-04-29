#!/usr/bin/env bash

nix-shell --accept-flake-config dev-shell.nix  --show-trace --argstr vs-overlay $PWD