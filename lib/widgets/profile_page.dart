import 'package:flutter/material.dart';
import '../models/game.dart';
import '../models/user_game.dart';

class ProfilePage extends StatelessWidget {
  final List<Game> playedGames;
  final List<Game> ratedGames;
  final Map<int, UserGame> userGames;
  final void Function(Game) onGameTap;
  final void Function(Game, double) onRatingChanged;
  final void Function(Game, bool) onPlayedChanged;

  const ProfilePage({
    super.key,
    required this.playedGames,
    required this.ratedGames,
    required this.userGames,
    required this.onGameTap,
    required this.onRatingChanged,
    required this.onPlayedChanged,
  });

  @override
  Widget build(BuildContext context) {
    final Color cardColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey.shade900
        : Colors.white;
    final Color textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text('Played Games', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          ),
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: playedGames.length,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final game = playedGames[index];
                final userGame = userGames[game.id] ?? UserGame(gameId: game.id, userId: '');
                return InkWell(
                  onTap: () => onGameTap(game),
                  child: SizedBox(
                    width: 140,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            game.imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 100,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: Colors.grey[300],
                              height: 100,
                              child: const Center(child: Icon(Icons.broken_image)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          game.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            ...List.generate(5, (i) => Icon(
                                  i < userGame.rating ? Icons.star : Icons.star_border,
                                  color: Colors.amber,
                                  size: 18,
                                )),
                            const SizedBox(width: 4),
                            Icon(
                              userGame.played ? Icons.favorite : Icons.favorite_border,
                              color: userGame.played ? Colors.red : Colors.grey,
                              size: 18,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text('Rated Games', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          ),
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: ratedGames.length,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final game = ratedGames[index];
                final userGame = userGames[game.id] ?? UserGame(gameId: game.id, userId: '');
                return InkWell(
                  onTap: () => onGameTap(game),
                  child: SizedBox(
                    width: 140,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            game.imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 100,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: Colors.grey[300],
                              height: 100,
                              child: const Center(child: Icon(Icons.broken_image)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          game.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            ...List.generate(5, (i) => Icon(
                                  i < userGame.rating ? Icons.star : Icons.star_border,
                                  color: Colors.amber,
                                  size: 18,
                                )),
                            const SizedBox(width: 4),
                            Icon(
                              userGame.played ? Icons.favorite : Icons.favorite_border,
                              color: userGame.played ? Colors.red : Colors.grey,
                              size: 18,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 