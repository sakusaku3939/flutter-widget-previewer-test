import 'package:flutter_test/flutter_test.dart';
import 'package:widget_previewer_lab/src/app.dart';
import 'package:widget_previewer_lab/src/models/preview_status.dart';
import 'package:widget_previewer_lab/src/previews/widget_previews.dart';
import 'package:widget_previewer_lab/src/widgets/status_card.dart';

void main() {
  testWidgets('app renders the preview gallery', (tester) async {
    await tester.pumpWidget(const WidgetPreviewerLabApp());

    expect(find.text('Widget Previewer Lab'), findsWidgets);
    expect(find.text('flutter widget-preview start'), findsOneWidget);
  });

  testWidgets('success status card renders its stable label', (tester) async {
    await tester.pumpWidget(
      const PreviewHost(child: StatusCard(status: PreviewStatus.success)),
    );

    expect(find.text('Success'), findsOneWidget);
    expect(find.text('READY'), findsOneWidget);
  });

  testWidgets('error status card renders text feedback', (tester) async {
    await tester.pumpWidget(
      const PreviewHost(child: StatusCard(status: PreviewStatus.error)),
    );

    expect(find.text('Error'), findsOneWidget);
    expect(find.text('ACTION NEEDED'), findsOneWidget);
    expect(find.textContaining('エラー色だけに頼らず'), findsOneWidget);
  });

  testWidgets('empty status card renders empty state copy', (tester) async {
    await tester.pumpWidget(
      const PreviewHost(child: StatusCard(status: PreviewStatus.empty)),
    );

    expect(find.text('Empty'), findsOneWidget);
    expect(find.text('NO DATA'), findsOneWidget);
  });
}
