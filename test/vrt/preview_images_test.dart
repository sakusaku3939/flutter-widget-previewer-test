import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as image;

import 'support/preview_images.dart';

void main() {
  testWidgets('waits until an image has decoded', (tester) async {
    final bytes = image.encodePng(image.Image(width: 2, height: 2));
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Image.memory(bytes),
      ),
    );
    await tester.runAsync(() => waitForPreviewImages(tester));
    await tester.pump();
    expect(tester.widget<RawImage>(find.byType(RawImage)).image, isNotNull);
  });

  testWidgets('reports a decoding error even with an error widget', (
    tester,
  ) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Image.memory(
          Uint8List.fromList([0, 1, 2]),
          errorBuilder: (context, error, stack) => const Text('Image failed'),
        ),
      ),
    );
    await tester.runAsync(() async {
      await expectLater(waitForPreviewImages(tester), throwsA(anything));
    });
    await tester.pump();
    expect(find.text('Image failed'), findsOneWidget);
  });
}
