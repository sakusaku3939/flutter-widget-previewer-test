import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../widgets/adaptive_preview_panel.dart';
import '../foundation/preview_case.dart';
import '../foundation/preview_surface.dart';

const previewGalleryGroup = 'PreviewGallery';

const previewGalleryMobileSize = Size(390, 760);
const previewGalleryTabletSize = Size(760, 640);

const previewGalleryMobileName = 'Mobile layout';
const previewGalleryTabletName = 'Tablet layout';

final previewGalleryMobilePreviewCase = PreviewCase(
  goldenFileName: 'preview_gallery_mobile',
  group: previewGalleryGroup,
  name: previewGalleryMobileName,
  size: previewGalleryMobileSize,
  builder: (_) => const AdaptivePreviewPanel(),
);

@Preview(
  group: previewGalleryGroup,
  name: previewGalleryMobileName,
  size: previewGalleryMobileSize,
  brightness: Brightness.light,
)
Widget previewGalleryMobilePreview() {
  return _preview(previewGalleryMobilePreviewCase);
}

final previewGalleryTabletPreviewCase = PreviewCase(
  goldenFileName: 'preview_gallery_tablet',
  group: previewGalleryGroup,
  name: previewGalleryTabletName,
  size: previewGalleryTabletSize,
  builder: (_) => const AdaptivePreviewPanel(),
);

@Preview(
  group: previewGalleryGroup,
  name: previewGalleryTabletName,
  size: previewGalleryTabletSize,
  brightness: Brightness.light,
)
Widget previewGalleryTabletPreview() {
  return _preview(previewGalleryTabletPreviewCase);
}

final previewGalleryPreviewCases = <PreviewCase>[
  previewGalleryMobilePreviewCase,
  previewGalleryTabletPreviewCase,
];

Widget _preview(PreviewCase previewCase) {
  return PreviewSurface(previewCase: previewCase);
}
