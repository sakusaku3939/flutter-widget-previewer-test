import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_previewer_lab/src/previews/foundation/preview_surface.dart';
import 'package:widget_previewer_lab/src/previews/preview_scenarios.dart';

void main() {
  group('preview scenario goldens', () {
    for (final scenario in previewScenarios) {
      goldenTest(
        scenario.name,
        fileName: 'preview_${scenario.id}',
        constraints: BoxConstraints.tight(scenario.size),
        pumpBeforeTest: pumpOnce,
        builder: () => PreviewSurface(scenario: scenario),
      );
    }
  });
}
