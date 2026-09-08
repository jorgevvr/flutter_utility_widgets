# Roadmap & Arquitetura — `flutter_utility_widgets`

Este documento serve como guia completo de implementação para o desenvolvimento do pacote `flutter_utility_widgets`. Quando você abrir este projeto em uma nova janela de IDE ou sessão, siga este roteiro.

---

## 1. Visão Geral e Objetivos

* **Objetivo:** Substituir bibliotecas de terceiros abandonadas ou desatualizadas por componentes próprios, limpos, mantidos e reutilizáveis em qualquer projeto Flutter.
* **Bibliotecas a serem substituídas no app principal (`Minhas-Contas-X`):**
  1. `numberpicker` (^2.1.2) → **`UtilityNumberPicker`**
  2. `month_picker_dialog` (^6.7.2) → **`UtilityMonthPicker`**
  3. `flutter_simple_calculator` (^2.7.1) → **`UtilityCalculator`**

---

## 2. Princípios de Design e Diretrizes Técnicas

1. **Agnóstico a Design System (Sem Acoplamento):**
   * Os widgets do core (`lib/src/`) devem importar **apenas** `package:flutter/widgets.dart` (ou `foundation.dart`/`rendering.dart`).
   * **NÃO** importar `package:flutter/material.dart` nem `package:flutter/cupertino.dart` nos widgets centrais.
   * Não usar `Theme.of(context)` diretamente no core. Cores, bordas e fontes devem ser recebidas via parâmetros (`TextStyle`, `Decoration`, `Color`, etc.) ou herdadas de `DefaultTextStyle` / `Directionality`.
   * *Opcional:* Se desejar criar helpers específicos (ex: `showMaterialMonthPicker`), estes ficam em pasta separada (`lib/src/material_helpers/`) ou são construídos diretamente no app consumidor.
2. **Zero Dependências Externas:**
   * O `pubspec.yaml` do package depende exclusivamente do Flutter SDK (`sdk: flutter`).
   * Não adicionar pacotes de terceiros.
3. **Multiplataforma:**
   * Suporte total e nativo para Android, iOS, Web, Windows, macOS e Linux.

---

## 3. Estrutura de Diretórios Recomendada

```text
flutter_utility_widgets/
├── ROADMAP.md                         # Este documento de referência
├── README.md                          # Instruções de instalação e uso público
├── pubspec.yaml                       # Configuração do package (somente sdk: flutter)
├── lib/
│   ├── flutter_utility_widgets.dart   # Arquivo barrel (exporta todos os componentes)
│   └── src/
│       ├── number_picker/
│       │   ├── number_picker.dart     # Widget UtilityNumberPicker
│       │   └── number_picker_wheel.dart # Implementação com ListWheelScrollView
│       ├── month_picker/
│       │   ├── month_picker_view.dart # Grade de meses e seletor de ano
│       │   └── month_picker_dialog.dart # Diálogo agnóstico/responsivo
│       └── calculator/
│           ├── calculator_engine.dart # Máquina de cálculo e parser aritmético puro
│           └── calculator_view.dart   # Display e teclado customizável
├── test/
│   ├── number_picker_test.dart
│   ├── month_picker_test.dart
│   └── calculator_test.dart
└── example/                           # App de demonstração e testes manuais
    ├── pubspec.yaml                   # Depende de flutter_utility_widgets (path: ../)
    └── lib/
        └── main.dart                  # Tela com abas/rotas para testar os 3 widgets
```

---

## 4. Especificação Técnica dos Componentes

### 4.1. `UtilityNumberPicker` (Fase 1)
* **Objetivo:** Seletor numérico em tambor rotativo com rolagem fluida e snap automático ao centro.
* **Mecanismo:** `ListWheelScrollView.useDelegate` combinado com `FixedExtentScrollController`.
* **API Principal (compatível com uso existente):**
  * `minValue` (`int`, obrigatório)
  * `maxValue` (`int`, obrigatório)
  * `value` (`int`, obrigatório)
  * `onChanged` (`ValueChanged<int>`, obrigatório)
  * `step` (`int`, default `1`)
  * `axis` (`Axis`, default `Axis.vertical`, suporte a horizontal via `RotatedBox` ou layout equivalente)
  * `itemHeight` (`double`, default `50.0`)
  * `itemWidth` (`double`, default `100.0`)
  * `itemCount` (`int`, quantidade visível de itens, default `3`)
  * `textStyle` (`TextStyle?`, estilo dos itens não selecionados)
  * `selectedTextStyle` (`TextStyle?`, estilo do item em foco no centro)
  * `decoration` (`Decoration?`, destaque/borda do item selecionado)
  * `textMapper` (`String Function(String numberText)?`, formatação customizada ex: `01`, `02`)
  * `haptics` (`bool`, default `false`)

