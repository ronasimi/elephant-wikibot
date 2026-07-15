# Elephant Wikibot

A custom **abenz1267/elephant** provider that fetches the top 3 Wikipedia results for a query and uses a local, hardware-accelerated micro-LLM (Qwen 2.5 0.5B) to generate 2-3 paragraph summaries directly inside the Walker launcher.

## Requirements
* `walker`
* `abenz1267/elephant` (specifically `elephant-menus`)
* `llama.cpp` (or `llama.cpp-vulkan` for AMD iGPU / `llama.cpp-cuda` for NVIDIA)
* `jq`
* `curl`

## Installation (Arch Linux)

This repository includes a `PKGBUILD` to natively install the provider, systemd service, and download the ~600MB Qwen 2.5 model.

1. Clone the repository:
   ```bash
   git clone [https://github.com/ronasimi/elephant-wikibot.git](https://github.com/ronasimi/elephant-wikibot.git)
   cd elephant-wikibot
