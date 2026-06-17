import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_previewer_lab/src/presentation/previews/foundation/preview_surface.dart';
import 'package:widget_previewer_lab/src/presentation/previews/vrt_previews.dart';

void main() {
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
              child: PreviewSurface(previewCase: preview),
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
