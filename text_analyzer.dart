import 'data_processor.dart';

/// Результат аналізу тексту.
class TextStats {
  final int characters;
  final int charactersWithoutSpaces;
  final int words;
  final int uniqueWords;
  final int sentences;
  final int lines;
  final double averageWordLength;
  final String longestWord;
  final List<MapEntry<String, int>> topWords;

  const TextStats({
    required this.characters,
    required this.charactersWithoutSpaces,
    required this.words,
    required this.uniqueWords,
    required this.sentences,
    required this.lines,
    required this.averageWordLength,
    required this.longestWord,
    required this.topWords,
  });
}

/// Текстовий аналізатор: підрахунок слів, символів, речень.
class TextAnalyzer {
  const TextAnalyzer._();

  static TextStats analyze(String text, {int topN = 5}) {
    final words = DataProcessor.extractWords(text);
    final counts = DataProcessor.countWords(text);

    final sortedCounts = counts.entries.toList()
      ..sort((a, b) {
        final byCount = b.value.compareTo(a.value);
        return byCount != 0 ? byCount : a.key.compareTo(b.key);
      });

    final totalLetters = words.fold<int>(0, (sum, w) => sum + w.length);
    final longest = words.isEmpty
        ? ''
        : words.reduce((a, b) => b.length > a.length ? b : a);

    return TextStats(
      characters: text.length,
      charactersWithoutSpaces: text.replaceAll(RegExp(r'\s'), '').length,
      words: words.length,
      uniqueWords: counts.length,
      sentences: text
          .split(RegExp(r'[.!?]+'))
          .where((s) => s.trim().isNotEmpty)
          .length,
      lines: text.isEmpty ? 0 : text.split(RegExp(r'\r?\n')).length,
      averageWordLength: words.isEmpty ? 0 : totalLetters / words.length,
      longestWord: longest,
      topWords: sortedCounts.take(topN).toList(),
    );
  }
}
