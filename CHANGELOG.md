## 1.0.0

* **UtilityNumberPicker**:
  * Seletor numérico rotativo estilo tambor agnóstico a design systems.
  * Suporte a rolagem vertical e horizontal, toque, clique direto, arrasto por mouse e roda do mouse.
  * Suporte a formatação com `textMapper` e resposta tátil (`haptics`).

* **UtilityMonthPicker**:
  * Seletor de mês e ano limpo, sem obrigar seleção de dia.
  * Navegação rápida de anos com botões `<` e `>` e visualização em grade ao tocar no ano.
  * Suporte a limites `firstDate` e `lastDate`, nomes customizados (`monthNames`) e estilos visuais agnósticos.
  * Função utilitária e card de diálogo `UtilityMonthPickerDialog`.

* **UtilityCalculator**:
  * Motor de cálculo aritmético puro `CalculatorEngine` com controle de precisão financeira.
  * Suporte a valor inicial opcional (`initialValue`) e retorno de resultado (`onSubmitted`).
  * Porcentagem contextual financeira (`%`), inversão de sinal (`+/-`), `Backspace` e `AC`.
  * Widget `UtilityCalculator` e helper modal `showUtilityCalculatorModal`.
