// Завдання 1: змінні, типи даних, оператори, керуючі конструкції,
// колекції, null safety та обробка помилок.
import 'dart:math' as math;

void main() {
  print('=== Dart Variables & Types Demo ===');
  demonstrateNumbers();
  demonstrateStrings();
  demonstrateBooleans();
  demonstrateControlFlow();
  demonstrateCollections();
  demonstrateNullSafety();
  demonstrateErrorHandling();
}

void _section(String title) => print('\n--- $title ---');

// ---------------------------------------------------------------- Числа
void demonstrateNumbers() {
  _section('Числа: int, double, num');

  int a = 17;
  double b = 4.5;
  num c = 10; // num: може бути і int, і double
  print('a=$a (${a.runtimeType}), b=$b (${b.runtimeType}), '
      'c=$c (${c.runtimeType})');
  c = 2.5;
  print('після зміни c=$c (${c.runtimeType})');

  print('a + b = ${a + b}');
  print('a - b = ${a - b}');
  print('a * b = ${a * b}');
  print('a / 4 = ${a / 4} (завжди double)');
  print('a ~/ 4 = ${a ~/ 4} (цілочисельне ділення)');
  print('a % 4 = ${a % 4}; -a % 4 = ${-a % 4} (остача завжди невід\'ємна)');
  print('pow(2, 10) = ${math.pow(2, 10)}; sqrt(144) = ${math.sqrt(144)}');

  var counter = 0;
  counter++;
  ++counter;
  counter += 5;
  counter -= 1;
  counter *= 2;
  print('Інкремент і складені присвоєння: counter = $counter');

  print('Бітові: 5 & 3 = ${5 & 3}, 5 | 3 = ${5 | 3}, 5 ^ 3 = ${5 ^ 3}, '
      '1 << 4 = ${1 << 4}, 256 >> 2 = ${256 >> 2}');

  // Перетворення типів
  final parsedInt = int.parse('42');
  final parsedDouble = double.parse('3.14');
  final invalid = int.tryParse('abc');
  print('int.parse("42") = $parsedInt; double.parse("3.14") = $parsedDouble; '
      'int.tryParse("abc") = $invalid');
  print('3.99.toInt() = ${3.99.toInt()}; 3.5.round() = ${3.5.round()}; '
      '3.2.ceil() = ${3.2.ceil()}; 3.8.floor() = ${3.8.floor()}');
  print('42.toDouble() = ${42.toDouble()}; '
      '3.14159.toStringAsFixed(2) = ${3.14159.toStringAsFixed(2)}');

  // Особливості double
  print('0.1 + 0.2 = ${0.1 + 0.2}; '
      'порівняння з допуском: ${(0.1 + 0.2 - 0.3).abs() < 1e-9}');
  print('0 / 0 isNaN: ${(0 / 0).isNaN}; infinity: ${double.infinity}');
}

// ---------------------------------------------------------------- Рядки
void demonstrateStrings() {
  _section('Рядки');

  const language = 'Dart';
  final version = 3;
  print('Мова: $language, версія: $version, 2 + 2 = ${2 + 2}');
  print('${language.toUpperCase()} має ${language.length} літери');

  const multiLine = '''
Це багаторядковий
рядок у потрійних лапках''';
  print(multiLine);

  print('Escape: табуляція[\t], лапка[\'], слеш[\\], юнікод[\u{1F680}]');
  print(r'Raw-рядок: \n не обробляється, $language теж');

  const text = '  Hello, Dart World!  ';
  print('trim: "${text.trim()}"');
  print('toLowerCase: ${text.trim().toLowerCase()}');
  print('contains("Dart"): ${text.contains('Dart')}');
  print('startsWith("  He"): ${text.startsWith('  He')}');
  print('indexOf("Dart"): ${text.indexOf('Dart')}');
  print('replaceAll: ${text.trim().replaceAll('World', 'Flutter')}');
  print('split: ${text.trim().split(', ')}');
  print('substring(0, 5): ${text.trim().substring(0, 5)}');
  print('padLeft: "${'7'.padLeft(3, '0')}"; повтор: ${'=-' * 5}');
  print('codeUnitAt(0): ${'A'.codeUnitAt(0)}; fromCharCode(66): '
      '${String.fromCharCode(66)}');
  print('Порівняння: "a" == "a" -> ${'a' == 'a'}; '
      '"a".compareTo("b") -> ${'a'.compareTo('b')}');

  final reversed = 'level'.split('').reversed.join();
  print('"level" паліндром: ${reversed == 'level'}');

  final buffer = StringBuffer();
  for (var i = 1; i <= 3; i++) {
    buffer.write('[$i]');
  }
  print('StringBuffer: $buffer');
}

// ---------------------------------------------------------------- Логіка
bool _check(String name, bool value) {
  print('  обчислено $name');
  return value;
}

