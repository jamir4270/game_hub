import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import '../models/game.dart';
import '../models/user_game.dart';

class HomePage extends StatelessWidget {
  final List<Game> games;
  final Map<int, UserGame> userGames;
  final void Function(Game) onGameTap;
  final void Function(Game, double) onRatingChanged;
  final void Function(Game, bool) onPlayedChanged;
  final List<Game> highestRated;
  final List<Game> popular;
  final List<Game> other;

  const HomePage({
    super.key,
    required this.games,
    required this.userGames,
    required this.onGameTap,
    required this.onRatingChanged,
    required this.onPlayedChanged,
    required this.highestRated,
    required this.popular,
    required this.other,
  });

  // For demo: first 5 as trending, next 4 as saved
  List<Game> get trendingGames => games.take(5).toList();
  List<Game> get savedGames => games.skip(5).take(4).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Hub'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade800
                        : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Marquee(
                    text:
                        "Did you know that the first video game Easter egg appeared in Adventure for the Atari 2600 in 1980, hidden by a developer who wasn't credited? Or that Mario was originally called 'Jumpman' in Donkey Kong, and his iconic mustache was added due to pixel limitations? Halo 2 had a hidden message from a developer proposing to his girlfriend, and The Legend of Zelda: Ocarina of Time uses reversed dog barks as some enemy sound effects. Minecraft was almost called Cave Game, and its world is so vast that it's practically infinite — if you walked to the edge, the game would start glitching. In Pokémon Red and Blue, there's a myth that beating the game 100 times unlocks Pikablu, a non-existent Pokémon fans speculated about for years. Pac-Man was inspired by a pizza with a slice missing, and the original Tetris was coded by a Russian scientist during the Cold War, using text characters because he didn't have graphics capabilities. Meanwhile, in Metal Gear Solid 3, saving the game during a boss fight and returning a week later causes the elderly boss to die of old age! Even crazier, there's a playable version of Galaga inside Tekken 3. Video game history is packed with quirky surprises, hidden tributes, and creative hacks that make the gaming world endlessly fascinating.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                    blankSpace: 60.0,
                    velocity: 40.0,
                    pauseAfterRound: const Duration(seconds: 1),
                    startPadding: 10.0,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Saved Games',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 260,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: savedGames.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final game = savedGames[index];
                      return InkWell(
                        onTap: () => onGameTap(game),
                        child: SizedBox(
                          width: 140,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.asset(
                                    game.imageUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      color: Colors.grey[300],
                                      child: const Center(child: Icon(Icons.broken_image)),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                game.name,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).textTheme.bodyLarge?.color,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Wrap(
                                spacing: 4,
                                children: game.tags.take(2).map((tag) => Chip(label: Text(tag))).toList(),
                              ),
                              Row(
                                children: [
                                  ...List.generate(5, (i) => Icon(Icons.star, size: 16)),
                                  Icon(Icons.favorite, size: 16),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Welcome to your GameHub!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Discover trending games and manage your collection.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Trending Games',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 260,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: trendingGames.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final game = trendingGames[index];
                      return InkWell(
                        onTap: () => onGameTap(game),
                        child: SizedBox(
                          width: 140,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.asset(
                                    game.imageUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      color: Colors.grey[300],
                                      child: const Center(child: Icon(Icons.broken_image)),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                game.name,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).textTheme.bodyLarge?.color,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
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
          ),
        ),
      ),
    );
  }
} 