import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorldOfWarcraftPage extends StatefulWidget {
  const WorldOfWarcraftPage({super.key});

  @override
  State<WorldOfWarcraftPage> createState() => _WorldOfWarcraftPageState();
}

class _WorldOfWarcraftPageState extends State<WorldOfWarcraftPage> {
  double _rating = 0;
  bool _favorite = false;
  String _review = '';
  final TextEditingController _reviewController = TextEditingController();
  bool _darkMode = false;
  List<String> _reviews = [];

  @override
  void initState() {
    super.initState();
    _loadPrefs();
    _loadDarkMode();
    _loadReviews();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _rating = prefs.getDouble('wow_rating') ?? 0;
      _favorite = prefs.getBool('wow_favorite') ?? false;
      _review = prefs.getString('wow_review') ?? '';
      _reviewController.text = _review;
    });
  }

  Future<void> _loadDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  Future<void> _loadReviews() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _reviews = prefs.getStringList('wow_reviews') ?? [];
    });
  }

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('wow_rating', _rating);
    await prefs.setBool('wow_favorite', _favorite);
    await prefs.setString('wow_review', _review);
  }

  Future<void> _addReview(String review) async {
    if (review.trim().isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final reviews = prefs.getStringList('wow_reviews') ?? [];
    reviews.add(review.trim());
    await prefs.setStringList('wow_reviews', reviews);
    setState(() {
      _reviews = reviews;
      _review = '';
      _reviewController.clear();
    });
  }

  Color get bgColor => _darkMode ? const Color(0xFF181A20) : const Color(0xFFF5F6FA);
  Color get cardColor => _darkMode ? const Color(0xFF23262F) : Colors.white;
  Color get textColor => _darkMode ? Colors.white : Colors.black;
  Color get subTextColor => _darkMode ? Colors.grey[400]! : Colors.grey[800]!;
  Color get accentColor => Colors.deepPurple;

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 8),
    child: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
  );

  Widget _buildFeatureList(List<String> features) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: features.map((f) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(f, style: TextStyle(fontSize: 16, color: textColor))),
        ],
      ),
    )).toList(),
  );

  Widget _buildGameModes(List<Map<String, String>> modes) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: modes.map((mode) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(Icons.videogame_asset, color: Colors.deepPurple, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text('${mode['name']}: ${mode['desc']}', style: TextStyle(fontSize: 16, color: textColor))),
        ],
      ),
    )).toList(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('World of Warcraft', style: TextStyle(color: textColor)),
        backgroundColor: accentColor,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/worldofwarcraft_card.jpg',
                  width: 300,
                  height: 160,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('World of Warcraft', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                Chip(label: Text('MMORPG', style: TextStyle(color: textColor)), backgroundColor: cardColor),
                Chip(label: Text('T (Teen)', style: TextStyle(color: textColor)), backgroundColor: cardColor),
                Chip(label: Text('PC, Mac', style: TextStyle(color: textColor)), backgroundColor: cardColor),
              ],
            ),
            _buildSectionTitle('Basic Details'),
            Text('''
• Title: World of Warcraft
• Release Date: November 23, 2004
• Developer: Blizzard Entertainment
• Publisher: Blizzard Entertainment
• Platform: PC, Mac
• Genre: MMORPG
• Rating: T (Teen)
• Players: Online multiplayer (thousands)
''', style: TextStyle(color: textColor)),
            _buildSectionTitle('Description'),
            Text(
              'Enter the fantasy world of Azeroth as one of many races and classes. Explore, quest, raid, and fight alongside or against other players in the world\'s most iconic MMORPG.',
              style: TextStyle(fontSize: 16, color: textColor),
            ),
            _buildSectionTitle('Key Features'),
            _buildFeatureList([
              'Expansive open world',
              'Player vs. Player combat',
              'Massive raids and dungeons',
              'Guilds, crafting, and professions',
              'Expansions with new zones and classes',
              'Cross-realm play',
            ]),
            _buildSectionTitle('Game Modes'),
            _buildGameModes([
              {'name': 'PvE Mode', 'desc': 'Cooperative quests, dungeons, and raids'},
              {'name': 'PvP Mode', 'desc': 'Battlegrounds, arenas, and world PvP'},
              {'name': 'Roleplay Mode', 'desc': 'Immersive storytelling and character acting'},
            ]),
            _buildSectionTitle('Your Rating & Favorite'),
            Row(
              children: List.generate(5, (i) => IconButton(
                icon: Icon(
                  i < _rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
                onPressed: () {
                  setState(() {
                    _rating = i + 1.0;
                  });
                  _savePrefs();
                },
              ))
                ..add(IconButton(
                  icon: Icon(_favorite ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _favorite = !_favorite;
                    });
                    _savePrefs();
                  },
                )),
            ),
            _buildSectionTitle('Write a Review'),
            TextField(
              controller: _reviewController,
              maxLines: 3,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(hintText: 'Write your review...', hintStyle: TextStyle(color: subTextColor)),
              onChanged: (val) {
                setState(() {
                  _review = val;
                });
              },
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: textColor,
                ),
                onPressed: () => _addReview(_review),
                child: const Text('Submit Review'),
              ),
            ),
            if (_reviews.isNotEmpty) ...[
              _buildSectionTitle('Your Reviews'),
              ..._reviews.map((r) => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(top: 4, bottom: 8),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(r, style: TextStyle(fontSize: 16, color: textColor)),
              )),
            ],
          ],
        ),
      ),
    );
  }
} 