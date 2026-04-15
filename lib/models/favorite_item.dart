enum FavoriteType { rune, translation }

class FavoriteItem {
  const FavoriteItem({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.createdAt,
    this.symbol,
    this.referenceId,
  });

  final String id;
  final FavoriteType type;
  final String title;
  final String subtitle;
  final String? symbol;
  final String? referenceId;
  final DateTime createdAt;

  factory FavoriteItem.fromMap(Map<String, dynamic> map) {
    return FavoriteItem(
      id: map['id'] as String,
      type: FavoriteType.values.firstWhere(
        (value) => value.name == map['type'],
        orElse: () => FavoriteType.translation,
      ),
      title: map['title'] as String,
      subtitle: map['subtitle'] as String,
      symbol: map['symbol'] as String?,
      referenceId: map['referenceId'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'subtitle': subtitle,
      'symbol': symbol,
      'referenceId': referenceId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
