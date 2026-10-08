import '../exceptions.dart';
import '../mixins.dart';
import 'person.dart';

/// Оцінка за національною шкалою (покращений enum з полями та методами).
enum LetterGrade {
  a('A', 90.0),
  b('B', 82.0),
  c('C', 74.0),
  d('D', 64.0),
  e('E', 60.0),
  f('F', 0.0);

  const LetterGrade(this.label, this.minScore);

  final String label;
  final double minScore;

  /// Значення йдуть від найвищого до найнижчого, тому перше підходяще - наше.
  static LetterGrade fromScore(double score) =>
      values.firstWhere((grade) => score >= grade.minScore);
}

class Student extends Person with Describable {
  static const double passingGrade = 60;
  static const double maxGrade = 100;

  final int enrollmentYear;
  final List<String> enrolledCourses;
  final Map<String, double> grades;
  final Set<String> skills;

  Student({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.birthDate,
    int? enrollmentYear,
    List<String>? enrolledCourses,
    Map<String, double>? grades,
    Set<String>? skills,
  })  : enrollmentYear = enrollmentYear ?? DateTime.now().year,
        enrolledCourses = enrolledCourses ?? <String>[],
        grades = grades ?? <String, double>{},
        skills = skills ?? <String>{};

  @override
  String get role => 'Student';

  /// Середній бал (за 100-бальною шкалою). Для порожніх оцінок - 0.
  double get gpa {
    if (grades.isEmpty) {
      return 0;
    }
    final total = grades.values.fold<double>(0, (sum, g) => sum + g);
    return total / grades.length;
  }

  LetterGrade get letterGrade => LetterGrade.fromScore(gpa);

  void enrollInCourse(String courseId) {
    if (enrolledCourses.contains(courseId)) {
      throw AlreadyEnrolledException(id, courseId);
    }
    enrolledCourses.add(courseId);
  }

  void addGrade(String courseId, double grade) {
    if (grade.isNaN || grade < 0 || grade > maxGrade) {
      throw InvalidGradeException(grade);
    }
    if (!enrolledCourses.contains(courseId)) {
      throw NotEnrolledException(id, courseId);
    }
    grades[courseId] = grade;
  }

  /// Курси, складені на оцінку >= 60.
  List<String> getPassedCourses() => grades.entries
      .where((entry) => entry.value >= passingGrade)
      .map((entry) => entry.key)
      .toList();

  @override
  String toString() => 'Student(id: $id, name: $fullName, '
      'courses: ${enrolledCourses.length}, '
      'gpa: ${gpa.toStringAsFixed(1)})';

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'birthDate': birthDate.toIso8601String(),
        'enrollmentYear': enrollmentYear,
        'enrolledCourses': List<String>.of(enrolledCourses),
        'grades': Map<String, double>.of(grades),
        'skills': skills.toList(),
      };

  factory Student.fromJson(Map<String, dynamic> json) {
    final rawGrades =
        (json['grades'] as Map<String, dynamic>?) ?? <String, dynamic>{};
    return Student(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      birthDate: DateTime.parse(json['birthDate'] as String),
      enrollmentYear: json['enrollmentYear'] as int?,
      enrolledCourses: List<String>.from(
          (json['enrolledCourses'] as List<dynamic>?) ?? const <dynamic>[]),
      grades: rawGrades
          .map((course, value) => MapEntry(course, (value as num).toDouble())),
      skills: Set<String>.from(
          (json['skills'] as List<dynamic>?) ?? const <dynamic>[]),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Student && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
