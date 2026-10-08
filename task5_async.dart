// Завдання 5: асинхронне програмування (Future, Stream, файли, Isolate).
//
// Запуск з кореня проєкту:  dart run bin/task5_async.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:dart_basics/dart_basics.dart';

const _outputDir = 'output';

/// "База даних" для симуляції запитів до API.
final List<Student> _database = generateStudents(5);

void main() async {
  print('=== Dart Async Programming Demo ===');
  await demonstrateFutures();
  await demonstrateStreams();
  await demonstrateFileOperations();
}

/// Симуляція API-запиту: повертає JSON студента через 500 мс.
Future<String> fetchStudentData(String studentId) async {
  await Future.delayed(const Duration(milliseconds: 500));
  for (final student in _database) {
    if (student.id == studentId) {
      return jsonEncode(student.toJson());
    }
  }
  throw EntityNotFoundException('Student', studentId);
}

Future<List<Student>> loadStudentsFromFile(String filename) async {
  final file = File(filename);
  if (!await file.exists()) {
    throw FileSystemException('Файл не знайдено', filename);
  }
  final content = await file.readAsString();
  final decoded = jsonDecode(content) as List<dynamic>;
  return decoded
      .map((item) => Student.fromJson(item as Map<String, dynamic>))
      .toList();
}

Future<void> saveStudentsToFile(List<Student> students, String filename) async {
  final file = File(filename);
  await file.parent.create(recursive: true);
  const encoder = JsonEncoder.withIndent('  ');
  await file.writeAsString(
      encoder.convert(students.map((s) => s.toJson()).toList()));
}

/// Генератор потоку: студенти надходять із затримкою.
Stream<Student> studentStream() async* {
  for (final student in _database) {
    await Future.delayed(const Duration(milliseconds: 200));
    yield student;
  }
}

Future<void> demonstrateFutures() async {
  print('\n--- Futures ---');
  final ids = _database.map((s) => s.id).toList();

  // Послідовно vs паралельно
  var watch = Stopwatch()..start();
  final sequential = <String>[];
  for (final id in ids) {
    sequential.add(await fetchStudentData(id));
  }
  watch.stop();
  final sequentialMs = watch.elapsedMilliseconds;

  watch = Stopwatch()..start();
  final parallel = await Future.wait(ids.map(fetchStudentData));
  watch.stop();
  final parallelMs = watch.elapsedMilliseconds;
  print('Послідовно: ${sequential.length} запитів за $sequentialMs мс');
  print('Future.wait: ${parallel.length} запитів за $parallelMs мс '
      '(прискорення x${(sequentialMs / parallelMs).toStringAsFixed(1)})');

  // Обробка помилок: try/on/catch
  try {
    await fetchStudentData('S9999');
  } on EntityNotFoundException catch (e) {
    print('try/on: ${e.message}');
  }

  // catchError
  final fallback = await fetchStudentData('S9999')
      .catchError((Object error) => '{"error": "запасне значення"}');
  print('catchError: $fallback');

  // timeout
  try {
    await fetchStudentData('S0001').timeout(const Duration(milliseconds: 100));
  } on TimeoutException {
    print('timeout: запит перевищив 100 мс');
  }

  // then / whenComplete
  await fetchStudentData('S0002')
      .then((json) => Student.fromJson(jsonDecode(json) as Map<String, dynamic>))
      .then((student) => print('then: отримано ${student.fullName}'))
      .whenComplete(() => print('whenComplete: виконується завжди'));

  // Часткові помилки в Future.wait
  final results = await Future.wait(
    ['S0001', 'S9999', 'S0003'].map((id) async {
      try {
        await fetchStudentData(id);
        return '$id: OK';
      } on UniversityException catch (e) {
        return '$id: ${e.message}';
      }
    }),
  );
  print('Future.wait з обробкою помилок: $results');
}

