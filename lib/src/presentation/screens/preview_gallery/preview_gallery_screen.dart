import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design/app_tokens.dart';
import '../../widgets/adaptive_preview_panel.dart';
import 'preview_gallery_notifier.dart';

class PreviewGalleryScreen extends ConsumerWidget {
  const PreviewGalleryScreen({super.key});

  static const routeName = '/preview-gallery';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(previewGalleryNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Widget Previewer Lab')),
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTokens.spacing),
            child: AdaptivePreviewPanel(state: state),
          ),
        ),
      ),
    );
  }
}
