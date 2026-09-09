import 'package:flutter/widgets.dart';

/// Configurações visuais e de estilo para o [UtilityMonthPicker].
///
/// Totalmente agnóstico a design systems (não depende de Material ou Cupertino).
class UtilityMonthPickerStyle {
  /// Estilo de texto do título (ano ou cabeçalho) no topo.
  final TextStyle? headerTextStyle;

  /// Espaçamento interno do cabeçalho de navegação.
  final EdgeInsetsGeometry headerPadding;

  /// Estilo de texto para meses disponíveis e não selecionados.
  final TextStyle? monthTextStyle;

  /// Estilo de texto para o mês selecionado.
  final TextStyle? selectedMonthTextStyle;

  /// Decoração (cor, borda, raio) do mês selecionado.
  final Decoration? selectedMonthDecoration;

  /// Estilo de texto para o mês atual (do sistema), quando não selecionado.
  final TextStyle? currentMonthTextStyle;

  /// Decoração para destacar o mês atual (do sistema), quando não selecionado.
  final Decoration? currentMonthDecoration;

  /// Estilo de texto para meses desabilitados (fora do intervalo [firstDate, lastDate]).
  final TextStyle? disabledMonthTextStyle;

  /// Estilo de texto para itens de ano na visão de seleção de ano.
  final TextStyle? yearItemTextStyle;

  /// Estilo de texto para o ano selecionado na visão de anos.
  final TextStyle? selectedYearTextStyle;

  /// Decoração para o ano selecionado na visão de anos.
  final Decoration? selectedYearDecoration;

  /// Estilo de texto para anos fora do intervalo permitido.
  final TextStyle? disabledYearTextStyle;

  /// Cor dos botões/ícones de navegação de ano (`<` e `>`).
  final Color arrowColor;

  /// Cor dos botões de navegação quando desabilitados.
  final Color disabledArrowColor;

  /// Raio da borda para efeitos de foco e itens.
  final BorderRadiusGeometry borderRadius;

  /// Cor de fundo opcional do seletor.
  final Color? backgroundColor;

  /// Espaçamento horizontal entre os meses na grade.
  final double crossAxisSpacing;

  /// Espaçamento vertical entre as linhas de meses.
  final double mainAxisSpacing;

  const UtilityMonthPickerStyle({
    this.headerTextStyle,
    this.headerPadding = const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
    this.monthTextStyle,
    this.selectedMonthTextStyle,
    this.selectedMonthDecoration,
    this.currentMonthTextStyle,
    this.currentMonthDecoration,
    this.disabledMonthTextStyle,
    this.yearItemTextStyle,
    this.selectedYearTextStyle,
    this.selectedYearDecoration,
    this.disabledYearTextStyle,
    this.arrowColor = const Color(0xFF1E88E5),
    this.disabledArrowColor = const Color(0x38000000),
    this.borderRadius = const BorderRadius.all(Radius.circular(12.0)),
    this.backgroundColor,
    this.crossAxisSpacing = 8.0,
    this.mainAxisSpacing = 8.0,
  });

  /// Retorna uma cópia com os campos substituídos.
  UtilityMonthPickerStyle copyWith({
    TextStyle? headerTextStyle,
    EdgeInsetsGeometry? headerPadding,
    TextStyle? monthTextStyle,
    TextStyle? selectedMonthTextStyle,
    Decoration? selectedMonthDecoration,
    TextStyle? currentMonthTextStyle,
    Decoration? currentMonthDecoration,
    TextStyle? disabledMonthTextStyle,
    TextStyle? yearItemTextStyle,
    TextStyle? selectedYearTextStyle,
    Decoration? selectedYearDecoration,
    TextStyle? disabledYearTextStyle,
    Color? arrowColor,
    Color? disabledArrowColor,
    BorderRadiusGeometry? borderRadius,
    Color? backgroundColor,
    double? crossAxisSpacing,
    double? mainAxisSpacing,
  }) {
    return UtilityMonthPickerStyle(
      headerTextStyle: headerTextStyle ?? this.headerTextStyle,
      headerPadding: headerPadding ?? this.headerPadding,
      monthTextStyle: monthTextStyle ?? this.monthTextStyle,
      selectedMonthTextStyle: selectedMonthTextStyle ?? this.selectedMonthTextStyle,
      selectedMonthDecoration: selectedMonthDecoration ?? this.selectedMonthDecoration,
      currentMonthTextStyle: currentMonthTextStyle ?? this.currentMonthTextStyle,
      currentMonthDecoration: currentMonthDecoration ?? this.currentMonthDecoration,
      disabledMonthTextStyle: disabledMonthTextStyle ?? this.disabledMonthTextStyle,
      yearItemTextStyle: yearItemTextStyle ?? this.yearItemTextStyle,
      selectedYearTextStyle: selectedYearTextStyle ?? this.selectedYearTextStyle,
      selectedYearDecoration: selectedYearDecoration ?? this.selectedYearDecoration,
      disabledYearTextStyle: disabledYearTextStyle ?? this.disabledYearTextStyle,
      arrowColor: arrowColor ?? this.arrowColor,
      disabledArrowColor: disabledArrowColor ?? this.disabledArrowColor,
      borderRadius: borderRadius ?? this.borderRadius,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      crossAxisSpacing: crossAxisSpacing ?? this.crossAxisSpacing,
      mainAxisSpacing: mainAxisSpacing ?? this.mainAxisSpacing,
    );
  }
}
