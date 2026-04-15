class RuneModel {
  const RuneModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.latinEquivalent,
    required this.sound,
    required this.meaning,
    required this.description,
  });

  final String id;
  final String symbol;
  final String name;
  final String latinEquivalent;
  final String sound;
  final String meaning;
  final String description;

  factory RuneModel.fromMap(Map<String, dynamic> map) {
    return RuneModel(
      id: map['id'] as String,
      symbol: map['symbol'] as String,
      name: map['name'] as String,
      latinEquivalent: map['latinEquivalent'] as String,
      sound: map['sound'] as String,
      meaning: map['meaning'] as String,
      description: map['description'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'latinEquivalent': latinEquivalent,
      'sound': sound,
      'meaning': meaning,
      'description': description,
    };
  }
}
