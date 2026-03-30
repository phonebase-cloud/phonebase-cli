<div align="center">
  <h1>PhoneBase CLI</h1>
  <p>Cloud phones for Claude Code — 让你的 AI Agent 拥有真实 Android 设备</p>
  <p>
    <a href="https://github.com/phonebase-cloud/phonebase-cli/releases"><img src="https://img.shields.io/badge/版本-1.0.1-2F81F7.svg" alt="版本 1.0.1" /></a>
    <img src="https://img.shields.io/badge/平台-macOS%20%7C%20Linux%20%7C%20Windows-6E7781.svg" alt="平台: macOS, Linux, Windows" />
    <a href="../LICENSE"><img src="https://img.shields.io/badge/许可证-GPL%20v3-blue.svg" alt="许可证: GPL v3" /></a>
    <img src="https://img.shields.io/badge/Rust-1.75+-DEA584.svg?logo=rust&logoColor=white" alt="Rust 1.75+" />
  </p>
  <p><a href="../README.md">English</a> | <a href="./README.zh-CN.md">简体中文</a></p>
  <p>
    <a href="https://phonebase.cloud">官方网站</a> ·
    <a href="https://github.com/phonebase-cloud/phonebase-cli/releases">版本发布</a>
  </p>
</div>

## 项目简介

**pb** 是 [PhoneBase](https://phonebase.cloud) 的 CLI 工具 — 专为 AI Agent 打造的云手机。让 Claude Code、Codex、Cursor 直接在终端里操控真实 Android 设备：点击、滑动、截图、执行 Shell。

单个二进制覆盖全部能力：设备生命周期管理（创建、启动、停止、删除）、实时控制（触控、输入、文件传输），以及可选的 TUI 模式。所有命令输出结构化 JSON 到 stdout — 天生为 AI Agent 调用和解析而设计。

## 安装

```bash
curl -fsSL https://get.phonebase.cloud | sh
```

然后认证：

```bash
pb login        # 浏览器登录
pb apikey <key> # 或直接设置 API Key
```

### 更新

```bash
pb update
```

## 快速开始

```bash
# 认证
pb login                          # 浏览器登录
pb apikey <your-key>              # 或直接设置 API Key

# 设备管理
pb devices                        # 列出所有设备
pb devices create                 # 创建设备
pb devices info <id>              # 查看设备详情

# 连接并控制
pb connect <device-id>            # 连接设备
pb input tap 540 960              # 点击屏幕坐标 (540, 960)
pb input swipe 540 1500 540 500   # 滑动手势
pb input text "hello"             # 输入文本
pb shell "pm list packages"       # 执行 Shell 命令
pb screencap                      # 截图
pb disconnect                     # 断开连接
```

## 使用指南

### 认证

```bash
pb login                    # 浏览器登录（Device Code Flow）
pb apikey <key>             # 设置 API Key（适用于 CI/脚本）
pb status                   # 查看登录状态
pb logout                   # 登出
```


### 设备管理

```bash
pb devices                  # 列出设备（表格格式）
pb devices list             # 列出设备（JSON）
pb devices create           # 创建设备
pb devices start <id>       # 启动设备
pb devices stop <id>        # 停止设备
pb devices reboot <id>      # 重启设备
pb devices delete <id>      # 删除设备
```

### 设备控制

连接设备后（`pb connect <id>`），使用 adb 风格命令控制：

```bash
# 输入操作
pb input tap <x> <y>                       # 点击
pb input swipe <x1> <y1> <x2> <y2>         # 滑动
pb input text <text>                        # 输入文本
pb input keyevent <code>                    # 发送按键（如 KEYCODE_HOME）

# Shell 与文件
pb shell <command>                          # 执行 Shell 命令
pb install <apk>                            # 安装 APK
pb push <local-path>                        # 推送文件到设备
pb pull <remote-path>                       # 从设备拉取文件

# 检查
pb screencap                                # 截图保存到 .screencap/
pb dump                                     # 导出 UI 层次结构（XML）
pb list                                     # 列出可用控制接口
pb info <api-name>                          # 查看接口详情
```

### 直接调用 API

向任意控制接口直接传递 JSON 参数：

```bash
pb -j '{"x":100,"y":200}' input/click
pb -f params.json input/swipe
echo '{"command":"ls"}' | pb -f - shell/exec
```

### 交互式 TUI

```bash
pb ui
```

### 配置管理

```bash
pb config                   # 查看当前配置
pb config set gateway <url> # 设置 API 网关地址
pb config set timeout 60    # 设置请求超时（秒）
```

## AI Agent 集成

pb 为 AI Agent 场景专门设计，所有命令输出结构化 JSON 到 stdout，便于解析：

```json
{"code": 200, "data": [...], "msg": "OK"}
```

- **stdout** = 仅 JSON 数据（用于解析）
- **stderr** = 日志和人类可读信息（用于调试）

多设备场景下通过 `-s` 指定目标设备：

```bash
pb -s <device-id> shell "getprop ro.build.version.sdk"
pb -s <device-id> screencap
```

## 构建

### 环境要求

- Rust 1.75+
- macOS 需安装 Xcode Command Line Tools（`xcode-select --install`）

### 开发构建

```bash
# Debug 构建（脚本自动处理 SDK 路径）
./scripts/build-release.sh --debug --fast --local

# 运行测试
cargo test --workspace

# 带日志运行
RUST_LOG=debug ./dist/pbd devices list 2>debug.log
```

### 发布构建

```bash
# 当前平台
./scripts/build-release.sh --release --local

# 所有平台（需要 Docker + cross）
./scripts/build-release.sh --all

# 指定目标
./scripts/build-release.sh aarch64-apple-darwin x86_64-unknown-linux-gnu
```

构建产物输出到 `dist/` 目录。

## 许可证

本项目以 [GPL-3.0](../LICENSE) 协议开源。

如需闭源商用或其他商业授权，请联系 [phonebase.cloud](https://phonebase.cloud)。
