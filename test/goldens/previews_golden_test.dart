import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_previewer_lab/src/presentation/previews/foundation/preview_surface.dart';
import 'package:widget_previewer_lab/src/presentation/previews/golden_previews.dart';

void main() {
  group('preview goldens', () {
    for (final preview in goldenPreviews) {
      goldenTest(
        preview.name,
        fileName: 'preview_${preview.goldenFileName}',
        constraints: BoxConstraints.tight(preview.size),
        pumpBeforeTest: pumpOnce,
        builder: () => PreviewSurface(previewCase: preview),
      );
    }
  });
}
