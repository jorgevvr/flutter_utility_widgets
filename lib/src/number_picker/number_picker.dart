import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Um seletor numérico em tambor rotativo, agnóstico a design systems,
/// com suporte completo a toque, arrasto de mouse, clique direto e rodinha do mouse.
class UtilityNumberPicker extends StatefulWidget {
  /// Menor valor selecionável.
  final int minValue;

  /// Maior valor selecionável.
  final int maxValue;

  /// Valor atualmente selecionado.
  final int value;

  /// Callback acionado quando o valor selecionado muda.
  final ValueChanged<int> onChanged;

  /// Incremento entre cada valor da lista. Padrão: 1.
  final int step;

  /// Altura de cada item individual. Padrão: 50.0.
  final double itemHeight;

  /// Largura de cada item individual. Padrão: 100.0.
  final double itemWidth;

  /// Orientação do seletor (vertical ou horizontal). Padrão: vertical.
  final Axis axis;

  /// Quantidade de itens visíveis na tela simultaneamente. Deve ser ímpar. Padrão: 3.
  final int itemCount;

  /// Estilo de texto dos itens não selecionados.
  final TextStyle? textStyle;

  /// Estilo de texto do item selecionado (no centro).
  final TextStyle? selectedTextStyle;

  /// Decoração (borda, cor de fundo, etc.) desenhada atrás do item central selecionado.
  final Decoration? decoration;

  /// Função para transformar o número exibido em texto customizado (ex: prefixar '0').
  final String Function(String valueText)? textMapper;

  /// Se deve disparar resposta tátil ao rolar entre números. Padrão: false.
  final bool haptics;

  /// Se a rolagem deve ter efeito de lupa/escala no centro. Padrão: true.
  final bool useMagnifier;

  /// Escala de ampliação do item central se [useMagnifier] for true. Padrão: 1.15.
  final double magnification;

  const UtilityNumberPicker({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.value,
    required this.onChanged,
    this.step = 1,
    this.itemHeight = 50.0,
    this.itemWidth = 100.0,
    this.axis = Axis.vertical,
    this.itemCount = 3,
    this.textStyle,
    this.selectedTextStyle,
    this.decoration,
    this.textMapper,
    this.haptics = false,
    this.useMagnifier = true,
    this.magnification = 1.15,
  })  : assert(minValue <= maxValue, 'minValue não pode ser maior que maxValue'),
        assert(value >= minValue && value <= maxValue, 'value deve estar entre minValue e maxValue'),
        assert(step > 0, 'step deve ser maior que zero'),
        assert(itemCount % 2 != 0, 'itemCount deve ser um número ímpar (ex: 1, 3, 5)');

  @override
  State<UtilityNumberPicker> createState() => _UtilityNumberPickerState();
}

class _UtilityNumberPickerState extends State<UtilityNumberPicker> {
  late FixedExtentScrollController _scrollController;
  late int _itemCountTotal;

  @override
  void initState() {
    super.initState();
    _calculateItemCount();
    _scrollController = FixedExtentScrollController(
      initialItem: _valueToIndex(widget.value),
    );
  }

  void _calculateItemCount() {
    _itemCountTotal = ((widget.maxValue - widget.minValue) ~/ widget.step) + 1;
  }

  int _valueToIndex(int val) {
    return ((val - widget.minValue) ~/ widget.step).clamp(0, _itemCountTotal - 1);
  }

  int _indexToValue(int index) {
    return widget.minValue + (index * widget.step);
  }

