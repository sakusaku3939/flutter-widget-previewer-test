import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as image;

import '../../tool/vrt_image_comparison.dart';

void main() {
  test('identical pixels match', () {
    final base = image.Image(width: 2, height: 2, numChannels: 4);
    expect(compareVrtImages(head: base.clone(), base: base).isMatch, isTrue);
  });

  test('color and alpha changes are highlighted', () {
    for (final rgba in [
      [1, 0, 0, 0],
      [0, 0, 0, 1],
    ]) {
      final base = image.Image(width: 1, height: 1, numChannels: 4);
      final head = base.clone()
        ..setPixelRgba(0, 0, rgba[0], rgba[1], rgba[2], rgba[3]);
      final result = compareVrtImages(head: head, base: base);
      expect(result.isMatch, isFalse);
      final pixel = result.diff.getPixel(0, 0);
      expect([pixel.r, pixel.g, pixel.b], [255, 0, 255]);
    }
  });

  test('dimension changes in either direction are detected', () {
    final small = image.Image(width: 1, height: 1);
    final large = image.Image(width: 2, height: 3);
    for (final pair in [
      [small, large],
      [large, small],
    ]) {
      final result = compareVrtImages(head: pair[0], base: pair[1]);
      expect(result.isMatch, isFalse);
      expect([result.diff.width, result.diff.height], [2, 3]);
    }
  });
}
