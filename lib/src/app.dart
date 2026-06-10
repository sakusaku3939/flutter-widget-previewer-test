import 'package:flutter/material.dart';

import 'screens/preview_gallery_screen.dart';
import 'theme/app_theme.dart';

class WidgetPreviewerLabApp extends StatelessWidget {
  const WidgetPreviewerLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Widget Previewer Lab',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: const PreviewGalleryScreen(),
    );
  }
}
