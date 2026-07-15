pkgname=elephant-wikibot
pkgver=1.0.0
pkgrel=1
pkgdesc="A local Wikipedia AI summarization provider for Elephant/Walker using Qwen 2.5 0.5B"
arch=('x86_64')
url="https://github.com/ronasimi/elephant-wikibot"
license=('MIT')
depends=('llama.cpp' 'jq' 'curl' 'walker' 'elephant-menus')
optdepends=('llama.cpp-vulkan: For AMD iGPU hardware acceleration')
install="${pkgname}.install"
source=(
    "https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct-GGUF/resolve/main/qwen2.5-0.5b-instruct-q8_0.gguf"
    "menus/wikibot.lua"
    "systemd/llama-server-wikibot.service"
)
sha256sums=('SKIP' 'SKIP' 'SKIP')

package() {
    # Install the model globally
    install -Dm644 "qwen2.5-0.5b-instruct-q8_0.gguf" "${pkgdir}/usr/share/models/qwen2.5-0.5b-instruct-q8_0.gguf"

    # Install the systemd user service
    install -Dm644 "systemd/llama-server-wikibot.service" "${pkgdir}/usr/lib/systemd/user/llama-server-wikibot.service"

    # Install the Lua script to a shared directory
    install -Dm644 "menus/wikibot.lua" "${pkgdir}/usr/share/elephant-wikibot/wikibot.lua"
}
