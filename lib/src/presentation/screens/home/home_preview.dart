import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../previews/foundation/preview.dart';
import '../../previews/foundation/preview_surface.dart';
import 'home_screen.dart';

const homeGroup = 'Home';

const homeMobileSize = Size(390, 760);
const homeTabletSize = Size(760, 640);

const homeMobileName = 'Mobile layout';
const homeTabletName = 'Tablet layout';

final _homeMobilePreviewCase = PreviewCase(
  goldenFileName: 'home_mobile',
  group: homeGroup,
  name: homeMobileName,
  size: homeMobileSize,
  builder: (_) => const HomeContent(),
);

@Preview(
  group: homeGroup,
  name: homeMobileName,
  size: homeMobileSize,
  brightness: Brightness.light,
)
Widget homeMobilePreview() {
  return PreviewSurface(previewCase: _homeMobilePreviewCase);
}

final _homeTabletPreviewCase = PreviewCase(
  goldenFileName: 'home_tablet',
  group: homeGroup,
  name: homeTabletName,
  size: homeTabletSize,
  builder: (_) => const HomeContent(),
);

@Preview(
  group: homeGroup,
  name: homeTabletName,
  size: homeTabletSize,
  brightness: Brightness.light,
)
Widget homeTabletPreview() {
  return PreviewSurface(previewCase: _homeTabletPreviewCase);
}

final homePreviewCases = <PreviewCase>[
  _homeMobilePreviewCase,
  _homeTabletPreviewCase,
];
