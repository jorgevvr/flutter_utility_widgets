import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_utility_widgets/flutter_utility_widgets.dart';

void main() {
  testWidgets('UtilityNumberPicker renders initial value correctly', (WidgetTester tester) async {
    int currentValue = 10;

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: UtilityNumberPicker(
            minValue: 1,
            maxValue: 20,
            value: currentValue,
            onChanged: (val) => currentValue = val,
          ),
        ),
      ),
    );

    // Deve encontrar o valor 10 renderizado
    expect(find.text('10'), findsOneWidget);
  });

  testWidgets('UtilityNumberPicker respects textMapper', (WidgetTester tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: UtilityNumberPicker(
            minValue: 1,
            maxValue: 5,
            value: 3,
            textMapper: (text) => 'R\$ $text',
            onChanged: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('R\$ 3'), findsOneWidget);
  });
}
