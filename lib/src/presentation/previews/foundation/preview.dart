import 'package:flutter/material.dart';

class PreviewCase {
  const PreviewCase({
    required this.vrtFileName,
    required this.group,
    required this.name,
    required this.size,
    required this.builder,
    this.brightness = Brightness.light,
  });

  final String vrtFileName;
  final String group;
  final String name;
  final Size size;
  final Brightness brightness;
  final WidgetBuilder builder;
}
