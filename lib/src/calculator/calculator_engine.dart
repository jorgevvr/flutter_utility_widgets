/// Motor de cálculo aritmético puro para o [UtilityCalculator].
///
/// Não possui dependência de widgets ou UI. Lida com operações aritméticas,
/// cálculo de porcentagem contextual financeiro, inversão de sinal (+/-),
/// prevenção de erros de ponto flutuante IEEE 754 e formatação numérica.
class CalculatorEngine {
  String _currentInput = '0';
  double? _previousValue;
  String? _operation;
  String _expression = '';
  bool _hasCalculated = false;
  bool _replaceOnNextDigit = false;
  bool _isError = false;

  /// Cria uma nova instância da calculadora, aceitando opcionalmente um [initialValue].
  CalculatorEngine({double? initialValue}) {
    if (initialValue != null && initialValue != 0.0) {
      _currentInput = formatNumber(initialValue);
    } else {
      _currentInput = '0';
    }
  }

  /// Retorna o valor numérico atual do display.
  double get currentValue {
    if (_isError) return 0.0;
    return double.tryParse(_currentInput) ?? 0.0;
  }

  /// Retorna a string do display principal (ex: "150.50" ou "Erro").
  String get displayValue => _currentInput;

  /// Retorna a expressão de cálculo em andamento (ex: "120 + 30 =").
  String get expression => _expression;

  /// Indica se o visor está atualmente em estado de erro (ex: divisão por zero).
  bool get isError => _isError;

  /// Indica se a última operação pressionada foi '='.
  bool get hasCalculated => _hasCalculated;

  /// Operação pendente ('+', '-', '×', '÷'), se houver.
  String? get operation => _operation;

  /// Arredonda para 10 casas decimais para eliminar resíduos de ponto flutuante.
  static double normalize(double val) {
    if (val.isNaN || val.isInfinite) return val;
    return double.parse(val.toStringAsFixed(10));
  }

  /// Formata um [double] para string sem zeros à direita desnecessários.
  static String formatNumber(double val) {
    if (val.isNaN || val.isInfinite) return 'Erro';
    final normalized = normalize(val);
    if (normalized == normalized.truncateToDouble()) {
      return normalized.toInt().toString();
    }
    String str = normalized.toString();
    if (str.contains('.')) {
      str = str.replaceAll(RegExp(r'0*$'), '');
      str = str.replaceAll(RegExp(r'\.$'), '');
    }
    return str;
  }

  /// Insere um dígito numérico ('0'..'9').
  void inputDigit(String digit) {
    if (_isError) {
      allClear();
    }

    if (_hasCalculated || _replaceOnNextDigit) {
      _currentInput = digit;
      if (_hasCalculated) {
        _expression = '';
      }
      _hasCalculated = false;
      _replaceOnNextDigit = false;
      return;
    }

    if (_currentInput == '0') {
      _currentInput = digit;
    } else {
      _currentInput += digit;
    }
  }

  /// Insere duplo zero ('00'), muito útil para valores monetários.
  void inputDoubleZero() {
    if (_isError) {
      allClear();
    }

    if (_hasCalculated || _replaceOnNextDigit) {
      _currentInput = '0';
      if (_hasCalculated) {
        _expression = '';
      }
      _hasCalculated = false;
      _replaceOnNextDigit = false;
      return;
    }

    if (_currentInput == '0') {
      return;
    }
    _currentInput += '00';
  }

  /// Insere o separador decimal ('.').
  void inputDecimal() {
    if (_isError) {
      allClear();
    }

    if (_hasCalculated || _replaceOnNextDigit) {
      _currentInput = '0.';
      if (_hasCalculated) {
        _expression = '';
      }
      _hasCalculated = false;
      _replaceOnNextDigit = false;
      return;
    }

    if (!_currentInput.contains('.')) {
      _currentInput += '.';
    }
  }

  /// Define a operação aritmética ('+', '-', '×', '÷').
  void setOperation(String op) {
    if (_isError) return;

    if (_previousValue != null && _operation != null && !_replaceOnNextDigit && !_hasCalculated) {
      _executePendingOperation();
      if (_isError) return;
    } else {
      _previousValue = currentValue;
    }

    _operation = op;
    _expression = '${formatNumber(_previousValue!)} $op';
    _replaceOnNextDigit = true;
    _hasCalculated = false;
  }

