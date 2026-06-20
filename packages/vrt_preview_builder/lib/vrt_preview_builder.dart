import 'dart:async';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:build/build.dart';
import 'package:glob/glob.dart';

Builder vrtPreviewBuilder(BuilderOptions _) => const VrtPreviewBuilder();

class VrtPreviewBuilder implements Builder {
  const VrtPreviewBuilder();

  static const _outputPath =
      'lib/src/presentation/previews/vrt_previews.g.dart';

  @override
  Map<String, List<String>> get buildExtensions => const {
    r'$lib$': ['src/presentation/previews/vrt_previews.g.dart'],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final entries = <_PreviewEntry>[];
    final inputPackage = buildStep.inputId.package;
    final dartFiles = buildStep.findAssets(Glob('lib/**.dart'));
    var order = 0;

    await for (final asset in dartFiles) {
      if (_shouldSkip(asset)) {
        continue;
      }

      final source = await buildStep.readAsString(asset);
      final unit = parseString(content: source, path: asset.path).unit;
      final constants = _topLevelConstants(unit);

      for (final declaration in unit.declarations) {
        if (declaration is! FunctionDeclaration) {
          continue;
        }

        final functionName = declaration.name.toString();
        if (functionName.startsWith('_')) {
          continue;
        }

        final returnType = declaration.returnType?.toSource();
        if (returnType != 'Widget' && returnType != 'WidgetBuilder') {
          continue;
        }

        final parameters = declaration.functionExpression.parameters;
        if (parameters != null && parameters.parameters.isNotEmpty) {
          continue;
        }

        for (final annotation in declaration.metadata) {
          if (annotation.name.toSource().split('.').last != 'Preview') {
            continue;
          }

          final arguments = _annotationArguments(annotation);
          _warnForUnsupportedPreviewArguments(
            functionName: functionName,
            arguments: arguments,
          );
          final group =
              _stringValue(arguments['group'], constants) ?? 'Default';
          final name =
              _stringValue(arguments['name'], constants) ?? functionName;
          final size = _sizeValue(arguments['size'], constants);

          if (size == null) {
            log.warning(
              'Skipping @$functionName because @Preview.size is missing or '
              'is not a Size(width, height) constant.',
            );
            continue;
          }

          entries.add(
            _PreviewEntry(
              importUri: _packageUri(inputPackage, asset),
              functionName: functionName,
              group: group,
              name: name,
              size: size,
              isWidgetBuilder: returnType == 'WidgetBuilder',
              order: order++,
            ),
          );
        }
      }
    }

    entries.sort((a, b) {
      final byImport = a.importUri.compareTo(b.importUri);
      if (byImport != 0) {
        return byImport;
      }
      return a.order.compareTo(b.order);
    });

    await buildStep.writeAsString(
      AssetId(inputPackage, _outputPath),
      _renderGeneratedFile(entries),
    );
  }

  static bool _shouldSkip(AssetId asset) {
    final path = asset.path;
    return path.endsWith('.g.dart');
  }

  static String _packageUri(String packageName, AssetId asset) {
    final packagePath = asset.path.substring('lib/'.length);
    return 'package:$packageName/$packagePath';
  }
}

Map<String, Expression> _topLevelConstants(CompilationUnit unit) {
  final constants = <String, Expression>{};

  for (final declaration in unit.declarations) {
    if (declaration is! TopLevelVariableDeclaration ||
        !declaration.variables.isConst) {
      continue;
    }

    for (final variable in declaration.variables.variables) {
      final initializer = variable.initializer;
      if (initializer != null) {
        constants[variable.name.toString()] = initializer;
      }
    }
  }

  return constants;
}

Map<String, Expression> _annotationArguments(Annotation annotation) {
  final values = <String, Expression>{};
  final arguments = annotation.arguments?.arguments ?? const <Expression>[];

  for (final argument in arguments) {
    if (argument is NamedExpression) {
      values[argument.name.label.toSource()] = argument.expression;
    }
  }

  return values;
}

String? _stringValue(
  Expression? expression,
  Map<String, Expression> constants,
) {
  if (expression == null) {
    return null;
  }

  final source = _resolveConstantSource(expression, constants);
  if (source.length < 2) {
    return null;
  }

  final quote = source[0];
  if ((quote != "'" && quote != '"') || source[source.length - 1] != quote) {
    return null;
  }

  return source.substring(1, source.length - 1);
}

