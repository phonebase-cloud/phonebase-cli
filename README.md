<div align="center">
  <h1>PhoneBase CLI</h1>
  <p>Cloud phones for Claude Code — give your AI agent a real Android device</p>
  <p>
    <a href="https://github.com/phonebase-cloud/phonebase-cli/releases"><img src="https://img.shields.io/badge/Version-1.0.5-2F81F7.svg" alt="Version 1.0.5" /></a>
    <img src="https://img.shields.io/badge/Platform-macOS%20%7C%20Linux%20%7C%20Windows-6E7781.svg" alt="Platform: macOS, Linux, Windows" />
    <a href="./LICENSE"><img src="https://img.shields.io/badge/License-GPL%20v3-blue.svg" alt="License: GPL v3" /></a>
    <img src="https://img.shields.io/badge/Rust-1.75+-DEA584.svg?logo=rust&logoColor=white" alt="Rust 1.75+" />
  </p>
  <p><a href="./README.md">English</a> | <a href="./README.zh-CN.md">简体中文</a></p>
  <p>
    <a href="https://phonebase.cloud">Website</a> ·
    <a href="https://github.com/phonebase-cloud/phonebase-cli/releases">Releases</a>
  </p>
</div>

## Overview

**pb** is the CLI for [PhoneBase](https://phonebase.cloud) — cloud phones purpose-built for AI agents. Give Claude Code, Codex, or Cursor a real Android device to tap, swipe, screenshot, and shell into, all from the terminal.

A single binary that covers everything: device lifecycle (create, start, stop, delete), real-time control (touch, type, file transfer), and an optional TUI mode. All commands output structured JSON to stdout — designed to be called and parsed by AI agents.

## Installation

**1. Install via npm:**

```bash
npm install -g phonebase-cli
```

<details>
<summary>Prefer a manual install? (no Node required)</summary>

Download the binary and `checksums.txt` for your platform from the [latest release](https://github.com/phonebase-cloud/phonebase-cli/releases/latest), then:

```bash
shasum -a 256 -c checksums.txt              # macOS (use sha256sum on Linux)
chmod +x phonebase-v<version>-<platform>
sudo mv phonebase-v<version>-<platform> /usr/local/bin/pb
```
</details>

**2. Verify:**

```bash
pb --version
```

**3. Sign in and pick a device:**

```bash
pb login                                    # browser login (or: pb apikey <key>)
pb devices                                  # list your cloud phones
pb connect <device-code>                    # connect and start driving it
```

**Stay up to date:**

```bash
npm update -g phonebase-cli                 # npm install
pb update                                   # manual install
```

## Quick Start

```bash
# Authenticate
pb login                          # Browser login
pb apikey <your-key>              # Or set API key

# Manage devices
pb devices                        # List all devices
pb devices create                 # Create a new device
pb devices info <id>              # View device details

# Connect and control
pb connect <device-id>            # Connect to a device
pb tap 540 960                    # Tap at (540, 960)
pb swipe 540 1500 540 500         # Swipe
pb text "hello"                   # Type text
pb shell "pm list packages"       # Run shell command
pb screencap                      # Take screenshot
pb disconnect                     # Disconnect
```

## Usage

### Authentication

```bash
pb login                    # Login via browser (Device Code Flow)
pb apikey <key>             # Set API key (for CI/scripts)
pb status                   # Check login status
pb logout                   # Sign out
```


### Device Management

```bash
pb devices                  # List devices (table format)
pb devices list             # List devices (JSON)
pb devices create           # Create device
pb devices start <id>       # Start device
pb devices stop <id>        # Stop device
pb devices reboot <id>      # Reboot device
pb devices delete <id>      # Delete device
```

### Device Control

After connecting to a device (`pb connect <id>`), control it with adb-style commands:

```bash
# Input
pb tap <x> <y>                             # Tap
pb swipe <x1> <y1> <x2> <y2>               # Swipe
pb text <text>                              # Type text
pb keyevent <code>                          # Key event (e.g. KEYCODE_HOME)

# Apps
pb launch <package>                         # Launch an app (auto-grants permissions)
pb packages                                 # List installed apps
pb icon <package>                           # Show app icon in terminal
pb install <apk|url>                        # Install APK / XAPK / URL
pb uninstall <package>                      # Uninstall app
pb browse <url>                             # Open URL in device browser

# Shell & Files
pb shell <command>                          # Execute shell command
pb push <local-path>                        # Push file to device
pb pull <remote-path>                       # Pull file from device
pb ls <path>                                # List device files
pb clipboard [text]                         # Get/set clipboard

# Inspection
pb screencap                                # Screenshot to .phonebase/
pb inspect                                  # Generate inspector HTML (screenshot + annotated XML)
pb dump / pb dumpc                          # Dump UI hierarchy (full / compact)
pb view                                     # Open live cloud-phone view in browser
pb list                                     # List available control APIs
pb info <api>                               # View API details
```

### Direct API Call

Pass JSON parameters directly to any control API:

```bash
pb -j '{"x":100,"y":200}' input/click
pb -f params.json input/swipe
echo '{"command":"ls"}' | pb -f - system/shell
```

### Configuration

```bash
pb config                                   # Show current config (JSON)
pb config set network_timeout 60            # Request timeout (seconds)
pb config set device_default <device-code>  # Default device for -s omission
```

Environment overrides: `PHONEBASE_API_KEY`, `PHONEBASE_LANG`.

## For AI Agents

Get your AI agent (Claude Code, Codex, Cursor) driving pb out of the box:

https://github.com/phonebase-cloud/phonebase-skills

```bash
npx skills add phonebase-cloud/phonebase-skills
```

## Building

### Requirements

- Rust 1.75+
- macOS: Xcode Command Line Tools (`xcode-select --install`)

### Development

```bash
# Debug build (pbd → dist/debug/pbd)
./scripts/build-release.sh --debug --fast --local

# Dev-release build (pb → dist/dev-release/pb, fast compile)
./scripts/build-release.sh --dev-release --fast --local
```

### Release Build

```bash
# Current platform (pb → dist/release/pb)
./scripts/build-release.sh --release --local

# All platforms (requires Docker + cross)
./scripts/build-release.sh --release --all

# Specific targets
./scripts/build-release.sh aarch64-apple-darwin x86_64-unknown-linux-gnu
```

Build output goes to `dist/<mode>/` (`debug` / `dev-release` / `release`).

## License

This project is licensed under the [GPL-3.0](./LICENSE) License.

For commercial licensing inquiries, please contact us at [phonebase.cloud](https://phonebase.cloud).
