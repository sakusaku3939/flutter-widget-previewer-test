import '../screens/home/home_preview.dart';
import '../screens/preview_gallery/preview_gallery_preview.dart';
import '../screens/result_summary/result_summary_preview.dart';
import 'foundation/preview.dart';

List<PreviewCase> get goldenPreviews {
  return [
    ...homePreviewCases,
    ...previewGalleryPreviewCases,
    ...resultSummaryPreviewCases,
  ];
}
