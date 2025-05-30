import 'dart:convert';

class Game {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final List<String> tags;
  final String dateReleased;
  final String company;
  final String version;

  Game({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.tags,
    required this.dateReleased,
    required this.company,
    required this.version,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'tags': jsonEncode(tags),
      'dateReleased': dateReleased,
      'company': company,
      'version': version,
    };
  }

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      tags: List<String>.from(jsonDecode(map['tags'] ?? '[]')),
      dateReleased: map['dateReleased'] ?? '',
      company: map['company'] ?? '',
      version: map['version'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());
  factory Game.fromJson(String source) => Game.fromMap(json.decode(source));
} 