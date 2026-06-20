import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../previews/foundation/preview.dart';
import '../../previews/foundation/preview_surface.dart';
import 'home_screen.dart';

const homeGroup = 'Home';

const homeMobileSize = Size(390, 760);

const homeMobileName = 'Mobile layout';

PreviewCase get _homeMobilePreviewCase {
  return PreviewCase(
    vrtFileName: 'home_mobile',
    group: homeGroup,
    name: homeMobileName,
    size: homeMobileSize,
    builder: (_) => const HomeContent(),
  );
}

@Preview(
  group: homeGroup,
  name: homeMobileName,
  size: homeMobileSize,
  brightness: Brightness.light,
)
Widget homeMobilePreview() {
  return PreviewSurface(previewCase: _homeMobilePreviewCase);
}