### 4.2. `UtilityMonthPicker` (Fase 2)
* **Objetivo:** Seletor de Mês e Ano limpo, sem obrigar seleção de dia.
* **Componentes:**
  1. **Cabeçalho de Ano:** Exibe o ano atual com botões de navegação anterior/próximo (`<` e `>`) ou toque para alternar para visualização de anos.
  2. **Grade de Meses:** `GridView` ou `Table` 3x4 com os 12 meses.
  3. **Customização de Nomes:** Parâmetro `monthNames` (`List<String>` com 12 nomes ou abreviações) para não forçar dependência com `intl` no core.
* **API Principal:**
  * `initialDate` (`DateTime`)
  * `firstDate` (`DateTime?`)
  * `lastDate` (`DateTime?`)
  * `onMonthSelected` (`ValueChanged<DateTime>`)
  * `monthNames` (`List<String>?`, fallback para `['Jan', 'Fev', 'Mar', ...]` ou callback)
  * Estilos de cores (`selectedColor`, `textColor`, `headerStyle`, etc.).

### 4.3. `UtilityCalculator` (Fase 3)
* **Objetivo:** Teclado de calculadora básico para entrada e operação de valores financeiros.
* **Componentes:**
  1. `CalculatorEngine` (lógica pura Dart, sem UI):
     * Estado: `displayValue`, `expression`, `pendingOperation`.
     * Operações: `+`, `-`, `×`, `÷`, `%`, `+/-`, `.`, `=`, `AC`, `Backspace`.
     * Precisão de ponto flutuante tratada para valores monetários.
  2. `CalculatorView` (Widget agnóstico):
     * Display superior com expressão e valor resultante.
     * Grade de botões com espaçamento, cores e tipografia injetadas por parâmetro.
     * Retorno do valor final em `onChanged` ou botão de confirmação.

---

## 5. Checklist de Implementação Passo a Passo

- [ ] **Etapa 0: Configuração Inicial**
  - [x] Package criado via `flutter create --template=package flutter_utility_widgets`.
  - [x] App `example/` criado via `flutter create example`.
  - [ ] Vincular `flutter_utility_widgets` no `example/pubspec.yaml` via `path: ../`.
  - [ ] Rodar `flutter pub get` no root e no `example/`.

- [ ] **Etapa 1: Implementação do `UtilityNumberPicker`**
  - [ ] Criar `lib/src/number_picker/number_picker.dart`.
  - [ ] Exportar em `lib/flutter_utility_widgets.dart`.
  - [ ] Criar testes unitários e de widget em `test/number_picker_test.dart`.
  - [ ] Criar página de demonstração no `example/lib/main.dart` testando limites, passo e estilos.
  - [ ] Rodar `flutter test` e `flutter analyze` para garantir zero avisos.

- [ ] **Etapa 2: Implementação do `UtilityMonthPicker`**
  - [ ] Criar `lib/src/month_picker/month_picker_view.dart`.
  - [ ] Exportar em `lib/flutter_utility_widgets.dart`.
  - [ ] Testes em `test/month_picker_test.dart`.
  - [ ] Adicionar demonstração no `example/lib/main.dart`.
  - [ ] Validar com `flutter test` e `flutter analyze`.

- [ ] **Etapa 3: Implementação do `UtilityCalculator`**
  - [ ] Criar `lib/src/calculator/calculator_engine.dart` com testes de lógica pura.
  - [ ] Criar `lib/src/calculator/calculator_view.dart`.
  - [ ] Exportar em `lib/flutter_utility_widgets.dart`.
  - [ ] Adicionar demonstração interativa no `example/lib/main.dart`.
  - [ ] Validar com `flutter test` e `flutter analyze`.

- [ ] **Etapa 4: Publicação no Git**
  - [ ] Criar repositório público no GitHub (ex: `https://github.com/seu-usuario/flutter_utility_widgets.git`).
  - [ ] Configurar `.gitignore` e `README.md`.
  - [ ] Subir código inicial e criar a tag `v1.0.0`:
    ```bash
    git init
    git add .
    git commit -m "feat: initial release with NumberPicker, MonthPicker and Calculator"
    git branch -M main
    git remote add origin https://github.com/seu-usuario/flutter_utility_widgets.git
    git push -u origin main
    git tag v1.0.0
    git push origin v1.0.0
    ```

- [ ] **Etapa 5: Migração no `Minhas-Contas-X`**
  - [ ] Adicionar no `pubspec.yaml` do app:
    ```yaml
    dependencies:
      flutter_utility_widgets:
        git:
          url: https://github.com/seu-usuario/flutter_utility_widgets.git
          ref: v1.0.0
    ```
  - [ ] Remover `numberpicker`, `month_picker_dialog` e `flutter_simple_calculator` do `pubspec.yaml`.
  - [ ] Substituir os imports e widgets nos arquivos do app.
  - [ ] Executar `flutter analyze` e a suíte de testes do app principal.