Object _mystery() => 'текст';

void demonstrateBooleans() {
  _section('Булеві значення та умови');

  const x = 7;
  const y = 10;
  print('x > y: ${x > y}; x < y: ${x < y}; x == y: ${x == y}; '
      'x != y: ${x != y}; x <= 7: ${x <= 7}');

  const hasTicket = true;
  const isAdult = false;
  print('AND: ${hasTicket && isAdult}; OR: ${hasTicket || isAdult}; '
      'NOT: ${!hasTicket}');

  print('Коротке замикання (B не обчислюється, бо A == false):');
  print('  результат: ${_check('A', false) && _check('B', true)}');

  final label = x.isEven ? 'парне' : 'непарне';
  print('Тернарний оператор: $x - $label');

  Object value = 42;
  if (value is int) {
    print('is-перевірка + автоприведення: ${value + 1}');
  }
  final Object mystery = _mystery();
  print('is! int: ${mystery is! int}; as String: ${(mystery as String).length}');
}

// ---------------------------------------------------------------- Керування
String describeScore(int score) => switch (score) {
      >= 90 => 'Відмінно',
      >= 75 => 'Добре',
      >= 60 => 'Задовільно',
      _ => 'Незадовільно',
    };

void demonstrateControlFlow() {
  _section('Керуючі конструкції: умови та цикли');

  // if / else if / else
  const temperature = 22;
  if (temperature < 0) {
    print('Мороз');
  } else if (temperature < 15) {
    print('Прохолодно');
  } else if (temperature < 25) {
    print('Комфортно ($temperature°C)');
  } else {
    print('Спекотно');
  }

  // switch (клас) - у Dart 3 break не потрібен
  const day = 6;
  switch (day) {
    case 6:
    case 7:
      print('День $day: вихідний');
    case 1:
      print('Понеділок');
    default:
      print('День $day: робочий');
  }

  // switch-вираз
  for (final score in [95, 80, 61, 30]) {
    print('switch-вираз: $score -> ${describeScore(score)}');
  }

  // for
  var sum = 0;
  for (var i = 1; i <= 5; i++) {
    sum += i;
  }
  print('for: сума 1..5 = $sum');

  // for-in
  final fruits = ['яблуко', 'груша', 'слива'];
  for (final fruit in fruits) {
    print('for-in: $fruit');
  }

  // while / do-while
  var n = 5;
  var factorial = 1;
  while (n > 1) {
    factorial *= n--;
  }
  print('while: 5! = $factorial');

  var attempts = 0;
  do {
    attempts++;
  } while (attempts < 3);
  print('do-while: виконано $attempts разів (мінімум 1)');

  // break / continue
  final odds = <int>[];
  for (var i = 1; i <= 10; i++) {
    if (i.isEven) {
      continue;
    }
    if (i > 7) {
      break;
    }
    odds.add(i);
  }
  print('continue/break: $odds');

  // мітка для виходу з вкладених циклів
  outer:
  for (var i = 1; i <= 3; i++) {
    for (var j = 1; j <= 3; j++) {
      if (i * j == 4) {
        print('labeled break: знайдено i=$i, j=$j');
        break outer;
      }
    }
  }

  // FizzBuzz
  final fizz = [
    for (var i = 1; i <= 15; i++)
      if (i % 15 == 0)
        'FizzBuzz'
      else if (i % 3 == 0)
        'Fizz'
      else if (i % 5 == 0)
        'Buzz'
        else
        '$i',
  ];
  print('FizzBuzz: ${fizz.join(' ')}');

  // Dart 3: pattern matching
  final Map<String, Object?> json = {'name': 'Олена', 'age': 20};
  if (json case {'name': String name, 'age': int age}) {
    print('if-case (pattern): $name, $age р.');
  }
  final [first, second, ...rest] = [1, 2, 3, 4, 5];
  print('Деструктуризація списку: first=$first, second=$second, rest=$rest');
}

