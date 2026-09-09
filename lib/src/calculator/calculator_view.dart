import 'package:flutter/widgets.dart';
import 'calculator_engine.dart';
import 'calculator_style.dart';

/// Widget de Calculadora agnóstico a design systems para entrada e operações aritméticas/financeiras.
///
/// Aceita valor inicial opcional via [initialValue], emite alterações em tempo real via [onChanged]
/// e confirmação do resultado final via [onSubmitted].
class UtilityCalculator extends StatefulWidget {
  /// Valor numérico inicial opcional exibido no visor.
  final double? initialValue;

  /// Callback chamado em tempo real a cada dígito ou operação executada.
  final ValueChanged<double>? onChanged;

  /// Callback chamado quando o usuário confirma o valor (botão de confirmação/OK).
  final ValueChanged<double>? onSubmitted;

  /// Configurações visuais e de estilo do componente.
  final UtilityCalculatorStyle? style;

  /// Se deve exibir a barra/botão de confirmação inferior. Padrão: true.
  final bool showConfirmationButton;

  /// Texto do botão de confirmação. Padrão: 'Confirmar'.
  final String confirmButtonText;

  /// Ícone ou widget opcional para o botão de confirmação.
  final Widget? confirmIcon;

  /// Largura fixa opcional do componente.
  final double? width;

  /// Altura fixa opcional do componente.
  final double? height;

  const UtilityCalculator({
    super.key,
    this.initialValue,
    this.onChanged,
    this.onSubmitted,
    this.style,
    this.showConfirmationButton = true,
    this.confirmButtonText = 'Confirmar',
    this.confirmIcon,
    this.width,
    this.height,
  });

  @override
  State<UtilityCalculator> createState() => _UtilityCalculatorState();
}

class _UtilityCalculatorState extends State<UtilityCalculator> {
  late CalculatorEngine _engine;

  @override
  void initState() {
    super.initState();
    _engine = CalculatorEngine(initialValue: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant UtilityCalculator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue && widget.initialValue != null) {
      _engine.allClear(resetValue: widget.initialValue);
    }
  }

  UtilityCalculatorStyle get _style => widget.style ?? const UtilityCalculatorStyle();

  void _notifyChange() {
    widget.onChanged?.call(_engine.currentValue);
  }

  void _onDigit(String digit) {
    setState(() {
      _engine.inputDigit(digit);
    });
    _notifyChange();
  }

  void _onDecimal() {
    setState(() {
      _engine.inputDecimal();
    });
    _notifyChange();
  }

  void _onOperator(String op) {
    setState(() {
      _engine.setOperation(op);
    });
    _notifyChange();
  }

  void _onEquals() {
    setState(() {
      _engine.calculate();
    });
    _notifyChange();
  }

  void _onPercent() {
    setState(() {
      _engine.percent();
    });
    _notifyChange();
  }

  void _onToggleSign() {
    setState(() {
      _engine.toggleSign();
    });
    _notifyChange();
  }

  void _onBackspace() {
    setState(() {
      _engine.backspace();
    });
    _notifyChange();
  }

  void _onClear() {
    setState(() {
      _engine.allClear(resetValue: widget.initialValue);
    });
    _notifyChange();
  }

  void _onSubmit() {
    // Se houver cálculo pendente (ex: digitou 10 + 5 e clicou em Confirmar direto sem teclar '=')
    if (_engine.operation != null && !_engine.hasCalculated) {
      _engine.calculate();
    }
    widget.onSubmitted?.call(_engine.currentValue);
  }

  String _formatDisplayForLocale(String rawValue) {
    if (_style.decimalSeparator == '.') return rawValue;
    return rawValue.replaceAll('.', _style.decimalSeparator);
  }

  Widget _buildDisplay() {
    final style = _style;
    final displayVal = _formatDisplayForLocale(_engine.displayValue);

    final defaultMainStyle = const TextStyle(
      fontSize: 34.0,
      fontWeight: FontWeight.bold,
      color: Color(0xDE000000),
    );
    final defaultExprStyle = const TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: Color(0x8A000000),
    );

    return Container(
      width: double.infinity,
      padding: style.displayPadding,
      decoration: BoxDecoration(
        color: style.displayBackgroundColor,
        borderRadius: style.borderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20.0,
            child: Text(
              _formatDisplayForLocale(_engine.expression),
              key: const Key('calculator_expression'),
              style: style.expressionTextStyle ?? defaultExprStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(height: 4.0),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              displayVal,
              key: const Key('calculator_display_value'),
              style: style.displayTextStyle ?? defaultMainStyle,
              maxLines: 1,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required VoidCallback onTap,
    required Color backgroundColor,
    TextStyle? textStyle,
    Widget? customContent,
    Key? key,
  }) {
    final style = _style;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(style.buttonSpacing / 2),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            key: key ?? Key('calc_btn_$label'),
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: style.borderRadius,
              ),
              child: customContent ??
                  Text(
                    label,
                    style: textStyle ??
                        const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xDE000000),
                        ),
                    textAlign: TextAlign.center,
                  ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    final style = _style;

