import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/adaptive_preview_panel.dart';

class PreviewGalleryScreen extends StatelessWidget {
  const PreviewGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Widget Previewer Lab')),
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTokens.spacing),
            child: const AdaptivePreviewPanel(),
          ),
        ),
      ),
    );
  }
}
