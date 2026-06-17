import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_previewer_lab/src/presentation/previews/foundation/preview_surface.dart';
import 'package:widget_previewer_lab/src/presentation/previews/vrt_previews.dart';

void main() {
  group('preview VRT', () {
    for (final preview in visualRegressionPreviews) {
      goldenTest(
        '${preview.group} ${preview.name}',
        fileName: 'preview_${preview.vrtFileName}',
        constraints: BoxConstraints.tight(preview.size),
        pumpBeforeTest: pumpOnce,
        builder: () => PreviewSurface(previewCase: preview),
      );
    }
  });
}
