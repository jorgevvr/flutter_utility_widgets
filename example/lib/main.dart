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
      home: const DemoHomePage(),
    );
  }
}

class DemoHomePage extends StatefulWidget {
  const DemoHomePage({super.key});

  @override
  State<DemoHomePage> createState() => _DemoHomePageState();
}

class _DemoHomePageState extends State<DemoHomePage> {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Utility Widgets Demo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Simulação do Diálogo como no Minhas Contas
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

                // Exemplo Inline Vertical
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

                // Exemplo Inline Horizontal
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

                // Exemplo Seletor de Ano
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
      ),
    );
  }
}