  @override
  void didUpdateWidget(covariant UtilityNumberPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.minValue != widget.minValue ||
        oldWidget.maxValue != widget.maxValue ||
        oldWidget.step != widget.step) {
      _calculateItemCount();
    }
    if (oldWidget.value != widget.value) {
      final targetIndex = _valueToIndex(widget.value);
      if (_scrollController.hasClients && _scrollController.selectedItem != targetIndex) {
        _scrollController.animateToItem(
          targetIndex,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onSelectedItemChanged(int index) {
    if (index >= 0 && index < _itemCountTotal) {
      final selectedVal = _indexToValue(index);
      if (selectedVal != widget.value) {
        if (widget.haptics) {
          HapticFeedback.selectionClick();
        }
        widget.onChanged(selectedVal);
      }
    }
  }

  void _animateToIndex(int index) {
    if (!_scrollController.hasClients) return;
    final targetIndex = index.clamp(0, _itemCountTotal - 1);
    if (targetIndex != _scrollController.selectedItem) {
      _scrollController.animateToItem(
        targetIndex,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      final delta = widget.axis == Axis.horizontal ? event.scrollDelta.dx : event.scrollDelta.dy;
      if (delta > 0) {
        _animateToOffset(1);
      } else if (delta < 0) {
        _animateToOffset(-1);
      }
    }
  }

  void _animateToOffset(int offset) {
    if (!_scrollController.hasClients) return;
    final nextIndex = (_scrollController.selectedItem + offset).clamp(0, _itemCountTotal - 1);
    _animateToIndex(nextIndex);
  }

  Widget _buildItem(BuildContext context, int index) {
    final itemValue = _indexToValue(index);

    final defaultUnselectedStyle = const TextStyle(
      fontSize: 16.0,
      color: Color(0x8A000000),
    );
    final defaultSelectedStyle = const TextStyle(
      fontSize: 22.0,
      fontWeight: FontWeight.bold,
      color: Color(0xFF000000),
    );

    final unselected = widget.textStyle ?? defaultUnselectedStyle;
    final selected = widget.selectedTextStyle ?? defaultSelectedStyle;

    String text = itemValue.toString();
    if (widget.textMapper != null) {
      text = widget.textMapper!(text);
    }

    return AnimatedBuilder(
      animation: _scrollController,
      builder: (context, _) {
        double currentOffset = 0.0;
        if (_scrollController.hasClients && _scrollController.position.hasContentDimensions) {
          currentOffset = _scrollController.offset / widget.itemHeight;
        } else {
          currentOffset = _valueToIndex(widget.value).toDouble();
        }

        final distance = (index - currentOffset).abs();
        final factor = distance.clamp(0.0, 1.0);
        final dynamicStyle = TextStyle.lerp(selected, unselected, factor) ?? selected;

        Widget content = Center(
          child: Text(
            text,
            style: dynamicStyle,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        );

        if (widget.axis == Axis.horizontal) {
          content = RotatedBox(quarterTurns: 1, child: content);
        }

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _animateToIndex(index),
            child: SizedBox(
              height: widget.itemHeight,
              width: widget.itemWidth,
              child: content,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isHorizontal = widget.axis == Axis.horizontal;
    final viewHeight = widget.itemHeight * widget.itemCount;
    final viewWidth = widget.itemWidth;

    Widget wheel = ScrollConfiguration(
      behavior: const _UtilityScrollBehavior(),
      child: ListWheelScrollView.useDelegate(
        controller: _scrollController,
        itemExtent: widget.itemHeight,
        onSelectedItemChanged: _onSelectedItemChanged,
        physics: const FixedExtentScrollPhysics(),
        perspective: 0.003,
        diameterRatio: 1.5,
        useMagnifier: widget.useMagnifier,
        magnification: widget.magnification,
        childDelegate: ListWheelChildBuilderDelegate(
          builder: _buildItem,
          childCount: _itemCountTotal,
        ),
      ),
    );

    if (isHorizontal) {
      wheel = RotatedBox(
        quarterTurns: 3,
        child: SizedBox(
          height: viewWidth,
          width: viewHeight,
          child: wheel,
        ),
      );
    }

    return Listener(
      onPointerSignal: _handlePointerSignal,
      child: SizedBox(
        height: isHorizontal ? widget.itemHeight : viewHeight,
        width: isHorizontal ? viewHeight : viewWidth,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (widget.decoration != null)
              IgnorePointer(
                child: Container(
                  height: widget.itemHeight,
                  width: widget.itemWidth,
                  decoration: widget.decoration,
                ),
              ),
            wheel,
          ],
        ),
      ),
    );
  }
}

/// Comportamento de rolagem agnóstico com suporte a arrasto por mouse, touch e trackpad.
class _UtilityScrollBehavior extends ScrollBehavior {
  const _UtilityScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}
