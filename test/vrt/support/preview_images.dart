import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wait for the first decoded frame, propagating failures instead of capturing
/// an empty image. Call inside tester.runAsync so decoding can finish.
Future<void> waitForPreviewImages(WidgetTester tester) async {
  for (final element in find.byType(Image).evaluate()) {
    final widget = element.widget as Image;
    final stream = widget.image.resolve(createLocalImageConfiguration(element));
    final completed = Completer<void>();
    final listener = ImageStreamListener(
      (info, synchronousCall) {
        info.dispose();
        if (!completed.isCompleted) completed.complete();
      },
      onError: (Object error, StackTrace? stack) {
        if (!completed.isCompleted) completed.completeError(error, stack);
      },
    );
    stream.addListener(listener);
    try {
      await completed.future.timeout(const Duration(seconds: 10));
    } finally {
      stream.removeListener(listener);
    }
  }
}
