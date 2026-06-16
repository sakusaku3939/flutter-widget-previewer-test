import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'result_summary_state.dart';

final resultSummaryNotifierProvider =
    NotifierProvider<ResultSummaryNotifier, ResultSummaryState>(
      ResultSummaryNotifier.new,
    );

class ResultSummaryNotifier extends Notifier<ResultSummaryState> {
  @override
  ResultSummaryState build() => const ResultSummaryState();

  void selectStatus(ResultSummaryStatus status) {
    state = state.copyWith(status: status);
  }

  void moveToNextStatus() {
    final nextStatus = switch (state.status) {
      ResultSummaryStatus.inProgress => ResultSummaryStatus.completed,
      ResultSummaryStatus.completed => ResultSummaryStatus.attention,
      ResultSummaryStatus.attention => ResultSummaryStatus.inProgress,
    };

    selectStatus(nextStatus);
  }
}
