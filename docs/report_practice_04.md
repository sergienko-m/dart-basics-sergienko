# Звіт з практичної роботи 4: Основи мови Dart

**Дисципліна:** Програмування для мобільних платформ
**Виконав:** <Сергієнко Максим>,
**Репозиторій:** https://github.com/<>/dart-basics-<Сергієнко>

> Примітка щодо ілюстрацій. У звіті наведено **схеми очікуваного виводу**. Значення в них отримані аналітично з коду та вхідних даних (`data/students.csv`), а не скопійовані з консолі. Позначки `<…>` означають значення, які залежать від запуску: час виконання, поточна дата, випадкові дані.

---

## 1. Мета роботи

Самостійно опанувати основи синтаксису Dart: змінні, типи, оператори, умови та цикли, функції (параметри, замикання, стрілочна нотація), ООП (класи, конструктори, успадкування, міксини), null safety, обробку помилок, колекції та асинхронність.

## 2. Середовище

| Компонент | Значення |
|---|---|
| Dart SDK | 3.0.0 або новіший (обмеження в `pubspec.yaml`: `sdk: ^3.0.0`) |
| Редактор | VS Code + розширення Dart |
| Керування версіями | Git, GitHub |
| Тести та якість | `dart test`, `dart analyze`, `dart format`, пакет `coverage` |

## 3. Структура проєкту

```
dart_basics/
├── README.md
├── pubspec.yaml
├── analysis_options.yaml
├── .gitignore
├── bin/
│   ├── task1_variables.dart     змінні, типи, керування, null safety, помилки
│   ├── task2_functions.dart     функції, замикання, калькулятор, аналізатор тексту
│   ├── task3_classes.dart       система університету (ООП)
│   ├── task4_collections.dart   колекції та аналіз CSV
│   └── task5_async.dart         Future, Stream, файли, Isolate
├── lib/
│   ├── dart_basics.dart         публічний API пакета
│   ├── exceptions.dart          власні виключення
│   ├── mixins.dart              Describable, Loggable
│   ├── models/                  person, student, course, university (+Professor)
│   └── utils/                   calculator, data_processor, text_analyzer, sample_data
├── test/                        models_test.dart, utils_test.dart
├── data/students.csv            вхідні дані (12 студентів)
└── docs/UML.md                  діаграма класів
```

---

## 4. Завдання 1. Налаштування проєкту та основи синтаксису

Створено пакет `dart_basics`, налаштовано `pubspec.yaml` (залежності `test`, `lints`, `coverage`), `analysis_options.yaml` (правила `package:lints/recommended.yaml`) і `.gitignore` для Dart (`.dart_tool/`, `coverage/`, `output/`).

### Програма `task1_variables.dart`

Розділи програми та конструкції Dart, які в них показані:

| Розділ | Що демонструється |
|---|---|
| Числа | `int`, `double`, `num`; `+ - * / ~/ %`; `++`, `+=`; бітові оператори; `int.parse`, `tryParse`, `round`, `toStringAsFixed`; особливості `double` (`0.1 + 0.2`) |
| Рядки | інтерполяція `$x` / `${…}`, багаторядкові та raw-рядки, escape-послідовності, методи `trim`, `split`, `replaceAll`, `padLeft`, `StringBuffer` |
| Булеві значення | порівняння, `&& || !`, коротке замикання, тернарний оператор, `is`, `is!`, `as` |
| Керуючі конструкції | `if / else if / else`, `switch` (оператор і вираз), `for`, `for-in`, `while`, `do-while`, `break`, `continue`, мітки, pattern matching (`if-case`, деструктуризація) |
| Колекції | `List`, `Set`, `Map`, `Record`; collection-if, collection-for, spread; незмінні списки |
| Null safety | `String?`, `?.`, `??`, `??=`, `!`, type promotion, `late`, `late final`, `required` |
| Помилки | `try / on / catch / finally`, `throw`, `rethrow`, власний `ValidationException`, `FormatException`, `RangeError` |

**Схема очікуваного виводу (фрагменти, перевірені за кодом):**

