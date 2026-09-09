import 'package:flutter/widgets.dart';
import 'calculator_style.dart';
import 'calculator_view.dart';

/// Um container/card agnóstico para exibir a calculadora em diálogos ou folhas modais.
///
/// Aceita [initialValue] opcional e retorna o resultado final ao chamar [onConfirm].
class UtilityCalculatorModalCard extends StatelessWidget {
  /// Valor inicial pré-preenchido no visor.
  final double? initialValue;

  /// Título exibido no topo do modal.
  final Widget? title;

  /// Callback chamado ao confirmar com o resultado numérico calculado.
  final ValueChanged<double>? onConfirm;

  /// Callback chamado ao fechar/cancelar.
  final VoidCallback? onCancel;

  /// Estilos visuais da calculadora.
  final UtilityCalculatorStyle? style;

  /// Texto do botão de confirmação. Padrão: 'Confirmar'.
  final String confirmButtonText;

  /// Cor de fundo do card do diálogo. Padrão: branco.
  final Color backgroundColor;

  /// Raio da borda do card modal.
  final BorderRadiusGeometry borderRadius;

  /// Largura máxima do modal. Padrão: 340.0.
  final double maxWidth;

  /// Altura do componente da calculadora dentro do modal. Padrão: 440.0.
  final double calculatorHeight;

  const UtilityCalculatorModalCard({
    super.key,
    this.initialValue,
    this.title,
    this.onConfirm,
    this.onCancel,
    this.style,
    this.confirmButtonText = 'Confirmar',
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.borderRadius = const BorderRadius.all(Radius.circular(24.0)),
    this.maxWidth = 340.0,
    this.calculatorHeight = 440.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: maxWidth,
        margin: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              offset: Offset(0, 10),
              blurRadius: 24.0,
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (title != null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: title!),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        key: const Key('calculator_modal_close'),
                        behavior: HitTestBehavior.opaque,
                        onTap: onCancel ?? () => Navigator.of(context).pop(),
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            '✕',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0x8A000000),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
              ],
              UtilityCalculator(
                initialValue: initialValue,
                style: style,
                confirmButtonText: confirmButtonText,
                height: calculatorHeight,
                onSubmitted: (val) {
                  if (onConfirm != null) {
                    onConfirm!(val);
                  } else {
                    Navigator.of(context).pop(val);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Abre a calculadora de forma modal e agnóstica via [showGeneralDialog],
/// retornando um [Future<double?>] com o resultado numérico selecionado pelo usuário.
Future<double?> showUtilityCalculatorModal({
  required BuildContext context,
  double? initialValue,
  Widget? title,
  UtilityCalculatorStyle? style,
  String confirmButtonText = 'Confirmar',
  Color backgroundColor = const Color(0xFFFFFFFF),
  BorderRadiusGeometry borderRadius = const BorderRadius.all(Radius.circular(24.0)),
  bool barrierDismissible = true,
}) {
  return showGeneralDialog<double>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: 'Fechar',
    barrierColor: const Color(0x66000000),
    pageBuilder: (ctx, anim1, anim2) {
      return UtilityCalculatorModalCard(
        initialValue: initialValue,
        title: title,
        style: style,
        confirmButtonText: confirmButtonText,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
        onConfirm: (val) => Navigator.of(ctx).pop(val),
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
