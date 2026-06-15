import 'package:flutter/material.dart';

class UiScenario {
  const UiScenario({
    required this.id,
    required this.group,
    required this.name,
    required this.size,
    required this.builder,
    this.brightness = Brightness.light,
  });

  final String id;
  final String group;
  final String name;
  final Size size;
  final Brightness brightness;
  final WidgetBuilder builder;
}
