import 'package:flutter/widgets.dart';

/// Configurações visuais e de estilo para o [UtilityCalculator].
///
/// Totalmente agnóstico a design systems (não depende de Material ou Cupertino).
class UtilityCalculatorStyle {
  /// Cor de fundo da área do display superior.
  final Color displayBackgroundColor;

  /// Estilo de texto do valor numérico principal no display.
  final TextStyle? displayTextStyle;

  /// Estilo de texto da expressão (ex: "150 + 25 =") exibida acima do número.
  final TextStyle? expressionTextStyle;

  /// Espaçamento interno da área do display.
  final EdgeInsetsGeometry displayPadding;

  /// Espaçamento entre os botões da calculadora.
  final double buttonSpacing;

  /// Raio de curvatura das bordas dos botões.
  final BorderRadiusGeometry borderRadius;

  /// Cor de fundo dos botões numéricos (0..9, 00, .).
  final Color numberButtonColor;

  /// Estilo de texto dos botões numéricos.
  final TextStyle? numberTextStyle;

  /// Cor de fundo dos botões de operadores aritméticos (+, -, ×, ÷).
  final Color operatorButtonColor;

  /// Estilo de texto dos operadores aritméticos.
  final TextStyle? operatorTextStyle;

  /// Cor de fundo dos botões de ações especiais (AC, C, +/-, %, ⌫).
  final Color actionButtonColor;

  /// Estilo de texto dos botões de ação especial.
  final TextStyle? actionTextStyle;

  /// Cor de fundo do botão de igualdade (=).
  final Color equalsButtonColor;

  /// Estilo de texto do botão de igualdade (=).
  final TextStyle? equalsTextStyle;

  /// Cor de fundo do botão de confirmação/retorno (quando visível).
  final Color confirmButtonColor;

  /// Estilo de texto do botão de confirmação.
  final TextStyle? confirmTextStyle;

  /// Separador decimal exibido no display e teclado ('.' ou ','). Padrão: ','.
  final String decimalSeparator;

  const UtilityCalculatorStyle({
    this.displayBackgroundColor = const Color(0x0D000000),
    this.displayTextStyle,
    this.expressionTextStyle,
    this.displayPadding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
    this.buttonSpacing = 8.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(16.0)),
    this.numberButtonColor = const Color(0x14000000),
    this.numberTextStyle,
    this.operatorButtonColor = const Color(0xFF1E88E5),
    this.operatorTextStyle,
    this.actionButtonColor = const Color(0x24000000),
    this.actionTextStyle,
    this.equalsButtonColor = const Color(0xFF1565C0),
    this.equalsTextStyle,
    this.confirmButtonColor = const Color(0xFF2E7D32),
    this.confirmTextStyle,
    this.decimalSeparator = ',',
  });

  /// Retorna uma cópia com os campos substituídos.
  UtilityCalculatorStyle copyWith({
    Color? displayBackgroundColor,
    TextStyle? displayTextStyle,
    TextStyle? expressionTextStyle,
    EdgeInsetsGeometry? displayPadding,
    double? buttonSpacing,
    BorderRadiusGeometry? borderRadius,
    Color? numberButtonColor,
    TextStyle? numberTextStyle,
    Color? operatorButtonColor,
    TextStyle? operatorTextStyle,
    Color? actionButtonColor,
    TextStyle? actionTextStyle,
    Color? equalsButtonColor,
    TextStyle? equalsTextStyle,
    Color? confirmButtonColor,
    TextStyle? confirmTextStyle,
    String? decimalSeparator,
  }) {
    return UtilityCalculatorStyle(
      displayBackgroundColor: displayBackgroundColor ?? this.displayBackgroundColor,
      displayTextStyle: displayTextStyle ?? this.displayTextStyle,
      expressionTextStyle: expressionTextStyle ?? this.expressionTextStyle,
      displayPadding: displayPadding ?? this.displayPadding,
      buttonSpacing: buttonSpacing ?? this.buttonSpacing,
      borderRadius: borderRadius ?? this.borderRadius,
      numberButtonColor: numberButtonColor ?? this.numberButtonColor,
      numberTextStyle: numberTextStyle ?? this.numberTextStyle,
      operatorButtonColor: operatorButtonColor ?? this.operatorButtonColor,
      operatorTextStyle: operatorTextStyle ?? this.operatorTextStyle,
      actionButtonColor: actionButtonColor ?? this.actionButtonColor,
      actionTextStyle: actionTextStyle ?? this.actionTextStyle,
      equalsButtonColor: equalsButtonColor ?? this.equalsButtonColor,
      equalsTextStyle: equalsTextStyle ?? this.equalsTextStyle,
      confirmButtonColor: confirmButtonColor ?? this.confirmButtonColor,
      confirmTextStyle: confirmTextStyle ?? this.confirmTextStyle,
      decimalSeparator: decimalSeparator ?? this.decimalSeparator,
    );
  }
}
