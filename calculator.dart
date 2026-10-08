import 'dart:math' as math;

import '../exceptions.dart';

/// Калькулятор: базові операції та обчислення виразів на кшталт `2+3*(4-1)^2`.
class Calculator {
  const Calculator._();

  static double add(num a, num b) => (a + b).toDouble();

  static double subtract(num a, num b) => (a - b).toDouble();

  static double multiply(num a, num b) => (a * b).toDouble();

  static double divide(num a, num b) {
    if (b == 0) {
      throw const CalculatorException('Ділення на нуль');
    }
    return a / b;
  }

  static double modulo(num a, num b) {
    if (b == 0) {
      throw const CalculatorException('Остача від ділення на нуль');
    }
    return (a % b).toDouble();
  }

  static double power(num base, num exponent) =>
      math.pow(base, exponent).toDouble();

  static double squareRoot(num value) {
    if (value < 0) {
      throw const CalculatorException('Корінь з від\'ємного числа');
    }
    return math.sqrt(value);
  }

  static double percentOf(num percent, num value) => value * percent / 100;

  static double average(List<num> values) {
    if (values.isEmpty) {
      throw const CalculatorException('Порожній список для середнього');
    }
    return values.fold<double>(0, (sum, v) => sum + v) / values.length;
  }

  /// Обчислює арифметичний вираз: + - * / ^ та дужки, унарний мінус.
  static double evaluate(String expression) =>
      _ExpressionParser(expression).parse();
}

/// Рекурсивний низхідний парсер.
/// Пріоритети (від найнижчого): + - | * / | унарний - | ^ (права асоціативність).
class _ExpressionParser {
  _ExpressionParser(String source)
      : _src = source.replaceAll(RegExp(r'\s+'), '');

  final String _src;
  int _pos = 0;

  bool get _atEnd => _pos >= _src.length;

  String get _current => _src[_pos];

  double parse() {
    if (_src.isEmpty) {
      throw const CalculatorException('Порожній вираз');
    }
    final value = _parseExpression();
    if (!_atEnd) {
      throw CalculatorException(
          'Неочікуваний символ "$_current" на позиції ${_pos + 1}');
    }
    return value;
  }

  double _parseExpression() {
    var value = _parseTerm();
    while (!_atEnd && (_current == '+' || _current == '-')) {
      final op = _current;
      _pos++;
      final right = _parseTerm();
      value = op == '+' ? value + right : value - right;
    }
    return value;
  }

  double _parseTerm() {
    var value = _parseUnary();
    while (!_atEnd && (_current == '*' || _current == '/')) {
      final op = _current;
      _pos++;
      final right = _parseUnary();
      value = op == '*' ? value * right : Calculator.divide(value, right);
    }
    return value;
  }

  double _parseUnary() {
    if (!_atEnd && _current == '-') {
      _pos++;
      return -_parseUnary();
    }
    if (!_atEnd && _current == '+') {
      _pos++;
      return _parseUnary();
    }
    return _parsePower();
  }

  double _parsePower() {
    final base = _parsePrimary();
    if (!_atEnd && _current == '^') {
      _pos++;
      final exponent = _parseUnary();
      return math.pow(base, exponent).toDouble();
    }
    return base;
  }

  double _parsePrimary() {
    if (_atEnd) {
      throw const CalculatorException('Несподіваний кінець виразу');
    }
    if (_current == '(') {
      _pos++;
      final value = _parseExpression();
      if (_atEnd || _current != ')') {
        throw const CalculatorException('Відсутня закриваюча дужка');
      }
      _pos++;
      return value;
    }
    final start = _pos;
    while (!_atEnd && _isNumberChar(_current)) {
      _pos++;
    }
    if (start == _pos) {
      throw CalculatorException(
          'Очікувалось число на позиції ${_pos + 1}, знайдено "$_current"');
    }
    final text = _src.substring(start, _pos);
    final number = double.tryParse(text);
    if (number == null) {
      throw CalculatorException('Некоректне число "$text"');
    }
    return number;
  }

  static bool _isNumberChar(String c) =>
      c == '.' || (c.compareTo('0') >= 0 && c.compareTo('9') <= 0);
}
