import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoomPage extends StatefulWidget {
  const DoomPage({super.key});

  @override
  State<DoomPage> createState() => _DoomPageState();
}

class _DoomPageState extends State<DoomPage> {
  double _rating = 0;
  bool _favorite = false;
  String _review = '';
  final TextEditingController _reviewController = TextEditingController();
  List<String> _reviews = [];
  bool _darkMode = false;

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
      _rating = prefs.getDouble('doom_rating') ?? 0;
      _favorite = prefs.getBool('doom_favorite') ?? false;
      _review = prefs.getString('doom_review') ?? '';
      _reviewController.text = _review;
    });
  }

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('doom_rating', _rating);
    await prefs.setBool('doom_favorite', _favorite);
    await prefs.setString('doom_review', _review);
  }

  Future<void> _loadReviews() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _reviews = prefs.getStringList('doom_reviews') ?? [];
    });
  }

  Future<void> _addReview(String review) async {
    if (review.trim().isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final reviews = prefs.getStringList('doom_reviews') ?? [];
    reviews.add(review.trim());
    await prefs.setStringList('doom_reviews', reviews);
    setState(() {
      _reviews = reviews;
      _review = '';
      _reviewController.clear();
    });
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

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 8),
    child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
  );

  Widget _buildFeatureList(List<String> features) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: features.map((f) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(f, style: const TextStyle(fontSize: 16))),
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
          const Icon(Icons.videogame_asset, color: Colors.deepPurple, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text('${mode['name']}: ${mode['desc']}', style: const TextStyle(fontSize: 16))),
        ],
      ),
    )).toList(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(title: const Text('Doom'), backgroundColor: accentColor, iconTheme: IconThemeData(color: textColor)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/doom_card.jpg',
                  width: 300,
                  height: 160,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Doom', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: const [
                Chip(label: Text('First-Person Shooter')),
                Chip(label: Text('M (Mature)')),
                Chip(label: Text('PC, Various')),
              ],
            ),
            _buildSectionTitle('Basic Details'),
            const Text('''
• Title: Doom
• Release Date: December 10, 1993
• Developer: id Software
• Publisher: GT Interactive
• Platform: PC, Various
• Genre: First-Person Shooter
• Rating: M (Mature)
• Players: Single-player, Multiplayer
'''),
            _buildSectionTitle('Description'),
            const Text(
              'Doom is the legendary first-person shooter that defined a genre. As the Doom Slayer, battle your way through hordes of demons on Mars and in Hell using an arsenal of powerful weapons.',
              style: TextStyle(fontSize: 16),
            ),
            _buildSectionTitle('Key Features'),
            _buildFeatureList([
              'Fast-paced, visceral combat',
              'Iconic weapons and power-ups',
              'Maze-like level design',
              'Multiplayer deathmatch',
              'Modding and custom WADs',
            ]),
            _buildSectionTitle('Game Modes'),
            _buildGameModes([
              {'name': 'Campaign', 'desc': 'Classic single-player experience'},
              {'name': 'Multiplayer', 'desc': 'Deathmatch and co-op'},
              {'name': 'Mods', 'desc': 'User-created levels and content'},
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