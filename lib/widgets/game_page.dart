import 'package:flutter/material.dart';
import '../models/game.dart';

class GamePage extends StatefulWidget {
  final Game game;
  final double rating;
  final bool played;
  final void Function(double) onRatingChanged;
  final void Function(bool) onPlayedChanged;

  const GamePage({
    super.key,
    required this.game,
    required this.rating,
    required this.played,
    required this.onRatingChanged,
    required this.onPlayedChanged,
  });

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late double _rating;
  late bool _played;
  final List<String> _reviews = [];
  final TextEditingController _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _rating = widget.rating;
    _played = widget.played;
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _handleRating(double newRating) {
    setState(() {
      _rating = newRating;
      if (!_played) _played = true;
    });
    widget.onRatingChanged(newRating);
    if (!_played) widget.onPlayedChanged(true);
  }

  void _handlePlayed(bool played) {
    setState(() {
      _played = played;
    });
    widget.onPlayedChanged(played);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final _GameContent content = _getGameContent(widget.game.name);
    return Scaffold(
      appBar: AppBar(
        title: Text(content.title),
        backgroundColor: isDark ? Colors.green[900] : Colors.green[700],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.game.imageUrl.isNotEmpty)
              Image.asset(
                widget.game.imageUrl,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 300,
                  color: Colors.grey[300],
                  child: const Center(child: Icon(Icons.broken_image, size: 48)),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content.title,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Released: ${content.releaseDate}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ...List.generate(5, (i) => IconButton(
                            icon: Icon(
                              i < _rating ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                              size: 28,
                            ),
                            onPressed: () => _handleRating(i + 1.0),
                          )),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(
                          _played ? Icons.favorite : Icons.favorite_border,
                          color: _played ? Colors.red : Colors.grey,
                          size: 28,
                        ),
                        onPressed: () => _handlePlayed(!_played),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content.description,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  _buildFeaturesList(content.features),
                  const SizedBox(height: 16),
                  _buildGameModes(content.modes),
                  const SizedBox(height: 16),
                  _buildGameStats(content),
                  const SizedBox(height: 24),
                  const Text('User Reviews', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _reviews.isEmpty
                      ? const Text('No reviews yet. Be the first to leave a comment!')
                      : Column(
                          children: _reviews
                              .map((review) => Card(
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Icon(Icons.person, size: 24),
                                          const SizedBox(width: 8),
                                          Expanded(child: Text(review)),
                                        ],
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _reviewController,
                          decoration: const InputDecoration(
                            hintText: 'Leave a review...',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          final text = _reviewController.text.trim();
                          if (text.isNotEmpty) {
                            setState(() {
                              _reviews.insert(0, text);
                              _reviewController.clear();
                            });
                          }
                        },
                        child: const Text('Post'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _GameContent _getGameContent(String name) {
    switch (name) {
      case 'Terraria':
        return _GameContent(
          title: 'Terraria',
          releaseDate: 'May 16, 2011',
          developer: 'Re-Logic',
          publisher: 'Re-Logic',
          platform: 'PC, Console, Mobile',
          genre: '2D Sandbox',
          rating: 'T (Teen)',
          players: '1–8 (Multiplayer)',
          description: 'Terraria is a 2D sandbox adventure game that offers endless possibilities. Dig, fight, explore, and build in a world where creativity and adventure collide. Craft weapons, armor, and magical items to battle creatures and bosses in this pixelated universe.',
          features: [
            'Endless world exploration',
            'Craft over 500 weapons',
            'Build elaborate structures',
            'Fight epic bosses',
            'Multiplayer support up to 8 players',
            'Regular content updates',
          ],
          modes: [
            _GameMode('Classic Mode', 'Standard gameplay experience with balanced difficulty'),
            _GameMode('Expert Mode', 'Increased challenge with unique rewards'),
            _GameMode('Master Mode', 'Ultimate difficulty for experienced players'),
            _GameMode('Journey Mode', 'Creative mode with godmode and item duplication'),
          ],
        );
      case 'Diablo':
        return _GameContent(
          title: 'Diablo',
          releaseDate: 'January 1997',
          developer: 'Blizzard North',
          publisher: 'Blizzard Entertainment',
          platform: 'Microsoft Windows, PlayStation, Mac OS',
          genre: 'Action role-playing, dungeon crawl',
          rating: 'Not specified',
          players: 'Single-player, multiplayer',
          description: 'Set in the fictional Kingdom of Khanduras, players descend into the depths beneath the town of Tristram to confront Diablo, the Lord of Terror. The game features randomly generated dungeon levels and a dark, gothic atmosphere.',
          features: [
            'Randomly generated dungeons',
            'Three character classes',
            'Dark, gothic atmosphere',
            'Multiplayer support',
            'Loot and item system',
          ],
          modes: [
            _GameMode('Single-player', 'Classic solo experience'),
            _GameMode('Multiplayer', 'Co-op and PvP over Battle.net'),
          ],
        );
      case "Baldur's Gate 2":
      case "Baldur's Gate II: Shadows of Amn":
        return _GameContent(
          title: "Baldur's Gate II: Shadows of Amn",
          releaseDate: 'September 2000',
          developer: 'BioWare',
          publisher: 'Interplay Entertainment',
          platform: 'Microsoft Windows, Mac OS',
          genre: 'Role-playing',
          rating: 'M (Mature)',
          players: 'Single-player, multiplayer',
          description: 'Continuing the saga of the Bhaalspawn, players navigate political intrigue and battle formidable foes in the Sword Coast region. The game is renowned for its deep narrative and complex character development.',
          features: [
            'Deep narrative',
            'Complex character development',
            'Party-based gameplay',
            'Hundreds of spells and abilities',
            'Expansive world',
          ],
          modes: [
            _GameMode('Single-player', 'Story-driven campaign'),
            _GameMode('Multiplayer', 'Co-op and competitive play'),
          ],
        );
      case 'World of Warcraft':
        return _GameContent(
          title: 'World of Warcraft',
          releaseDate: 'November 23, 2004',
          developer: 'Blizzard Entertainment',
          publisher: 'Blizzard Entertainment',
          platform: 'Windows, Mac OS X',
          genre: 'MMORPG',
          rating: 'T (Teen)',
          players: 'Multiplayer',
          description: 'Set in the Warcraft universe, players create avatars to explore the world of Azeroth, engage in quests, and interact with other players. The game has received multiple expansions, enhancing its content and gameplay.',
          features: [
            'Massive open world',
            'Multiple expansions',
            'Diverse classes and races',
            'PvE and PvP content',
            'Guilds and social systems',
          ],
          modes: [
            _GameMode('Questing', 'Story and side quests'),
            _GameMode('Raids', 'Large group PvE content'),
            _GameMode('PvP', 'Battlegrounds and arenas'),
          ],
        );
      case 'Far Cry':
        return _GameContent(
          title: 'Far Cry',
          releaseDate: 'March 23, 2004',
          developer: 'Crytek',
          publisher: 'Ubisoft',
          platform: 'Microsoft Windows',
          genre: 'First-person shooter',
          rating: 'M (Mature)',
          players: 'Single-player, multiplayer',
          description: 'Players assume the role of Jack Carver, navigating a tropical archipelago to uncover a sinister plot involving genetic experiments. The game is known for its open-ended gameplay and advanced AI.',
          features: [
            'Open-ended gameplay',
            'Advanced AI',
            'Expansive environments',
            'Vehicle combat',
            'Multiplayer modes',
          ],
          modes: [
            _GameMode('Single-player', 'Story campaign'),
            _GameMode('Multiplayer', 'Competitive modes'),
          ],
        );
      case 'Gears of War':
        return _GameContent(
          title: 'Gears of War',
          releaseDate: 'November 7, 2006',
          developer: 'Epic Games',
          publisher: 'Microsoft Game Studios',
          platform: 'Xbox 360, Microsoft Windows',
          genre: 'Third-person shooter',
          rating: 'M (Mature)',
          players: 'Single-player, multiplayer',
          description: 'Set on the planet Sera, players control Marcus Fenix, leading a squad against the subterranean Locust Horde. The game introduced a cover-based combat system and received acclaim for its graphics and gameplay.',
          features: [
            'Cover-based combat',
            'Squad tactics',
            'Multiplayer modes',
            'Epic story',
            'Co-op campaign',
          ],
          modes: [
            _GameMode('Single-player', 'Story campaign'),
            _GameMode('Co-op', 'Play with a friend'),
            _GameMode('Multiplayer', 'Competitive modes'),
          ],
        );
      case 'Starcraft':
      case 'StarCraft':
        return _GameContent(
          title: 'StarCraft',
          releaseDate: 'March 31, 1998',
          developer: 'Blizzard Entertainment',
          publisher: 'Blizzard Entertainment',
          platform: 'Microsoft Windows, Mac OS',
          genre: 'Real-time strategy',
          rating: 'T (Teen)',
          players: 'Single-player, multiplayer',
          description: 'In a distant sector of the galaxy, three species—the Terrans, Zerg, and Protoss—vie for dominance. Players engage in strategic base-building and combat, with each faction offering unique units and abilities.',
          features: [
            'Three unique factions',
            'Strategic base-building',
            'Resource management',
            'Multiplayer battles',
            'Epic campaign',
          ],
          modes: [
            _GameMode('Single-player', 'Campaign missions'),
            _GameMode('Multiplayer', 'Online battles'),
          ],
        );
      case 'Doom':
        return _GameContent(
          title: 'Doom',
          releaseDate: 'December 10, 1993',
          developer: 'id Software',
          publisher: 'id Software',
          platform: 'MS-DOS',
          genre: 'First-person shooter',
          rating: 'Not rated (pre-ESRB)',
          players: 'Single-player, multiplayer',
          description: 'Players assume the role of a space marine battling demons unleashed from Hell. The game is credited with pioneering the first-person shooter genre and has influenced countless titles since its release.',
          features: [
            'Fast-paced action',
            'Demon-slaying arsenal',
            'Iconic levels',
            'Multiplayer support',
            'Modding community',
          ],
          modes: [
            _GameMode('Single-player', 'Classic campaign'),
            _GameMode('Multiplayer', 'Deathmatch and co-op'),
          ],
        );
      case 'Killzone 2':
        return _GameContent(
          title: 'Killzone 2',
          releaseDate: 'February 27, 2009',
          developer: 'Guerrilla Games',
          publisher: 'Sony Computer Entertainment',
          platform: 'PlayStation 3',
          genre: 'First-person shooter',
          rating: 'M (Mature)',
          players: 'Single-player, multiplayer',
          description: 'Set in a futuristic war-torn universe, players join the ISA forces in an assault against the Helghast on their home planet. The game is noted for its intense combat and impressive graphics.',
          features: [
            'Intense combat',
            'Futuristic weapons',
            'Large-scale battles',
            'Multiplayer modes',
            'Stunning visuals',
          ],
          modes: [
            _GameMode('Single-player', 'Story campaign'),
            _GameMode('Multiplayer', 'Competitive modes'),
          ],
        );
      default:
        return _GameContent(
          title: widget.game.name,
          releaseDate: widget.game.dateReleased,
          developer: widget.game.company,
          publisher: widget.game.company,
          platform: 'Unknown',
          genre: widget.game.tags.isNotEmpty ? widget.game.tags.join(', ') : 'Unknown',
          rating: 'Unknown',
          players: 'Unknown',
          description: widget.game.description,
          features: [],
          modes: [],
        );
    }
  }

  Widget _buildFeaturesList(List<String> features) {
    if (features.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Key Features',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...features.map(_buildFeatureItem).toList(),
      ],
    );
  }

  Widget _buildGameModes(List<_GameMode> modes) {
    if (modes.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Game Modes',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...modes.map((m) => _buildModeCard(m.title, m.description)).toList(),
      ],
    );
  }

  Widget _buildGameStats(_GameContent content) {
    return Card(
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Game Statistics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(height: 12),
            _buildStatRow('Developer', content.developer),
            _buildStatRow('Publisher', content.publisher),
            _buildStatRow('Platform', content.platform),
            _buildStatRow('Genre', content.genre),
            _buildStatRow('Rating', content.rating),
            _buildStatRow('Players', content.players),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.circle, size: 8, color: Colors.green[700]),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildModeCard(String title, String description) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(height: 4),
            Text(description, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _GameContent {
  final String title;
  final String releaseDate;
  final String developer;
  final String publisher;
  final String platform;
  final String genre;
  final String rating;
  final String players;
  final String description;
  final List<String> features;
  final List<_GameMode> modes;
  _GameContent({
    required this.title,
    required this.releaseDate,
    required this.developer,
    required this.publisher,
    required this.platform,
    required this.genre,
    required this.rating,
    required this.players,
    required this.description,
    required this.features,
    required this.modes,
  });
}

class _GameMode {
  final String title;
  final String description;
  _GameMode(this.title, this.description);
} 