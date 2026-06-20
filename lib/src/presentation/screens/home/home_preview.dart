import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../previews/foundation/preview_surface.dart';
import 'home_screen.dart';

const homeGroup = 'Home';

const homeMobileSize = Size(390, 760);

const homeMobileName = 'Mobile layout';

@Preview(group: homeGroup, name: homeMobileName, size: homeMobileSize)
Widget homeMobilePreview() {
  return const PreviewSurface(child: HomeContent());
}
