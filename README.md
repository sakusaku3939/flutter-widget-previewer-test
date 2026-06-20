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

表示する状態と `@Preview` adapter は各画面の `screens/{feature}/` 配下へ置きます。普段の UI 開発では画面単位の `@Preview` を追加します。部品単位の `@Preview` は作らず、Previewer の group も画面単位で分けます。

状態管理は `flutter_riverpod` の `NotifierProvider` を使い、各画面の `*_notifier.dart` に provider と notifier を置きます。

## VRT

Flutter 標準の golden test で `@Preview` を Visual Regression Testing (VRT) します。VRT対象は build_runner で `lib/src/presentation/previews/vrt_previews.g.dart` に生成し、`lib/src/presentation/previews/vrt_previews.dart` から公開しています。

`@Preview` を追加・変更した場合は、VRT一覧を再生成します。

```bash
fvm dart run build_runner build --delete-conflicting-outputs
```

VRT生成対象は、`lib/` 配下の public top-level `@Preview` 関数です。戻り値は `Widget` または `WidgetBuilder`、引数なし、`size` は `Size(width, height)` 形式の定数にしてください。`wrapper` / `theme` / `localizations` / `textScaleFactor` はVRT生成では未対応です。

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

GitHub Actions の `vrt` workflow では、`Verify` job で生成済みVRT一覧と静的解析を確認し、PRでは `Compare screenshots` job で base branch と head branch のVRT画像を生成して差分画像を作成します。main push では `Generate screenshots` job でスクリーンショット生成が通ることを確認します。

- base: PRのbase branch（通常は `main`）
- head: PR branch
- 差分ありの場合: `vrt/screenshot-reports` ブランチの `vrt/pr-<number>/<short_sha>/` に `base_*` / `head_*` / `diff_*` 画像をコミット
- PRコメント: 同じbotコメントを更新し、同一リポジトリ内PRでは base / head / diff 画像を表形式でインライン表示

画像は専用ブランチにコミットするため、PR merge 後も参照できます。Actionsのレポート更新コミットには `[skip ci]` を付け、余計なCI起動を抑えます。
