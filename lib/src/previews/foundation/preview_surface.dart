import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import 'preview_scenario.dart';

class PreviewSurface extends StatelessWidget {
  const PreviewSurface({required this.scenario, super.key});

  final PreviewScenario scenario;

  @override
  Widget build(BuildContext context) {
    final theme = scenario.brightness == Brightness.dark
        ? AppTheme.dark()
        : AppTheme.light();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTokens.spacing),
            child: Builder(builder: scenario.builder),
          ),
        ),
      ),
    );
  }
}
