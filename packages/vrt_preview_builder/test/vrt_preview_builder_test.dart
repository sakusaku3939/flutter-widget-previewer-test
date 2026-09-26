import 'package:build/build.dart';
import 'package:build_runner_core/build_runner_core.dart';
import 'package:build_test/build_test.dart';
import 'package:test/test.dart';
import 'package:vrt_preview_builder/vrt_preview_builder.dart';

const output = 'app|lib/src/presentation/previews/vrt_previews.g.dart';

Future<TestBuilderResult> generate(String source, {String? other}) {
  const builder = VrtPreviewBuilder();
  return testBuilders(
    [builder],
    {'app|lib/a.dart': source, 'app|lib/b.dart': ?other},
    rootPackage: 'app',
    visibleOutputBuilders: {builder},
  );
}

void main() {
  test('generates Widget and WidgetBuilder with resolved constants', () async {
    final result = await generate('''
const size = Size(390, 844);
const selectedSize = size;
@Preview(size: selectedSize, group: 'Sample', name: 'First')
Widget firstPreview() => const Text('First');
@Preview(size: Size(320, 568))
WidgetBuilder secondPreview() => (context) => const Text('Second');
''');
    expect(result.buildResult.status, BuildStatus.success);
    final source = result.readerWriter.testing.readString(
      AssetId.parse(output),
    );
    expect(source, contains('Size(390, 844)'));
    expect(source, contains('builder: _i1.firstPreview'));
    expect(source, contains('Builder(builder: _i1.secondPreview())'));
  });

  final invalid = {
    'missing size': '@Preview() Widget samplePreview() => const Text("A");',
    'unresolved size':
        '@Preview(size: Size.square(10)) Widget samplePreview() => const Text("A");',
    'inferred return':
        '@Preview(size: Size(10, 10)) samplePreview() => const Text("A");',
    'private':
        '@Preview(size: Size(10, 10)) Widget _samplePreview() => const Text("A");',
    'parameters':
        '@Preview(size: Size(10, 10)) Widget samplePreview(int x) => Text("A");',
    'static':
        'class Samples { @Preview(size: Size(10, 10)) static Widget samplePreview() => const Text("A"); }',
    'constructor':
        'class Sample extends StatelessWidget { @Preview(size: Size(10, 10)) const Sample(); }',
    for (final option in [
      'wrapper',
      'theme',
      'brightness',
      'localizations',
      'textScaleFactor',
    ])
      option:
          '@Preview(size: Size(10, 10), $option: setting) Widget samplePreview() => const Text("A");',
  };
  for (final entry in invalid.entries) {
    test('rejects ${entry.key}', () async {
      final result = await generate(entry.value);
      expect(result.buildResult.status, BuildStatus.failure);
      expect(
        result.readerWriter.testing.exists(AssetId.parse(output)),
        isFalse,
      );
    });
  }

  test('rejects duplicate output names across files', () async {
    const source =
        '@Preview(size: Size(10, 10)) Widget samplePreview() => const Text("A");';
    final result = await generate(source, other: source);
    expect(result.buildResult.status, BuildStatus.failure);
  });

  test('rejects repeated annotations on one function', () async {
    final result = await generate('''
@Preview(size: Size(10, 10))
@Preview(size: Size(20, 20))
Widget samplePreview() => const Text('A');
''');
    expect(result.buildResult.status, BuildStatus.failure);
  });
}
