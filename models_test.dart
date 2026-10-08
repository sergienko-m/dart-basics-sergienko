import 'package:dart_basics/dart_basics.dart';
import 'package:test/test.dart';

Student makeStudent(String id, {int year = 2023}) => Student(
      id: id,
      firstName: 'Олена',
      lastName: 'Коваль',
      birthDate: DateTime(2000, 6, 15),
      enrollmentYear: year,
    );

University makeUniversity() {
  final u = University(name: 'Test University');
  u.addCourse(Course(
      id: 'CS101',
      name: 'Basics',
      description: 'd',
      credits: 5,
      instructor: 'I'));
  u.addCourse(Course(
      id: 'CS201',
      name: 'OOP',
      description: 'd',
      credits: 5,
      instructor: 'I',
      prerequisites: ['CS101']));
  u.addStudent(makeStudent('S1'));
  u.addStudent(makeStudent('S2'));
  return u;
}

void main() {
  group('Student', () {
    test('fullName та role', () {
      final s = makeStudent('S1');
      expect(s.fullName, 'Олена Коваль');
      expect(s.role, 'Student');
    });

    test('ageOn враховує день народження', () {
      final s = makeStudent('S1');
      expect(s.ageOn(DateTime(2024, 6, 15)), 24);
      expect(s.ageOn(DateTime(2024, 6, 14)), 23);
    });

    test('gpa: порожній і середній', () {
      final s = makeStudent('S1');
      expect(s.gpa, 0);
      s.enrollInCourse('A');
      s.enrollInCourse('B');
      s.addGrade('A', 90);
      s.addGrade('B', 70);
      expect(s.gpa, 80);
      expect(s.letterGrade, LetterGrade.c);
    });

    test('повторний запис кидає AlreadyEnrolledException', () {
      final s = makeStudent('S1')..enrollInCourse('A');
      expect(() => s.enrollInCourse('A'),
          throwsA(isA<AlreadyEnrolledException>()));
    });

    test('addGrade: валідація', () {
      final s = makeStudent('S1')..enrollInCourse('A');
      expect(() => s.addGrade('A', 101), throwsA(isA<InvalidGradeException>()));
      expect(() => s.addGrade('A', -1), throwsA(isA<InvalidGradeException>()));
      expect(() => s.addGrade('B', 50), throwsA(isA<NotEnrolledException>()));
    });

    test('getPassedCourses: межа 60', () {
      final s = makeStudent('S1')
        ..enrollInCourse('A')
        ..enrollInCourse('B')
        ..enrollInCourse('C')
        ..addGrade('A', 60)
        ..addGrade('B', 59.9)
        ..addGrade('C', 100);
      expect(s.getPassedCourses(), ['A', 'C']);
    });

    test('JSON туди й назад', () {
      final s = Student(
        id: 'S1',
        firstName: 'A',
        lastName: 'B',
        birthDate: DateTime(2001, 2, 3),
        enrollmentYear: 2022,
        enrolledCourses: ['X'],
        grades: {'X': 77.5},
        skills: {'Dart'},
      );
      final copy = Student.fromJson(s.toJson());
      expect(copy.id, 'S1');
      expect(copy.birthDate, DateTime(2001, 2, 3));
      expect(copy.enrollmentYear, 2022);
      expect(copy.enrolledCourses, ['X']);
      expect(copy.grades, {'X': 77.5});
      expect(copy.skills, {'Dart'});
    });
  });

  group('LetterGrade', () {
    test('fromScore', () {
      expect(LetterGrade.fromScore(95), LetterGrade.a);
      expect(LetterGrade.fromScore(82), LetterGrade.b);
      expect(LetterGrade.fromScore(60), LetterGrade.e);
      expect(LetterGrade.fromScore(10), LetterGrade.f);
    });
  });

  group('Course', () {
    test('пререквізити', () {
      final course = Course(
          id: 'CS201',
          name: 'n',
          description: 'd',
          credits: 5,
          instructor: 'i',
          prerequisites: ['CS101']);
      final s = makeStudent('S1');
      expect(course.hasPrerequisites(), isTrue);
      expect(course.canStudentEnroll(s), isFalse);
      s.enrollInCourse('CS101');
      s.addGrade('CS101', 75);
      expect(course.canStudentEnroll(s), isTrue);
      s.enrollInCourse('CS201');
      expect(course.canStudentEnroll(s), isFalse); // вже записаний
    });
  });

  group('Professor / Person (поліморфізм)', () {
    test('role, fullName, raiseSalary', () {
      final p = Professor(
        id: 'P1',
        firstName: 'Андрій',
        lastName: 'Іваненко',
        birthDate: DateTime(1975, 1, 1),
        department: 'CS',
        salary: 1000,
      );
      final Person asPerson = p;
      expect(asPerson.role, 'Professor');
      expect(asPerson.fullName, 'Prof. Андрій Іваненко');
      p.raiseSalary(10);
      expect(p.salary, closeTo(1100, 1e-9));
      expect(() => p.raiseSalary(0), throwsArgumentError);
    });
  });

  group('University', () {
    test('CRUD студентів', () {
      final u = makeUniversity();
      expect(u.students.length, 2);
      expect(u.findStudentById('S1'), isNotNull);
      expect(u.findStudentById('nope'), isNull);
      expect(() => u.addStudent(makeStudent('S1')),
          throwsA(isA<DuplicateEntityException>()));
      u.removeStudent('S2');
      expect(u.students.length, 1);
      expect(() => u.removeStudent('S2'),
          throwsA(isA<EntityNotFoundException>()));
    });

    test('enrollStudent перевіряє пререквізити', () {
      final u = makeUniversity();
      expect(() => u.enrollStudent('S1', 'CS201'),
          throwsA(isA<PrerequisitesNotMetException>()));
      u.enrollStudent('S1', 'CS101');
      u.findStudentById('S1')!.addGrade('CS101', 80);
      u.enrollStudent('S1', 'CS201');
      expect(u.getStudentsByCourse('CS201').map((s) => s.id), ['S1']);
    });

    test('getAvailableCoursesForStudent', () {
      final u = makeUniversity();
      expect(u.getAvailableCoursesForStudent('S1').map((c) => c.id), ['CS101']);
    });

    test('generateStatistics', () {
      final u = makeUniversity();
      u.enrollStudent('S1', 'CS101');
      u.enrollStudent('S2', 'CS101');
      u.findStudentById('S1')!.addGrade('CS101', 90);
      u.findStudentById('S2')!.addGrade('CS101', 70);
      final stats = u.generateStatistics();
      expect(stats['totalStudents'], 2);
      expect(stats['totalCourses'], 2);
      expect(stats['averageGpa'], 80.0);
      expect(stats['topStudent'], 'Олена Коваль');
      expect(stats['enrollmentsPerCourse'], {'CS101': 2, 'CS201': 0});
    });

    test('журнал Loggable', () {
      final u = makeUniversity();
      expect(u.history, isNotEmpty);
      expect(u.history.first, contains('CS101'));
    });
  });
}
