import 'package:flutter/widgets.dart';
import 'month_picker_style.dart';

/// Seletor de Mês e Ano limpo, leve e agnóstico a design systems.
///
/// Permite selecionar mês e ano sem exigir a seleção de um dia específico.
/// Suporta limites ([firstDate], [lastDate]), navegação de ano rápida,
/// customização de nomes de meses e estilos visuais completos.
class UtilityMonthPicker extends StatefulWidget {
  /// Data inicial utilizada como referência para o seletor.
  /// Se nulo, utiliza [DateTime.now()].
  final DateTime? initialDate;

  /// Data atualmente selecionada.
  final DateTime? selectedDate;

  /// Menor data (mês/ano) permitida para seleção.
  final DateTime? firstDate;

  /// Maior data (mês/ano) permitida para seleção.
  final DateTime? lastDate;

  /// Callback chamado quando o usuário seleciona um mês.
  final ValueChanged<DateTime> onMonthSelected;

  /// Callback opcional chamado quando o ano exibido é alterado.
  final ValueChanged<int>? onYearChanged;

  /// Lista com os 12 nomes ou abreviações dos meses (de janeiro a dezembro).
  ///
  /// Se nulo, o padrão em português é utilizado:
  /// `['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez']`.
  final List<String>? monthNames;

  /// Configurações de estilo visual do seletor.
  final UtilityMonthPickerStyle? style;

  /// Widget customizado para o botão de ano anterior.
  final Widget? previousIcon;

  /// Widget customizado para o botão de próximo ano.
  final Widget? nextIcon;

  /// Se deve permitir alternar para a visualização de seleção rápida de ano
  /// ao tocar no ano no cabeçalho. Padrão: true.
  final bool enableYearToggle;

  /// Se deve destacar visualmente o mês atual do sistema. Padrão: true.
  final bool highlightCurrentMonth;

  /// Largura fixa opcional do componente.
  final double? width;

  /// Altura fixa opcional do componente.
  final double? height;

  const UtilityMonthPicker({
    super.key,
    this.initialDate,
    this.selectedDate,
    this.firstDate,
    this.lastDate,
    required this.onMonthSelected,
    this.onYearChanged,
    this.monthNames,
    this.style,
    this.previousIcon,
    this.nextIcon,
    this.enableYearToggle = true,
    this.highlightCurrentMonth = true,
    this.width,
    this.height,
  }) : assert(
          monthNames == null || monthNames.length == 12,
          'monthNames deve conter exatamente 12 itens.',
        );

  @override
  State<UtilityMonthPicker> createState() => _UtilityMonthPickerState();
}

class _UtilityMonthPickerState extends State<UtilityMonthPicker> {
  static const List<String> _defaultMonthNames = [
    'Jan',
    'Fev',
    'Mar',
    'Abr',
    'Mai',
    'Jun',
    'Jul',
    'Ago',
    'Set',
    'Out',
    'Nov',
    'Dez',
  ];

  late int _displayedYear;
  DateTime? _selectedDate;
  bool _isSelectingYear = false;
  ScrollController? _yearScrollController;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    final baseDate = widget.selectedDate ?? widget.initialDate ?? DateTime.now();
    _displayedYear = baseDate.year;

