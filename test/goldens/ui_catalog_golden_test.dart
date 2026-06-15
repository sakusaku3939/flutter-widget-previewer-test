import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_previewer_lab/src/ui_catalog/preview_surface.dart';
import 'package:widget_previewer_lab/src/ui_catalog/widget_scenarios.dart';

void main() {
  group('UI catalog goldens', () {
    for (final scenario in widgetScenarios) {
      goldenTest(
        scenario.name,
        fileName: 'ui_catalog_${scenario.id}',
        constraints: BoxConstraints.tight(scenario.size),
        pumpBeforeTest: pumpOnce,
        builder: () => PreviewSurface(scenario: scenario),
      );
    }
  });
}
