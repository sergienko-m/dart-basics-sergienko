// Завдання 2: функції, замикання, функціональне програмування,
// калькулятор і текстовий аналізатор.
//
// Запуск:  dart run bin/task2_functions.dart
// Калькулятор з аргументу:  dart run bin/task2_functions.dart "2+3*(4-1)^2"
import 'package:dart_basics/dart_basics.dart';

typedef Predicate<T> = bool Function(T value);

extension StringCapitalize on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}

void main(List<String> args) {
  print('=== Dart Functions Demo ===');

  if (args.isNotEmpty) {
    final expression = args.join(' ');
    try {
      print('$expression = ${Calculator.evaluate(expression)}');
    } on CalculatorException catch (e) {
      print('Помилка: ${e.message}');
    }
    return;
  }

  testBasicFunctions();
  testAdvancedFunctions();
  testFunctionalProgramming();
  demonstrateCalculator();
  demonstrateTextAnalyzer();
}

// ------------------------------------------------ 1. Звичайні функції
int calculateSum(int a, int b) => a + b; // стрілочна нотація

double calculateAverage(List<double> numbers) {
  if (numbers.isEmpty) {
    throw ArgumentError('Список не може бути порожнім');
  }
  var total = 0.0;
  for (final n in numbers) {
    total += n;
  }
  return total / numbers.length;
}

// ------------------------------------------------ 2. Optional / named
String formatName(
  String firstName,
  String lastName, {
  String? middleName,
  bool uppercase = false,
}) {
  final parts = <String>[
    firstName,
    if (middleName != null && middleName.isNotEmpty) middleName,
    lastName,
  ];
  final fullName = parts.join(' ');
  return uppercase ? fullName.toUpperCase() : fullName;
}

/// Позиційний необов'язковий параметр із значенням за замовчуванням.
String greet(String name, [String greeting = 'Привіт']) => '$greeting, $name!';

// ------------------------------------------------ 4. Рекурсія
int fibonacci(int n) {
  if (n < 0) {
    throw ArgumentError.value(n, 'n', 'має бути невід\'ємним');
  }
  if (n < 2) {
    return n;
  }
  return fibonacci(n - 1) + fibonacci(n - 2);
}

int factorial(int n) {
  if (n < 0) {
    throw ArgumentError.value(n, 'n', 'має бути невід\'ємним');
  }
  if (n > 20) {
    // 21! не вміщується в 64-бітний int
    throw ArgumentError.value(n, 'n', 'для n > 20 використовуйте BigInt');
  }
  return n <= 1 ? 1 : n * factorial(n - 1);
}

BigInt factorialBig(int n) => n <= 1
    ? BigInt.one
    : BigInt.from(n) * factorialBig(n - 1);

final Map<int, BigInt> _fibCache = {};

/// Рекурсія з мемоізацією: лінійна складність замість експоненційної.
BigInt fibonacciMemo(int n) {
  if (n < 2) {
    return BigInt.from(n);
  }
  final cached = _fibCache[n];
  if (cached != null) {
    return cached;
  }
  final result = fibonacciMemo(n - 1) + fibonacciMemo(n - 2);
  _fibCache[n] = result;
  return result;
}

int gcd(int a, int b) => b == 0 ? a.abs() : gcd(b, a % b);

// ------------------------------------------------ 3. Замикання
int Function() makeCounter() {
  var count = 0; // змінна "захоплюється" замиканням
  return () => ++count;
}

double Function(double) makeMultiplier(double factor) => (x) => x * factor;

T Function(T) compose<T>(T Function(T) f, T Function(T) g) => (x) => f(g(x));

R Function(A) memoize<A, R>(R Function(A) fn) {
  final cache = <A, R>{};
  return (A arg) => cache.putIfAbsent(arg, () => fn(arg));
}

int applyTwice(int Function(int) f, int x) => f(f(x));

// ------------------------------------------------ Тести / демонстрації
void _check(String name, Object? actual, Object? expected) {
  final ok = actual == expected;
  print('  [${ok ? 'OK' : 'FAIL'}] $name = $actual'
      '${ok ? '' : ' (очікувалось $expected)'}');
}

void testBasicFunctions() {
  print('\n--- Базові функції ---');
  _check('calculateSum(7, 5)', calculateSum(7, 5), 12);
  _check('calculateAverage([4, 6, 8])', calculateAverage([4, 6, 8]), 6.0);
  try {
    calculateAverage([]);
  } on ArgumentError catch (e) {
    print('  Порожній список -> ArgumentError: ${e.message}');
  }

  print('\n--- Параметри: позиційні, необов\'язкові, іменовані ---');
  print('  ${formatName('Олена', 'Коваль')}');
  print('  ${formatName('Олена', 'Коваль', middleName: 'Іванівна')}');
  print('  ${formatName('Олена', 'Коваль', uppercase: true)}');
  print('  ${greet('Андрій')} | ${greet('Андрій', 'Вітаю')}');

  print('\n--- Рекурсія ---');
  _check('fibonacci(10)', fibonacci(10), 55);
  _check('factorial(5)', factorial(5), 120);
  _check('factorial(20)', factorial(20), 2432902008176640000);
  print('  factorialBig(25) = ${factorialBig(25)}');
  print('  fibonacciMemo(90) = ${fibonacciMemo(90)}');
  _check('gcd(48, 18)', gcd(48, 18), 6);

  final slow = Stopwatch()..start();
  fibonacci(30);
  slow.stop();
  final fast = Stopwatch()..start();
  fibonacciMemo(300);
  fast.stop();
  print('  Наївний fibonacci(30): ${slow.elapsedMicroseconds} мкс; '
      'мемоізований fibonacciMemo(300): ${fast.elapsedMicroseconds} мкс');
}