Future<void> demonstrateStreams() async {
  print('\n--- Streams ---');

  print('await for:');
  await for (final student in studentStream().take(3)) {
    print('  отримано ${student.fullName} (GPA ${student.gpa.toStringAsFixed(1)})');
  }

  final selected = await studentStream()
      .where((s) => s.gpa >= 60)
      .map((s) => '${s.id}:${s.gpa.toStringAsFixed(0)}')
      .toList();
  print('where + map + toList: $selected');

  final done = Completer<void>();
  var received = 0;
  studentStream().take(2).listen(
    (student) => received++,
    onError: (Object e) => print('помилка потоку: $e'),
    onDone: () {
      print('listen: потік завершено, отримано $received елементи(ів)');
      done.complete();
    },
  );
  await done.future;

  final controller = StreamController<int>.broadcast();
  final first = controller.stream
      .map((n) => n * 2)
      .listen((v) => print('  підписник 1 (x2): $v'));
  final second = controller.stream
      .where((n) => n.isEven)
      .listen((v) => print('  підписник 2 (парні): $v'));
  for (var i = 1; i <= 4; i++) {
    controller.add(i);
  }
  await controller.close();
  await Future.wait([first.asFuture<void>(), second.asFuture<void>()]);

  final sum = await Stream.periodic(const Duration(milliseconds: 50), (i) => i + 1)
      .take(5)
      .fold<int>(0, (a, b) => a + b);
  print('Stream.periodic + fold (1+2+3+4+5): $sum');
}

Future<void> demonstrateFileOperations() async {
  print('\n--- Файлові операції ---');
  const path = '$_outputDir/students.json';
  final students = generateStudents(2000);

  var watch = Stopwatch()..start();
  await saveStudentsToFile(students, path);
  watch.stop();
  print('Записано ${students.length} студентів у $path '
      'за ${watch.elapsedMilliseconds} мс');

  watch = Stopwatch()..start();
  final loaded = await loadStudentsFromFile(path);
  watch.stop();
  print('Прочитано ${loaded.length} студентів за ${watch.elapsedMilliseconds} мс; '
      'перший: ${loaded.first}');

  // Помилки
  try {
    await loadStudentsFromFile('$_outputDir/missing.json');
  } on FileSystemException catch (e) {
    print('Відсутній файл: ${e.message}');
  }
  final broken = File('$_outputDir/broken.json');
  await broken.writeAsString('{ це не JSON');
  try {
    await loadStudentsFromFile(broken.path);
  } on FormatException catch (e) {
    print('Некоректний JSON: ${e.runtimeType}');
  } finally {
    await broken.delete();
  }

  // Потокове читання за рядками
  var lines = 0;
  await for (final _
      in File(path).openRead().transform(utf8.decoder).transform(const LineSplitter())) {
    lines++;
  }
  print('Потокове читання: $lines рядків у файлі');

  // Порівняння: синхронно vs асинхронно vs Isolate
  const runs = 5;
  watch = Stopwatch()..start();
  for (var i = 0; i < runs; i++) {
    jsonDecode(File(path).readAsStringSync());
  }
  watch.stop();
  final syncMs = watch.elapsedMilliseconds;

  watch = Stopwatch()..start();
  for (var i = 0; i < runs; i++) {
    jsonDecode(await File(path).readAsString());
  }
  watch.stop();
  final asyncMs = watch.elapsedMilliseconds;

  watch = Stopwatch()..start();
  for (var i = 0; i < runs; i++) {
    final content = await File(path).readAsString();
    await Isolate.run(() => jsonDecode(content) as List<dynamic>);
  }
  watch.stop();
  final isolateMs = watch.elapsedMilliseconds;

  print('Порівняння ($runs читань + розбір JSON):');
  print('  синхронно (readAsStringSync): $syncMs мс');
  print('  асинхронно (readAsString):    $asyncMs мс');
  print('  async + Isolate.run:          $isolateMs мс');

  // Обробка й збереження результату
  final top = ([...loaded]..sort((a, b) => b.gpa.compareTo(a.gpa))).take(5);
  final summary = {
    'total': loaded.length,
    'averageGpa': double.parse(
        (loaded.fold<double>(0, (s, st) => s + st.gpa) / loaded.length)
            .toStringAsFixed(2)),
    'top5': [for (final s in top) '${s.fullName} (${s.gpa.toStringAsFixed(1)})'],
  };
  await File('$_outputDir/async_summary.json')
      .writeAsString(const JsonEncoder.withIndent('  ').convert(summary));
  print('Підсумок збережено: $_outputDir/async_summary.json');
}
