import 'dart:math' as math;

import '../models/student.dart';
import '../models/university.dart';

/// Статистичні показники вибірки (запис - Dart 3 records).
typedef DescriptiveStats = ({
  double min,
  double max,
  double mean,
  double median,
  double stdDev,
});

/// Обробка даних: списки, множини, мапи та звіти.
class DataProcessor {
  const DataProcessor._();

  static final RegExp _wordPattern =
      RegExp(r"[\p{L}\p{N}]+(?:['ʼ’][\p{L}\p{N}]+)?", unicode: true);

  // ---------- Lists ----------

  static List<int> filterEvenNumbers(List<int> numbers) =>
      numbers.where((n) => n.isEven).toList();

  /// Слова в нижньому регістрі (працює з кирилицею).
  static List<String> extractWords(String text) => _wordPattern
      .allMatches(text)
      .map((m) => m.group(0)!.toLowerCase())
      .toList();

  static Map<String, int> countWords(String text) {
    final counts = <String, int>{};
    for (final word in extractWords(text)) {
      counts[word] = (counts[word] ?? 0) + 1;
    }
    return counts;
  }

  /// Студенти, відсортовані за GPA (від більшого до меншого).
  static List<Map<String, dynamic>> sortStudentsByGPA(List<Student> students) {
    final sorted = List<Student>.of(students)
      ..sort((a, b) => b.gpa.compareTo(a.gpa));
    return [
      for (final s in sorted)
        {
          'id': s.id,
          'name': s.fullName,
          'gpa': double.parse(s.gpa.toStringAsFixed(2)),
        },
    ];
  }

  // ---------- Sets ----------

  static Set<String> getUniqueSkills(List<Student> students) =>
      students.expand((s) => s.skills).toSet();

  /// Курси, на які записані ВСІ студенти (перетин множин).
  static Set<String> findCommonCourses(List<Student> students) {
    if (students.isEmpty) {
      return <String>{};
    }
    return students
        .map((s) => s.enrolledCourses.toSet())
        .reduce((a, b) => a.intersection(b));
  }

  // ---------- Maps ----------

  /// Групування за курсом навчання: "1 курс", "2 курс", ...
  static Map<String, List<Student>> groupStudentsByYear(
    List<Student> students, {
    DateTime? now,
  }) {
    final currentYear = (now ?? DateTime.now()).year;
    final groups = <String, List<Student>>{};
    for (final student in students) {
      final courseYear =
          math.max(1, currentYear - student.enrollmentYear + 1);
      groups.putIfAbsent('$courseYear курс', () => <Student>[]).add(student);
    }
    return groups;
  }

  static Map<String, double> calculateAverageGradesByCourse(
      List<Student> students) {
    final sums = <String, double>{};
    final counts = <String, int>{};
    for (final student in students) {
      student.grades.forEach((course, grade) {
        sums[course] = (sums[course] ?? 0) + grade;
        counts[course] = (counts[course] ?? 0) + 1;
      });
    }
    return {
      for (final entry in sums.entries)
        entry.key: entry.value / counts[entry.key]!,
    };
  }

  // ---------- Advanced ----------

  /// Звіт по кожному курсу університету.
  static List<Map<String, dynamic>> generateReport(University university) {
    return [
      for (final course in university.courses)
        () {
          final enrolled = university.getStudentsByCourse(course.id);
          final grades = enrolled
              .where((s) => s.grades.containsKey(course.id))
              .map((s) => s.grades[course.id]!)
              .toList();
          final passed =
              grades.where((g) => g >= Student.passingGrade).length;
          return <String, dynamic>{
            'courseId': course.id,
            'name': course.name,
            'instructor': course.instructor,
            'enrolled': enrolled.length,
            'graded': grades.length,
            'averageGrade': grades.isEmpty
                ? 0.0
                : double.parse(
                    (grades.reduce((a, b) => a + b) / grades.length)
                        .toStringAsFixed(2)),
            'passRatePercent': grades.isEmpty
                ? 0.0
                : double.parse((passed / grades.length * 100).toStringAsFixed(1)),
          };
        }(),
    ];
  }

  /// Описова статистика: min, max, середнє, медіана, стандартне відхилення.
  static DescriptiveStats describe(List<double> values) {
    if (values.isEmpty) {
      throw ArgumentError('Список не може бути порожнім');
    }
    final sorted = List<double>.of(values)..sort();
    final n = sorted.length;
    final mean = sorted.fold<double>(0, (sum, v) => sum + v) / n;
    final median = n.isOdd
        ? sorted[n ~/ 2]
        : (sorted[n ~/ 2 - 1] + sorted[n ~/ 2]) / 2;
    final variance =
        sorted.fold<double>(0, (sum, v) => sum + math.pow(v - mean, 2)) / n;
    return (
      min: sorted.first,
      max: sorted.last,
      mean: mean,
      median: median,
      stdDev: math.sqrt(variance),
    );
  }

  /// Розподіл оцінок за літерами A..F (порядок збережено).
  static Map<String, int> gradeDistribution(List<double> grades) {
    final result = <String, int>{
      for (final g in LetterGrade.values) g.label: 0,
    };
    for (final grade in grades) {
      final label = LetterGrade.fromScore(grade).label;
      result[label] = result[label]! + 1;
    }
    return result;
  }

  // ---------- CSV ----------

  static const String csvHeader =
      'id,firstName,lastName,birthDate,enrollmentYear,skills,courses,grades';

  static List<String> _splitList(String value) => value
      .split(';')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  /// Формат рядка: id,ім'я,прізвище,YYYY-MM-DD,рік,skills;..,courses;..,CS101:90;..
  static List<Student> parseStudentsCsv(String csv) {
    final lines = csv
        .split(RegExp(r'\r?\n'))
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();
    if (lines.length < 2) {
      return <Student>[];
    }
    final students = <Student>[];
    for (var i = 1; i < lines.length; i++) {
      final cols = lines[i].split(',');
      if (cols.length < 8) {
        throw FormatException(
            'Рядок $i: очікується 8 колонок, знайдено ${cols.length}',
            lines[i]);
      }
      final grades = <String, double>{};
      for (final pair in _splitList(cols[7])) {
        final kv = pair.split(':');
        if (kv.length != 2) {
          throw FormatException('Некоректна оцінка "$pair"', lines[i]);
        }
        grades[kv[0]] = double.parse(kv[1]);
      }
      students.add(Student(
        id: cols[0].trim(),
        firstName: cols[1].trim(),
        lastName: cols[2].trim(),
        birthDate: DateTime.parse(cols[3].trim()),
        enrollmentYear: int.parse(cols[4].trim()),
        skills: _splitList(cols[5]).toSet(),
        enrolledCourses: _splitList(cols[6]),
        grades: grades,
      ));
    }
    return students;
  }

  static String studentsToCsv(List<Student> students) {
    final buffer = StringBuffer(csvHeader)..writeln();
    for (final s in students) {
      final grades =
          s.grades.entries.map((e) => '${e.key}:${e.value}').join(';');
      buffer.writeln([
        s.id,
        s.firstName,
        s.lastName,
        s.birthDate.toIso8601String().substring(0, 10),
        s.enrollmentYear,
        s.skills.join(';'),
        s.enrolledCourses.join(';'),
        grades,
      ].join(','));
    }
    return buffer.toString();
  }
}
