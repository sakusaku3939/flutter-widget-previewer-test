import 'package:flutter/material.dart';

import '../../core/design/app_tokens.dart';
import '../screens/preview_gallery/preview_gallery_state.dart';
import 'status_card.dart';

class AdaptivePreviewPanel extends StatelessWidget {
  const AdaptivePreviewPanel({
    this.state = const PreviewGalleryState(),
    super.key,
  });

  final PreviewGalleryState state;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 640;
        final cards = state.statuses
            .map((status) => StatusCard(status: status, compact: !isWide))
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(width: constraints.maxWidth),
            const SizedBox(height: AppTokens.spacing),
            if (isWide)
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: AppTokens.spacing,
                mainAxisSpacing: AppTokens.spacing,
                childAspectRatio: 2.4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: cards,
              )
            else
              Column(spacing: 12, children: cards),
            const SizedBox(height: AppTokens.spacing),
            _VerificationStrip(commands: state.commands),
          ],
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTokens.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'FLUTTER PREVIEWER',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text('Widget Previewer Lab', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 10),
            Text(
              'Previewer と Android エミュレーターで同じ Widget を検証する最小テストアプリ。',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppTokens.muted,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Current width: ${width.toStringAsFixed(0)}dp',
              style: theme.textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _VerificationStrip extends StatelessWidget {
  const _VerificationStrip({required this.commands});

  final List<String> commands;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final command in commands)
          Chip(label: Text(command), visualDensity: VisualDensity.compact),
      ],
    );
  }
}
