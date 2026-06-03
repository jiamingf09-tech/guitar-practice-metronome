# 吉他练习节拍器

[![CI / Release](https://github.com/jiamingf09-tech/guitar-practice-metronome/actions/workflows/ci.yml/badge.svg)](https://github.com/jiamingf09-tech/guitar-practice-metronome/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/jiamingf09-tech/guitar-practice-metronome)](https://github.com/jiamingf09-tech/guitar-practice-metronome/releases/latest)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

English | [中文](README.zh.md)

基于 Flutter 构建的跨平台节拍器，专为吉他练习设计。
除基础节拍功能外，还包含速度训练、静音小节练习、细分节奏、
Tap Tempo、以及预设系统——全部采用简洁暗色 UI，支持中英文切换。

---

## 支持平台

| 平台 | 架构 | 状态 |
|---|---|---|
| macOS | arm64 | ✅ |
| Windows | x64 | ✅ |
| Linux | x64 | ✅ |
| Android | arm64-v8a / armeabi-v7a / x86_64 | ✅ |
| iOS | arm64 | ✅ |

---

## 功能特性

### 核心节拍器
- **BPM 范围** 30–300，支持滑块、±步进按钮调节
- **拍号** — 4/4 · 3/4 · 6/8 · 5/4
- **细分节奏** — 全音符 · 二分 · 四分 · 八分 · 十六分 · 八分+十六分 · 十六分+八分 · 三连音
- **预备拍（Count-in）** — 播放前 1–4 小节静音引导
- **节拍指示灯** — 强拍与细分节奏的视觉区分

### 练习工具
- **Tap Tempo** — 点击按钮自动识别你的自然速度
- **速度训练** — 从起始 BPM 自动渐进到目标 BPM，可配置步长和小节数
- **静音小节（Gap Click）** — 正常小节与静音小节交替，训练内在律动
- **练习计时器** — 设定练习时长，时间到自动停止节拍器

### 预设系统
- 保存、加载、删除命名预设
- 每个预设存储完整配置（BPM、拍号、细分、速度训练、静音小节、计时器）

### 界面 / 体验
- Material 3 暗色主题
- 中文 / English 界面切换，跨会话持久化
- 无广告、无账号、无需网络

---

## 下载

从 [Releases 页面](https://github.com/jiamingf09-tech/guitar-practice-metronome/releases/latest) 获取最新版本。

| 平台 | 文件 | 说明 |
|---|---|---|
| macOS arm64 | `GuitarMetronome-macos-arm64.zip` | 解压后拖入「应用程序」文件夹 |
| Windows x64 | `GuitarMetronome-windows-x64.zip` | 解压后运行 `guitar_metronome.exe` |
| Linux x64 | `GuitarMetronome-linux-x64.tar.gz` | 解压后运行 `guitar_metronome` |
| Android | `GuitarMetronome-android.apk` | 需在设置中开启「安装未知来源应用」 |
| iOS | `GuitarMetronome-ios-unsigned.ipa` | 需通过 AltStore / Sideloadly 等工具侧载 |

> **macOS 提示：** 应用未经过公证。首次启动请右键点击 → 打开，以绕过 Gatekeeper。

---

## 从源码构建

### 环境要求

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.41（stable 渠道）
- macOS 构建：Xcode 15+、CocoaPods
- Windows 构建：Visual Studio 2022，含「使用 C++ 的桌面开发」工作负载
- Linux 构建：`clang`、`cmake`、`ninja-build`、`pkg-config`、`libgtk-3-dev`
- Android 构建：Android Studio 或 `sdkmanager`，Build-Tools 34
- iOS 构建：Xcode 15+，iOS 12+ 部署目标

```sh
# 克隆仓库
git clone https://github.com/jiamingf09-tech/guitar-practice-metronome.git
cd guitar-practice-metronome

# 安装依赖
flutter pub get

# 在本机平台运行
flutter run -d macos      # 或：windows、linux
```

### 构建发布包

```sh
flutter build macos   --release
flutter build windows --release
flutter build linux   --release
flutter build apk     --release                    # Android APK
flutter build ios     --release --no-codesign      # iOS（未签名）
```

### 验证

```sh
flutter analyze
flutter test
```

---

## 架构说明

### 音频引擎

`AudioEngine` 是一个只包含 `playAccentClick` / `playNormalClick` 的薄接口。
`DefaultAudioEngine` 在启动时合成短正弦波 WAV 文件（无需捆绑音频资源），
通过 `audioplayers` 配合预热音频池降低延迟。
若需替换为原生后端，只需实现 `AudioEngine` 并在 `main()` 中注入即可。

### 节拍器时钟

时钟在 `MetronomeController` 中以 `Timer` 递归循环运行。
每个 tick 根据当前 `MetronomeConfig`（支持速度训练中的 BPM 渐进）计算下一个间隔。
状态以 `ValueNotifier<MetronomeState>` 暴露，Widget 仅在相关状态变化时重建。

---

## 参与贡献

1. Fork 仓库并创建功能分支
2. `flutter analyze && flutter test` 必须全部通过
3. 每个 PR 专注于一个功能或修复
4. UI 字符串统一在 `lib/services/app_strings.dart` 中同时添加 `AppLanguage.en` 和 `AppLanguage.zh` 两种语言

---

## 许可证

MIT — 详见 [LICENSE](LICENSE)。