    final defaultNumberStyle = style.numberTextStyle ??
        const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: Color(0xDE000000));
    final defaultOperatorStyle = style.operatorTextStyle ??
        const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF));
    final defaultActionStyle = style.actionTextStyle ??
        const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Color(0xDE000000));
    final defaultEqualsStyle = style.equalsTextStyle ??
        const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF));

    return Column(
      children: [
        // Linha 1: AC, ⌫, %, ÷
        Expanded(
          child: Row(
            children: [
              _buildButton(
                label: 'AC',
                onTap: _onClear,
                backgroundColor: style.actionButtonColor,
                textStyle: defaultActionStyle,
              ),
              _buildButton(
                label: '⌫',
                onTap: _onBackspace,
                backgroundColor: style.actionButtonColor,
                textStyle: defaultActionStyle,
              ),
              _buildButton(
                label: '%',
                onTap: _onPercent,
                backgroundColor: style.actionButtonColor,
                textStyle: defaultActionStyle,
              ),
              _buildButton(
                label: '÷',
                onTap: () => _onOperator('÷'),
                backgroundColor: style.operatorButtonColor,
                textStyle: defaultOperatorStyle,
              ),
            ],
          ),
        ),
        // Linha 2: 7, 8, 9, ×
        Expanded(
          child: Row(
            children: [
              _buildButton(
                label: '7',
                onTap: () => _onDigit('7'),
                backgroundColor: style.numberButtonColor,
                textStyle: defaultNumberStyle,
              ),
              _buildButton(
                label: '8',
                onTap: () => _onDigit('8'),
                backgroundColor: style.numberButtonColor,
                textStyle: defaultNumberStyle,
              ),
              _buildButton(
                label: '9',
                onTap: () => _onDigit('9'),
                backgroundColor: style.numberButtonColor,
                textStyle: defaultNumberStyle,
              ),
              _buildButton(
                label: '×',
                onTap: () => _onOperator('×'),
                backgroundColor: style.operatorButtonColor,
                textStyle: defaultOperatorStyle,
              ),
            ],
          ),
        ),
        // Linha 3: 4, 5, 6, -
        Expanded(
          child: Row(
            children: [
              _buildButton(
                label: '4',
                onTap: () => _onDigit('4'),
                backgroundColor: style.numberButtonColor,
                textStyle: defaultNumberStyle,
              ),
              _buildButton(
                label: '5',
                onTap: () => _onDigit('5'),
                backgroundColor: style.numberButtonColor,
                textStyle: defaultNumberStyle,
              ),
              _buildButton(
                label: '6',
                onTap: () => _onDigit('6'),
                backgroundColor: style.numberButtonColor,
                textStyle: defaultNumberStyle,
              ),
              _buildButton(
                label: '-',
                onTap: () => _onOperator('-'),
                backgroundColor: style.operatorButtonColor,
                textStyle: defaultOperatorStyle,
              ),
            ],
          ),
        ),
        // Linha 4: 1, 2, 3, +
        Expanded(
          child: Row(
            children: [
              _buildButton(
                label: '1',
                onTap: () => _onDigit('1'),
                backgroundColor: style.numberButtonColor,
                textStyle: defaultNumberStyle,
              ),
              _buildButton(
                label: '2',
                onTap: () => _onDigit('2'),
                backgroundColor: style.numberButtonColor,
                textStyle: defaultNumberStyle,
              ),
              _buildButton(
                label: '3',
                onTap: () => _onDigit('3'),
                backgroundColor: style.numberButtonColor,
                textStyle: defaultNumberStyle,
              ),
              _buildButton(
                label: '+',
                onTap: () => _onOperator('+'),
                backgroundColor: style.operatorButtonColor,
                textStyle: defaultOperatorStyle,
              ),
            ],
          ),
        ),
        // Linha 5: +/-, 0, separador decimal, =
        Expanded(
          child: Row(
            children: [
              _buildButton(
                label: '+/-',
                onTap: _onToggleSign,
                backgroundColor: style.numberButtonColor,
                textStyle: defaultNumberStyle,
              ),
              _buildButton(
                label: '0',
                onTap: () => _onDigit('0'),
                backgroundColor: style.numberButtonColor,
                textStyle: defaultNumberStyle,
              ),
              _buildButton(
                label: style.decimalSeparator,
                onTap: _onDecimal,
                backgroundColor: style.numberButtonColor,
                textStyle: defaultNumberStyle,
              ),
              _buildButton(
                label: '=',
                onTap: _onEquals,
                backgroundColor: style.equalsButtonColor,
                textStyle: defaultEqualsStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmButton() {
    final style = _style;

    final defaultConfirmStyle = style.confirmTextStyle ??
        const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFFFFFF),
        );

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: style.buttonSpacing),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          key: const Key('calculator_confirm_button'),
          behavior: HitTestBehavior.opaque,
          onTap: _onSubmit,
          child: Container(
            height: 48.0,
            decoration: BoxDecoration(
              color: style.confirmButtonColor,
              borderRadius: style.borderRadius,
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.confirmIcon != null) ...[
                  widget.confirmIcon!,
                  const SizedBox(width: 8.0),
                ],
                Text(
                  widget.confirmButtonText,
                  style: defaultConfirmStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height ?? 440.0,
      child: Column(
        children: [
          _buildDisplay(),
          const SizedBox(height: 8.0),
          Expanded(child: _buildKeypad()),
          if (widget.showConfirmationButton) _buildConfirmButton(),
        ],
      ),
    );
  }
}
