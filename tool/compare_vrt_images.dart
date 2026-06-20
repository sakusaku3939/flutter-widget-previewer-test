import 'dart:convert';
import 'dart:io';

import 'package:image/image.dart' as image;

void main(List<String> args) {
  final options = _Options.parse(args);

  final headDir = Directory(options.headDir);
  final baseDir = Directory(options.baseDir);
  final diffDir = Directory(options.diffDir);

  _requireDirectory(headDir, 'head');
  _requireDirectory(baseDir, 'base');

  if (diffDir.existsSync()) {
    diffDir.deleteSync(recursive: true);
  }
  diffDir.createSync(recursive: true);

  final headFiles = _pngFilesByName(headDir);
  final baseFiles = _pngFilesByName(baseDir);
  final allNames = {...headFiles.keys, ...baseFiles.keys}.toList()..sort();

  final failedItems = <String>[];
  final newItems = <String>[];
  final deletedItems = <String>[];
  final passedItems = <String>[];

  for (final name in allNames) {
    final headFile = headFiles[name];
    final baseFile = baseFiles[name];

    if (headFile == null) {
      deletedItems.add(name);
      continue;
    }

    if (baseFile == null) {
      newItems.add(name);
      continue;
    }

    final head = _decodePng(headFile);
    final base = _decodePng(baseFile);
    final comparison = _compareImages(head: head, base: base);

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
    'baseItems': baseFiles.keys.toList()..sort(),
    'headItems': headFiles.keys.toList()..sort(),
    'diffItems': failedItems,
    'headDir': './${headDir.path.split(RegExp(r'[\\/]')).last}',
    'baseDir': './${baseDir.path.split(RegExp(r'[\\/]')).last}',
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
  required image.Image head,
  required image.Image base,
}) {
  final width = head.width > base.width ? head.width : base.width;
  final height = head.height > base.height ? head.height : base.height;
  final diff = image.Image(width: width, height: height);
  var changedPixels = 0;

  for (var y = 0; y < height; y++) {
    for (var x = 0; x < width; x++) {
      final hasHead = x < head.width && y < head.height;
      final hasBase = x < base.width && y < base.height;

      if (!hasHead || !hasBase) {
        changedPixels++;
        diff.setPixelRgba(x, y, 255, 0, 255, 255);
        continue;
      }

      final headPixel = head.getPixel(x, y);
      final basePixel = base.getPixel(x, y);
      final matches =
          headPixel.r == basePixel.r &&
          headPixel.g == basePixel.g &&
          headPixel.b == basePixel.b &&
          headPixel.a == basePixel.a;

      if (matches) {
        diff.setPixelRgba(
          x,
          y,
          headPixel.r,
          headPixel.g,
          headPixel.b,
          headPixel.a,
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
    required this.headDir,
    required this.baseDir,
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
      headDir: positional[0],
      baseDir: positional[1],
      diffDir: positional[2],
      jsonPath: jsonPath,
    );
  }

  final String headDir;
  final String baseDir;
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
  dart run tool/compare_vrt_images.dart <head-dir> <base-dir> <diff-dir> [options]

Options:
  -J, --json <path>  JSON report path. Default: reg.json
''');
}
