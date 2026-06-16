import 'package:flutter/material.dart';

import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/preview_gallery/preview_gallery_screen.dart';
import 'presentation/screens/result_summary/result_summary_screen.dart';
import 'presentation/theme/app_theme.dart';

class WidgetPreviewerLabApp extends StatelessWidget {
  const WidgetPreviewerLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Widget Previewer Lab',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: const HomeScreen(),
      routes: {
        PreviewGalleryScreen.routeName: (_) => const PreviewGalleryScreen(),
        ResultSummaryScreen.routeName: (_) => const ResultSummaryScreen(),
      },
    );
  }
}
