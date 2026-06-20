import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../previews/foundation/preview_surface.dart';
import '../../widgets/adaptive_preview_panel.dart';

const previewGalleryGroup = 'PreviewGallery';

const previewGalleryMobileSize = Size(390, 760);
const previewGalleryTabletSize = Size(760, 640);

const previewGalleryMobileName = 'Mobile layout';
const previewGalleryTabletName = 'Tablet layout';

@Preview(
  group: previewGalleryGroup,
  name: previewGalleryMobileName,
  size: previewGalleryMobileSize,
)
Widget previewGalleryMobilePreview() {
  return const PreviewSurface(child: AdaptivePreviewPanel());
}

@Preview(
  group: previewGalleryGroup,
  name: previewGalleryTabletName,
  size: previewGalleryTabletSize,
)
Widget previewGalleryTabletPreview() {
  return const PreviewSurface(child: AdaptivePreviewPanel());
}
