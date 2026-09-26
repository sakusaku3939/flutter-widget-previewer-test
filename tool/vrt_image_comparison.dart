import 'package:image/image.dart' as image;

VrtImageComparison compareVrtImages({
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

  return VrtImageComparison(isMatch: changedPixels == 0, diff: diff);
}

class VrtImageComparison {
  const VrtImageComparison({required this.isMatch, required this.diff});

  final bool isMatch;
  final image.Image diff;
}
