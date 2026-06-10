import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../models/preview_status.dart';
import '../theme/app_theme.dart';
import '../widgets/adaptive_preview_panel.dart';
import '../widgets/status_card.dart';

@Preview(
  group: 'Status',
  name: 'Success card',
  size: Size(390, 180),
  brightness: Brightness.light,
)
Widget successStatusCardPreview() {
  return const PreviewHost(child: StatusCard(status: PreviewStatus.success));
}

@Preview(
  group: 'Status',
  name: 'Error card',
  size: Size(390, 180),
  brightness: Brightness.light,
)
Widget errorStatusCardPreview() {
  return const PreviewHost(child: StatusCard(status: PreviewStatus.error));
}

@Preview(
  group: 'Theme',
  name: 'Status card dark',
  size: Size(390, 180),
  brightness: Brightness.dark,
)
Widget darkStatusCardPreview() {
  return const PreviewHost(
    brightness: Brightness.dark,
    child: StatusCard(status: PreviewStatus.loading),
  );
}

@Preview(
  group: 'Layout',
  name: 'Mobile layout',
  size: Size(390, 760),
  brightness: Brightness.light,
)
Widget mobileLayoutPreview() {
  return const PreviewHost(child: AdaptivePreviewPanel());
}

@Preview(
  group: 'Layout',
  name: 'Tablet layout',
  size: Size(760, 640),
  brightness: Brightness.light,
)
Widget tabletLayoutPreview() {
  return const PreviewHost(child: AdaptivePreviewPanel());
}

@Preview(
  group: 'Locale',
  name: 'Japanese labels',
  size: Size(430, 260),
  brightness: Brightness.light,
)
Widget japaneseLabelsPreview() {
  return const PreviewHost(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        StatusCard(status: PreviewStatus.empty),
        SizedBox(height: AppTokens.spacing),
        StatusCard(status: PreviewStatus.success),
      ],
    ),
  );
}

class PreviewHost extends StatelessWidget {
  const PreviewHost({
    required this.child,
    this.brightness = Brightness.light,
    super.key,
  });

  final Widget child;
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    final theme = brightness == Brightness.dark
        ? AppTheme.dark()
        : AppTheme.light();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTokens.spacing),
            child: child,
          ),
        ),
      ),
    );
  }
}
