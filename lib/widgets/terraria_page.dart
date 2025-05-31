import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TerrariaPage extends StatefulWidget {
  const TerrariaPage({super.key});

  @override
  State<TerrariaPage> createState() => _TerrariaPageState();
}

class _TerrariaPageState extends State<TerrariaPage> {
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
      _rating = prefs.getDouble('terraria_rating') ?? 0;
      _favorite = prefs.getBool('terraria_favorite') ?? false;
      _review = prefs.getString('terraria_review') ?? '';
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
      _reviews = prefs.getStringList('terraria_reviews') ?? [];
    });
  }

  Future<void> _addReview(String review) async {
    if (review.trim().isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final reviews = prefs.getStringList('terraria_reviews') ?? [];
    reviews.add(review.trim());
    await prefs.setStringList('terraria_reviews', reviews);
    setState(() {
      _reviews = reviews;
      _review = '';
      _reviewController.clear();
    });
  }

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('terraria_rating', _rating);
    await prefs.setBool('terraria_favorite', _favorite);
    await prefs.setString('terraria_review', _review);
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
        title: Text('Terraria', style: TextStyle(color: textColor)),
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
                  'assets/images/terraria_card.jpg',
                  width: 300,
                  height: 160,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Terraria', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                Chip(label: Text('2D Sandbox', style: TextStyle(color: textColor)), backgroundColor: cardColor),
                Chip(label: Text('T (Teen)', style: TextStyle(color: textColor)), backgroundColor: cardColor),
                Chip(label: Text('1–8 Players', style: TextStyle(color: textColor)), backgroundColor: cardColor),
                Chip(label: Text('PC, Console, Mobile', style: TextStyle(color: textColor)), backgroundColor: cardColor),
              ],
            ),
            _buildSectionTitle('Basic Details'),
            Text('''
• Title: Terraria
• Release Date: May 16, 2011
• Developer: Re-Logic
• Publisher: Re-Logic
• Platform: PC, Console, Mobile
• Genre: 2D Sandbox
• Rating: T (Teen)
• Players: 1–8 (Multiplayer)
''', style: TextStyle(color: textColor)),
            _buildSectionTitle('Description'),
            Text(
              'Terraria is a 2D sandbox adventure game that offers endless possibilities. Dig, fight, explore, and build in a world where creativity and adventure collide. Craft weapons, armor, and magical items to battle creatures and bosses in this pixelated universe.',
              style: TextStyle(fontSize: 16, color: textColor),
            ),
            _buildSectionTitle('Key Features'),
            _buildFeatureList([
              'Endless world exploration',
              'Craft over 500 weapons',
              'Build elaborate structures',
              'Fight epic bosses',
              'Multiplayer support up to 8 players',
              'Regular content updates',
            ]),
            _buildSectionTitle('Game Modes'),
            _buildGameModes([
              {'name': 'Classic Mode', 'desc': 'Standard gameplay experience with balanced difficulty'},
              {'name': 'Expert Mode', 'desc': 'Increased challenge with unique rewards'},
              {'name': 'Master Mode', 'desc': 'Ultimate difficulty for experienced players'},
              {'name': 'Journey Mode', 'desc': 'Creative mode with godmode and item duplication'},
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