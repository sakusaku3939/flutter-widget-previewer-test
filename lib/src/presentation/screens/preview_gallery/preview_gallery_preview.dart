import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../previews/foundation/preview.dart';
import '../../previews/foundation/preview_surface.dart';
import '../../widgets/adaptive_preview_panel.dart';

const previewGalleryGroup = 'PreviewGallery';

const previewGalleryMobileSize = Size(390, 760);
const previewGalleryTabletSize = Size(760, 640);

const previewGalleryMobileName = 'Mobile layout';
const previewGalleryTabletName = 'Tablet layout';

PreviewCase get _previewGalleryMobilePreviewCase {
  return PreviewCase(
    goldenFileName: 'preview_gallery_mobile',
    group: previewGalleryGroup,
    name: previewGalleryMobileName,
    size: previewGalleryMobileSize,
    builder: (_) => const AdaptivePreviewPanel(),
  );
}

@Preview(
  group: previewGalleryGroup,
  name: previewGalleryMobileName,
  size: previewGalleryMobileSize,
  brightness: Brightness.light,
)
Widget previewGalleryMobilePreview() {
  return PreviewSurface(previewCase: _previewGalleryMobilePreviewCase);
}

PreviewCase get _previewGalleryTabletPreviewCase {
  return PreviewCase(
    goldenFileName: 'preview_gallery_tablet',
    group: previewGalleryGroup,
    name: previewGalleryTabletName,
    size: previewGalleryTabletSize,
    builder: (_) => const AdaptivePreviewPanel(),
  );
}

@Preview(
  group: previewGalleryGroup,
  name: previewGalleryTabletName,
  size: previewGalleryTabletSize,
  brightness: Brightness.light,
)
Widget previewGalleryTabletPreview() {
  return PreviewSurface(previewCase: _previewGalleryTabletPreviewCase);
}

List<PreviewCase> get previewGalleryPreviewCases {
  return [_previewGalleryMobilePreviewCase, _previewGalleryTabletPreviewCase];
}
