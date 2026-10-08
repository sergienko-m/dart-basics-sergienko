# dart-basics

Практична робота 4 «Основи мови Dart» (дисципліна «Програмування для мобільних платформ»).

Проєкт охоплює: синтаксис, змінні та типи, оператори, умови й цикли, функції
(параметри, замикання, стрілочна нотація), ООП (класи, конструктори,
успадкування, міксіни), null safety, обробку помилок, колекції та асинхронність.

## Встановлення Dart SDK (3.0.0 або новіший)

1. Завантажте SDK: <https://dart.dev/get-dart> (Windows: `choco install dart-sdk`,
   macOS: `brew tap dart-lang/dart && brew install dart`, Linux: інструкція на сайті).
2. Перевірте: `dart --version`
3. Редактор: VS Code + розширення **Dart**.

## Швидкий старт

```bash
git clone https://github.com/<ваш-логін>/dart-basics-<прізвище>.git
cd dart-basics-<прізвище>
dart pub get
```

## Запуск завдань

| Завдання | Команда | Що демонструє |
|---|---|---|
| 1. Змінні й типи | `dart run bin/task1_variables.dart` | типи, оператори, умови/цикли, колекції, null safety, помилки |
| 2. Функції | `dart run bin/task2_functions.dart` | параметри, замикання, map/where/fold, рекурсія, калькулятор, текстовий аналізатор |
| 3. ООП | `dart run bin/task3_classes.dart` | система університету: класи, наслідування, міксіни, CRUD |
| 4. Колекції | `dart run bin/task4_collections.dart` | List/Set/Map, аналіз `data/students.csv`, звіти в `output/` |
| 5. Async | `dart run bin/task5_async.dart` | Future, Stream, JSON-файли, Isolate, порівняння продуктивності |

Калькулятор з командного рядка:

```bash
dart run bin/task2_functions.dart "2 + 3 * (4 - 1) ^ 2"
```

## Якість коду

```bash
dart format .                                   # форматування
dart analyze                                    # статичний аналіз
dart test                                       # unit-тести
dart run coverage:test_with_coverage            # покриття -> coverage/lcov.info
dart doc                                        # API-документація -> doc/api
```

Звіт покриття у вигляді HTML (за наявності `lcov`): `genhtml coverage/lcov.info -o coverage/html`.

## Структура

```
bin/   task1..task5 - виконувані програми
lib/
  dart_basics.dart       публічний API пакета
  exceptions.dart        власні виключення
  mixins.dart            Describable, Loggable
  models/                Person, Student, Course, University (+Professor)
  utils/                 Calculator, DataProcessor, TextAnalyzer, sample_data
test/  models_test.dart, utils_test.dart
data/  students.csv      вхідні дані для завдання 4
docs/  UML.md            діаграма класів (Mermaid)
```

## Приклад використання класів

```dart
import 'package:dart_basics/dart_basics.dart';

void main() {
  final uni = University(name: 'Mobile Tech University');
  uni.addCourse(Course(id: 'CS101', name: 'Basics', description: 'Dart',
      credits: 5, instructor: 'Іваненко'));
  uni.addCourse(Course(id: 'CS201', name: 'OOP', description: 'Classes',
      credits: 5, instructor: 'Іваненко', prerequisites: ['CS101']));
  uni.addStudent(Student(id: 'S1', firstName: 'Олена', lastName: 'Коваль',
      birthDate: DateTime(2004, 3, 12)));

  uni.enrollStudent('S1', 'CS101');
  uni.findStudentById('S1')!.addGrade('CS101', 92);
  uni.enrollStudent('S1', 'CS201'); // дозволено: CS101 складено

  print(uni.generateStatistics());
}
```

## Модель оцінювання

Оцінки 0-100; курс складено при оцінці >= 60. GPA - середнє арифметичне оцінок.
Літерна шкала: A >= 90, B >= 82, C >= 74, D >= 64, E >= 60, F < 60.

## Автор

