import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design/app_tokens.dart';
import '../../theme/app_theme.dart';

class PreviewSurface extends StatelessWidget {
  const PreviewSurface({
    required this.child,
    this.brightness = Brightness.light,
    super.key,
  });

  final Widget child;
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    final appTheme = brightness == Brightness.dark
        ? AppTheme.dark()
        : AppTheme.light();
    // Registered only by the golden test; Previewer uses system fallback.
    final theme = appTheme.copyWith(
      textTheme: appTheme.textTheme.apply(fontFamily: 'NotoSansJP'),
      primaryTextTheme: appTheme.primaryTextTheme.apply(
        fontFamily: 'NotoSansJP',
      ),
    );

    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTokens.spacing),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
