/// Власні виключення предметної області.
///
/// Усі "бізнес-помилки" університету успадковують [UniversityException],
/// тому їх можна ловити одним `on UniversityException catch (e)`.
class UniversityException implements Exception {
  final String message;

  const UniversityException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

class InvalidGradeException extends UniversityException {
  final double grade;

  InvalidGradeException(this.grade)
      : super('Оцінка має бути в діапазоні 0..100, отримано $grade');
}

class AlreadyEnrolledException extends UniversityException {
  AlreadyEnrolledException(String studentId, String courseId)
      : super('Студент $studentId вже записаний на курс $courseId');
}

class NotEnrolledException extends UniversityException {
  NotEnrolledException(String studentId, String courseId)
      : super('Студент $studentId не записаний на курс $courseId');
}

class DuplicateEntityException extends UniversityException {
  DuplicateEntityException(String type, String id)
      : super('$type з id "$id" вже існує');
}

class EntityNotFoundException extends UniversityException {
  EntityNotFoundException(String type, String id)
      : super('$type з id "$id" не знайдено');
}

class PrerequisitesNotMetException extends UniversityException {
  final List<String> missing;

  PrerequisitesNotMetException(String courseId, this.missing)
      : super('Для курсу $courseId не виконано пререквізити: '
            '${missing.join(', ')}');
}

/// Помилки калькулятора (ділення на нуль, некоректний вираз тощо).
class CalculatorException implements Exception {
  final String message;

  const CalculatorException(this.message);

  @override
  String toString() => 'CalculatorException: $message';
}
