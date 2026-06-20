import 'dart:convert';
import 'dart:io';

const _suffixes = {
  'masterImage': 'expected',
  'testImage': 'actual',
  'maskedDiff': 'diff',
  'isolatedDiff': 'diffFallback',
};

void main(List<String> args) {
  final options = _Options.parse(args);
  final failuresDir = Directory(options.failuresDir);
  final outDir = Directory(options.outDir);

  if (outDir.existsSync()) {
    outDir.deleteSync(recursive: true);
  }

  final expectedDir = Directory('${outDir.path}/expected')
    ..createSync(recursive: true);
  final actualDir = Directory('${outDir.path}/actual')
    ..createSync(recursive: true);
  final diffDir = Directory('${outDir.path}/diff')..createSync(recursive: true);

  final cases = <String, _GoldenFailure>{};

  if (failuresDir.existsSync()) {
    final files = failuresDir
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.toLowerCase().endsWith('.png'));

    for (final file in files) {
      final parsed = _parseFailureFile(file);
      if (parsed == null) continue;

      final failure = cases.putIfAbsent(parsed.caseName, _GoldenFailure.new);
      switch (parsed.kind) {
        case 'expected':
          failure.expected = file;
        case 'actual':
          failure.actual = file;
        case 'diff':
          failure.diff = file;
        case 'diffFallback':
          failure.diffFallback = file;
      }
    }
  }

  final failedItems = <String>[];

  for (final entry
      in cases.entries.toList()..sort((a, b) => a.key.compareTo(b.key))) {
    final failure = entry.value;
    if (failure.expected == null || failure.actual == null) {
      stderr.writeln(
        'Skipping ${entry.key}: expected masterImage and testImage files.',
      );
      continue;
    }

    final reportName = '${entry.key}.png';
    failure.expected!.copySync('${expectedDir.path}/$reportName');
    failure.actual!.copySync('${actualDir.path}/$reportName');
    (failure.diff ?? failure.diffFallback ?? failure.actual!).copySync(
      '${diffDir.path}/$reportName',
    );
    failedItems.add(reportName);
  }

  final reportJson = {
    'failedItems': failedItems,
    'newItems': <String>[],
    'deletedItems': <String>[],
    'passedItems': <String>[],
    'expectedItems': failedItems,
    'actualItems': failedItems,
    'diffItems': failedItems,
    'actualDir': './actual',
    'expectedDir': './expected',
    'diffDir': './diff',
  };

  File('${outDir.path}/reg.json')
    ..createSync(recursive: true)
    ..writeAsStringSync(const JsonEncoder.withIndent('  ').convert(reportJson));

  stdout.writeln(
    'Generated reg-cli report input at ${outDir.path} '
    '(${failedItems.length} failed golden${failedItems.length == 1 ? '' : 's'}).',
  );
}

_ParsedFailureFile? _parseFailureFile(File file) {
  final name = file.uri.pathSegments.last;
  if (!name.endsWith('.png')) return null;

  final stem = name.substring(0, name.length - '.png'.length);
  for (final entry in _suffixes.entries) {
    final suffix = '_${entry.key}';
    if (stem.endsWith(suffix)) {
      return _ParsedFailureFile(
        caseName: stem.substring(0, stem.length - suffix.length),
        kind: entry.value,
      );
    }
  }

  return null;
}

class _GoldenFailure {
  File? expected;
  File? actual;
  File? diff;
  File? diffFallback;
}

class _ParsedFailureFile {
  const _ParsedFailureFile({required this.caseName, required this.kind});

  final String caseName;
  final String kind;
}

class _Options {
  const _Options({required this.failuresDir, required this.outDir});

  factory _Options.parse(List<String> args) {
    var failuresDir = 'test/goldens/failures';
    var outDir = 'build/golden-reg-report';

    for (var i = 0; i < args.length; i++) {
      switch (args[i]) {
        case '--failures-dir':
          failuresDir = _readValue(args, ++i, '--failures-dir');
        case '--out-dir':
          outDir = _readValue(args, ++i, '--out-dir');
        case '--help':
        case '-h':
          _printUsage();
          exit(0);
        default:
          stderr.writeln('Unknown option: ${args[i]}');
          _printUsage();
          exit(64);
      }
    }

    return _Options(failuresDir: failuresDir, outDir: outDir);
  }

  final String failuresDir;
  final String outDir;
}

String _readValue(List<String> args, int index, String option) {
  if (index >= args.length || args[index].startsWith('--')) {
    stderr.writeln('Missing value for $option.');
    _printUsage();
    exit(64);
  }
  return args[index];
}

void _printUsage() {
  stdout.writeln('''
Usage:
  dart run tool/generate_reg_cli_golden_report.dart [options]

Options:
  --failures-dir <path>  Flutter golden failures directory.
                         Default: test/goldens/failures
  --out-dir <path>       reg-cli input/output directory.
                         Default: build/golden-reg-report
''');
}
