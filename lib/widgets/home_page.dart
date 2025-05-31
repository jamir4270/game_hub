import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'doom_page.dart';
import 'starcraft_page.dart';
import 'gearsofwar_page.dart';
import 'farcry_page.dart';
import 'worldofwarcraft_page.dart';
import 'baldursgate2_page.dart';
import 'diablo_page.dart';
import 'terraria_page.dart';
import 'killzone2_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StaticGame {
  final String title;
  final String imageUrl;
  final List<String> tags;
  final Widget page;
  const StaticGame({required this.title, required this.imageUrl, required this.tags, required this.page});
}

final List<StaticGame> allGames = [
  StaticGame(title: 'Doom', imageUrl: 'assets/images/doom_card.jpg', tags: ['Shooter', 'Classic'], page: const DoomPage()),
  StaticGame(title: 'Starcraft', imageUrl: 'assets/images/starcraft_card.jpg', tags: ['Strategy', 'RTS'], page: const StarcraftPage()),
  StaticGame(title: 'Gears of War', imageUrl: 'assets/images/gearsofwar_card.jpg', tags: ['Shooter', 'Action'], page: const GearsOfWarPage()),
  StaticGame(title: 'Far Cry', imageUrl: 'assets/images/farcry_card.jpg', tags: ['Shooter', 'Open World'], page: const FarCryPage()),
  StaticGame(title: 'World of Warcraft', imageUrl: 'assets/images/worldofwarcraft_card.jpg', tags: ['MMORPG', 'Fantasy'], page: const WorldOfWarcraftPage()),
  StaticGame(title: "Baldur's Gate 2", imageUrl: 'assets/images/baldursgate2_card.jpg', tags: ['RPG', 'Fantasy'], page: const BaldursGate2Page()),
  StaticGame(title: 'Diablo', imageUrl: 'assets/images/diablo_card.jpg', tags: ['RPG', 'Action'], page: const DiabloPage()),
  StaticGame(title: 'Terraria', imageUrl: 'assets/images/terraria_card.jpg', tags: ['Sandbox', 'Adventure'], page: const TerrariaPage()),
  StaticGame(title: 'Killzone 2', imageUrl: 'assets/images/killzone2_card.jpg', tags: ['Shooter', 'Futuristic'], page: const Killzone2Page()),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadDarkMode();
  }

  Future<void> _loadDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  Color get bgColor => _darkMode ? const Color(0xFF181A20) : const Color(0xFFF5F6FA);
  Color get cardColor => _darkMode ? const Color(0xFF23262F) : Colors.white;
  Color get textColor => _darkMode ? Colors.white : Colors.black;
  Color get subTextColor => _darkMode ? Colors.grey[400]! : Colors.grey[800]!;
  Color get accentColor => Colors.deepPurple;

  List<StaticGame> get trendingGames => allGames.take(5).toList();
  List<StaticGame> get savedGames => allGames.skip(5).take(4).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('Game Hub', style: TextStyle(color: textColor)),
        backgroundColor: accentColor,
        iconTheme: IconThemeData(color: textColor),
        elevation: 0,
      ),
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
                    color: _darkMode ? Colors.grey.shade800 : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Marquee(
                    text:
                        "Did you know that the first video game Easter egg appeared in Adventure for the Atari 2600 in 1980, hidden by a developer who wasn't credited? Or that Mario was originally called 'Jumpman' in Donkey Kong, and his iconic mustache was added due to pixel limitations? Halo 2 had a hidden message from a developer proposing to his girlfriend, and The Legend of Zelda: Ocarina of Time uses reversed dog barks as some enemy sound effects. Minecraft was almost called Cave Game, and its world is so vast that it's practically infinite — if you walked to the edge, the game would start glitching. In Pokémon Red and Blue, there's a myth that beating the game 100 times unlocks Pikablu, a non-existent Pokémon fans speculated about for years. Pac-Man was inspired by a pizza with a slice missing, and the original Tetris was coded by a Russian scientist during the Cold War, using text characters because he didn't have graphics capabilities. Meanwhile, in Metal Gear Solid 3, saving the game during a boss fight and returning a week later causes the elderly boss to die of old age! Even crazier, there's a playable version of Galaga inside Tekken 3. Video game history is packed with quirky surprises, hidden tributes, and creative hacks that make the gaming world endlessly fascinating.",
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor,
                    ),
                    blankSpace: 60.0,
                    velocity: 40.0,
                    pauseAfterRound: const Duration(seconds: 1),
                    startPadding: 10.0,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Saved Games',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: textColor),
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
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => game.page),
                        ),
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
                                game.title,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
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
                    color: subTextColor,
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
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => game.page),
                        ),
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
                                game.title,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
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