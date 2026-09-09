import 'package:flutter/material.dart';
import 'package:flutter_utility_widgets/flutter_utility_widgets.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Utility Widgets Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DemoTabsPage(),
    );
  }
}

class DemoTabsPage extends StatelessWidget {
  const DemoTabsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Utility Widgets Showcase'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.pin), text: 'Number Picker'),
              Tab(icon: Icon(Icons.calendar_month), text: 'Month Picker'),
              Tab(icon: Icon(Icons.calculate), text: 'Calculator'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            NumberPickerDemoView(),
            MonthPickerDemoView(),
            CalculatorDemoView(),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 1. DEMO DO NUMBER PICKER
// ==========================================

class NumberPickerDemoView extends StatefulWidget {
  const NumberPickerDemoView({super.key});

  @override
  State<NumberPickerDemoView> createState() => _NumberPickerDemoViewState();
}

class _NumberPickerDemoViewState extends State<NumberPickerDemoView> {
  int _verticalValue = 12;
  int _horizontalValue = 5;
  int _yearValue = 2026;
  int _dialogValue = 10;

  void _openPickerDialog() {
    int tempValue = _dialogValue;
    showDialog<int>(
      context: context,
      builder: (ctx) {
        final colorScheme = Theme.of(ctx).colorScheme;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              title: const Text(
                'Número de Parcelas',
                textAlign: TextAlign.center,
              ),
              content: UtilityNumberPicker(
                minValue: 1,
                maxValue: 48,
                value: tempValue,
                itemCount: 3,
                onChanged: (val) {
                  setDialogState(() => tempValue = val);
                },
                selectedTextStyle: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
                textStyle: TextStyle(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  fontSize: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.symmetric(
                    horizontal: BorderSide(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                ),
              ),
              actions: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(ctx, tempValue),
                  child: const Text('Confirmar'),
                ),
              ],
            );
          },
        );
      },
    ).then((result) {
      if (result != null) {
        setState(() => _dialogValue = result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 0,
                color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Simulação de Diálogo (Como no Minhas Contas)',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Valor selecionado no diálogo: $_dialogValue parcelas',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        icon: const Icon(Icons.dialpad),
                        label: const Text('Abrir Seletor em Diálogo'),
                        onPressed: _openPickerDialog,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 0,
                color: colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'UtilityNumberPicker (Vertical)',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Selecionado: $_verticalValue parcelas (Role o mouse, arraste ou clique)'),
                      const SizedBox(height: 16),
                      UtilityNumberPicker(
                        minValue: 1,
                        maxValue: 48,
                        value: _verticalValue,
                        itemCount: 3,
                        onChanged: (val) {
                          setState(() => _verticalValue = val);
                        },
                        selectedTextStyle: TextStyle(
                          color: colorScheme.primary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textStyle: TextStyle(
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                          fontSize: 16,
                        ),
                        decoration: BoxDecoration(
                          border: Border.symmetric(
                            horizontal: BorderSide(
                              color: colorScheme.primary.withValues(alpha: 0.3),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 0,
                color: colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'UtilityNumberPicker (Horizontal)',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Nota selecionada: $_horizontalValue'),
                      const SizedBox(height: 16),
                      UtilityNumberPicker(
                        minValue: 1,
                        maxValue: 10,
                        value: _horizontalValue,
                        axis: Axis.horizontal,
                        itemHeight: 50,
                        itemWidth: 60,
                        itemCount: 5,
                        onChanged: (val) {
                          setState(() => _horizontalValue = val);
                        },
                        selectedTextStyle: TextStyle(
                          color: colorScheme.secondary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colorScheme.secondary,
                            width: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 0,
                color: colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Seletor de Ano (com textMapper)',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Ano: $_yearValue'),
                      const SizedBox(height: 16),
                      UtilityNumberPicker(
                        minValue: 2020,
                        maxValue: 2035,
                        value: _yearValue,
                        onChanged: (val) {
                          setState(() => _yearValue = val);
                        },
                        textMapper: (ano) => 'Ano $ano',
                        selectedTextStyle: TextStyle(
                          color: colorScheme.tertiary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 2. DEMO DO MONTH PICKER
// ==========================================

class MonthPickerDemoView extends StatefulWidget {
  const MonthPickerDemoView({super.key});

  @override
  State<MonthPickerDemoView> createState() => _MonthPickerDemoViewState();
}

class _MonthPickerDemoViewState extends State<MonthPickerDemoView> {
  DateTime _dialogMonth = DateTime(2026, 5, 1);
  DateTime _inlineMonth = DateTime(2026, 8, 1);
  DateTime _restrictedMonth = DateTime(2026, 6, 1);

  String _formatMonth(DateTime dt) {
    const names = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro'
    ];
    return '${names[dt.month - 1]} de ${dt.year}';
  }

  void _openMonthPickerDialog() async {
    final colorScheme = Theme.of(context).colorScheme;

    final result = await showUtilityMonthPickerDialog(
      context: context,
      initialDate: _dialogMonth,
      selectedDate: _dialogMonth,
      firstDate: DateTime(2020, 1, 1),
      lastDate: DateTime(2035, 12, 31),
      title: Text(
        'Selecione o Mês de Referência',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
      ),
      style: UtilityMonthPickerStyle(
        arrowColor: colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
    );

    if (result != null) {
      setState(() {
        _dialogMonth = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Diálogo Modal
              Card(
                elevation: 0,
                color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Diálogo Modal (showUtilityMonthPickerDialog)',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Mês Selecionado: ${_formatMonth(_dialogMonth)}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        icon: const Icon(Icons.calendar_month),
                        label: const Text('Abrir Diálogo de Mês'),
                        onPressed: _openMonthPickerDialog,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Inline Padrão
              Card(
                elevation: 0,
                color: colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'UtilityMonthPicker (Inline com Tema Customizado)',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text('Selecionado: ${_formatMonth(_inlineMonth)}'),
                      const SizedBox(height: 16),
                      UtilityMonthPicker(
                        initialDate: _inlineMonth,
                        selectedDate: _inlineMonth,
                        style: UtilityMonthPickerStyle(
                          arrowColor: colorScheme.primary,
                          headerTextStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        onMonthSelected: (date) {
                          setState(() => _inlineMonth = date);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Com Limites
              Card(
                elevation: 0,
                color: colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'UtilityMonthPicker (Com Intervalo: Mar/2026 até Set/2026)',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text('Selecionado: ${_formatMonth(_restrictedMonth)}'),
                      const SizedBox(height: 16),
                      UtilityMonthPicker(
                        initialDate: _restrictedMonth,
                        selectedDate: _restrictedMonth,
                        firstDate: DateTime(2026, 3, 1),
                        lastDate: DateTime(2026, 9, 30),
                        style: UtilityMonthPickerStyle(
                          arrowColor: colorScheme.secondary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onMonthSelected: (date) {
                          setState(() => _restrictedMonth = date);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 3. DEMO DO CALCULATOR
// ==========================================

class CalculatorDemoView extends StatefulWidget {
  const CalculatorDemoView({super.key});

  @override
  State<CalculatorDemoView> createState() => _CalculatorDemoViewState();
}

class _CalculatorDemoViewState extends State<CalculatorDemoView> {
  double _accountBalance = 150.75;
  double _inlineValue = 50.0;
  double _submittedInlineValue = 50.0;

  void _openCalculatorModal() async {
    final colorScheme = Theme.of(context).colorScheme;

    final result = await showUtilityCalculatorModal(
      context: context,
      initialValue: _accountBalance,
      title: Text(
        'Editar Valor da Conta',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
      ),
      style: UtilityCalculatorStyle(
        operatorButtonColor: colorScheme.primary,
        equalsButtonColor: colorScheme.tertiary,
        confirmButtonColor: Colors.green.shade700,
        borderRadius: BorderRadius.circular(16),
      ),
    );

    if (result != null) {
      setState(() {
        _accountBalance = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Simulação de Retorno para a Tela Chamadora com initialValue
              Card(
                elevation: 0,
                color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Simulação: Valor Inicial & Retorno para a Tela',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Valor atual da conta: R\$ ${_accountBalance.toStringAsFixed(2).replaceAll('.', ',')}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        icon: const Icon(Icons.calculate),
                        label: const Text('Editar Valor na Calculadora (Modal)'),
                        onPressed: _openCalculatorModal,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Calculadora Inline
              Card(
                elevation: 0,
                color: colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'UtilityCalculator (Inline com onChanged e onSubmitted)',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Tempo real: R\$ ${_inlineValue.toStringAsFixed(2).replaceAll('.', ',')} | Confirmado: R\$ ${_submittedInlineValue.toStringAsFixed(2).replaceAll('.', ',')}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      UtilityCalculator(
                        initialValue: 50.0,
                        style: UtilityCalculatorStyle(
                          operatorButtonColor: colorScheme.primary,
                          equalsButtonColor: colorScheme.primary,
                          confirmButtonColor: colorScheme.secondary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        onChanged: (val) {
                          setState(() => _inlineValue = val);
                        },
                        onSubmitted: (val) {
                          setState(() => _submittedInlineValue = val);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Valor confirmado: R\$ ${val.toStringAsFixed(2).replaceAll('.', ',')}'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
