import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/widget_previews.dart';

import '../../previews/foundation/preview_surface.dart';
import 'result_summary_notifier.dart';
import 'result_summary_screen.dart';
import 'result_summary_state.dart';

const resultSummaryGroup = 'ResultSummary';

const resultSummaryMobileSize = Size(390, 760);

const resultSummaryInteractiveMobileName = 'Interactive mobile';
const resultSummaryInProgressMobileName = 'In progress mobile';
const resultSummaryCompletedMobileName = 'Completed mobile';
const resultSummaryAttentionMobileName = 'Attention mobile';

@Preview(
  group: resultSummaryGroup,
  name: resultSummaryInteractiveMobileName,
  size: resultSummaryMobileSize,
)
Widget resultSummaryInteractiveMobilePreview() {
  return const PreviewSurface(child: ResultSummaryPreviewContent());
}

@Preview(
  group: resultSummaryGroup,
  name: resultSummaryInProgressMobileName,
  size: resultSummaryMobileSize,
)
Widget resultSummaryInProgressMobilePreview() {
  return PreviewSurface(
    child: _resultSummaryPreviewContentForStatus(
      ResultSummaryStatus.inProgress,
    ),
  );
}

@Preview(
  group: resultSummaryGroup,
  name: resultSummaryCompletedMobileName,
  size: resultSummaryMobileSize,
)
Widget resultSummaryCompletedMobilePreview() {
  return PreviewSurface(
    child: _resultSummaryPreviewContentForStatus(ResultSummaryStatus.completed),
  );
}

@Preview(
  group: resultSummaryGroup,
  name: resultSummaryAttentionMobileName,
  size: resultSummaryMobileSize,
)
Widget resultSummaryAttentionMobilePreview() {
  return PreviewSurface(
    child: _resultSummaryPreviewContentForStatus(ResultSummaryStatus.attention),
  );
}

Widget _resultSummaryPreviewContentForStatus(ResultSummaryStatus status) {
  return ResultSummaryContent(
    state: ResultSummaryState(status: status),
    onStatusChanged: (_) {},
    onPressed: () {},
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
