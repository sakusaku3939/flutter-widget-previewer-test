# Widget Previewer Lab

Flutter Widget Previewer と golden test による画像差分テスト（VRT）の検証用アプリ。

## セットアップ

FVM の stable を使用する。
Dart SDK 要件は `^3.12.1`、CI の Flutter は `3.44.2`。

```bash
fvm use stable
fvm flutter pub get
fvm dart pub get --directory packages/vrt_preview_builder
fvm dart run build_runner build --delete-conflicting-outputs
```

FVM を使用しない場合は `fvm` を除外し、Flutter SDK 付属の Dart を使用する。

VRT 一覧は Git 管理の対象外とする。
clone 直後、`flutter clean` 実行後、`@Preview` の変更後は、解析やテストの前に `build_runner` を再実行する。

## Widget Previewer

```bash
fvm flutter widget-preview start
```

| 画面 | プレビュー |
| --- | --- |
| Home | mobile |
| PreviewGallery | mobile / tablet |
| ResultSummary | 操作可能な mobile / 状態別 mobile |

`@Preview` は `lib/src/presentation/screens/{feature}/*_preview.dart` に定義する。
プレビューと group は画面単位とし、部品単位では作成しない。

状態管理には Riverpod の `NotifierProvider` を使用し、provider と notifier は各画面の `*_notifier.dart` に配置する。
`ResultSummary` が状態切り替えの実装例となる。

## VRT

`@Preview` からテスト対象一覧を生成し、golden test で描画結果を検証する。
通常の画像生成と比較は CI で実行する。

### プレビューの条件

- `lib/` 配下の public なトップレベル関数
- 引数なし、戻り値に `Widget` または `WidgetBuilder` を明記
- `size` は生成処理が解決できる `Size(width, height)` 形式の定数
- 関数名から決まる画像出力名が全ファイルで一意
- 1 関数につき `@Preview` は 1 つ

static メソッドやコンストラクタは対象外とする。
`wrapper`、`theme`、`brightness`、`localizations`、`textScaleFactor` も未対応であり、指定すると生成エラーとなる。

### ローカル実行

プロジェクトルートで実行する。

```bash
# 基準画像を生成
fvm dart run tool/run_vrt.dart --update-goldens

# 基準画像と現在の描画結果を比較
fvm dart run tool/run_vrt.dart
```

いずれも VRT 一覧を再生成し、成功した場合のみテストを実行する。
画像は `test/vrt/goldens/ci/` に出力され、Git 管理の対象外となる。

## Android エミュレーター

```bash
fvm flutter emulators
fvm flutter emulators --launch <emulator_id>
fvm flutter devices
fvm flutter run -d <device_id>
```

## 検証

セットアップと VRT 一覧の生成後に実行する。

```bash
fvm flutter analyze
fvm flutter test --exclude-tags golden
fvm dart run tool/run_vrt.dart --update-goldens
fvm flutter test
```

生成処理のテストは `packages/vrt_preview_builder` で実行する。

```bash
fvm dart test
```

## CI

GitHub Actions の `vrt` ワークフローで実行する。
解析や撮影の前に VRT 一覧を生成する。

| ジョブ | 内容 |
| --- | --- |
| Verify | 静的解析、生成処理のテスト、golden 以外のテスト |
| Compare screenshots（PR） | base SHA と head SHA の画像を同じ環境で生成し、変更、追加、削除を検出 |
| Generate screenshots（main push） | 一覧生成と撮影の成功を確認 |

PR の比較結果は Actions アーティファクトに保存する。
同一リポジトリ内の PR（Dependabot を除く）では同じ bot コメントを更新し、差分がある場合は Before / After / Diff を最大 12 件表示する。

コメント用の画像は、差分がある場合に `vrt/screenshot-reports` ブランチの `vrt/pr-<number>/<short_sha>/` へ保存する。

## 補足

### VRT の描画

- テスト専用の NotoSansJP を使用するため、実アプリや Previewer と字形が異なる場合がある。
- Material の影は表示安定性のため無効にする。
- `Image` の読み込み失敗、10 秒のタイムアウト、VRT 一覧が空の場合はテスト失敗となる（`DecorationImage` は読み込み待機の対象外）。
- 画像は固定のローカルファイルを使用する。

### private リポジトリでの画像表示

認証情報なしの raw URL では画像を表示できないため、外部ストレージへのアップロードか、GitHub CLI v2.99.0 以降の `gh pr comment --attach` を利用する。
v2.99.0 の添付機能は `GITHUB_TOKEN` に未対応のため、CI では必要な権限を設定した PAT などを使用する。
