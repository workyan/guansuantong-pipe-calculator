import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guansuantong_pipe_calculator/main.dart';

void main() {
  testWidgets('shows all calculator tools on home', (tester) async {
    await tester.pumpWidget(
      const PipeQuickCalcApp(screenshotScene: 'home-overview'),
    );
    await tester.pumpAndSettle();
    expect(find.text('管算通'), findsOneWidget);
    expect(find.text('全部计算器'), findsOneWidget);
    expect(find.text('滚动偏移'), findsWidgets);
  });

  testWidgets('calculator updates from editable input', (tester) async {
    await tester.pumpWidget(
      const PipeQuickCalcApp(screenshotScene: 'cut-length'),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextFormField, '3200'), '1200');
    await tester.pump();
    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(find.text('1015.00 mm'), findsWidgets);
  });
}
