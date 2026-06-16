import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design/app_tokens.dart';
import 'result_summary_notifier.dart';
import 'result_summary_state.dart';

class ResultSummaryScreen extends ConsumerWidget {
  const ResultSummaryScreen({super.key});

  static const routeName = '/result-summary';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(resultSummaryNotifierProvider);
    final notifier = ref.read(resultSummaryNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Result Summary')),
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTokens.spacing),
            child: ResultSummaryContent(
              state: state,
              onStatusChanged: notifier.selectStatus,
              onPressed: notifier.moveToNextStatus,
            ),
          ),
        ),
      ),
    );
  }
}

class ResultSummaryContent extends StatelessWidget {
  const ResultSummaryContent({
    this.state = const ResultSummaryState(),
    this.onStatusChanged,
    this.onPressed,
    super.key,
  });

  final ResultSummaryState state;
  final ValueChanged<ResultSummaryStatus>? onStatusChanged;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppTokens.cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ResultBadge(text: state.subject),
                const SizedBox(height: 12),
                SegmentedButton<ResultSummaryStatus>(
                  segments: [
                    for (final status in ResultSummaryStatus.values)
                      ButtonSegment(value: status, label: Text(status.label)),
                  ],
                  selected: {state.status},
                  onSelectionChanged: onStatusChanged == null
                      ? null
                      : (selected) => onStatusChanged!(selected.first),
                ),
                const SizedBox(height: AppTokens.spacing),
                Text(state.title, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 10),
                Text(
                  state.message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppTokens.muted,
                  ),
                ),
                const SizedBox(height: AppTokens.spacing),
                FilledButton.icon(
                  onPressed: onPressed,
                  icon: const Icon(Icons.arrow_forward),
                  label: Text(state.actionLabel),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppTokens.spacing),
        Text('Next steps', style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        Column(
          spacing: 12,
          children: [
            for (final (index, step) in state.steps.indexed)
              _StepCard(step: step, index: index + 1),
          ],
        ),
      ],
    );
  }
}

class _ResultBadge extends StatelessWidget {
  const _ResultBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: const Icon(Icons.check_circle, size: 18),
      label: Text(text),
      visualDensity: VisualDensity.compact,
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({required this.step, required this.index});

  final ResultSummaryStep step;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTokens.cardPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              child: Text(
                '$index',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(step.title, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(
                    step.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTokens.muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
