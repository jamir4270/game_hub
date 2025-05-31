import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<StaticGame> playedGames = [];
  List<StaticGame> ratedGames = [];
  Map<String, double> ratings = {};
  Map<String, bool> favorites = {};
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
    _loadDarkMode();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    List<StaticGame> played = [];
    List<StaticGame> rated = [];
    Map<String, double> r = {};
    Map<String, bool> f = {};
    for (final game in allGames) {
      final key = _keyFromTitle(game.title);
      final rating = prefs.getDouble('${key}_rating') ?? 0;
      final favorite = prefs.getBool('${key}_favorite') ?? false;
      r[game.title] = rating;
      f[game.title] = favorite;
      if (favorite) played.add(game);
      if (rating > 0) rated.add(game);
    }
    setState(() {
      playedGames = played;
      ratedGames = rated;
      ratings = r;
      favorites = f;
    });
  }

  Future<void> _loadDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  String _keyFromTitle(String title) {
    return title.toLowerCase().replaceAll("'", '').replaceAll(' ', '');
  }

  Color get bgColor => _darkMode ? const Color(0xFF181A20) : const Color(0xFFF5F6FA);
  Color get cardColor => _darkMode ? const Color(0xFF23262F) : Colors.white;
  Color get textColor => _darkMode ? Colors.white : Colors.black;
  Color get subTextColor => _darkMode ? Colors.grey[400]! : Colors.grey[800]!;
  Color get accentColor => Colors.deepPurple;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('Your Profile', style: TextStyle(color: textColor)),
        backgroundColor: accentColor,
        iconTheme: IconThemeData(color: textColor),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text('Played Games', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: textColor)),
          ),
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: playedGames.length,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final game = playedGames[index];
                final rating = ratings[game.title] ?? 0;
                final favorite = favorites[game.title] ?? false;
                return InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => game.page),
                  ),
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
                          game.title,
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
                                  i < rating ? Icons.star : Icons.star_border,
                                  color: Colors.amber,
                                  size: 18,
                                )),
                            const SizedBox(width: 4),
                            Icon(
                              favorite ? Icons.favorite : Icons.favorite_border,
                              color: favorite ? Colors.red : Colors.grey,
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text('Rated Games', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: textColor)),
          ),
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: ratedGames.length,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final game = ratedGames[index];
                final rating = ratings[game.title] ?? 0;
                final favorite = favorites[game.title] ?? false;
                return InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => game.page),
                  ),
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
                          game.title,
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
                                  i < rating ? Icons.star : Icons.star_border,
                                  color: Colors.amber,
                                  size: 18,
                                )),
                            const SizedBox(width: 4),
                            Icon(
                              favorite ? Icons.favorite : Icons.favorite_border,
                              color: favorite ? Colors.red : Colors.grey,
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