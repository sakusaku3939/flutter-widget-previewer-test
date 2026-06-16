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

Previewer には `lib/src/previews/cases/preview_gallery_preview_cases.dart` の個別 `@Preview` が表示されます。

- `PreviewGallery`: mobile / tablet

表示する状態と `@Preview` adapter は画面ごとに `lib/src/previews/cases/` 配下へ置きます。普段の UI 開発では画面単位の PreviewCase と `@Preview` を追加します。部品単位の `@Preview` は作らず、Previewer の group も画面単位で分けます。

## Golden Test

Alchemist でレイアウト確認用の PreviewCase を Golden Test します。対象は `lib/src/previews/preview_cases.dart` の `goldenPreviewCases` に集約しています。

```bash
fvm flutter test test/goldens/preview_cases_golden_test.dart
```

基準画像を更新する場合は次を実行します。

```bash
fvm flutter test test/goldens/preview_cases_golden_test.dart --update-goldens
```

OS別のローカル golden は無効化し、`goldens/ci` のみを検証します。

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