// ---------------------------------------------------------------- Колекції
void demonstrateCollections() {
  _section('Колекції: List, Set, Map, Record');

  // List
  final numbers = <int>[5, 3, 8, 1];
  numbers.add(9);
  numbers.addAll([2, 7]);
  numbers.insert(0, 10);
  numbers.remove(8);
  numbers.removeAt(1);
  print('List після змін: $numbers');
  numbers.sort();
  print('sort: $numbers; reversed: ${numbers.reversed.toList()}');
  print('indexOf(9): ${numbers.indexOf(9)}; contains(100): '
      '${numbers.contains(100)}; sublist(1, 3): ${numbers.sublist(1, 3)}');

  final withIf = [1, 2, if (numbers.length > 3) 3];
  final withFor = [for (var i = 0; i < 3; i++) i * i];
  print('collection-if: $withIf; collection-for: $withFor; '
      'spread: ${[...withIf, ...withFor]}');

  final fixed = List<int>.unmodifiable([1, 2, 3]);
  try {
    fixed.add(4);
  } on UnsupportedError catch (e) {
    print('Незмінний список: ${e.runtimeType}');
  }

  // Set
  final a = {1, 2, 3, 4};
  final b = {3, 4, 5};
  a.add(2); // дублікат ігнорується
  print('Set a=$a; union=${a.union(b)}; intersection=${a.intersection(b)}; '
      'difference=${a.difference(b)}');
  print('Унікальні з списку: ${[1, 1, 2, 2, 3].toSet()}');

  // Map
  final grades = <String, int>{'Dart': 90, 'SQL': 75};
  grades['Git'] = 82;
  grades.putIfAbsent('SQL', () => 0); // вже є - не змінюється
  grades.update('Dart', (v) => v + 5);
  print('Map: $grades; keys=${grades.keys}; values=${grades.values}');
  print('containsKey("Git"): ${grades.containsKey('Git')}; '
      'remove("SQL"): ${grades.remove('SQL')}');
  grades.forEach((subject, grade) => print('  $subject -> $grade'));
  print('Інверсія мапи: ${{for (final e in grades.entries) e.value: e.key}}');

  // Record (Dart 3)
  (String, int) pair = ('Dart', 3);
  final (language, version) = pair;
  ({String name, int age}) person = (name: 'Олена', age: 20);
  print('Record: $pair -> $language/$version; named: ${person.name}, '
      '${person.age}');
}

// ---------------------------------------------------------------- Null safety
String? findUser(int id) => id == 1 ? 'Олена' : null;

String greet({required String name, String? title}) =>
    title == null ? 'Привіт, $name!' : 'Вітаю, $title $name!';

late final String _config;

void demonstrateNullSafety() {
  _section('Null safety');

  String? nickname = findUser(2); // null
  print('nullable: $nickname');
  print('?. -> ${nickname?.length}');
  print('?? -> ${nickname ?? 'немає значення'}');
  nickname ??= 'гість'; // присвоїти, лише якщо null
  print('??= -> $nickname');

  final user = findUser(1);
  if (user != null) {
    // type promotion: user тепер String
    print('promotion: ${user.toUpperCase()} (${user.length} літер)');
  }

  List<int>? maybeList = findUser(2)?.codeUnits;
  print('?[]: ${maybeList?[0]}; ?? []: ${maybeList ?? <int>[]}');

  _config = 'production'; // late final: одноразове відкладене присвоєння
  print('late final: $_config');

  late final String lazyValue = _expensive(); // обчислюється при першому зверненні
  print('late (lazy) ще не обчислено');
  print('late (lazy): $lazyValue');

  print(greet(name: 'Андрій'));
  print(greet(name: 'Ковальчук', title: 'професор'));

  String? nothing = findUser(99);
  try {
    print(nothing!.length); // ! кидає помилку для null
  } on Error catch (e) {
    print('Оператор ! на null -> ${e.runtimeType}');
  }
}

String _expensive() {
  print('  (виконується важке обчислення)');
  return 'результат';
}

// ---------------------------------------------------------------- Помилки
class ValidationException implements Exception {
  final String message;
  const ValidationException(this.message);

  @override
  String toString() => 'ValidationException: $message';
}

int parseAge(String input) {
  final age = int.tryParse(input);
  if (age == null) {
    throw FormatException('Це не число', input);
  }
  if (age < 0 || age > 150) {
    throw RangeError.range(age, 0, 150, 'age');
  }
  if (age < 16) {
    throw const ValidationException('Мінімальний вік - 16');
  }
  return age;
}

void _rethrowDemo() {
  try {
    parseAge('abc');
  } on FormatException {
    print('  залоговано помилку і прокидаємо далі (rethrow)');
    rethrow;
  }
}

void demonstrateErrorHandling() {
  _section('Обробка помилок');

  for (final input in ['25', 'abc', '200', '10']) {
    try {
      print('parseAge("$input") = ${parseAge(input)}');
    } on FormatException catch (e) {
      print('parseAge("$input"): FormatException - ${e.message}');
    } on RangeError catch (e) {
      print('parseAge("$input"): RangeError - ${e.message}');
    } on ValidationException catch (e) {
      print('parseAge("$input"): $e');
    } finally {
      print('  finally виконується завжди');
    }
  }

  try {
    _rethrowDemo();
  } catch (e) {
    print('Перехоплено після rethrow: ${e.runtimeType}');
  }

  final zero = int.parse('0');
  try {
    print(10 ~/ zero);
  } catch (e, stackTrace) {
    print('Ділення на нуль: ${e.runtimeType}; '
        'stackTrace доступний: ${stackTrace.toString().isNotEmpty}');
  }
}
