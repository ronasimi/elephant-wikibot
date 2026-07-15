# Wikibot

A custom **abenz1267/elephant** provider that fetches the top 3 Wikipedia results for a query and uses a local, hardware-accelerated micro-LLM (Qwen 2.5 0.5B) to generate 2-3 paragraph summaries directly inside the Walker launcher.

## Requirements
* `walker`
* `abenz1267/elephant` (specifically `elephant-menus`)
* `llama.cpp-vulkan`
* `jq`
* `curl`

## Installation

1. Clone this repository:
   ```bash
   git clone [https://github.com/yourusername/elephant-wikibot.git](https://github.com/yourusername/elephant-wikibot.git)
   cd elephant-wikibot
