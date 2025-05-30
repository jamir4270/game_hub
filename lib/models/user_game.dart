class UserGame {
  final int gameId;
  final String userId;
  double rating;
  bool played;

  UserGame({
    required this.gameId,
    required this.userId,
    this.rating = 0.0,
    this.played = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'gameId': gameId,
      'userId': userId,
      'rating': rating,
      'played': played ? 1 : 0,
    };
  }

  factory UserGame.fromMap(Map<String, dynamic> map) {
    return UserGame(
      gameId: map['gameId'],
      userId: map['userId'],
      rating: (map['rating'] ?? 0.0).toDouble(),
      played: (map['played'] ?? 0) == 1,
    );
  }
} 