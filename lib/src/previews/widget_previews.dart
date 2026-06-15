import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../ui_catalog/preview_surface.dart';
import '../ui_catalog/widget_scenarios.dart';

@Preview(
  group: 'Status',
  name: 'Success card',
  size: Size(390, 180),
  brightness: Brightness.light,
)
Widget successStatusCardPreview() {
  return PreviewSurface(scenario: widgetScenarioById('status_success_card'));
}

@Preview(
  group: 'Status',
  name: 'Error card',
  size: Size(390, 180),
  brightness: Brightness.light,
)
Widget errorStatusCardPreview() {
  return PreviewSurface(scenario: widgetScenarioById('status_error_card'));
}

@Preview(
  group: 'Theme',
  name: 'Status card dark',
  size: Size(390, 180),
  brightness: Brightness.dark,
)
Widget darkStatusCardPreview() {
  return PreviewSurface(scenario: widgetScenarioById('theme_status_card_dark'));
}

@Preview(
  group: 'Layout',
  name: 'Mobile layout',
  size: Size(390, 760),
  brightness: Brightness.light,
)
Widget mobileLayoutPreview() {
  return PreviewSurface(scenario: widgetScenarioById('layout_mobile'));
}

@Preview(
  group: 'Layout',
  name: 'Tablet layout',
  size: Size(760, 640),
  brightness: Brightness.light,
)
Widget tabletLayoutPreview() {
  return PreviewSurface(scenario: widgetScenarioById('layout_tablet'));
}

@Preview(
  group: 'Locale',
  name: 'Japanese labels',
  size: Size(430, 260),
  brightness: Brightness.light,
)
Widget japaneseLabelsPreview() {
  return PreviewSurface(scenario: widgetScenarioById('locale_japanese_labels'));
}
