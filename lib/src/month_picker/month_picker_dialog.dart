import 'package:flutter/widgets.dart';
import 'month_picker_style.dart';
import 'month_picker_view.dart';

/// Um container/card de diálogo agnóstico a design systems para o [UtilityMonthPicker].
///
/// Pode ser utilizado diretamente dentro de `showDialog` (Material),
/// `showCupertinoDialog` (Cupertino), ou com o [showUtilityMonthPickerDialog] agnóstico.
class UtilityMonthPickerDialog extends StatefulWidget {
  /// Data inicial de referência.
  final DateTime? initialDate;

  /// Data pré-selecionada.
  final DateTime? selectedDate;

  /// Menor data permitida.
  final DateTime? firstDate;

  /// Maior data permitida.
  final DateTime? lastDate;

  /// Título opcional exibido no topo do diálogo.
  final Widget? title;

  /// Nomes ou abreviações dos 12 meses.
  final List<String>? monthNames;

  /// Estilos visuais do seletor.
  final UtilityMonthPickerStyle? style;

  /// Callback chamado ao confirmar com a data selecionada.
  final ValueChanged<DateTime>? onConfirm;

  /// Callback chamado ao cancelar.
  final VoidCallback? onCancel;

  /// Texto do botão de confirmação. Padrão: 'OK'.
  final String confirmText;

  /// Texto do botão de cancelamento. Padrão: 'Cancelar'.
  final String cancelText;

  /// Widget customizado para o botão de confirmação.
  final Widget? confirmWidget;

  /// Widget customizado para o botão de cancelamento.
  final Widget? cancelWidget;

  /// Cor de fundo do card do diálogo. Padrão: branco (Color(0xFFFFFFFF)).
  final Color backgroundColor;

  /// Raio da borda do diálogo.
  final BorderRadiusGeometry borderRadius;

  /// Largura máxima do card do diálogo. Padrão: 320.0.
  final double maxWidth;

  const UtilityMonthPickerDialog({
    super.key,
    this.initialDate,
    this.selectedDate,
    this.firstDate,
    this.lastDate,
    this.title,
    this.monthNames,
    this.style,
    this.onConfirm,
    this.onCancel,
    this.confirmText = 'OK',
    this.cancelText = 'Cancelar',
    this.confirmWidget,
    this.cancelWidget,
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.borderRadius = const BorderRadius.all(Radius.circular(24.0)),
    this.maxWidth = 320.0,
  });

  @override
  State<UtilityMonthPickerDialog> createState() => _UtilityMonthPickerDialogState();
}

class _UtilityMonthPickerDialogState extends State<UtilityMonthPickerDialog> {
  late DateTime _currentSelection;

  @override
  void initState() {
    super.initState();
    _currentSelection = widget.selectedDate ?? widget.initialDate ?? DateTime.now();
  }

  void _onMonthSelected(DateTime date) {
    setState(() {
      _currentSelection = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? const UtilityMonthPickerStyle();

    return Center(
      child: Container(
        width: widget.maxWidth,
        margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: widget.borderRadius,
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              offset: Offset(0, 10),
              blurRadius: 24.0,
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.title != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 8.0),
                child: widget.title!,
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: UtilityMonthPicker(
                initialDate: widget.initialDate,
                selectedDate: _currentSelection,
                firstDate: widget.firstDate,
                lastDate: widget.lastDate,
                onMonthSelected: _onMonthSelected,
                monthNames: widget.monthNames,
                style: style,
                height: 270.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (widget.cancelWidget != null)
                    widget.cancelWidget!
                  else
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: widget.onCancel ?? () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                          child: Text(
                            widget.cancelText,
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              color: style.arrowColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(width: 8.0),
                  if (widget.confirmWidget != null)
                    widget.confirmWidget!
                  else
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (widget.onConfirm != null) {
                            widget.onConfirm!(_currentSelection);
                          } else {
                            Navigator.of(context).pop(_currentSelection);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            color: style.arrowColor,
                            borderRadius: const BorderRadius.all(Radius.circular(100.0)),
                          ),
                          child: Text(
                            widget.confirmText,
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Abre o seletor de mês de forma modal e agnóstica utilizando [showGeneralDialog].
Future<DateTime?> showUtilityMonthPickerDialog({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? selectedDate,
  DateTime? firstDate,
  DateTime? lastDate,
  Widget? title,
  List<String>? monthNames,
  UtilityMonthPickerStyle? style,
  String confirmText = 'OK',
  String cancelText = 'Cancelar',
  Color backgroundColor = const Color(0xFFFFFFFF),
  BorderRadiusGeometry borderRadius = const BorderRadius.all(Radius.circular(24.0)),
  bool barrierDismissible = true,
}) {
  return showGeneralDialog<DateTime>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: 'Fechar',
    barrierColor: const Color(0x66000000),
    pageBuilder: (ctx, anim1, anim2) {
      return UtilityMonthPickerDialog(
        initialDate: initialDate,
        selectedDate: selectedDate,
        firstDate: firstDate,
        lastDate: lastDate,
        title: title,
        monthNames: monthNames,
        style: style,
        confirmText: confirmText,
        cancelText: cancelText,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
        onConfirm: (date) => Navigator.of(ctx).pop(date),
        onCancel: () => Navigator.of(ctx).pop(),
      );
    },
    transitionDuration: const Duration(milliseconds: 200),
    transitionBuilder: (ctx, anim1, anim2, child) {
      return ScaleTransition(
        scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic),
        child: FadeTransition(opacity: anim1, child: child),
      );
    },
  );
}