void testAdvancedFunctions() {
  print('\n--- Замикання та функції вищого порядку ---');
  final counterA = makeCounter();
  final counterB = makeCounter();
  print('  counterA: ${counterA()}, ${counterA()}, ${counterA()}; '
      'counterB: ${counterB()} (незалежний лічильник)');

  final triple = makeMultiplier(3);
  print('  makeMultiplier(3)(7) = ${triple(7)}');

  final addOne = (int x) => x + 1;
  final square = (int x) => x * x;
  print('  compose(add1, square)(5) = ${compose<int>(addOne, square)(5)}');
  print('  applyTwice(square, 3) = ${applyTwice(square, 3)}');

  var calls = 0;
  final cachedSquare = memoize<int, int>((x) {
    calls++;
    return x * x;
  });
  cachedSquare(9);
  cachedSquare(9);
  cachedSquare(9);
  print('  memoize: 3 виклики, реальних обчислень: $calls');

  final callbacks = <void Function()>[];
  for (var i = 0; i < 3; i++) {
    callbacks.add(() => print('  замикання захопило i=$i'));
  }
  for (final callback in callbacks) {
    callback();
  }
}

void testFunctionalProgramming() {
  print('\n--- map / where / fold / reduce ---');
  final numbers = [1, 2, 3, 4, 5, 6];
  final isEven = (int n) => n.isEven;
  Predicate<int> isBig = (n) => n > 3;

  print('  where(even): ${numbers.where(isEven).toList()}');
  print('  map(x*x): ${numbers.map((n) => n * n).toList()}');
  print('  where(even).map(*2): '
      '${numbers.where(isEven).map((n) => n * 2).toList()}');
  print('  fold(0, +): ${numbers.fold<int>(0, (a, b) => a + b)}; '
      'reduce(max): ${numbers.reduce((a, b) => a > b ? a : b)}');
  print('  any(>3): ${numbers.any(isBig)}; every(>3): ${numbers.every(isBig)}');
  print('  expand: ${numbers.take(3).expand((n) => [n, n * 10]).toList()}');

  final names = ['олена', 'андрій', 'марія', 'іван'];
  final sorted = List<String>.of(names)
    ..sort((a, b) => a.length.compareTo(b.length));
  print('  capitalize+sort за довжиною: '
      '${sorted.map((n) => n.capitalize()).toList()}');
  names.map((n) => n.capitalize()).forEach(print); // tear-off: print

  final words = ['dart', 'flutter', 'dart', 'git', 'flutter', 'dart'];
  final frequency = words.fold<Map<String, int>>(
    {},
    (map, word) => map..update(word, (v) => v + 1, ifAbsent: () => 1),
  );
  print('  частота слів через fold: $frequency');
}

void demonstrateCalculator() {
  print('\n--- Калькулятор ---');
  print('  add(7, 5) = ${Calculator.add(7, 5)}');
  print('  subtract(7, 5) = ${Calculator.subtract(7, 5)}');
  print('  multiply(7, 5) = ${Calculator.multiply(7, 5)}');
  print('  divide(18, 4) = ${Calculator.divide(18, 4)}');
  print('  modulo(18, 4) = ${Calculator.modulo(18, 4)}');
  print('  power(2, 10) = ${Calculator.power(2, 10)}');
  print('  squareRoot(144) = ${Calculator.squareRoot(144)}');
  print('  percentOf(15, 200) = ${Calculator.percentOf(15, 200)}');

  const expressions = [
    '2 + 3 * 4',
    '(2 + 3) * 4',
    '2 ^ 3 ^ 2',
    '-2 ^ 2',
    '10 / 4 - 1.5',
    '1 / 0',
    '2 + * 3',
    '(1 + 2',
  ];
  for (final expression in expressions) {
    try {
      print('  $expression = ${Calculator.evaluate(expression)}');
    } on CalculatorException catch (e) {
      print('  $expression -> ${e.message}');
    }
  }
}

void demonstrateTextAnalyzer() {
  print('\n--- Текстовий аналізатор ---');
  const text = 'Dart - це швидка мова. Dart використовується з Flutter! '
      'Чи подобається вам Dart?\nДругий рядок тексту.';
  final stats = TextAnalyzer.analyze(text, topN: 3);
  print('  Текст: "$text"');
  print('  Символів (з пробілами): ${stats.characters}');
  print('  Символів (без пробілів): ${stats.charactersWithoutSpaces}');
  print('  Слів: ${stats.words}; унікальних: ${stats.uniqueWords}');
  print('  Речень: ${stats.sentences}; рядків: ${stats.lines}');
  print('  Середня довжина слова: ${stats.averageWordLength.toStringAsFixed(2)}');
  print('  Найдовше слово: ${stats.longestWord}');
  print('  Топ-3 слова: '
      '${stats.topWords.map((e) => '${e.key} x${e.value}').join(', ')}');
}
