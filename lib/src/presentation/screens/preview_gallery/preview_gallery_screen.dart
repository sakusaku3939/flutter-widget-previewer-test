import 'package:flutter/material.dart';

import '../../../core/design/app_tokens.dart';
import '../../widgets/adaptive_preview_panel.dart';
import 'preview_gallery_notifier.dart';

class PreviewGalleryScreen extends StatefulWidget {
  const PreviewGalleryScreen({super.key});

  static const routeName = '/preview-gallery';

  @override
  State<PreviewGalleryScreen> createState() => _PreviewGalleryScreenState();
}

class _PreviewGalleryScreenState extends State<PreviewGalleryScreen> {
  late final PreviewGalleryNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = PreviewGalleryNotifier();
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Widget Previewer Lab')),
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTokens.spacing),
            child: ListenableBuilder(
              listenable: _notifier,
              builder: (context, _) {
                return AdaptivePreviewPanel(state: _notifier.state);
              },
            ),
          ),
        ),
      ),
    );
  }
}
