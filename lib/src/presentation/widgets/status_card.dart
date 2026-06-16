import 'package:flutter/material.dart';

import '../../core/design/app_tokens.dart';
import '../screens/preview_gallery/preview_gallery_state.dart';

class StatusCard extends StatelessWidget {
  const StatusCard({required this.status, this.compact = false, super.key});

  final PreviewStatus status;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = status.color(context);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(compact ? 14 : AppTokens.cardPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StatusMarker(color: statusColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(status.title, style: theme.textTheme.titleMedium),
                      _StatusLabel(text: status.label, color: statusColor),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    status.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTokens.muted,
                    ),
                  ),
                  if (status == PreviewStatus.loading) ...[
                    const SizedBox(height: 14),
                    const LinearProgressIndicator(minHeight: 5),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusMarker extends StatelessWidget {
  const _StatusMarker({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _StatusLabel extends StatelessWidget {
  const _StatusLabel({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: color),
        ),
      ),
    );
  }
}
