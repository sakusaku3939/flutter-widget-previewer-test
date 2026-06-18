import 'dart:convert';
import 'dart:io';

import 'package:image/image.dart' as image;

void main(List<String> args) {
  final options = _Options.parse(args);

  final actualDir = Directory(options.actualDir);
  final expectedDir = Directory(options.expectedDir);
  final diffDir = Directory(options.diffDir);

  _requireDirectory(actualDir, 'actual');
  _requireDirectory(expectedDir, 'expected');

  if (diffDir.existsSync()) {
    diffDir.deleteSync(recursive: true);
  }
  diffDir.createSync(recursive: true);

  final actualFiles = _pngFilesByName(actualDir);
  final expectedFiles = _pngFilesByName(expectedDir);
  final allNames = {...actualFiles.keys, ...expectedFiles.keys}.toList()
    ..sort();

  final failedItems = <String>[];
  final newItems = <String>[];
  final deletedItems = <String>[];
  final passedItems = <String>[];

  for (final name in allNames) {
    final actualFile = actualFiles[name];
    final expectedFile = expectedFiles[name];

    if (actualFile == null) {
      deletedItems.add(name);
      continue;
    }

    if (expectedFile == null) {
      newItems.add(name);
      continue;
    }

    final actual = _decodePng(actualFile);
    final expected = _decodePng(expectedFile);
    final comparison = _compareImages(actual: actual, expected: expected);

    if (comparison.isMatch) {
      passedItems.add(name);
      continue;
    }

    failedItems.add(name);
    File('${diffDir.path}/$name')
      ..createSync(recursive: true)
      ..writeAsBytesSync(image.encodePng(comparison.diff));
  }

  final report = {
    'failedItems': failedItems,
    'newItems': newItems,
    'deletedItems': deletedItems,
    'passedItems': passedItems,
    'expectedItems': expectedFiles.keys.toList()..sort(),
    'actualItems': actualFiles.keys.toList()..sort(),
    'diffItems': failedItems,
    'actualDir': './${actualDir.path.split(RegExp(r'[\\/]')).last}',
    'expectedDir': './${expectedDir.path.split(RegExp(r'[\\/]')).last}',
    'diffDir': './${diffDir.path.split(RegExp(r'[\\/]')).last}',
  };

  File(options.jsonPath)
    ..createSync(recursive: true)
    ..writeAsStringSync(const JsonEncoder.withIndent('  ').convert(report));

  final changed = failedItems.length + newItems.length + deletedItems.length;
  stdout.writeln(
    'Compared ${allNames.length} VRT image${allNames.length == 1 ? '' : 's'}: '
    '$changed changed, ${passedItems.length} passed.',
  );
}

Map<String, File> _pngFilesByName(Directory directory) {
  final result = <String, File>{};

  for (final entity in directory.listSync()) {
    if (entity is! File) continue;

    final name = entity.uri.pathSegments.last;
    if (!name.toLowerCase().endsWith('.png')) continue;

    result[name] = entity;
  }

  return result;
}

image.Image _decodePng(File file) {
  final decoded = image.decodePng(file.readAsBytesSync());
  if (decoded == null) {
    stderr.writeln('Failed to decode PNG: ${file.path}');
    exit(65);
  }
  return decoded;
}

_ImageComparison _compareImages({
  required image.Image actual,
  required image.Image expected,
}) {
  final width = actual.width > expected.width ? actual.width : expected.width;
  final height = actual.height > expected.height
      ? actual.height
      : expected.height;
  final diff = image.Image(width: width, height: height);
  var changedPixels = 0;

  for (var y = 0; y < height; y++) {
    for (var x = 0; x < width; x++) {
      final hasActual = x < actual.width && y < actual.height;
      final hasExpected = x < expected.width && y < expected.height;

      if (!hasActual || !hasExpected) {
        changedPixels++;
        diff.setPixelRgba(x, y, 255, 0, 255, 255);
        continue;
      }

      final actualPixel = actual.getPixel(x, y);
      final expectedPixel = expected.getPixel(x, y);
      final matches =
          actualPixel.r == expectedPixel.r &&
          actualPixel.g == expectedPixel.g &&
          actualPixel.b == expectedPixel.b &&
          actualPixel.a == expectedPixel.a;

      if (matches) {
        diff.setPixelRgba(
          x,
          y,
          actualPixel.r,
          actualPixel.g,
          actualPixel.b,
          actualPixel.a,
        );
      } else {
        changedPixels++;
        diff.setPixelRgba(x, y, 255, 0, 255, 255);
      }
    }
  }

  return _ImageComparison(isMatch: changedPixels == 0, diff: diff);
}

void _requireDirectory(Directory directory, String label) {
  if (directory.existsSync()) return;

  stderr.writeln('Missing $label directory: ${directory.path}');
  exit(64);
}

class _ImageComparison {
  const _ImageComparison({required this.isMatch, required this.diff});

  final bool isMatch;
  final image.Image diff;
}

class _Options {
  const _Options({
    required this.actualDir,
    required this.expectedDir,
    required this.diffDir,
    required this.jsonPath,
  });

  factory _Options.parse(List<String> args) {
    if (args.contains('--help') || args.contains('-h')) {
      _printUsage();
      exit(0);
    }

    if (args.length < 3) {
      _printUsage();
      exit(64);
    }

    final positional = <String>[];
    var jsonPath = 'reg.json';

    for (var index = 0; index < args.length; index++) {
      switch (args[index]) {
        case '-J':
        case '--json':
          jsonPath = _readValue(args, ++index, args[index - 1]);
        default:
          positional.add(args[index]);
      }
    }

    if (positional.length != 3) {
      _printUsage();
      exit(64);
    }

    return _Options(
      actualDir: positional[0],
      expectedDir: positional[1],
      diffDir: positional[2],
      jsonPath: jsonPath,
    );
  }

  final String actualDir;
  final String expectedDir;
  final String diffDir;
  final String jsonPath;
}

String _readValue(List<String> args, int index, String option) {
  if (index >= args.length || args[index].startsWith('-')) {
    stderr.writeln('Missing value for $option.');
    exit(64);
  }

  return args[index];
}

void _printUsage() {
  stdout.writeln('''
Usage:
  dart run tool/compare_vrt_images.dart <actual-dir> <expected-dir> <diff-dir> [options]

Options:
  -J, --json <path>  JSON report path. Default: reg.json
''');
}
