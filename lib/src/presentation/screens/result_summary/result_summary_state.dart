class ResultSummaryState {
  const ResultSummaryState({
    this.status = ResultSummaryStatus.inProgress,
    this.subject = 'サンプルユーザー',
    this.steps = const [
      ResultSummaryStep(title: '受付完了', description: '入力内容を受け付けました。'),
      ResultSummaryStep(title: '確認中', description: '内容を確認しています。'),
      ResultSummaryStep(title: '通知待ち', description: '必要に応じて追加情報をご案内します。'),
    ],
  });

  final ResultSummaryStatus status;
  final String subject;
  final List<ResultSummaryStep> steps;

  String get title => status.title;

  String get message => status.message;

  String get actionLabel => status.actionLabel;

  ResultSummaryState copyWith({
    ResultSummaryStatus? status,
    String? subject,
    List<ResultSummaryStep>? steps,
  }) {
    return ResultSummaryState(
      status: status ?? this.status,
      subject: subject ?? this.subject,
      steps: steps ?? this.steps,
    );
  }
}

class ResultSummaryStep {
  const ResultSummaryStep({required this.title, required this.description});

  final String title;
  final String description;
}

enum ResultSummaryStatus {
  inProgress(
    label: '確認中',
    title: '処理を確認しています',
    message: '現在の状態を確認しています。完了後に結果と次の操作が表示されます。',
    actionLabel: '完了に進める',
  ),
  completed(
    label: '完了',
    title: '処理が完了しました',
    message: '結果を確認し、必要に応じて次の操作へ進めます。',
    actionLabel: '注意状態にする',
  ),
  attention(
    label: '要確認',
    title: '確認が必要です',
    message: '一部の項目に確認が必要です。内容を見直してから次の操作へ進めてください。',
    actionLabel: '確認中に戻す',
  );

  const ResultSummaryStatus({
    required this.label,
    required this.title,
    required this.message,
    required this.actionLabel,
  });

  final String label;
  final String title;
  final String message;
  final String actionLabel;
}
