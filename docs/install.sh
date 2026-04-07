#!/bin/sh
# PhoneBase CLI installer
# Usage: curl -fsSL https://get.phonebase.cloud/install.sh | sh
set -e

REPO="phonebase-cloud/phonebase-cli"
BIN_NAME="pb"
ASSET_PREFIX="phonebase"

# ── Detect platform ──
detect_platform() {
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    ARCH=$(uname -m)

    case "$OS" in
        linux)  OS="linux" ;;
        darwin) OS="macos" ;;
        *)      echo "Unsupported OS: $OS"; exit 1 ;;
    esac

    case "$ARCH" in
        x86_64|amd64)  ARCH="x64" ;;
        aarch64|arm64) ARCH="arm64" ;;
        *)             echo "Unsupported architecture: $ARCH"; exit 1 ;;
    esac

    PLATFORM="${OS}-${ARCH}"
}

# ── Detect install directory ──
detect_install_dir() {
    if [ -w /usr/local/bin ]; then
        INSTALL_DIR="/usr/local/bin"
    elif [ -d "$HOME/.local/bin" ]; then
        INSTALL_DIR="$HOME/.local/bin"
    else
        mkdir -p "$HOME/.local/bin"
        INSTALL_DIR="$HOME/.local/bin"
    fi
}

# ── Download helper ──
download() {
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "$1" -o "$2"
    elif command -v wget >/dev/null 2>&1; then
        wget -qO "$2" "$1"
    else
        echo "curl or wget is required"
        exit 1
    fi
}

# ── Get latest version via GitHub redirect (no API rate limit) ──
get_latest_version() {
    if command -v curl >/dev/null 2>&1; then
        REDIRECT_URL=$(curl -fsSI "https://github.com/${REPO}/releases/latest" 2>/dev/null | grep -i "^location:" | tr -d '\r' | awk '{print $2}')
    elif command -v wget >/dev/null 2>&1; then
        REDIRECT_URL=$(wget --spider -S "https://github.com/${REPO}/releases/latest" 2>&1 | grep -i "Location:" | tail -1 | awk '{print $2}' | tr -d '\r')
    fi

    if [ -z "$REDIRECT_URL" ]; then
        echo "  Failed to get latest version"
        exit 1
    fi

    # .../releases/tag/v1.0.1 or .../releases/tag/1.0.1 → 1.0.1
    TAG=$(echo "$REDIRECT_URL" | sed 's|.*/||')
    VERSION=$(echo "$TAG" | sed 's|^v||')
}

main() {
    echo ""
    echo "  PhoneBase CLI Installer"
    echo "  ───────────────────────"
    echo ""

    detect_platform
    detect_install_dir
    get_latest_version

    echo "  Version:    ${TAG}"
    echo "  Platform:   ${PLATFORM}"
    echo "  Install to: ${INSTALL_DIR}"
    echo ""

    # Download binary
    URL="https://github.com/${REPO}/releases/download/${TAG}/${ASSET_PREFIX}-v${VERSION}-${PLATFORM}"
    TMP=$(mktemp)
    echo "  Downloading..."
    download "$URL" "$TMP"

    # Install
    chmod +x "$TMP"
    mv "$TMP" "${INSTALL_DIR}/${BIN_NAME}"
    echo "  ✓ Installed: ${INSTALL_DIR}/${BIN_NAME}"
    echo ""

    # Check PATH
    if ! echo "$PATH" | tr ':' '\n' | grep -qx "$INSTALL_DIR"; then
        echo "  ⚠  Add ${INSTALL_DIR} to your PATH:"
        echo ""
        echo "     export PATH=\"${INSTALL_DIR}:\$PATH\""
        echo ""
        echo "  Add to ~/.bashrc or ~/.zshrc to make it permanent."
        echo ""
    fi

    echo "  Get started:"
    echo ""
    echo "    pb login          # Login via browser"
    echo "    pb apikey <key>   # Or set API Key"
    echo "    pb devices        # List devices"
    echo ""
}

main
