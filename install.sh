#!/bin/bash

echo "Setting up Wikibot..."

# Ensure dependencies are installed via AUR
echo "Checking dependencies..."
yay -S --needed llama.cpp-vulkan jq curl walker elephant-menus

# Download the Qwen micro-model
echo "Downloading Qwen 2.5 0.5B (Q8_0)..."
mkdir -p ~/.local/share/models
wget -nc -O ~/.local/share/models/qwen2.5-0.5b-instruct.gguf https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct-GGUF/resolve/main/qwen2.5-0.5b-instruct-q8_0.gguf

# Install the Elephant provider
echo "Installing Wikibot Lua provider..."
mkdir -p ~/.config/elephant/menus
cp menus/wikibot.lua ~/.config/elephant/menus/wikibot.lua

# Install and enable the systemd service
echo "Configuring systemd service..."
mkdir -p ~/.config/systemd/user
cp systemd/llama-server.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now llama-server.service

echo "Done! Add the following to your ~/.config/walker/config.toml:"
echo '[[providers.prefixes]]'
echo 'prefix = "?"'
echo 'provider = "menus:wikibot"'
