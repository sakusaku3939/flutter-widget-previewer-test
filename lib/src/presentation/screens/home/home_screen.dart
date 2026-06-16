import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design/app_tokens.dart';
import 'home_notifier.dart';
import 'home_state.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Widget Previewer Lab')),
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTokens.spacing),
            child: HomeContent(
              state: state,
              onOpen: (routeName) => Navigator.of(context).pushNamed(routeName),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({this.state = const HomeState(), this.onOpen, super.key});

  final HomeState state;
  final ValueChanged<String>? onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Screens', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          'プレビュー対象の画面へ移動して、通常アプリ上でも同じ UI を確認できます。',
          style: theme.textTheme.bodyMedium?.copyWith(color: AppTokens.muted),
        ),
        const SizedBox(height: AppTokens.spacing),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 640;
            final cards = [
              for (final destination in state.destinations)
                _DestinationCard(
                  destination: destination,
                  onPressed: onOpen == null
                      ? null
                      : () => onOpen!(destination.routeName),
                ),
            ];

            if (!isWide) {
              return Column(spacing: 12, children: cards);
            }

            return GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: AppTokens.spacing,
              mainAxisSpacing: AppTokens.spacing,
              childAspectRatio: 2.2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: cards,
            );
          },
        ),
      ],
    );
  }
}

class _DestinationCard extends StatelessWidget {
  const _DestinationCard({required this.destination, this.onPressed});

  final HomeDestination destination;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppTokens.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppTokens.cardPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destination.label,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(destination.title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      destination.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTokens.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(Icons.chevron_right, color: theme.colorScheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}