```
=== Dart Variables & Types Demo ===

--- Числа: int, double, num ---
a=17 (int), b=4.5 (double), c=10 (int)
після зміни c=2.5 (double)
a / 4 = 4.25 (завжди double)
a ~/ 4 = 4 (цілочисельне ділення)
a % 4 = 1; -a % 4 = 3
Інкремент і складені присвоєння: counter = 12
0.1 + 0.2 = 0.30000000000000004; порівняння з допуском: true

--- Керуючі конструкції ---
switch-вираз: 95 -> Відмінно / 80 -> Добре / 61 -> Задовільно / 30 -> Незадовільно
continue/break: [1, 3, 5, 7]
labeled break: знайдено i=2, j=2
FizzBuzz: 1 2 Fizz 4 Buzz Fizz 7 8 Fizz Buzz 11 Fizz 13 14 FizzBuzz

--- Null safety ---
nullable: null
?? -> немає значення
??= -> гість
late (lazy) ще не обчислено
  (виконується важке обчислення)
late (lazy): результат

--- Обробка помилок ---
parseAge("abc"): FormatException - Це не число
parseAge("10"): ValidationException: Мінімальний вік - 16
```

---

## 5. Завдання 2. Функції

### Реалізовані функції (`task2_functions.dart`)

| Категорія | Функції |
|---|---|
| Звичайні | `calculateSum`, `calculateAverage` (кидає `ArgumentError` для порожнього списку) |
| Параметри | `formatName` (іменовані `middleName`, `uppercase`), `greet` (позиційний необов'язковий) |
| Рекурсія | `fibonacci`, `factorial` (до 20, інакше `ArgumentError`), `factorialBig` (`BigInt`), `fibonacciMemo` (з кешем), `gcd` |
| Замикання | `makeCounter`, `makeMultiplier`, `compose<T>`, `memoize<A, R>`, `applyTwice` |
| Функціональний стиль | `map`, `where`, `fold`, `reduce`, `any`, `every`, `expand`, tear-off (`forEach(print)`), `typedef Predicate<T>` |
| Розширення | `extension StringCapitalize on String` |

### Калькулятор (`lib/utils/calculator.dart`)

Клас `Calculator` містить `add`, `subtract`, `multiply`, `divide`, `modulo`, `power`, `squareRoot`, `percentOf`, `average` і метод `evaluate(String)`. Метод `evaluate` реалізований рекурсивним низхідним парсером і підтримує `+ - * / ^`, дужки та унарний мінус. Пріоритети: `+ -` нижчі за `* /`, унарний мінус нижчий за `^`, а `^` має праву асоціативність. Помилки (ділення на нуль, невідповідні дужки, невідомі символи) повертаються як `CalculatorException`.

### Текстовий аналізатор (`lib/utils/text_analyzer.dart`)

`TextAnalyzer.analyze` повертає кількість символів (з пробілами та без), слів, унікальних слів, речень, рядків, середню довжину слова, найдовше слово та топ-N слів. Слова розпізнаються регулярним виразом з Unicode-класами `\p{L}`, тому кирилиця обробляється коректно.

**Схема очікуваного виводу:**

```
--- Базові функції ---
  [OK] calculateSum(7, 5) = 12
  [OK] calculateAverage([4, 6, 8]) = 6.0
  Порожній список -> ArgumentError: Список не може бути порожнім
  Олена Коваль
  Олена Іванівна Коваль
  ОЛЕНА КОВАЛЬ
  Привіт, Андрій! | Вітаю, Андрій!
  [OK] fibonacci(10) = 55
  [OK] factorial(5) = 120
  [OK] factorial(20) = 2432902008176640000
  factorialBig(25) = 15511210043330985984000000
  fibonacciMemo(90) = 2880067194370816120
  [OK] gcd(48, 18) = 6
  Наївний fibonacci(30): <t1> мкс; мемоізований fibonacciMemo(300): <t2> мкс   (t2 << t1)

--- Замикання та функції вищого порядку ---
  counterA: 1, 2, 3; counterB: 1 (незалежний лічильник)
  makeMultiplier(3)(7) = 21.0
  compose(add1, square)(5) = 26
  applyTwice(square, 3) = 81
  memoize: 3 виклики, реальних обчислень: 1
  замикання захопило i=0 / i=1 / i=2

--- map / where / fold / reduce ---
  where(even): [2, 4, 6]
  map(x*x): [1, 4, 9, 16, 25, 36]
  where(even).map(*2): [4, 8, 12]
  fold(0, +): 21; reduce(max): 6
  any(>3): true; every(>3): false
  expand: [1, 10, 2, 20, 3, 30]

--- Калькулятор ---
  add(7, 5) = 12.0 ; subtract = 2.0 ; multiply = 35.0 ; divide(18, 4) = 4.5
  modulo(18, 4) = 2.0 ; power(2, 10) = 1024.0 ; squareRoot(144) = 12.0 ; percentOf(15, 200) = 30.0
  2 + 3 * 4 = 14.0
  (2 + 3) * 4 = 20.0
  2 ^ 3 ^ 2 = 512.0
  -2 ^ 2 = -4.0
  10 / 4 - 1.5 = 1.0
  1 / 0 -> Ділення на нуль
  2 + * 3 -> Очікувалось число на позиції 5, знайдено "*"
  (1 + 2 -> Відсутня закриваюча дужка

--- Текстовий аналізатор ---
  Слів: 15; унікальних: 13; речень: 4; рядків: 2; топ-слово: dart x3
```

---

## 6. Завдання 3. ООП: система управління університетом

### Модель класів

```
            Person (abstract) ──────────── mixin Describable (on Person)
             ▲          ▲
             │          │
          Student    Professor
             │
   LetterGrade (enum)

University (with Loggable) ◇── Student*, Professor*, Course*
Course ─ перевіряє пререквізити Student

UniversityException
 ├─ InvalidGradeException
 ├─ AlreadyEnrolledException
 ├─ NotEnrolledException
 ├─ DuplicateEntityException
 ├─ EntityNotFoundException
 └─ PrerequisitesNotMetException
```

Повна діаграма у форматі Mermaid знаходиться в `docs/UML.md`.

### Застосовані принципи ООП

| Принцип | Де реалізовано |
|---|---|
| Інкапсуляція | `Professor._salary` змінюється лише через `raiseSalary` (з валідацією); `Loggable._log` доступний тільки як незмінний `history` |
| Успадкування | `Student` і `Professor` наслідують `Person`; винятки наслідують `UniversityException` |
| Поліморфізм | `Professor` перевизначає `fullName` (`"Prof. …"`); список `List<Person>` обробляється однаково, а `role` повертає різні значення |
| Абстракція | `Person` з абстрактним `role` |
| Міксини | `Describable on Person` додає `description`; `Loggable` додає журнал подій до `University` |
| Конструктори | іменовані параметри, `required`, super-параметри, списки ініціалізації, `factory Student.fromJson` |
| Enum з логікою | `LetterGrade` (поля, конструктор, `fromScore`) |

### Бізнес-логіка

* Курс вважається складеним при оцінці ≥ 60; GPA рівний середній оцінці за 100-бальною шкалою.
* `Course.canStudentEnroll` повертає `true`, якщо студент ще не записаний і склав усі пререквізити.
* `University.enrollStudent` кидає `PrerequisitesNotMetException` зі списком відсутніх пререквізитів.
* CRUD: `addStudent`, `findStudentById`, `updateStudent`, `removeStudent` (аналогічно для курсів і викладачів); дублікати та відсутні сутності породжують власні виключення.

### Сценарій демонстрації (`task3_classes.dart`)

1. Створюється університет «Mobile Tech University».
2. Додаються 2 викладачі та 6 студентів.
3. Створюються курси: CS101, MA101, CS201 (потребує CS101), CS301 (потребує CS201 та MA101).
4. Студентів записують на курси; спроби запису без пререквізитів, повторний запис і запис неіснуючого студента показують обробку помилок.
5. Виставляються оцінки; некоректна оцінка (105) та оцінка за курс, на який студент не записаний, відхиляються.
6. Виводиться статистика та звіт по курсах, демонструється поліморфізм, JSON-серіалізація, видалення та журнал змін.

**Схема очікуваного виводу (значення, що залежать від дати, пропущено):**

```
>>> 4. Запис студентів на курси
  ПОМИЛКА (S3 -> CS201 без складеного CS101): PrerequisitesNotMetException: Для курсу CS201 не виконано пререквізити: CS101
  ПОМИЛКА (S1 повторно -> CS101): AlreadyEnrolledException: Студент S1 вже записаний на курс CS101
  ПОМИЛКА (неіснуючий студент S99): EntityNotFoundException: Student з id "S99" не знайдено

>>> 5. Виставлення оцінок
  ПОМИЛКА (оцінка 105 для S1): InvalidGradeException: Оцінка має бути в діапазоні 0..100, отримано 105.0
  OK: S1 -> CS201 (CS101 складено)
  OK: S2 -> CS201 (CS101 складено)
  ПОМИЛКА (S3 -> CS201 (CS101 = 55, не складено)): PrerequisitesNotMetException: ...
  OK: S1 -> CS301 (CS201 і MA101 складено)
  Доступні курси для S1: []
  Доступні курси для S3: [MA101]

>>> 6. Статистика університету
  totalStudents: 6
  totalProfessors: 2
  totalCourses: 4
  totalCredits: 20
  averageGpa: 75.1
  topStudent: Софія Гончар
  enrollmentsPerCourse: {CS101: 4, MA101: 3, CS201: 2, CS301: 1}
  payrollBudget: 60000.0
  (averageStudentAge залежить від поточної дати)

>>> 7. Поліморфізм
  Professor | Prof. Андрій Іваненко | [Professor] Prof. Андрій Іваненко, <вік> р., id=P1
  Student   | Олена Коваль          | [Student] Олена Коваль, <вік> р., id=S1
  Зарплата після підвищення на 10%: 35200.0

>>> 8. CRUD, JSON та журнал змін
  fromJson == оригінал: true
  Delete: студентів залишилось 5
  ПОМИЛКА (видалити S6 повторно): EntityNotFoundException: Student з id "S6" не знайдено
```

---

## 7. Завдання 4. Колекції та аналіз даних

### Клас `DataProcessor`

| Група | Методи |
|---|---|
| Списки | `filterEvenNumbers`, `countWords`, `sortStudentsByGPA`, `extractWords` |
| Множини | `getUniqueSkills` (об'єднання), `findCommonCourses` (перетин) |
| Мапи | `groupStudentsByYear`, `calculateAverageGradesByCourse` |
| Складні операції | `generateReport(University)`, `describe` (min, max, середнє, медіана, стандартне відхилення; повертає record), `gradeDistribution` |
| CSV | `parseStudentsCsv`, `studentsToCsv` |

### Вхідні дані

`data/students.csv` містить 12 студентів. Формат рядка: `id,firstName,lastName,birthDate,enrollmentYear,skills;…,courses;…,course:grade;…`.

### Очікувані результати аналізу (обчислено за CSV)

Топ-5 за GPA:

| № | Студент | GPA |
|---|---|---|
| 1 | Софія Гончаренко | 94.5 |
| 2 | Анна Поліщук | 89.67 |
| 3 | Ірина Ткаченко | 89.33 |
| 4 | Наталія Олійник | 87.0 |
| 5 | Олена Коваленко | 86.33 |

Середні оцінки за курсами: CS101 ≈ 76.92, MA101 ≈ 71.29, CS201 = 75.2, EN101 ≈ 84.17, PH101 = 72.2.
Унікальні навички: Dart, Git, Flutter, SQL, Python, Java. Спільний курс усіх студентів: `{CS101}`. Усього оцінок: 35.
Групування за роком вступу (на жовтень 2026): 6 курс (2021), 5 курс (2022), 4 курс (2023), 3 курс (2024).

**Схема гістограми розподілу оцінок** (літери A-F, кількість у `█`; точні числа дає програма):

```
A | ████  ...
B | ████  ...
...
F | ██    ...
```

Також програма вимірює час `where().toList()` проти циклу `for` на 1 000 000 елементів (значення залежать від комп'ютера) і зберігає результати у файли:

* `output/csv_report.json` (рейтинг, середні за курсами, навички, розподіл, статистика);
* `output/ranking.csv` (`rank,name,gpa`).

---

## 8. Завдання 5. Асинхронне програмування

| Тема | Реалізація в `task5_async.dart` |
|---|---|
| `Future` | `fetchStudentData` (затримка 500 мс), `Future.wait`, `then`, `catchError`, `whenComplete`, `timeout` (`TimeoutException`) |
| Помилки | `try / on EntityNotFoundException`, часткові помилки в `Future.wait` |
| `Stream` | генератор `async*` (`studentStream`), `await for`, `where / map / take / toList`, `listen(onDone)`, `StreamController.broadcast`, `Stream.periodic` + `fold` |
| Файли | `saveStudentsToFile`, `loadStudentsFromFile` (JSON), обробка `FileSystemException` і `FormatException`, потокове читання за рядками (`openRead`, `LineSplitter`) |
| Продуктивність | послідовні запити проти `Future.wait`; синхронне читання проти асинхронного й проти `Isolate.run` |

**Схема очікуваного виводу:**

```
--- Futures ---
Послідовно: 5 запитів за ≈2500 мс
Future.wait: 5 запитів за ≈500 мс (прискорення ≈ x5.0)
try/on: Student з id "S9999" не знайдено
catchError: {"error": "запасне значення"}
timeout: запит перевищив 100 мс
then: отримано <ім'я>
whenComplete: виконується завжди
Future.wait з обробкою помилок: [S0001: OK, S9999: Student з id "S9999" не знайдено, S0003: OK]

--- Streams ---
await for: (3 студенти з інтервалом ≈200 мс)
listen: потік завершено, отримано 2 елементи(ів)
Stream.periodic + fold (1+2+3+4+5): 15

--- Файлові операції ---
Записано 2000 студентів у output/students.json за <t> мс
Відсутній файл: Файл не знайдено
Некоректний JSON: FormatException
Порівняння (5 читань + розбір JSON): синхронно <t1> мс | асинхронно <t2> мс | Isolate.run <t3> мс
```

Висновок про продуктивність: паралельний `Future.wait` скорочує загальний час до часу найповільнішого запиту; для читання одного локального файлу синхронний і асинхронний варіанти дають близький час, а `Isolate.run` виграє лише коли розбір JSON блокує головний потік достатньо довго.

---

## 9. Тестування та якість коду

Тести (`dart test`) охоплюють:

* **models_test.dart:** `fullName`, обчислення віку (`ageOn`), GPA і літерна оцінка, валідація оцінок, дублікат запису, межа 60 у `getPassedCourses`, JSON туди й назад, пререквізити курсу, поліморфізм `Professor`, CRUD університету, перевірка пререквізитів при записі, статистика, журнал `Loggable`.
* **utils_test.dart:** операції калькулятора, пріоритети та помилки `evaluate`, `DataProcessor` (списки, множини, мапи, `describe`, `gradeDistribution`, CSV-розбір і зворотне перетворення, `generateReport`), `TextAnalyzer`, детермінованість `generateStudents`.

**Схема очікуваного підсумку:** `All tests passed!`

Додаткові команди якості:

| Команда | Призначення |
|---|---|
| `dart format .` | форматування за стилем Dart |
| `dart analyze` | статичний аналіз (очікується `No issues found!`) |
| `dart run coverage:test_with_coverage` | звіт покриття `coverage/lcov.info` |
| `dart doc` | API-документація (`doc/api`) |

---

## 10. Git та GitHub

Репозиторій: `dart-basics-<прізвище>`, публічний. Рекомендований перелік комітів (мінімум 15), що відображає послідовну розробку:

1. `chore: init Dart project, pubspec, gitignore`
2. `chore: add analysis_options`
3. `feat: add custom exceptions`
4. `feat: add Person base class`
5. `feat: add Student model with JSON`
6. `feat: add Course with prerequisites`
7. `feat: add mixins Describable and Loggable`
8. `feat: add Professor and University`
9. `feat: add Calculator with expression parser`
10. `feat: add DataProcessor`
11. `feat: add TextAnalyzer and sample data generator`
12. `feat: add task1 variables demo`
13. `feat: add task2 functions demo`
14. `feat: add task3 university demo`
15. `feat: add task4 collections demo and students.csv`
16. `feat: add task5 async demo`
17. `test: add models and utils tests`
18. `docs: add README and UML`

---

## 11. Відповідність критеріям оцінювання

| Завдання | Бали | Що виконано |
|---|---|---|
| 1. Проєкт і синтаксис | 1 | структура bin/lib/test, README, pubspec, .gitignore, демонстрація типів і конструкцій |
| 2. Змінні й функції | 1 | усі типи функцій, замикання, функціональний стиль, калькулятор, аналізатор тексту |
| 3. ООП | 1.5 | наслідування, поліморфізм, інкапсуляція, міксини, CRUD, бізнес-логіка, власні виключення |
| 4. Колекції | 1 | List/Set/Map, групування, статистика, CSV-аналіз, звіти |
| 5. Async | 0.5 | Future, Stream, файли JSON, помилки, порівняння продуктивності |
| Бонуси | до 1.5 | Dart 3 (records, patterns, enhanced enum, sealed-подібні ієрархії винятків), оптимізація (мемоізація, Isolate), тести та coverage |

## 12. Висновки

У роботі створено повний Dart-проєкт: від базового синтаксису до системи управління університетом з наслідуванням, міксинами, перевіркою бізнес-правил і власними виключеннями. Реалізовано обробку даних у функціональному стилі, аналіз CSV зі звітами, асинхронні операції з файлами та unit-тести. Отримано практичні навички проєктування структури пакета, документування й перевірки якості коду.

---

### Контрольний список перед здачею

* [ ] `dart pub get`, `dart analyze`, `dart test` виконуються без помилок
* [ ] У README і звіті вказано прізвище та групу
* [ ] Репозиторій публічний, комітів не менше 15
* [ ] Прочитано код завдань 3 і 5 і зрозуміло, як вони працюють (на захисті буде live coding)
