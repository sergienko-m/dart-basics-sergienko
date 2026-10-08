// Завдання 3: система управління університетом (ООП).
import 'package:dart_basics/dart_basics.dart';

void main() {
  print('=== University Management System Demo ===');
  runUniversityDemo();
}

void _step(String title) => print('\n>>> $title');

/// Запускає дію й показує, як обробляються бізнес-помилки.
void _try(String description, void Function() action) {
  try {
    action();
    print('  OK: $description');
  } on UniversityException catch (e) {
    print('  ПОМИЛКА ($description): $e');
  }
}

void runUniversityDemo() {
  // 1. Університет
  _step('1. Створення університету');
  final university = University(name: 'Mobile Tech University');
  print('  ${university.name}');

  // 2. Викладачі та студенти
  _step('2. Викладачі та студенти');
  university.addProfessor(Professor(
    id: 'P1',
    firstName: 'Андрій',
    lastName: 'Іваненко',
    birthDate: DateTime(1975, 5, 14),
    department: "Комп'ютерні науки",
    salary: 32000,
  ));
  university.addProfessor(Professor(
    id: 'P2',
    firstName: 'Ірина',
    lastName: 'Мельник',
    birthDate: DateTime(1982, 9, 3),
    department: 'Математика',
    salary: 28000,
  ));

  final studentData = [
    ('S1', 'Олена', 'Коваль', DateTime(2004, 3, 12)),
    ('S2', 'Максим', 'Бондар', DateTime(2003, 7, 25)),
    ('S3', 'Марія', 'Шевчук', DateTime(2004, 11, 2)),
    ('S4', 'Дмитро', 'Лисенко', DateTime(2002, 1, 30)),
    ('S5', 'Софія', 'Гончар', DateTime(2005, 8, 21)),
    ('S6', 'Тарас', 'Руденко', DateTime(2003, 4, 4)),
  ];
  for (final (id, first, last, birth) in studentData) {
    university.addStudent(Student(
      id: id,
      firstName: first,
      lastName: last,
      birthDate: birth,
      enrollmentYear: 2023,
      skills: {'Dart'},
    ));
  }
  print('  Студентів: ${university.students.length}, '
      'викладачів: ${university.professors.length}');
  _try('додати дубль студента S1', () {
    university.addStudent(university.findStudentById('S1')!);
  });

  // 3. Курси
  _step('3. Курси з пререквізитами');
  university.addCourse(Course(
    id: 'CS101',
    name: 'Основи програмування',
    description: 'Вступ до Dart',
    credits: 5,
    instructor: 'Іваненко',
  ));
  university.addCourse(Course(
    id: 'MA101',
    name: 'Вища математика',
    description: 'Лінійна алгебра та аналіз',
    credits: 4,
    instructor: 'Мельник',
  ));
  university.addCourse(Course(
    id: 'CS201',
    name: 'ООП та структури даних',
    description: 'Класи, наслідування, колекції',
    credits: 5,
    instructor: 'Іваненко',
    prerequisites: ['CS101'],
  ));
  university.addCourse(Course(
    id: 'CS301',
    name: 'Розробка на Flutter',
    description: 'Мобільні застосунки',
    credits: 6,
    instructor: 'Іваненко',
    prerequisites: ['CS201', 'MA101'],
  ));
  university.assignProfessorToCourse('P1', 'CS101');
  university.assignProfessorToCourse('P1', 'CS201');
  university.assignProfessorToCourse('P1', 'CS301');
  university.assignProfessorToCourse('P2', 'MA101');
  for (final course in university.courses) {
    print('  $course; пререквізити: '
        '${course.hasPrerequisites() ? course.prerequisites : 'немає'}');
  }

  // 4. Запис на курси
  _step('4. Запис студентів на курси');
  for (final id in ['S1', 'S2', 'S3', 'S4']) {
    university.enrollStudent(id, 'CS101');
  }
  for (final id in ['S1', 'S2', 'S5']) {
    university.enrollStudent(id, 'MA101');
  }
  print('  Студенти CS101: '
      '${university.getStudentsByCourse('CS101').map((s) => s.fullName).join(', ')}');
  _try('S3 -> CS201 без складеного CS101',
      () => university.enrollStudent('S3', 'CS201'));
  _try('S1 повторно -> CS101', () => university.enrollStudent('S1', 'CS101'));
  _try('неіснуючий студент S99', () => university.enrollStudent('S99', 'CS101'));

  // 5. Оцінки
  _step('5. Виставлення оцінок');
  final grades = <(String, String, double)>[
    ('S1', 'CS101', 92),
    ('S2', 'CS101', 78),
    ('S3', 'CS101', 55),
    ('S4', 'CS101', 66),
    ('S1', 'MA101', 88),
    ('S2', 'MA101', 61),
    ('S5', 'MA101', 95),
  ];
  for (final (studentId, courseId, grade) in grades) {
    university.findStudentById(studentId)!.addGrade(courseId, grade);
  }
  _try('оцінка 105 для S1', () => university.findStudentById('S1')!.addGrade('CS101', 105));
  _try('оцінка для S6 з курсу, на який він не записаний',
      () => university.findStudentById('S6')!.addGrade('CS101', 70));

  // Тепер S1 і S2 склали CS101, тож можуть записатись на CS201
  _try('S1 -> CS201 (CS101 складено)',
      () => university.enrollStudent('S1', 'CS201'));
  _try('S2 -> CS201 (CS101 складено)',
      () => university.enrollStudent('S2', 'CS201'));
  _try('S3 -> CS201 (CS101 = 55, не складено)',
      () => university.enrollStudent('S3', 'CS201'));
  university.findStudentById('S1')!.addGrade('CS201', 90);
  _try('S1 -> CS301 (CS201 і MA101 складено)',
      () => university.enrollStudent('S1', 'CS301'));

  for (final student in university.students) {
    print('  $student; складено: ${student.getPassedCourses()}; '
        'оцінка: ${student.letterGrade.label}');
  }
  print('  Доступні курси для S1: '
      '${university.getAvailableCoursesForStudent('S1').map((c) => c.id).toList()}');
  print('  Доступні курси для S3: '
      '${university.getAvailableCoursesForStudent('S3').map((c) => c.id).toList()}');

  // 6. Статистика
  _step('6. Статистика університету');
  university.generateStatistics().forEach((key, value) {
    print('  $key: $value');
  });

  _step('6.1 Звіт по курсах (DataProcessor.generateReport)');
  for (final row in DataProcessor.generateReport(university)) {
    print('  $row');
  }

  // 7. Наслідування та поліморфізм
  _step('7. Поліморфізм: список Person');
  final people = <Person>[...university.professors, ...university.students.take(2)];
  for (final person in people) {
    // person is Describable - автоматичне приведення типу (type promotion)
    final description =
        person is Describable ? person.description : person.toString();
    print('  ${person.role.padRight(9)} | ${person.fullName.padRight(22)} | $description');
  }
  final professor = university.findProfessorById('P1')!;
  professor.raiseSalary(10);
  print('  Зарплата після підвищення на 10%: ${professor.salary}');

  // 8. CRUD + JSON + журнал
  _step('8. CRUD, JSON та журнал змін (mixin Loggable)');
  final found = university.findStudentById('S6');
  print('  Read: $found');
  final json = found!.toJson();
  print('  toJson: $json');
  final restored = Student.fromJson(json);
  print('  fromJson == оригінал: ${restored == found}');
  university.removeStudent('S6');
  print('  Delete: студентів залишилось ${university.students.length}');
  _try('видалити S6 повторно', () => university.removeStudent('S6'));
  print('  Останні записи журналу:');
  for (final entry in university.history.reversed.take(5).toList().reversed) {
    print('    - $entry');
  }
}