_PreviewSize? _sizeValue(
  Expression? expression,
  Map<String, Expression> constants,
) {
  if (expression == null) {
    return null;
  }

  final source = _resolveConstantSource(expression, constants);
  final match = RegExp(
    r'^(?:const\s+)?Size\(([^,]+),\s*([^)]+)\)$',
  ).firstMatch(source);

  if (match == null) {
    return null;
  }

  return _PreviewSize(width: match.group(1)!, height: match.group(2)!);
}

String _resolveConstantSource(
  Expression expression,
  Map<String, Expression> constants,
) {
  var source = expression.toSource();
  final visited = <String>{};

  while (constants.containsKey(source) && visited.add(source)) {
    source = constants[source]!.toSource();
  }

  return source;
}

void _warnForUnsupportedPreviewArguments({
  required String functionName,
  required Map<String, Expression> arguments,
}) {
  const unsupported = {'wrapper', 'theme', 'localizations', 'textScaleFactor'};
  final usedUnsupported = arguments.keys.where(unsupported.contains).toList();

  if (usedUnsupported.isEmpty) {
    return;
  }

  log.warning(
    'Generating VRT for @$functionName without unsupported @Preview '
    'argument(s): ${usedUnsupported.join(', ')}.',
  );
}

String _renderGeneratedFile(List<_PreviewEntry> entries) {
  final imports = <String, String>{};
  var importIndex = 0;

  for (final entry in entries) {
    imports.putIfAbsent(entry.importUri, () => '_i${++importIndex}');
  }

  final buffer =
      StringBuffer()
        ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND.')
        ..writeln('// ignore_for_file: type=lint')
        ..writeln('// Generated by vrt_preview_builder.')
        ..writeln()
        ..writeln("import 'package:flutter/material.dart';")
        ..writeln()
        ..writeln("import 'foundation/preview.dart';");

  for (final importUri in imports.keys) {
    buffer.writeln("import '$importUri' as ${imports[importUri]};");
  }

  buffer
    ..writeln()
    ..writeln('final List<VrtPreviewEntry> visualRegressionPreviews = [');

  for (final entry in entries) {
    final alias = imports[entry.importUri]!;
    final builder =
        entry.isWidgetBuilder
            ? '() => Builder(builder: $alias.${entry.functionName}())'
            : '$alias.${entry.functionName}';

    buffer
      ..writeln('  VrtPreviewEntry(')
      ..writeln("    vrtFileName: '${_vrtFileName(entry.functionName)}',")
      ..writeln("    group: '${_escapeDartString(entry.group)}',")
      ..writeln("    name: '${_escapeDartString(entry.name)}',")
      ..writeln('    size: Size(${entry.size.width}, ${entry.size.height}),')
      ..writeln('    builder: $builder,')
      ..writeln('  ),');
  }

  buffer.writeln('];');
  return buffer.toString();
}

String _vrtFileName(String functionName) {
  final name =
      functionName.endsWith('Preview')
          ? functionName.substring(0, functionName.length - 'Preview'.length)
          : functionName;
  final buffer = StringBuffer();

  for (var index = 0; index < name.length; index++) {
    final char = name[index];
    final isUpper = char.toUpperCase() == char && char.toLowerCase() != char;

    if (isUpper && index > 0) {
      buffer.write('_');
    }

    buffer.write(char.toLowerCase());
  }

  return buffer.toString();
}

String _escapeDartString(String value) {
  return value.replaceAll(r'\', r'\\').replaceAll("'", r"\'");
}

class _PreviewEntry {
  const _PreviewEntry({
    required this.importUri,
    required this.functionName,
    required this.group,
    required this.name,
    required this.size,
    required this.isWidgetBuilder,
    required this.order,
  });

  final String importUri;
  final String functionName;
  final String group;
  final String name;
  final _PreviewSize size;
  final bool isWidgetBuilder;
  final int order;
}

class _PreviewSize {
  const _PreviewSize({required this.width, required this.height});

  final String width;
  final String height;
}
