import 'package:flutter/material.dart';

import '../../models/preview_status.dart';
import '../../theme/app_theme.dart';
import '../../widgets/adaptive_preview_panel.dart';
import '../../widgets/status_card.dart';
import '../foundation/preview_scenario.dart';

final widgetPreviewScenarios = <PreviewScenario>[
  PreviewScenario(
    id: 'status_success_card',
    group: 'Status',
    name: 'Success card',
    size: const Size(390, 180),
    builder: (_) => const StatusCard(status: PreviewStatus.success),
  ),
  PreviewScenario(
    id: 'status_error_card',
    group: 'Status',
    name: 'Error card',
    size: const Size(390, 180),
    builder: (_) => const StatusCard(status: PreviewStatus.error),
  ),
  PreviewScenario(
    id: 'theme_status_card_dark',
    group: 'Theme',
    name: 'Status card dark',
    size: const Size(390, 180),
    brightness: Brightness.dark,
    builder: (_) => const StatusCard(status: PreviewStatus.loading),
  ),
  PreviewScenario(
    id: 'layout_mobile',
    group: 'Layout',
    name: 'Mobile layout',
    size: const Size(390, 760),
    builder: (_) => const AdaptivePreviewPanel(),
  ),
  PreviewScenario(
    id: 'layout_tablet',
    group: 'Layout',
    name: 'Tablet layout',
    size: const Size(760, 640),
    builder: (_) => const AdaptivePreviewPanel(),
  ),
  PreviewScenario(
    id: 'locale_japanese_labels',
    group: 'Locale',
    name: 'Japanese labels',
    size: const Size(430, 260),
    builder: (_) => const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        StatusCard(status: PreviewStatus.empty),
        SizedBox(height: AppTokens.spacing),
        StatusCard(status: PreviewStatus.success),
      ],
    ),
  ),
];
