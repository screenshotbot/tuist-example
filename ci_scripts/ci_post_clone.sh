#!/bin/bash

set -e

echo "Current directory: $(pwd)"
echo "Environment variables:"
env

# Xcode Cloud runs this from ci_scripts/; everything below is relative to the
# repository root.
cd "${CI_PRIMARY_REPOSITORY_PATH:-$(dirname "$0")/..}"

# This repository has no .xcodeproj checked in — Tuist generates it from
# Project.swift. Install Tuist (version pinned in .mise.toml) and generate the
# workspace before Xcode Cloud starts building.
curl https://mise.run | sh
export PATH="$HOME/.local/bin:$PATH"
mise trust
mise install
mise exec -- tuist install
mise exec -- tuist generate --no-open

# Install screenshotbot recorder
curl https://screenshotbot.io/recorder.sh | sh

# Update commit graph for better git performance
~/screenshotbot/recorder ci upload-commit-graph --main-branch main
