class TranslationHistoryItem {
  const TranslationHistoryItem({
    required this.id,
    required this.inputText,
    required this.outputText,
    required this.createdAt,
  });

  final String id;
  final String inputText;
  final String outputText;
  final DateTime createdAt;

  factory TranslationHistoryItem.fromMap(Map<String, dynamic> map) {
    return TranslationHistoryItem(
      id: map['id'] as String,
      inputText: map['inputText'] as String,
      outputText: map['outputText'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'inputText': inputText,
      'outputText': outputText,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
