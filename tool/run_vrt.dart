import 'dart:io';

/// Run from the project root with the Dart SDK bundled with Flutter.
Future<void> main(List<String> arguments) async {
  final flutterBin = File(
    Platform.resolvedExecutable,
  ).parent.parent.parent.parent;
  final flutter = flutterBin.uri
      .resolve(Platform.isWindows ? 'flutter.bat' : 'flutter')
      .toFilePath();
  if (!File(flutter).existsSync()) {
    stderr.writeln(
      'Run with Flutter\'s Dart SDK: fvm dart run tool/run_vrt.dart',
    );
    exitCode = 1;
    return;
  }

  final build = await Process.start(Platform.resolvedExecutable, [
    'run',
    'build_runner',
    'build',
    '--delete-conflicting-outputs',
  ], mode: ProcessStartMode.inheritStdio);
  exitCode = await build.exitCode;
  if (exitCode != 0) return;

  final test = await Process.start(
    flutter,
    ['test', 'test/vrt/previews_vrt_test.dart', ...arguments],
    mode: ProcessStartMode.inheritStdio,
    runInShell: Platform.isWindows,
  );
  exitCode = await test.exitCode;
}
