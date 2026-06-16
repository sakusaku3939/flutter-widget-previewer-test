import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_previewer_lab/src/presentation/previews/foundation/preview_surface.dart';
import 'package:widget_previewer_lab/src/presentation/previews/preview_cases.dart';

void main() {
  group('preview case goldens', () {
    for (final previewCase in goldenPreviewCases) {
      goldenTest(
        previewCase.name,
        fileName: 'preview_${previewCase.goldenFileName}',
        constraints: BoxConstraints.tight(previewCase.size),
        pumpBeforeTest: pumpOnce,
        builder: () => PreviewSurface(previewCase: previewCase),
      );
    }
  });
}
