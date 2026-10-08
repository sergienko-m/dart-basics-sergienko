// Завдання 4: колекції та аналіз даних із CSV.
//
// Запуск з кореня проєкту:  dart run bin/task4_collections.dart
import 'dart:convert';
import 'dart:io';

import 'package:dart_basics/dart_basics.dart';

const _csvPath = 'data/students.csv';
const _outputDir = 'output';

void main() {
  print('=== Dart Collections & Data Processing Demo ===');
  demonstrateLists();
  demonstrateSets();
  demonstrateMaps();
  demonstrateAdvancedOperations();
  runCsvAnalysis();
}

void _section(String title) => print('\n--- $title ---');

void demonstrateLists() {
  _section('Lists');
  final numbers = List<int>.generate(10, (i) => i + 1);
  print('Початковий: $numbers');
  print('Парні (DataProcessor.filterEvenNumbers): '
      '${DataProcessor.filterEvenNumbers(numbers)}');
  print('map (квадрати): ${numbers.map((n) => n * n).toList()}');
  print('where (> 7): ${numbers.where((n) => n > 7).toList()}');
  print('fold (сума): ${numbers.fold<int>(0, (a, b) => a + b)}');
  print('reduce (добуток перших 5): ${numbers.take(5).reduce((a, b) => a * b)}');
  print('firstWhere (>4): ${numbers.firstWhere((n) => n > 4)}; '
      'з orElse: ${numbers.firstWhere((n) => n > 100, orElse: () => -1)}');
  print('skip(7): ${numbers.skip(7).toList()}; '
      'indexWhere(>=6): ${numbers.indexWhere((n) => n >= 6)}');

  final words = ['flutter', 'dart', 'git', 'sql', 'kotlin'];
  final byLengthThenAlpha = List<String>.of(words)
    ..sort((a, b) {
      final byLength = a.length.compareTo(b.length);
      return byLength != 0 ? byLength : a.compareTo(b);
    });
  print('Сортування (довжина, потім алфавіт): $byLengthThenAlpha');
}

void demonstrateSets() {
  _section('Sets');
  final backend = {'Dart', 'SQL', 'Git', 'Python'};
  final mobile = {'Dart', 'Flutter', 'Git', 'Kotlin'};
  print('Union: ${backend.union(mobile)}');
  print('Intersection: ${backend.intersection(mobile)}');
  print('Difference (backend - mobile): ${backend.difference(mobile)}');
  print('containsAll({Dart, Git}): ${backend.containsAll({'Dart', 'Git'})}');
  print('Дублікати зникають: ${['a', 'b', 'a', 'c', 'b'].toSet()}');
}

void demonstrateMaps() {
  _section('Maps');
  final scores = <String, int>{'Dart': 92, 'Algorithms': 84, 'Databases': 91};
  print('Ключі: ${scores.keys.toList()}; значення: ${scores.values.toList()}');
  final top = Map<String, int>.fromEntries(
      scores.entries.where((e) => e.value >= 90));
  print('Оцінки 90+: $top');
  final plusTwo = scores.map((k, v) => MapEntry(k, v + 2));
  print('Перетворення +2: $plusTwo');

  final sortedKeys = scores.keys.toList()
    ..sort((a, b) => scores[b]!.compareTo(scores[a]!));
  print('Предмети за спаданням оцінки: $sortedKeys');

  final text = 'Dart is fun and Dart is fast';
  print('Частота слів: ${DataProcessor.countWords(text)}');
}

void demonstrateAdvancedOperations() {
  _section('Advanced operations');
  final nested = [
    [1, 2],
    [3, 4],
    [5, 6],
  ];
  print('Вкладений список: $nested -> ${nested.expand((l) => l).toList()}');

  final groups = <String, List<int>>{
    'A': [80, 90],
    'B': [70, 75],
  };
  print('Середні за групами: '
      '${groups.map((k, v) => MapEntry(k, v.reduce((a, b) => a + b) / v.length))}');

  final students = generateStudents(6);
  final ranking = DataProcessor.sortStudentsByGPA(students);
  print('Рейтинг (згенеровані студенти, seed=42):');
  for (final row in ranking.take(3)) {
    print('  $row');
  }
  final stats = DataProcessor.describe(students.map((s) => s.gpa).toList());
  print('Описова статистика GPA: min=${stats.min.toStringAsFixed(1)}, '
      'max=${stats.max.toStringAsFixed(1)}, mean=${stats.mean.toStringAsFixed(2)}, '
      'median=${stats.median.toStringAsFixed(1)}, '
      'stdDev=${stats.stdDev.toStringAsFixed(2)}');
}

