import 'package:flutter/material.dart';

typedef VrtPreviewBuilder = Widget Function();

class VrtPreviewEntry {
  const VrtPreviewEntry({
    required this.vrtFileName,
    required this.group,
    required this.name,
    required this.size,
    required this.builder,
  });

  final String vrtFileName;
  final String group;
  final String name;
  final Size size;
  final VrtPreviewBuilder builder;
}
