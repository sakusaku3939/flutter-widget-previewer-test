import 'package:flutter/foundation.dart';

import 'result_summary_state.dart';

class ResultSummaryNotifier extends ChangeNotifier {
  ResultSummaryNotifier([this._state = const ResultSummaryState()]);

  ResultSummaryState _state;

  ResultSummaryState get state => _state;

  set state(ResultSummaryState value) {
    if (identical(_state, value)) {
      return;
    }
    _state = value;
    notifyListeners();
  }

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
