import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FarCryPage extends StatefulWidget {
  const FarCryPage({super.key});

  @override
  State<FarCryPage> createState() => _FarCryPageState();
}

class _FarCryPageState extends State<FarCryPage> {
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
      _rating = prefs.getDouble('farcry_rating') ?? 0;
      _favorite = prefs.getBool('farcry_favorite') ?? false;
      _review = prefs.getString('farcry_review') ?? '';
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
      _reviews = prefs.getStringList('farcry_reviews') ?? [];
    });
  }

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('farcry_rating', _rating);
    await prefs.setBool('farcry_favorite', _favorite);
    await prefs.setString('farcry_review', _review);
  }

  Future<void> _addReview(String review) async {
    if (review.trim().isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final reviews = prefs.getStringList('farcry_reviews') ?? [];
    reviews.add(review.trim());
    await prefs.setStringList('farcry_reviews', reviews);
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
        title: Text('Far Cry', style: TextStyle(color: textColor)),
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
                  'assets/images/farcry_card.jpg',
                  width: 300,
                  height: 160,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Far Cry', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                Chip(label: Text('First-Person Shooter', style: TextStyle(color: textColor)), backgroundColor: cardColor),
                Chip(label: Text('M (Mature)', style: TextStyle(color: textColor)), backgroundColor: cardColor),
                Chip(label: Text('PC', style: TextStyle(color: textColor)), backgroundColor: cardColor),
              ],
            ),
            _buildSectionTitle('Basic Details'),
            Text('''
• Title: Far Cry
• Release Date: March 23, 2004
• Developer: Crytek
• Publisher: Ubisoft
• Platform: PC
• Genre: First-Person Shooter
• Rating: M (Mature)
• Players: Single-player, Multiplayer
''', style: TextStyle(color: textColor)),
            _buildSectionTitle('Description'),
            Text(
              'Far Cry places you in the role of Jack Carver, a former special forces operative stranded on a mysterious tropical island. Use strategy, stealth, and firepower to uncover a deadly secret.',
              style: TextStyle(fontSize: 16, color: textColor),
            ),
            _buildSectionTitle('Key Features'),
            _buildFeatureList([
              'Open-ended gameplay',
              'Tactical combat with AI enemies',
              'Lush tropical environments',
              'Physics-based interaction',
              'Multiplayer maps and modes',
            ]),
            _buildSectionTitle('Game Modes'),
            _buildGameModes([
              {'name': 'Story Mode', 'desc': 'Solo campaign'},
              {'name': 'Multiplayer', 'desc': 'Team deathmatch, assault, and more'},
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