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
  group('UtilityMonthPicker', () {
    testWidgets('renders all 12 default month names and initial year', (tester) async {
      await tester.pumpWidget(
        _wrap(
          UtilityMonthPicker(
            initialDate: DateTime(2026, 5, 1),
            onMonthSelected: (_) {},
          ),
        ),
      );

      expect(find.text('2026'), findsOneWidget);
      expect(find.text('Jan'), findsOneWidget);
      expect(find.text('Fev'), findsOneWidget);
      expect(find.text('Mar'), findsOneWidget);
      expect(find.text('Abr'), findsOneWidget);
      expect(find.text('Mai'), findsOneWidget);
      expect(find.text('Jun'), findsOneWidget);
      expect(find.text('Jul'), findsOneWidget);
      expect(find.text('Ago'), findsOneWidget);
      expect(find.text('Set'), findsOneWidget);
      expect(find.text('Out'), findsOneWidget);
      expect(find.text('Nov'), findsOneWidget);
      expect(find.text('Dez'), findsOneWidget);
    });

    testWidgets('supports custom month names', (tester) async {
      const customNames = [
        'M01', 'M02', 'M03', 'M04', 'M05', 'M06',
        'M07', 'M08', 'M09', 'M10', 'M11', 'M12'
      ];

      await tester.pumpWidget(
        _wrap(
          UtilityMonthPicker(
            initialDate: DateTime(2026, 1, 1),
            monthNames: customNames,
            onMonthSelected: (_) {},
          ),
        ),
      );

      expect(find.text('M01'), findsOneWidget);
      expect(find.text('M12'), findsOneWidget);
      expect(find.text('Jan'), findsNothing);
    });

    testWidgets('triggers onMonthSelected when tapping an enabled month', (tester) async {
      DateTime? selected;

      await tester.pumpWidget(
        _wrap(
          UtilityMonthPicker(
            initialDate: DateTime(2026, 3, 1),
            onMonthSelected: (date) {
              selected = date;
            },
          ),
        ),
      );

      await tester.tap(find.text('Out'));
      await tester.pump();

      expect(selected, isNotNull);
      expect(selected!.year, 2026);
      expect(selected!.month, 10);
    });

    testWidgets('respects firstDate and lastDate boundaries', (tester) async {
      DateTime? selected;

      await tester.pumpWidget(
        _wrap(
          UtilityMonthPicker(
            initialDate: DateTime(2026, 6, 1),
            firstDate: DateTime(2026, 3, 1),
            lastDate: DateTime(2026, 8, 31),
            onMonthSelected: (date) => selected = date,
          ),
        ),
      );

      // Fev está antes de firstDate (Março 2026) -> não deve selecionar
      await tester.tap(find.text('Fev'));
      await tester.pump();
      expect(selected, isNull);

      // Set está depois de lastDate (Agosto 2026) -> não deve selecionar
      await tester.tap(find.text('Set'));
      await tester.pump();
      expect(selected, isNull);

      // Julho está dentro do intervalo -> deve selecionar
      await tester.tap(find.text('Jul'));
      await tester.pump();
      expect(selected, isNotNull);
      expect(selected!.month, 7);
    });

    testWidgets('navigates years through header navigation buttons', (tester) async {
      int? changedYear;

      await tester.pumpWidget(
        _wrap(
          UtilityMonthPicker(
            initialDate: DateTime(2026, 1, 1),
            onYearChanged: (year) => changedYear = year,
            onMonthSelected: (_) {},
          ),
        ),
      );

      expect(find.text('2026'), findsOneWidget);

      // Navegar para o próximo ano
      await tester.tap(find.byKey(const Key('utility_month_picker_next_year')));
      await tester.pump();

      expect(find.text('2027'), findsOneWidget);
      expect(changedYear, 2027);

      // Navegar para o ano anterior
      await tester.tap(find.byKey(const Key('utility_month_picker_prev_year')));
      await tester.pump();

      expect(find.text('2026'), findsOneWidget);
      expect(changedYear, 2026);
    });

    testWidgets('toggles year grid and selects another year', (tester) async {
      DateTime? selectedDate;

      await tester.pumpWidget(
        _wrap(
          UtilityMonthPicker(
            initialDate: DateTime(2026, 1, 1),
            firstDate: DateTime(2020, 1, 1),
            lastDate: DateTime(2030, 12, 31),
            onMonthSelected: (date) => selectedDate = date,
          ),
        ),
      );

      // Clica no ano no cabeçalho para abrir a grade de anos
      await tester.tap(find.text('2026'));
      await tester.pumpAndSettle();

      // Grade de anos deve mostrar anos como 2024, 2028
      expect(find.text('2024'), findsOneWidget);
      expect(find.text('2028'), findsOneWidget);

      // Seleciona o ano 2028
      await tester.tap(find.text('2028'));
      await tester.pumpAndSettle();

      // Deve voltar para a grade de meses com 2028 no cabeçalho
      expect(find.text('2028'), findsOneWidget);
      expect(find.text('Mar'), findsOneWidget);

      // Seleciona um mês no novo ano
      await tester.tap(find.text('Mar'));
      await tester.pump();

      expect(selectedDate, isNotNull);
      expect(selectedDate!.year, 2028);
      expect(selectedDate!.month, 3);
    });
  });

  group('UtilityMonthPickerDialog', () {
    testWidgets('renders dialog and confirms selection', (tester) async {
      DateTime? confirmedDate;
      bool cancelled = false;

      await tester.pumpWidget(
        _wrap(
          UtilityMonthPickerDialog(
            initialDate: DateTime(2026, 4, 1),
            onConfirm: (date) => confirmedDate = date,
            onCancel: () => cancelled = true,
          ),
        ),
      );

      expect(find.text('2026'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
      expect(find.text('Cancelar'), findsOneWidget);

      // Seleciona outro mês (ex: Novembro)
      await tester.tap(find.text('Nov'));
      await tester.pump();

      // Clica em OK
      await tester.tap(find.text('OK'));
      await tester.pump();

      expect(confirmedDate, isNotNull);
      expect(confirmedDate!.year, 2026);
      expect(confirmedDate!.month, 11);
      expect(cancelled, isFalse);
    });

    testWidgets('triggers onCancel when clicking Cancelar', (tester) async {
      bool cancelled = false;

      await tester.pumpWidget(
        _wrap(
          UtilityMonthPickerDialog(
            initialDate: DateTime(2026, 4, 1),
            onCancel: () => cancelled = true,
          ),
        ),
      );

      await tester.tap(find.text('Cancelar'));
      await tester.pump();

      expect(cancelled, isTrue);
    });
  });
}
