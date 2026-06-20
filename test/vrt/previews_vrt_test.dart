import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_previewer_lab/src/presentation/previews/vrt_previews.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(_loadAppFonts);

  group('preview VRT', () {
    for (final preview in visualRegressionPreviews) {
      testWidgets('${preview.group} ${preview.name}', (tester) async {
        await tester.binding.setSurfaceSize(preview.size);
        tester.view
          ..devicePixelRatio = 1.0
          ..physicalSize = preview.size;
        tester.platformDispatcher.textScaleFactorTestValue = 1.0;
        addTearDown(() => tester.binding.setSurfaceSize(null));
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

        final previewKey = ValueKey('preview-${preview.vrtFileName}');
        await tester.pumpWidget(
          RepaintBoundary(
            key: previewKey,
            child: SizedBox.fromSize(
              size: preview.size,
              child: preview.builder(),
            ),
          ),
        );
        await tester.pump();

        await expectLater(
          find.byKey(previewKey),
          matchesGoldenFile('goldens/ci/preview_${preview.vrtFileName}.png'),
        );
      }, tags: 'golden');
    }
  });
}

Future<void> _loadAppFonts() async {
  final fontManifestJson = await rootBundle.loadString('FontManifest.json');
  final fontManifest = json.decode(fontManifestJson) as List<dynamic>;

  for (final fontFamilyManifest in fontManifest) {
    final fontFamily = fontFamilyManifest as Map<String, dynamic>;
    final loader = FontLoader(fontFamily['family'] as String);
    final fonts = fontFamily['fonts'] as List<dynamic>;

    for (final fontManifest in fonts) {
      final font = fontManifest as Map<String, dynamic>;
      loader.addFont(rootBundle.load(font['asset'] as String));
    }

    await loader.load();
  }
}
