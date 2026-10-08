import 'package:dart_basics/dart_basics.dart';
import 'package:test/test.dart';

Student st(String id, int year, Map<String, double> grades, Set<String> skills) =>
    Student(
      id: id,
      firstName: 'N$id',
      lastName: 'L$id',
      birthDate: DateTime(2002, 1, 1),
      enrollmentYear: year,
      enrolledCourses: grades.keys.toList(),
      grades: grades,
      skills: skills,
    );

void main() {
  group('Calculator', () {
    test('базові операції', () {
      expect(Calculator.add(2, 3), 5);
      expect(Calculator.subtract(2, 3), -1);
      expect(Calculator.multiply(4, 2.5), 10);
      expect(Calculator.divide(9, 2), 4.5);
      expect(Calculator.modulo(18, 4), 2);
      expect(Calculator.power(2, 10), 1024);
      expect(Calculator.squareRoot(81), 9);
      expect(Calculator.percentOf(15, 200), 30);
      expect(Calculator.average([1, 2, 3, 4]), 2.5);
    });

    test('помилки', () {
      expect(() => Calculator.divide(1, 0),
          throwsA(isA<CalculatorException>()));
      expect(() => Calculator.squareRoot(-1),
          throwsA(isA<CalculatorException>()));
      expect(() => Calculator.average([]), throwsA(isA<CalculatorException>()));
    });

    test('evaluate: пріоритети й дужки', () {
      expect(Calculator.evaluate('2 + 3 * 4'), 14);
      expect(Calculator.evaluate('(2 + 3) * 4'), 20);
      expect(Calculator.evaluate('2 ^ 3 ^ 2'), 512);
      expect(Calculator.evaluate('-2 ^ 2'), -4);
      expect(Calculator.evaluate('10 / 4 - 1.5'), 1);
      expect(Calculator.evaluate('2*-3'), -6);
    });

    test('evaluate: некоректні вирази', () {
      for (final bad in ['', '1 / 0', '2 + * 3', '(1 + 2', '1 + 2)', 'abc']) {
        expect(() => Calculator.evaluate(bad),
            throwsA(isA<CalculatorException>()),
            reason: 'вираз "$bad"');
      }
    });
  });

  group('DataProcessor', () {
    final a = st('A', 2022, {'CS101': 90, 'MA101': 70}, {'Dart'});
    final b = st('B', 2024, {'CS101': 50}, {'Dart', 'SQL'});

    test('filterEvenNumbers', () {
      expect(DataProcessor.filterEvenNumbers([1, 2, 3, 4, 5, 6]), [2, 4, 6]);
      expect(DataProcessor.filterEvenNumbers([]), isEmpty);
    });

    test('countWords ігнорує регістр і пунктуацію', () {
      expect(DataProcessor.countWords('Hello hello WORLD, world world!'),
          {'hello': 2, 'world': 3});
      expect(DataProcessor.countWords('Привіт, світе! привіт'),
          {'привіт': 2, 'світе': 1});
    });

    test('sortStudentsByGPA', () {
      final sorted = DataProcessor.sortStudentsByGPA([b, a]);
      expect(sorted.map((r) => r['id']), ['A', 'B']);
      expect(sorted.first['gpa'], 80.0);
    });

    test('множини', () {
      expect(DataProcessor.getUniqueSkills([a, b]), {'Dart', 'SQL'});
      expect(DataProcessor.findCommonCourses([a, b]), {'CS101'});
      expect(DataProcessor.findCommonCourses([]), isEmpty);
    });

    test('groupStudentsByYear', () {
      final groups = DataProcessor.groupStudentsByYear([a, b],
          now: DateTime(2025, 6, 1));
      expect(groups['4 курс'], [a]);
      expect(groups['2 курс'], [b]);
    });

    test('calculateAverageGradesByCourse', () {
      expect(DataProcessor.calculateAverageGradesByCourse([a, b]),
          {'CS101': 70.0, 'MA101': 70.0});
    });

    test('describe', () {
      final s = DataProcessor.describe([1, 2, 3, 4]);
      expect(s.min, 1);
      expect(s.max, 4);
      expect(s.mean, 2.5);
      expect(s.median, 2.5);
      expect(s.stdDev, closeTo(1.1180, 1e-3));
      expect(() => DataProcessor.describe([]), throwsArgumentError);
    });

    test('gradeDistribution', () {
      final d = DataProcessor.gradeDistribution([95, 85, 61, 10, 91]);
      expect(d, {'A': 2, 'B': 1, 'C': 0, 'D': 0, 'E': 1, 'F': 1});
    });

    test('CSV: розбір і зворотне перетворення', () {
      const csv = 'id,firstName,lastName,birthDate,enrollmentYear,skills,courses,grades\n'
          'S1,Олена,Коваль,2004-03-12,2023,Dart;Git,CS101;MA101,CS101:92;MA101:88.5\n'
          '\n'
          'S2,Іван,Петренко,2003-01-01,2022,,CS101,CS101:70\n';
      final students = DataProcessor.parseStudentsCsv(csv);
      expect(students.length, 2);
      expect(students[0].skills, {'Dart', 'Git'});
      expect(students[0].grades['MA101'], 88.5);
      expect(students[1].skills, isEmpty);

      final again =
          DataProcessor.parseStudentsCsv(DataProcessor.studentsToCsv(students));
      expect(again.map((s) => s.toJson().toString()),
          students.map((s) => s.toJson().toString()));
    });

    test('CSV: помилка формату', () {
      expect(
          () => DataProcessor.parseStudentsCsv('h\nS1,a,b'),
          throwsFormatException);
    });

    test('generateReport', () {
      final u = University(name: 'T');
      u.addCourse(Course(
          id: 'CS101',
          name: 'Basics',
          description: 'd',
          credits: 5,
          instructor: 'I'));
      u.addStudent(st('A', 2022, {'CS101': 90}, {}));
      u.addStudent(st('B', 2022, {'CS101': 50}, {}));
      final report = DataProcessor.generateReport(u);
      expect(report.single['enrolled'], 2);
      expect(report.single['averageGrade'], 70.0);
      expect(report.single['passRatePercent'], 50.0);
    });
  });

  group('TextAnalyzer', () {
    test('аналіз тексту', () {
      final stats = TextAnalyzer.analyze('Dart is fun. Dart is fast!');
      expect(stats.words, 6);
      expect(stats.uniqueWords, 4);
      expect(stats.sentences, 2);
      expect(stats.lines, 1);
      expect(stats.topWords.first.key, 'dart');
      expect(stats.topWords.first.value, 2);
      expect(stats.longestWord, 'dart');
    });

    test('порожній текст', () {
      final stats = TextAnalyzer.analyze('');
      expect(stats.words, 0);
      expect(stats.lines, 0);
      expect(stats.averageWordLength, 0);
    });
  });

  group('generateStudents', () {
    test('детермінована', () {
      final x = generateStudents(5);
      final y = generateStudents(5);
      expect(x.map((s) => s.toJson().toString()),
          y.map((s) => s.toJson().toString()));
      expect(x.first.id, 'S0001');
    });
  });
}
