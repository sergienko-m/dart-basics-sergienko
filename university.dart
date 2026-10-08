import '../exceptions.dart';
import '../mixins.dart';
import 'course.dart';
import 'person.dart';
import 'student.dart';

export 'person.dart';

/// Викладач: приклад успадкування та поліморфізму.
class Professor extends Person with Describable {
  final String department;
  final List<String> taughtCourses;
  double _salary;

  Professor({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.birthDate,
    required this.department,
    required double salary,
    List<String>? taughtCourses,
  })  : _salary = salary,
        taughtCourses = taughtCourses ?? <String>[];

  double get salary => _salary;

  @override
  String get role => 'Professor';

  /// Поліморфізм: перевизначаємо поведінку базового класу.
  @override
  String get fullName => 'Prof. ${super.fullName}';

  void assignCourse(String courseId) {
    if (!taughtCourses.contains(courseId)) {
      taughtCourses.add(courseId);
    }
  }

  void raiseSalary(double percent) {
    if (percent <= 0) {
      throw ArgumentError.value(percent, 'percent', 'має бути додатним');
    }
    _salary += _salary * percent / 100;
  }
}

double _round2(double value) => (value * 100).roundToDouble() / 100;

/// Університет: контейнер і CRUD-операції. Mixin [Loggable] веде журнал.
class University with Loggable {
  final String name;
  final List<Student> students;
  final List<Professor> professors;
  final List<Course> courses;

  University({
    required this.name,
    List<Student>? students,
    List<Professor>? professors,
    List<Course>? courses,
  })  : students = students ?? <Student>[],
        professors = professors ?? <Professor>[],
        courses = courses ?? <Course>[];

  // ---------- Студенти (CRUD) ----------

  void addStudent(Student student) {
    if (findStudentById(student.id) != null) {
      throw DuplicateEntityException('Student', student.id);
    }
    students.add(student);
    log('Додано студента ${student.id}');
  }

  void removeStudent(String studentId) {
    final index = students.indexWhere((s) => s.id == studentId);
    if (index == -1) {
      throw EntityNotFoundException('Student', studentId);
    }
    students.removeAt(index);
    log('Видалено студента $studentId');
  }

  Student? findStudentById(String id) {
    for (final student in students) {
      if (student.id == id) {
        return student;
      }
    }
    return null;
  }

  void updateStudent(Student updated) {
    final index = students.indexWhere((s) => s.id == updated.id);
    if (index == -1) {
      throw EntityNotFoundException('Student', updated.id);
    }
    students[index] = updated;
    log('Оновлено студента ${updated.id}');
  }

  // ---------- Викладачі та курси ----------

  void addProfessor(Professor professor) {
    if (findProfessorById(professor.id) != null) {
      throw DuplicateEntityException('Professor', professor.id);
    }
    professors.add(professor);
    log('Додано викладача ${professor.id}');
  }

  Professor? findProfessorById(String id) {
    for (final professor in professors) {
      if (professor.id == id) {
        return professor;
      }
    }
    return null;
  }

  void addCourse(Course course) {
    if (findCourseById(course.id) != null) {
      throw DuplicateEntityException('Course', course.id);
    }
    courses.add(course);
    log('Додано курс ${course.id}');
  }

  Course? findCourseById(String id) {
    for (final course in courses) {
      if (course.id == id) {
        return course;
      }
    }
    return null;
  }

  void assignProfessorToCourse(String professorId, String courseId) {
    final professor = findProfessorById(professorId);
    if (professor == null) {
      throw EntityNotFoundException('Professor', professorId);
    }
    if (findCourseById(courseId) == null) {
      throw EntityNotFoundException('Course', courseId);
    }
    professor.assignCourse(courseId);
    log('Викладач $professorId веде курс $courseId');
  }

  // ---------- Бізнес-логіка ----------

  /// Записує студента на курс з перевіркою пререквізитів.
  void enrollStudent(String studentId, String courseId) {
    final student = findStudentById(studentId);
    if (student == null) {
      throw EntityNotFoundException('Student', studentId);
    }
    final course = findCourseById(courseId);
    if (course == null) {
      throw EntityNotFoundException('Course', courseId);
    }
    final missing = course.missingPrerequisites(student);
    if (missing.isNotEmpty) {
      throw PrerequisitesNotMetException(courseId, missing);
    }
    student.enrollInCourse(courseId);
    log('Студент $studentId записаний на $courseId');
  }

  List<Student> getStudentsByCourse(String courseId) =>
      students.where((s) => s.enrolledCourses.contains(courseId)).toList();

  List<Course> getAvailableCoursesForStudent(String studentId) {
    final student = findStudentById(studentId);
    if (student == null) {
      throw EntityNotFoundException('Student', studentId);
    }
    return courses.where((c) => c.canStudentEnroll(student)).toList();
  }

  Map<String, dynamic> generateStatistics() {
    final graded = students.where((s) => s.grades.isNotEmpty).toList();
    final averageGpa = graded.isEmpty
        ? 0.0
        : graded.fold<double>(0, (sum, s) => sum + s.gpa) / graded.length;
    final averageAge = students.isEmpty
        ? 0.0
        : students.fold<int>(0, (sum, s) => sum + s.age) / students.length;

    Student? top;
    for (final student in graded) {
      if (top == null || student.gpa > top.gpa) {
        top = student;
      }
    }

    return {
      'university': name,
      'totalStudents': students.length,
      'totalProfessors': professors.length,
      'totalCourses': courses.length,
      'totalCredits': courses.fold<int>(0, (sum, c) => sum + c.credits),
      'averageGpa': _round2(averageGpa),
      'averageStudentAge': _round2(averageAge),
      'topStudent': top?.fullName,
      'enrollmentsPerCourse': {
        for (final course in courses)
          course.id: getStudentsByCourse(course.id).length,
      },
      'payrollBudget':
          professors.fold<double>(0, (sum, p) => sum + p.salary),
    };
  }
}
