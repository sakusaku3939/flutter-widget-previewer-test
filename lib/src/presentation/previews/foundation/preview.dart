import 'package:flutter/material.dart';

class PreviewCase {
  const PreviewCase({
    required this.goldenFileName,
    required this.group,
    required this.name,
    required this.size,
    required this.builder,
    this.brightness = Brightness.light,
  });

  final String goldenFileName;
  final String group;
  final String name;
  final Size size;
  final Brightness brightness;
  final WidgetBuilder builder;
}