  void _executePendingOperation() {
    if (_previousValue == null || _operation == null) return;
    final current = currentValue;

    double result;
    switch (_operation) {
      case '+':
        result = _previousValue! + current;
        break;
      case '-':
        result = _previousValue! - current;
        break;
      case '×':
      case '*':
        result = _previousValue! * current;
        break;
      case '÷':
      case '/':
        if (current == 0.0) {
          _isError = true;
          _currentInput = 'Erro';
          _expression = '${formatNumber(_previousValue!)} ÷ 0 =';
          return;
        }
        result = _previousValue! / current;
        break;
      default:
        result = current;
    }

    result = normalize(result);
    _previousValue = result;
    _currentInput = formatNumber(result);
  }

  /// Executa o cálculo da igualdade ('=').
  void calculate() {
    if (_isError) return;

    if (_operation == null || _previousValue == null) {
      _expression = '${formatNumber(currentValue)} =';
      _hasCalculated = true;
      return;
    }

    final current = currentValue;
    final op = _operation!;
    final prev = _previousValue!;

    double result;
    switch (op) {
      case '+':
        result = prev + current;
        break;
      case '-':
        result = prev - current;
        break;
      case '×':
      case '*':
        result = prev * current;
        break;
      case '÷':
      case '/':
        if (current == 0.0) {
          _isError = true;
          _currentInput = 'Erro';
          _expression = '${formatNumber(prev)} ÷ 0 =';
          return;
        }
        result = prev / current;
        break;
      default:
        result = current;
    }

    result = normalize(result);
    _expression = '${formatNumber(prev)} $op ${formatNumber(current)} =';
    _currentInput = formatNumber(result);
    _previousValue = null;
    _operation = null;
    _hasCalculated = true;
  }

  /// Calcula porcentagem de forma contextual para finanças.
  ///
  /// Exemplo:
  /// - `200 + 10%` -> 10% de 200 é 20. O display vira 20 e ao teclar `=` resulta 220.
  /// - `200 × 10%` -> 0.10. Ao teclar `=` resulta 20.
  /// - `50%` isolado -> 0.5.
  void percent() {
    if (_isError) return;
    final current = currentValue;

    if (_previousValue != null && (_operation == '+' || _operation == '-')) {
      final pctVal = normalize(_previousValue! * (current / 100.0));
      _currentInput = formatNumber(pctVal);
    } else {
      final pctVal = normalize(current / 100.0);
      _currentInput = formatNumber(pctVal);
    }
  }

  /// Inverte o sinal do número atual (+/-).
  void toggleSign() {
    if (_isError) return;
    if (_currentInput == '0') return;

    if (_currentInput.startsWith('-')) {
      _currentInput = _currentInput.substring(1);
    } else {
      _currentInput = '-$_currentInput';
    }
  }

  /// Apaga o último dígito inserido (Backspace).
  void backspace() {
    if (_isError || _hasCalculated) {
      _currentInput = '0';
      _hasCalculated = false;
      return;
    }

    if (_currentInput.length > 1) {
      _currentInput = _currentInput.substring(0, _currentInput.length - 1);
      if (_currentInput == '-' || _currentInput.isEmpty) {
        _currentInput = '0';
      }
    } else {
      _currentInput = '0';
    }
  }

  /// Limpa toda a operação e histórico (All Clear - AC).
  void allClear({double? resetValue}) {
    _previousValue = null;
    _operation = null;
    _expression = '';
    _hasCalculated = false;
    _replaceOnNextDigit = false;
    _isError = false;

    if (resetValue != null && resetValue != 0.0) {
      _currentInput = formatNumber(resetValue);
    } else {
      _currentInput = '0';
    }
  }

  /// Limpa apenas a entrada atual (C).
  void clearEntry() {
    if (_isError) {
      allClear();
      return;
    }
    _currentInput = '0';
    _replaceOnNextDigit = false;
  }
}
