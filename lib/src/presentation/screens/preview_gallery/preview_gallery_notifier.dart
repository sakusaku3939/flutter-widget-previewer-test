import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'preview_gallery_state.dart';

final previewGalleryNotifierProvider =
    NotifierProvider<PreviewGalleryNotifier, PreviewGalleryState>(
      PreviewGalleryNotifier.new,
    );

class PreviewGalleryNotifier extends Notifier<PreviewGalleryState> {
  @override
  PreviewGalleryState build() => const PreviewGalleryState();
}
