class Character {
  final String name;
  final String description;
  final String avatarPath;
  final List<String> traits;
  final String backstory;

  Character({
    required this.name,
    required this.description,
    required this.avatarPath,
    required this.traits,
    required this.backstory,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'avatarPath': avatarPath,
      'traits': traits,
      'backstory': backstory,
    };
  }

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      name: json['name'],
      description: json['description'],
      avatarPath: json['avatarPath'],
      traits: List<String>.from(json['traits']),
      backstory: json['backstory'],
    );
  }
}
