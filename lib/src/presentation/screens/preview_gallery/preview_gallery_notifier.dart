import 'package:flutter/foundation.dart';

import 'preview_gallery_state.dart';

class PreviewGalleryNotifier extends ChangeNotifier {
  PreviewGalleryNotifier([this._state = const PreviewGalleryState()]);

  PreviewGalleryState _state;

  PreviewGalleryState get state => _state;

  set state(PreviewGalleryState value) {
    if (identical(_state, value)) {
      return;
    }
    _state = value;
    notifyListeners();
  }
}
