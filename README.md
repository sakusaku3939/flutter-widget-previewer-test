# Widget Previewer Lab

Flutter Widget Previewer を検証するための最小テストアプリです。`@Preview` 付き Widget、通常アプリ起動、Android エミュレーター確認、`flutter analyze` / `flutter test` の実行を同じリポジトリで確認できます。

## 前提

- Flutter `3.35+`
- IDE の Widget Previewer 連携を見る場合は Flutter `3.38+`
- このリポジトリでは FVM stable を使用します

```bash
fvm use stable
fvm flutter --version
```

## セットアップ

```bash
fvm flutter pub get
```

FVM を使わない場合は、PATH 上の Flutter が `3.35+` であることを確認してから `flutter` コマンドに置き換えてください。

## Widget Previewer

Previewer を起動します。

```bash
fvm flutter widget-preview start
```

プレビュー定義は `lib/src/previews/widget_previews.dart` にあります。

- `Status`: success / error / dark loading
- `Layout`: mobile / tablet
- `Locale`: Japanese labels

## Android エミュレーター確認

利用可能なエミュレーターを確認します。

```bash
fvm flutter emulators
```

エミュレーターを起動します。

```bash
fvm flutter emulators --launch <emulator_id>
```

起動中のデバイスを確認します。

```bash
fvm flutter devices
```

アプリを実行します。

```bash
fvm flutter run -d <device_id>
```

## 検証

```bash
fvm flutter analyze
fvm flutter test
```

## デザイントークン

ユーザー指定の design-tokens を `lib/src/theme/app_theme.dart` に反映しています。

- primary: `#000000`
- background: `#F8FAFC`
- surface: `#FFFFFF`
- text: `#111827`
- success: `#15803D`
- error: `#B91C1C`
- warning: `#B45309`
- muted: `#64748B`
- base spacing: `16`
- card radius: `12`
- button radius: `10`
- card padding: `16`
