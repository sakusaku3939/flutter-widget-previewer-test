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
fvm dart pub get --directory packages/vrt_preview_builder
fvm dart run build_runner build --delete-conflicting-outputs
```

FVM を使わない場合は、PATH 上の Flutter が `3.35+` であることを確認してから `flutter` コマンドに置き換えてください。

VRT一覧は Git 管理しません。clone 直後や `flutter clean` 後は、静的解析・テストの前に上記の生成コマンドを実行してください。FVM を使わず Dart コマンドを実行する場合も、Flutter SDK に付属する Dart を使います。

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

通常の画像生成・比較は CI に任せます。CI は解析・撮影前にVRT一覧を生成するため、`@Preview` の追加・変更時に生成一覧をコミットする必要はありません。ローカルで静的解析・テストを直接実行する場合は、先に一覧を再生成します。

```bash
fvm dart run build_runner build --delete-conflicting-outputs
```

VRT生成対象は、`lib/` 配下の public top-level `@Preview` 関数です。戻り値は `Widget` または `WidgetBuilder`、引数なし、`size` は `Size(width, height)` 形式の定数にしてください。`wrapper` / `theme` / `brightness` / `localizations` / `textScaleFactor` はVRT生成では未対応で、指定すると生成をエラーにします。未対応の関数定義・staticメソッド・コンストラクタや、解決できないsizeもエラーにします。関数名から決まる画像出力名は全ファイルで一意にしてください。同じ関数への複数の`@Preview`も出力名が重複するためエラーです。

VRT画像は Git 管理せず、ローカルまたは CI 上で都度生成します。PR では base branch と head branch の画像を同じ CI 環境で生成し、生成結果同士を比較します。

ローカルでVRT画像を生成する場合は、プロジェクトルートで次を実行します。一覧生成と撮影を順に実行し、一覧生成に失敗した場合は撮影しません。

```bash
fvm dart run tool/run_vrt.dart --update-goldens
```

生成済み画像と現在の描画結果をローカルで比較する場合は次を実行します。

```bash
fvm dart run tool/run_vrt.dart
```

生成された `test/vrt/goldens/ci/*.png` はローカル確認用の一時成果物で、コミット対象にはしません。

生成画像は `test/vrt/goldens/ci/` に出力し、PR CI では base branch と head branch の同名画像を比較します。

### 描画条件

- NotoSansJP はVRTテストがファイルから直接読み込みます。`pubspec.yaml` の fonts/assets には登録せず、リリースアプリへ同梱しません。実アプリとWidget Previewerはシステムフォントを使用するため、VRTと字形が異なる場合があります。
- PreviewSurfaceではMaterialの影を無効にします。VRTは影の見た目を検証しません。
- 撮影前に画面内の`Image`の最初のフレームのデコード完了を待ちます。読み込み失敗や10秒のタイムアウトはテストを失敗させます。`DecorationImage`等はこの待機処理の対象外です。外部ネットワークに依存せず、固定のローカル画像を使用してください。
- 生成一覧が空の場合はVRTテストを失敗させます。

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
fvm dart pub get --directory packages/vrt_preview_builder
fvm dart run build_runner build --delete-conflicting-outputs
fvm flutter analyze
# packages/vrt_preview_builder で fvm dart test も実行
fvm flutter test --exclude-tags golden
fvm dart run tool/run_vrt.dart --update-goldens
fvm flutter test
```

## CI VRT Report

GitHub Actions の `vrt` workflow では、`Verify` job でVRT一覧を生成してから静的解析・テストを実行します。PRでは `Compare screenshots` job で base SHA と head SHA それぞれのソースから一覧とVRT画像を生成して差分画像を作成します。main push では `Generate screenshots` job で一覧生成と撮影が通ることを確認します。

- base: PRのbase branch（通常は `main`）
- head: PR branch
- 差分ありの場合: `vrt/screenshot-reports` ブランチの `vrt/pr-<number>/<short_sha>/` に `base_*` / `head_*` / `diff_*` 画像をコミット
- PRコメント: 同じbotコメントを更新し、同一リポジトリ内PRでは Before / After / Diff 画像を表形式でインライン表示
