import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_utility_widgets/flutter_utility_widgets.dart';

Widget _wrap(Widget child) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: const MediaQueryData(),
      child: child,
    ),
  );
}

void main() {
  group('CalculatorEngine (Lógica Aritmética Pura)', () {
    test('initializes with default value 0', () {
      final engine = CalculatorEngine();
      expect(engine.currentValue, 0.0);
      expect(engine.displayValue, '0');
      expect(engine.expression, '');
      expect(engine.isError, isFalse);
    });

    test('initializes with custom initialValue', () {
      final engine = CalculatorEngine(initialValue: 150.75);
      expect(engine.currentValue, 150.75);
      expect(engine.displayValue, '150.75');
    });

    test('performs simple addition with floating-point precision', () {
      final engine = CalculatorEngine();
      engine.inputDigit('0');
      engine.inputDecimal();
      engine.inputDigit('1');
      engine.setOperation('+');
      engine.inputDigit('0');
      engine.inputDecimal();
      engine.inputDigit('2');
      engine.calculate();

      expect(engine.currentValue, 0.3);
      expect(engine.displayValue, '0.3');
    });

    test('handles chained operations sequentially', () {
      final engine = CalculatorEngine();
      engine.inputDigit('1');
      engine.inputDigit('0'); // 10
      engine.setOperation('+');
      engine.inputDigit('5'); // + 5
      engine.setOperation('-'); // (resultado intermediário 15) -
      expect(engine.currentValue, 15.0);

      engine.inputDigit('3'); // - 3
      engine.calculate();
      expect(engine.currentValue, 12.0);
      expect(engine.displayValue, '12');
    });

    test('handles contextual financial percent addition (200 + 10% = 220)', () {
      final engine = CalculatorEngine();
      engine.inputDigit('2');
      engine.inputDoubleZero(); // 200
      engine.setOperation('+');
      engine.inputDigit('1');
      engine.inputDigit('0'); // 10
      engine.percent(); // 10% de 200 = 20

      expect(engine.displayValue, '20');
      engine.calculate();
      expect(engine.currentValue, 220.0);
    });

    test('handles contextual financial percent multiplication (200 * 10% = 20)', () {
      final engine = CalculatorEngine();
      engine.inputDigit('2');
      engine.inputDoubleZero(); // 200
      engine.setOperation('×');
      engine.inputDigit('1');
      engine.inputDigit('0'); // 10
      engine.percent();
      engine.calculate();

      expect(engine.currentValue, 20.0);
    });

    test('toggles sign (+/-)', () {
      final engine = CalculatorEngine();
      engine.inputDigit('5');
      engine.toggleSign();
      expect(engine.displayValue, '-5');
      expect(engine.currentValue, -5.0);

      engine.toggleSign();
      expect(engine.displayValue, '5');
      expect(engine.currentValue, 5.0);
    });

    test('handles backspace correctly', () {
      final engine = CalculatorEngine();
      engine.inputDigit('1');
      engine.inputDigit('2');
      engine.inputDigit('3');
      expect(engine.displayValue, '123');

      engine.backspace();
      expect(engine.displayValue, '12');

      engine.backspace();
      expect(engine.displayValue, '1');

      engine.backspace();
      expect(engine.displayValue, '0');
    });

    test('handles division by zero without crash', () {
      final engine = CalculatorEngine();
      engine.inputDigit('8');
      engine.setOperation('÷');
      engine.inputDigit('0');
      engine.calculate();

      expect(engine.isError, isTrue);
      expect(engine.displayValue, 'Erro');

      // Próxima digitação deve resetar o erro
      engine.inputDigit('5');
      expect(engine.isError, isFalse);
      expect(engine.displayValue, '5');
    });

    test('clears all with allClear', () {
      final engine = CalculatorEngine();
      engine.inputDigit('9');
      engine.setOperation('+');
      engine.allClear();

      expect(engine.displayValue, '0');
      expect(engine.expression, '');
      expect(engine.operation, isNull);
    });
  });

  group('UtilityCalculator Widget', () {
    testWidgets('renders initial value and displays it', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const UtilityCalculator(
            initialValue: 350.50,
          ),
        ),
      );

      // Display deve mostrar 350,5 (com separador padrão ',')
      expect(find.text('350,5'), findsOneWidget);
    });

    testWidgets('calculates 12 + 8 and submits result on confirm button', (tester) async {
      double? changedVal;
      double? submittedVal;

      await tester.pumpWidget(
        _wrap(
          UtilityCalculator(
            onChanged: (val) => changedVal = val,
            onSubmitted: (val) => submittedVal = val,
          ),
        ),
      );

      // Clica em 1
      await tester.tap(find.byKey(const Key('calc_btn_1')));
      await tester.pump();
      expect(changedVal, 1.0);

      // Clica em 2
      await tester.tap(find.byKey(const Key('calc_btn_2')));
      await tester.pump();
      expect(changedVal, 12.0);

      // Clica em +
      await tester.tap(find.byKey(const Key('calc_btn_+')));
      await tester.pump();

      // Clica em 8
      await tester.tap(find.byKey(const Key('calc_btn_8')));
      await tester.pump();
      expect(changedVal, 8.0);

      // Clica em =
      await tester.tap(find.byKey(const Key('calc_btn_=')));
      await tester.pump();
      expect(changedVal, 20.0);
      expect(find.text('20'), findsOneWidget);

      // Clica no botão de confirmação
      await tester.tap(find.byKey(const Key('calculator_confirm_button')));
      await tester.pump();

      expect(submittedVal, 20.0);
    });

    testWidgets('submits auto-calculates pending operation when clicking confirm directly', (tester) async {
      double? submittedVal;

      await tester.pumpWidget(
        _wrap(
          UtilityCalculator(
            onSubmitted: (val) => submittedVal = val,
          ),
        ),
      );

      // Digita 50 + 25 e clica direto em confirmar sem teclar =
      await tester.tap(find.byKey(const Key('calc_btn_5')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('calc_btn_0')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('calc_btn_+')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('calc_btn_2')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('calc_btn_5')));
      await tester.pump();

      await tester.tap(find.byKey(const Key('calculator_confirm_button')));
      await tester.pump();

      expect(submittedVal, 75.0);
    });
  });

  group('UtilityCalculatorModalCard', () {
    testWidgets('renders modal card and returns value on confirm', (tester) async {
      double? confirmedVal;
      bool cancelled = false;

      await tester.pumpWidget(
        _wrap(
          UtilityCalculatorModalCard(
            initialValue: 100.0,
            title: const Text('Calculadora de Desconto'),
            onConfirm: (val) => confirmedVal = val,
            onCancel: () => cancelled = true,
          ),
        ),
      );

      expect(find.text('Calculadora de Desconto'), findsOneWidget);
      expect(find.text('100'), findsOneWidget);

      // Clica no botão de confirmar
      await tester.tap(find.byKey(const Key('calculator_confirm_button')));
      await tester.pump();

      expect(confirmedVal, 100.0);
      expect(cancelled, isFalse);

      // Testa fechar
      await tester.tap(find.byKey(const Key('calculator_modal_close')));
      await tester.pump();
      expect(cancelled, isTrue);
    });
  });
}
