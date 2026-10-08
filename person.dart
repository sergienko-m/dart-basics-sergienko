/// Абстрактна особа: базовий клас для студентів і викладачів.
abstract class Person {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime birthDate;

  Person({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
  });

  String get fullName => '$firstName $lastName';

  int get age => ageOn(DateTime.now());

  /// Вік на задану дату (дозволяє детерміновано тестувати).
  int ageOn(DateTime date) {
    var years = date.year - birthDate.year;
    final hadBirthday = date.month > birthDate.month ||
        (date.month == birthDate.month && date.day >= birthDate.day);
    if (!hadBirthday) {
      years--;
    }
    return years;
  }

  /// Абстрактний геттер: кожен нащадок повертає свою роль.
  String get role;

  @override
  String toString() => '$role($fullName)';
}
