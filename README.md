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

Previewer には各 `screens/{feature}/*_preview.dart` の個別 `@Preview` が表示されます。

- `Home`: mobile
- `PreviewGallery`: mobile / tablet
- `ResultSummary`: interactive mobile / 状態別 mobile。`ResultSummaryNotifier` で表示状態を切り替える状態管理の例です。

表示する状態と `@Preview` adapter は各画面の `screens/{feature}/` 配下へ置きます。普段の UI 開発では画面単位の PreviewCase と `@Preview` を追加します。部品単位の `@Preview` は作らず、Previewer の group も画面単位で分けます。

状態管理は `flutter_riverpod` の `NotifierProvider` を使い、各画面の `*_notifier.dart` に provider と notifier を置きます。

## VRT

Flutter 標準の golden test でレイアウト確認用の PreviewCase を Visual Regression Testing (VRT) します。対象は `lib/src/presentation/previews/vrt_previews.dart` の `visualRegressionPreviews` に集約しています。

VRT画像は Git 管理せず、ローカルまたは CI 上で都度生成します。PR では base branch と head branch の画像を同じ CI 環境で生成し、生成結果同士を比較します。

VRT画像を生成する場合は次を実行します。

```bash
fvm flutter test test/vrt/previews_vrt_test.dart --update-goldens
```

生成済み画像と現在の描画結果をローカルで比較する場合は次を実行します。

```bash
fvm flutter test test/vrt/previews_vrt_test.dart
```

生成された `test/vrt/goldens/ci/*.png` はローカル確認用の一時成果物で、コミット対象にはしません。

生成画像は `test/vrt/goldens/ci/` に出力し、PR CI では base branch と head branch の同名画像を比較します。

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
fvm flutter test test/vrt/previews_vrt_test.dart --update-goldens
fvm flutter test
```

## CI VRT Report

GitHub Actions の `vrt` workflow では、PRごとに base branch と head branch のVRT画像を生成し、`reg-cli` で差分画像を作成します。push ではスクリーンショット生成が通ることを確認します。

- base: PRのbase branch（通常は `main`）
- head: PR branch
- 出力: `vrt-images-<run_id>` artifact
- 差分ありの場合: 一時的な GitHub Release に `expected_*` / `actual_*` / `diff_*` 画像をアップロード
- PRコメント: 同じbotコメントを更新し、同一リポジトリ内PRでは差分画像をインライン表示

Release tag は `vrt-pr-<number>-<short_sha>` 形式です。PR close 時に同じPR番号の一時Releaseとtagを削除します。fork PRでは書き込み権限が制限されるため、Release作成とPRコメント更新は行わず、artifactで確認します。
