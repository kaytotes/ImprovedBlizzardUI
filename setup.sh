#!/bin/bash

# Sets up a local development version of the addon.

clear

echo ""

echo "================================================================="
echo "Beginning Improved Blizzard UI Scaffolding"
echo "================================================================="

echo ""

# Get Dependencies
./.release/release.sh

echo ""

echo "================================================================="
echo "Copying Development Libraries"
echo "================================================================="

echo ""

cp -a .release/ImprovedBlizzardUI/libs/. libs

echo ""

echo "================================================================="
echo "Cleaning Up Files"
echo "================================================================="

echo ""

rm -rf .release/ImprovedBlizzardUI
rm -rf .release/ImprovedBlizzardUI-*

clear

echo ""

echo "================================================================="
echo "Set Up Complete! Restart WoW if already open."
echo "================================================================="

echo ""