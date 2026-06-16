import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/widget_previews.dart';

import '../../previews/foundation/preview.dart';
import '../../previews/foundation/preview_surface.dart';
import 'result_summary_notifier.dart';
import 'result_summary_screen.dart';
import 'result_summary_state.dart';

const resultSummaryGroup = 'ResultSummary';

const resultSummaryMobileSize = Size(390, 760);
const resultSummaryTabletSize = Size(760, 640);

const resultSummaryInteractiveMobileName = 'Interactive mobile';
const resultSummaryInteractiveTabletName = 'Interactive tablet';
const resultSummaryInProgressMobileName = 'In progress mobile';
const resultSummaryCompletedMobileName = 'Completed mobile';
const resultSummaryAttentionMobileName = 'Attention mobile';

PreviewCase get _resultSummaryInteractiveMobilePreviewCase {
  return PreviewCase(
    goldenFileName: 'result_summary_interactive_mobile',
    group: resultSummaryGroup,
    name: resultSummaryInteractiveMobileName,
    size: resultSummaryMobileSize,
    builder: (_) => const ResultSummaryPreviewContent(),
  );
}

@Preview(
  group: resultSummaryGroup,
  name: resultSummaryInteractiveMobileName,
  size: resultSummaryMobileSize,
  brightness: Brightness.light,
)
Widget resultSummaryInteractiveMobilePreview() {
  return PreviewSurface(
    previewCase: _resultSummaryInteractiveMobilePreviewCase,
  );
}

PreviewCase get _resultSummaryInteractiveTabletPreviewCase {
  return PreviewCase(
    goldenFileName: 'result_summary_interactive_tablet',
    group: resultSummaryGroup,
    name: resultSummaryInteractiveTabletName,
    size: resultSummaryTabletSize,
    builder: (_) => const ResultSummaryPreviewContent(),
  );
}

@Preview(
  group: resultSummaryGroup,
  name: resultSummaryInteractiveTabletName,
  size: resultSummaryTabletSize,
  brightness: Brightness.light,
)
Widget resultSummaryInteractiveTabletPreview() {
  return PreviewSurface(
    previewCase: _resultSummaryInteractiveTabletPreviewCase,
  );
}

PreviewCase get _resultSummaryInProgressMobilePreviewCase {
  return _resultSummaryPreviewCaseForStatus(
    status: ResultSummaryStatus.inProgress,
    goldenFileName: 'result_summary_in_progress_mobile',
    name: resultSummaryInProgressMobileName,
    size: resultSummaryMobileSize,
  );
}

@Preview(
  group: resultSummaryGroup,
  name: resultSummaryInProgressMobileName,
  size: resultSummaryMobileSize,
  brightness: Brightness.light,
)
Widget resultSummaryInProgressMobilePreview() {
  return PreviewSurface(previewCase: _resultSummaryInProgressMobilePreviewCase);
}

PreviewCase get _resultSummaryCompletedMobilePreviewCase {
  return _resultSummaryPreviewCaseForStatus(
    status: ResultSummaryStatus.completed,
    goldenFileName: 'result_summary_completed_mobile',
    name: resultSummaryCompletedMobileName,
    size: resultSummaryMobileSize,
  );
}

@Preview(
  group: resultSummaryGroup,
  name: resultSummaryCompletedMobileName,
  size: resultSummaryMobileSize,
  brightness: Brightness.light,
)
Widget resultSummaryCompletedMobilePreview() {
  return PreviewSurface(previewCase: _resultSummaryCompletedMobilePreviewCase);
}

PreviewCase get _resultSummaryAttentionMobilePreviewCase {
  return _resultSummaryPreviewCaseForStatus(
    status: ResultSummaryStatus.attention,
    goldenFileName: 'result_summary_attention_mobile',
    name: resultSummaryAttentionMobileName,
    size: resultSummaryMobileSize,
  );
}

@Preview(
  group: resultSummaryGroup,
  name: resultSummaryAttentionMobileName,
  size: resultSummaryMobileSize,
  brightness: Brightness.light,
)
Widget resultSummaryAttentionMobilePreview() {
  return PreviewSurface(previewCase: _resultSummaryAttentionMobilePreviewCase);
}

List<PreviewCase> get resultSummaryPreviewCases {
  return [
    _resultSummaryInProgressMobilePreviewCase,
    _resultSummaryCompletedMobilePreviewCase,
    _resultSummaryAttentionMobilePreviewCase,
  ];
}

PreviewCase _resultSummaryPreviewCaseForStatus({
  required ResultSummaryStatus status,
  required String goldenFileName,
  required String name,
  required Size size,
}) {
  return PreviewCase(
    goldenFileName: goldenFileName,
    group: resultSummaryGroup,
    name: name,
    size: size,
    builder: (_) => ResultSummaryContent(
      state: ResultSummaryState(status: status),
      onStatusChanged: (_) {},
      onPressed: () {},
    ),
  );
}

class ResultSummaryPreviewContent extends ConsumerWidget {
  const ResultSummaryPreviewContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(resultSummaryNotifierProvider);
    final notifier = ref.read(resultSummaryNotifierProvider.notifier);

    return ResultSummaryContent(
      state: state,
      onStatusChanged: notifier.selectStatus,
      onPressed: notifier.moveToNextStatus,
    );
  }
}
