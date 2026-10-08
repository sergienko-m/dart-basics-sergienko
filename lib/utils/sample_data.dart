import 'dart:math' as math;

import '../models/student.dart';

/// Детермінована генерація студентів (однаковий seed - однакові дані).
List<Student> generateStudents(int count, {int seed = 42}) {
  final random = math.Random(seed);
  const firstNames = ['Олена', 'Андрій', 'Марія', 'Дмитро', 'Ірина', 'Сергій'];
  const lastNames = ['Коваленко', 'Шевченко', 'Бондаренко', 'Мельник', 'Ткаченко'];
  const courseIds = ['CS101', 'CS102', 'MA101', 'PH101', 'EN101'];
  const skillNames = ['Dart', 'Flutter', 'SQL', 'Git', 'Python', 'Java'];

  return List<Student>.generate(count, (i) {
    final enrolled = (List<String>.of(courseIds)..shuffle(random))
        .take(2 + random.nextInt(3))
        .toList();
    final skills = (List<String>.of(skillNames)..shuffle(random))
        .take(1 + random.nextInt(3))
        .toSet();
    return Student(
      id: 'S${(i + 1).toString().padLeft(4, '0')}',
      firstName: firstNames[random.nextInt(firstNames.length)],
      lastName: lastNames[random.nextInt(lastNames.length)],
      birthDate: DateTime(
          1999 + random.nextInt(6), 1 + random.nextInt(12), 1 + random.nextInt(28)),
      enrollmentYear: 2021 + random.nextInt(4),
      enrolledCourses: enrolled,
      grades: {for (final c in enrolled) c: (40 + random.nextInt(61)).toDouble()},
      skills: skills,
    );
  });
}
