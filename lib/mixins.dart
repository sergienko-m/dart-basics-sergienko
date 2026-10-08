import 'models/person.dart';

/// Міксін, який додає текстовий опис будь-якій [Person].
///
/// `on Person` означає, що міксін можна підмішати лише до нащадків Person,
/// тому всередині доступні `role`, `fullName`, `age`, `id`.
mixin Describable on Person {
  String get description => '[$role] $fullName, $age р., id=$id';
}

/// Міксін із журналом подій (аудит змін).
mixin Loggable {
  final List<String> _log = <String>[];

  List<String> get history => List<String>.unmodifiable(_log);

  void log(String message) => _log.add(message);

  void clearLog() => _log.clear();
}
