import 'student.dart';

class Course {
  final String id;
  final String name;
  final String description;
  final int credits;
  final String instructor;
  final List<String> prerequisites;

  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.credits,
    required this.instructor,
    List<String>? prerequisites,
  })  : assert(credits > 0, 'Кількість кредитів має бути додатною'),
        prerequisites = prerequisites ?? <String>[];

  bool hasPrerequisites() => prerequisites.isNotEmpty;

  /// Пререквізити, які студент ще НЕ склав.
  List<String> missingPrerequisites(Student student) {
    final passed = student.getPassedCourses().toSet();
    return prerequisites.where((id) => !passed.contains(id)).toList();
  }

  /// Студент може записатись, якщо ще не записаний і склав усі пререквізити.
  bool canStudentEnroll(Student student) =>
      !student.enrolledCourses.contains(id) &&
      missingPrerequisites(student).isEmpty;

  @override
  String toString() => 'Course($id: $name, $credits кредитів, '
      'викладач: $instructor)';

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'credits': credits,
        'instructor': instructor,
        'prerequisites': List<String>.of(prerequisites),
      };
}