void runCsvAnalysis() {
  _section('Аналіз CSV: $_csvPath');
  final file = File(_csvPath);
  if (!file.existsSync()) {
    print('Файл $_csvPath не знайдено. Запускайте з кореня проєкту: '
        'dart run bin/task4_collections.dart');
    return;
  }

  final students = DataProcessor.parseStudentsCsv(file.readAsStringSync());
  print('Прочитано студентів: ${students.length}');

  print('\nТоп-5 за GPA:');
  final ranking = DataProcessor.sortStudentsByGPA(students);
  for (var i = 0; i < 5 && i < ranking.length; i++) {
    final row = ranking[i];
    print('  ${i + 1}. ${row['name']} - ${row['gpa']}');
  }

  print('\nГрупування за курсом навчання (на 2026 рік):');
  final byYear =
      DataProcessor.groupStudentsByYear(students, now: DateTime(2026, 10, 1));
  for (final key in byYear.keys.toList()..sort()) {
    print('  $key: ${byYear[key]!.map((s) => s.lastName).join(', ')}');
  }

  final averages = DataProcessor.calculateAverageGradesByCourse(students);
  print('\nСередні оцінки за курсами:');
  for (final entry in averages.entries) {
    print('  ${entry.key.padRight(6)} ${entry.value.toStringAsFixed(2)}');
  }

  print('\nУнікальні навички: ${DataProcessor.getUniqueSkills(students)}');
  print('Спільні курси всіх студентів: '
      '${DataProcessor.findCommonCourses(students)}');

  final allGrades = [for (final s in students) ...s.grades.values];
  final stats = DataProcessor.describe(allGrades);
  print('\nОписова статистика всіх оцінок (${allGrades.length} шт.):');
  print('  min=${stats.min}, max=${stats.max}, '
      'mean=${stats.mean.toStringAsFixed(2)}, median=${stats.median}, '
      'stdDev=${stats.stdDev.toStringAsFixed(2)}');

  print('\nРозподіл оцінок (гістограма):');
  final distribution = DataProcessor.gradeDistribution(allGrades);
  distribution.forEach((letter, count) {
    print('  $letter | ${'█' * count} $count');
  });

  // Продуктивність
  print('\nПродуктивність (1 000 000 елементів):');
  final big = List<int>.generate(1000000, (i) => i);
  final watchWhere = Stopwatch()..start();
  final viaWhere = DataProcessor.filterEvenNumbers(big);
  watchWhere.stop();
  final watchLoop = Stopwatch()..start();
  final viaLoop = <int>[];
  for (final n in big) {
    if (n % 2 == 0) {
      viaLoop.add(n);
    }
  }
  watchLoop.stop();
  print('  where().toList(): ${watchWhere.elapsedMilliseconds} мс '
      '(${viaWhere.length} елементів)');
  print('  цикл for + add:   ${watchLoop.elapsedMilliseconds} мс '
      '(${viaLoop.length} елементів)');

  // Збереження результатів
  Directory(_outputDir).createSync(recursive: true);
  final report = {
    'totalStudents': students.length,
    'ranking': ranking,
    'averageGradesByCourse': {
      for (final e in averages.entries)
        e.key: double.parse(e.value.toStringAsFixed(2)),
    },
    'uniqueSkills': DataProcessor.getUniqueSkills(students).toList()..sort(),
    'commonCourses': DataProcessor.findCommonCourses(students).toList(),
    'gradeDistribution': distribution,
    'statistics': {
      'min': stats.min,
      'max': stats.max,
      'mean': double.parse(stats.mean.toStringAsFixed(2)),
      'median': stats.median,
      'stdDev': double.parse(stats.stdDev.toStringAsFixed(2)),
    },
  };
  File('$_outputDir/csv_report.json').writeAsStringSync(
      const JsonEncoder.withIndent('  ').convert(report));
  File('$_outputDir/ranking.csv').writeAsStringSync(
      'rank,name,gpa\n${[
    for (var i = 0; i < ranking.length; i++)
      '${i + 1},${ranking[i]['name']},${ranking[i]['gpa']}',
  ].join('\n')}\n');
  print('\nЗвіти збережено: $_outputDir/csv_report.json, $_outputDir/ranking.csv');
}