    // Garante que o ano exibido inicial respeite os limites permitidos
    if (widget.firstDate != null && _displayedYear < widget.firstDate!.year) {
      _displayedYear = widget.firstDate!.year;
    } else if (widget.lastDate != null && _displayedYear > widget.lastDate!.year) {
      _displayedYear = widget.lastDate!.year;
    }
  }

  @override
  void didUpdateWidget(covariant UtilityMonthPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      _selectedDate = widget.selectedDate;
      if (widget.selectedDate != null) {
        _displayedYear = widget.selectedDate!.year;
      }
    }
  }

  @override
  void dispose() {
    _yearScrollController?.dispose();
    super.dispose();
  }

  List<String> get _resolvedMonthNames => widget.monthNames ?? _defaultMonthNames;

  UtilityMonthPickerStyle get _style => widget.style ?? const UtilityMonthPickerStyle();

  bool get _canGoPrevious {
    if (widget.firstDate == null) return true;
    return _displayedYear > widget.firstDate!.year;
  }

  bool get _canGoNext {
    if (widget.lastDate == null) return true;
    return _displayedYear < widget.lastDate!.year;
  }

  void _previousYear() {
    if (!_canGoPrevious) return;
    setState(() {
      _displayedYear--;
    });
    widget.onYearChanged?.call(_displayedYear);
  }

  void _nextYear() {
    if (!_canGoNext) return;
    setState(() {
      _displayedYear++;
    });
    widget.onYearChanged?.call(_displayedYear);
  }

  void _toggleYearMode() {
    if (!widget.enableYearToggle) return;
    setState(() {
      _isSelectingYear = !_isSelectingYear;
    });

    if (_isSelectingYear) {
      _yearScrollController?.dispose();
      _yearScrollController = ScrollController();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSelectedYear();
      });
    }
  }

  void _scrollToSelectedYear() {
    if (_yearScrollController == null || !_yearScrollController!.hasClients) return;
    final minYear = widget.firstDate?.year ?? (_displayedYear - 50);
    final yearIndex = _displayedYear - minYear;
    // 3 colunas, estimativa de 50px por linha
    final rowIndex = yearIndex ~/ 3;
    final targetOffset = (rowIndex * 50.0) - 60.0;
    _yearScrollController!.jumpTo(
      targetOffset.clamp(0.0, _yearScrollController!.position.maxScrollExtent),
    );
  }

  bool _isMonthDisabled(int month) {
    final monthStart = DateTime(_displayedYear, month, 1);
    final monthEnd = DateTime(_displayedYear, month + 1, 0, 23, 59, 59, 999);

    if (widget.firstDate != null && monthEnd.isBefore(widget.firstDate!)) {
      return true;
    }
    if (widget.lastDate != null && monthStart.isAfter(widget.lastDate!)) {
      return true;
    }
    return false;
  }

  bool _isMonthSelected(int month) {
    if (_selectedDate == null) return false;
    return _selectedDate!.year == _displayedYear && _selectedDate!.month == month;
  }

  bool _isCurrentMonth(int month) {
    final now = DateTime.now();
    return now.year == _displayedYear && now.month == month;
  }

  void _selectMonth(int month) {
    if (_isMonthDisabled(month)) return;
    final selected = DateTime(_displayedYear, month, 1);
    setState(() {
      _selectedDate = selected;
    });
    widget.onMonthSelected(selected);
  }

  void _selectYear(int year) {
    if (widget.firstDate != null && year < widget.firstDate!.year) return;
    if (widget.lastDate != null && year > widget.lastDate!.year) return;

    setState(() {
      _displayedYear = year;
      _isSelectingYear = false;
    });
    widget.onYearChanged?.call(year);
  }

  Widget _buildHeader() {
    final style = _style;
    final headerTextStyle = style.headerTextStyle ??
        const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Color(0xDE000000),
        );

    return Padding(
      padding: style.headerPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavigationArrowButton(
            key: const Key('utility_month_picker_prev_year'),
            onTap: _canGoPrevious ? _previousYear : null,
            isEnabled: _canGoPrevious,
            color: style.arrowColor,
            disabledColor: style.disabledArrowColor,
            isLeft: true,
            customWidget: widget.previousIcon,
          ),
          MouseRegion(
            cursor: widget.enableYearToggle ? SystemMouseCursors.click : SystemMouseCursors.basic,
            child: GestureDetector(
              key: const Key('utility_month_picker_year_toggle'),
              onTap: _toggleYearMode,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                decoration: BoxDecoration(
                  color: _isSelectingYear ? const Color(0x1A000000) : const Color(0x00000000),
                  borderRadius: style.borderRadius,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$_displayedYear',
                      style: headerTextStyle,
                    ),
                    if (widget.enableYearToggle) ...[
                      const SizedBox(width: 4.0),
                      CustomPaint(
                        size: const Size(10, 6),
                        painter: _DropdownArrowPainter(
                          color: headerTextStyle.color ?? const Color(0xDE000000),
                          isUp: _isSelectingYear,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          _NavigationArrowButton(
            key: const Key('utility_month_picker_next_year'),
            onTap: _canGoNext ? _nextYear : null,
            isEnabled: _canGoNext,
            color: style.arrowColor,
            disabledColor: style.disabledArrowColor,
            isLeft: false,
            customWidget: widget.nextIcon,
          ),
        ],
      ),
    );
  }

  Widget _buildMonthGrid() {
    final style = _style;
    final names = _resolvedMonthNames;

    final defaultTextStyle = const TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: Color(0xDE000000),
    );
    final defaultSelectedTextStyle = const TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
      color: Color(0xFFFFFFFF),
    );
    final defaultDisabledTextStyle = const TextStyle(
      fontSize: 14.0,
      color: Color(0x38000000),
    );

    final selectedDecoration = style.selectedMonthDecoration ??
        BoxDecoration(
          color: style.arrowColor,
          borderRadius: style.borderRadius,
        );

    final currentDecoration = style.currentMonthDecoration ??
        BoxDecoration(
          border: Border.all(color: style.arrowColor, width: 1.5),
          borderRadius: style.borderRadius,
        );

    return Column(
      children: List.generate(4, (rowIndex) {
        return Expanded(
          child: Row(
            children: List.generate(3, (colIndex) {
              final month = (rowIndex * 3) + colIndex + 1;
              final name = names[month - 1];
              final isDisabled = _isMonthDisabled(month);
              final isSelected = _isMonthSelected(month);
              final isCurrent = widget.highlightCurrentMonth && _isCurrentMonth(month);

              TextStyle textStyle;
              Decoration? itemDecoration;

              if (isDisabled) {
                textStyle = style.disabledMonthTextStyle ?? defaultDisabledTextStyle;
              } else if (isSelected) {
                textStyle = style.selectedMonthTextStyle ?? defaultSelectedTextStyle;
                itemDecoration = selectedDecoration;
              } else if (isCurrent) {
                textStyle = style.currentMonthTextStyle ??
                    defaultTextStyle.copyWith(
                      color: style.arrowColor,
                      fontWeight: FontWeight.bold,
                    );
                itemDecoration = currentDecoration;
              } else {
                textStyle = style.monthTextStyle ?? defaultTextStyle;
              }

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: style.crossAxisSpacing / 2,
                    vertical: style.mainAxisSpacing / 2,
                  ),
                  child: MouseRegion(
                    cursor: isDisabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: isDisabled ? null : () => _selectMonth(month),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: itemDecoration,
                        child: Text(
                          name,
                          style: textStyle,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  Widget _buildYearGrid() {
    final style = _style;
    final minYear = widget.firstDate?.year ?? (_displayedYear - 50);
    final maxYear = widget.lastDate?.year ?? (_displayedYear + 50);
    final totalYears = maxYear - minYear + 1;

    final defaultYearStyle = const TextStyle(
      fontSize: 14.0,
      color: Color(0xDE000000),
    );
    final defaultSelectedYearStyle = const TextStyle(
      fontSize: 15.0,
      fontWeight: FontWeight.bold,
      color: Color(0xFFFFFFFF),
    );
    final defaultDisabledYearStyle = const TextStyle(
      fontSize: 14.0,
      color: Color(0x38000000),
    );

    final selectedYearDec = style.selectedYearDecoration ??
        BoxDecoration(
          color: style.arrowColor,
          borderRadius: style.borderRadius,
        );

    return GridView.builder(
      controller: _yearScrollController,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.0,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: totalYears,
      itemBuilder: (context, index) {
        final year = minYear + index;
        final isSelected = year == _displayedYear;
        final isDisabled = (widget.firstDate != null && year < widget.firstDate!.year) ||
            (widget.lastDate != null && year > widget.lastDate!.year);

        TextStyle textStyle;
        Decoration? decoration;

        if (isDisabled) {
          textStyle = style.disabledYearTextStyle ?? defaultDisabledYearStyle;
        } else if (isSelected) {
          textStyle = style.selectedYearTextStyle ?? defaultSelectedYearStyle;
          decoration = selectedYearDec;
        } else {
          textStyle = style.yearItemTextStyle ?? defaultYearStyle;
        }

        return MouseRegion(
          cursor: isDisabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: isDisabled ? null : () => _selectYear(year),
            child: Container(
              alignment: Alignment.center,
              decoration: decoration,
              child: Text(
                '$year',
                style: textStyle,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height ?? 280.0,
      color: _style.backgroundColor,
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _isSelectingYear ? _buildYearGrid() : _buildMonthGrid(),
          ),
        ],
      ),
    );
  }
}

/// Botão agnóstico de navegação para avançar ou recuar anos.
class _NavigationArrowButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isEnabled;
  final Color color;
  final Color disabledColor;
  final bool isLeft;
  final Widget? customWidget;

  const _NavigationArrowButton({
    super.key,
    required this.onTap,
    required this.isEnabled,
    required this.color,
    required this.disabledColor,
    required this.isLeft,
    this.customWidget,
  });

  @override
  Widget build(BuildContext context) {
    final arrowColor = isEnabled ? color : disabledColor;

    Widget content;
    if (customWidget != null) {
      content = customWidget!;
    } else {
      content = SizedBox(
        width: 32.0,
        height: 32.0,
        child: Center(
          child: CustomPaint(
            size: const Size(12, 12),
            painter: _ChevronPainter(
              color: arrowColor,
              isLeft: isLeft,
            ),
          ),
        ),
      );
    }

    return MouseRegion(
      cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: content,
      ),
    );
  }
}

/// Desenha chevron < ou > pixel-perfect sem dependência de icones externos.
class _ChevronPainter extends CustomPainter {
  final Color color;
  final bool isLeft;

  const _ChevronPainter({required this.color, required this.isLeft});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    if (isLeft) {
      path.moveTo(size.width * 0.7, size.height * 0.15);
      path.lineTo(size.width * 0.3, size.height * 0.5);
      path.lineTo(size.width * 0.7, size.height * 0.85);
    } else {
      path.moveTo(size.width * 0.3, size.height * 0.15);
      path.lineTo(size.width * 0.7, size.height * 0.5);
      path.lineTo(size.width * 0.3, size.height * 0.85);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ChevronPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.isLeft != isLeft;
}

/// Desenha a seta para baixo/cima indicando alternância de seleção de ano.
class _DropdownArrowPainter extends CustomPainter {
  final Color color;
  final bool isUp;

  const _DropdownArrowPainter({required this.color, required this.isUp});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    if (isUp) {
      path.moveTo(0, size.height);
      path.lineTo(size.width / 2, 0);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width / 2, size.height);
      path.lineTo(size.width, 0);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _DropdownArrowPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.isUp != isUp;
}
