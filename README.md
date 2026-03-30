<div align="center">
  <h1>PhoneBase CLI</h1>
  <p>Cloud phones for Claude Code — give your AI agent a real Android device</p>
  <p>
    <a href="https://github.com/phonebase-cloud/phonebase-cli/releases"><img src="https://img.shields.io/badge/Version-1.0.1-2F81F7.svg" alt="Version 1.0.1" /></a>
    <img src="https://img.shields.io/badge/Platform-macOS%20%7C%20Linux%20%7C%20Windows-6E7781.svg" alt="Platform: macOS, Linux, Windows" />
    <a href="./LICENSE"><img src="https://img.shields.io/badge/License-GPL%20v3-blue.svg" alt="License: GPL v3" /></a>
    <img src="https://img.shields.io/badge/Rust-1.75+-DEA584.svg?logo=rust&logoColor=white" alt="Rust 1.75+" />
  </p>
  <p><a href="./README.md">English</a> | <a href="./docs/README.zh-CN.md">简体中文</a></p>
  <p>
    <a href="https://phonebase.cloud">Website</a> ·
    <a href="https://github.com/phonebase-cloud/phonebase-cli/releases">Releases</a>
  </p>
</div>

## Overview

**pb** is the CLI for [PhoneBase](https://phonebase.cloud) — cloud phones purpose-built for AI agents. Give Claude Code, Codex, or Cursor a real Android device to tap, swipe, screenshot, and shell into, all from the terminal.

A single binary that covers everything: device lifecycle (create, start, stop, delete), real-time control (touch, type, file transfer), and an optional TUI mode. All commands output structured JSON to stdout — designed to be called and parsed by AI agents.

## Installation

```bash
curl -fsSL https://get.phonebase.cloud | sh
```

Then authenticate:

```bash
pb login        # Browser login
pb apikey <key> # Or set API key directly
```

### Update

```bash
pb update
```

## Quick Start

```bash
# Authenticate
pb login                          # Browser-based login
pb apikey <your-key>              # Or set API key directly

# Manage devices
pb devices                        # List all devices
pb devices create                 # Create a new device
pb devices info <id>              # View device details

# Connect and control
pb connect <device-id>            # Connect to a device
pb input tap 540 960              # Tap screen at (540, 960)
pb input swipe 540 1500 540 500   # Swipe gesture
pb input text "hello"             # Type text
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
pb input tap <x> <y>                       # Tap
pb input swipe <x1> <y1> <x2> <y2>         # Swipe
pb input text <text>                        # Type text
pb input keyevent <code>                    # Key event (e.g. KEYCODE_HOME)

# Shell & Files
pb shell <command>                          # Execute shell command
pb install <apk>                            # Install APK
pb push <local-path>                        # Push file to device
pb pull <remote-path>                       # Pull file from device

# Inspection
pb screencap                                # Screenshot to .screencap/
pb dump                                     # Dump UI hierarchy (XML)
pb list                                     # List available control APIs
pb info <api-name>                          # View API details
```

### Direct API Call

Pass JSON parameters directly to any control API:

```bash
pb -j '{"x":100,"y":200}' input/click
pb -f params.json input/swipe
echo '{"command":"ls"}' | pb -f - shell/exec
```

### Interactive TUI

```bash
pb ui
```

### Configuration

```bash
pb config                   # Show current config
pb config set gateway <url> # Set API gateway URL
pb config set timeout 60    # Set request timeout (seconds)
```

## For AI Agents

pb is designed as an AI agent tool. All commands output structured JSON to stdout, making it easy to parse:

```json
{"code": 200, "data": [...], "msg": "OK"}
```

- **stdout** = JSON data only (for parsing)
- **stderr** = logs and human-readable messages (for debugging)

Specify device with `-s` flag when working with multiple devices:

```bash
pb -s <device-id> shell "getprop ro.build.version.sdk"
pb -s <device-id> screencap
```

## Building

### Requirements

- Rust 1.75+
- macOS: Xcode Command Line Tools (`xcode-select --install`)

### Development

```bash
# Debug build (uses build script for correct SDK paths)
./scripts/build-release.sh --debug --fast --local

# Run tests
cargo test --workspace

# Run with debug logging
RUST_LOG=debug ./dist/pbd devices list 2>debug.log
```

### Release Build

```bash
# Current platform
./scripts/build-release.sh --release --local

# All platforms (requires Docker + cross)
./scripts/build-release.sh --all

# Specific target
./scripts/build-release.sh aarch64-apple-darwin x86_64-unknown-linux-gnu
```

Build output goes to `dist/`.

## License

This project is licensed under the [GPL-3.0](./LICENSE) License.

For commercial licensing inquiries, please contact us at [phonebase.cloud](https://phonebase.cloud).
