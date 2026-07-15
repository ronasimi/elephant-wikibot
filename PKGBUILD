pkgname=elephant-wikibot-git
pkgver=r1.a1b2c3d # This is a placeholder; the pkgver() function will overwrite it automatically
pkgrel=1
pkgdesc="A local Wikipedia AI summarization provider for Elephant/Walker using Qwen 2.5 0.5B"
arch=('x86_64')
url="https://github.com/ronasimi/elephant-wikibot"
license=('MIT')
depends=('llama-cpp' 'jq' 'curl' 'walker' 'elephant-menus')
makedepends=('git')
provides=("${pkgname%-git}")
conflicts=("${pkgname%-git}")
install="elephant-wikibot.install"
source=(
    "git+https://github.com/ronasimi/elephant-wikibot.git"
    "https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct-GGUF/resolve/main/qwen2.5-0.5b-instruct-q8_0.gguf"
)
sha256sums=('SKIP' 'SKIP')

pkgver() {
    cd "${pkgname%-git}"
    # Dynamically generate the version based on git commit count and hash
    printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short=7 HEAD)"
}

package() {
    # 1. Install the model globally (downloaded alongside the git repo in $srcdir)
    install -Dm644 "qwen2.5-0.5b-instruct-q8_0.gguf" "${pkgdir}/usr/share/models/qwen2.5-0.5b-instruct-q8_0.gguf"

    # 2. Enter the cloned GitHub repository
    cd "${pkgname%-git}"

    # 3. Install the systemd user service from the repo
    install -Dm644 "systemd/llama-server-wikibot.service" "${pkgdir}/usr/lib/systemd/user/llama-server-wikibot.service"

    # 4. Install the Lua script from the repo
    install -Dm644 "menus/wikibot.lua" "${pkgdir}/usr/share/elephant-wikibot/wikibot.lua"
}
