import 'package:sqflite/sqflite.dart';

import '../models/account.dart';
import '../models/game.dart';
import '../models/user_game.dart';

class DatabaseService {
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = '$databasePath/loqosaurus_app.db';
    final database = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );

    _database = database;
    return database;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE account (uuid TEXT PRIMARY KEY, api_id TEXT, user_level INTEGER DEFAULT 0, api_name TEXT,api_email TEXT, api_photo_url TEXT, is_signed_in INTEGER DEFAULT 0, is_public INTEGER DEFAULT 0, is_contributor_mode INTEGER DEFAULT 0, is_restricted INTEGER DEFAULT 0, is_synchronized INTEGER DEFAULT 0, ttl TEXT, created_at TEXT NOT NULL);",
    );
    await db.execute(
      "CREATE TABLE game (id INTEGER PRIMARY KEY, name TEXT, description TEXT, imageUrl TEXT, tags TEXT);",
    );
    await db.execute(
      "CREATE TABLE user_game (gameId INTEGER, userId TEXT, rating REAL, played INTEGER, PRIMARY KEY (gameId, userId));",
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async { }

  // helper methods
  Future<void> insertAccount(Account account) async {
    final db = await _databaseService.database;
    await db.insert(
      'account',
      account.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateAccount(Account account) async {
    final db = await _databaseService.database;
    await db.update('account', account.toMap(), where: 'uuid = ?', whereArgs: [account.uuid]);
  }

  Future<List<Account>> getAccount(uuid) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('account', where: 'uuid = ?', whereArgs: [uuid]);
    return List.generate(maps.length, (index) => Account.fromMap(maps[index]));
  }

  Future<List<Account>> getSignedAccount() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'account',
      where: 'is_signed_in = 1',
      orderBy: 'created_at DESC',
      limit: 1,
    );
    return List.generate(maps.length, (index) => Account.fromMap(maps[index]));
  }

  Future<List<Account>> getAccounts(int limit) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('account', limit: limit);
    return List.generate(maps.length, (index) => Account.fromMap(maps[index]));
  }

  Future<void> clearAccounts() async {
    final db = await _databaseService.database;
    await db.delete('account');
  }

  // Game methods
  Future<void> insertGame(Game game) async {
    final db = await database;
    await db.insert('game', game.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Game>> getGames() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('game');
    return List.generate(maps.length, (index) => Game.fromMap(maps[index]));
  }

  Future<Game?> getGame(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('game', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Game.fromMap(maps.first);
    }
    return null;
  }

  // UserGame methods
  Future<void> upsertUserGame(UserGame userGame) async {
    final db = await database;
    await db.insert('user_game', userGame.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<UserGame?> getUserGame(int gameId, String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('user_game', where: 'gameId = ? AND userId = ?', whereArgs: [gameId, userId]);
    if (maps.isNotEmpty) {
      return UserGame.fromMap(maps.first);
    }
    return null;
  }

  Future<List<UserGame>> getUserGames(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('user_game', where: 'userId = ?', whereArgs: [userId]);
    return List.generate(maps.length, (index) => UserGame.fromMap(maps[index]));
  }

  Future<void> populateSampleGames() async {
    final db = await database;
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM game')) ?? 0;
    if (count > 0) return;
    final sampleGames = [
      Game(
        id: 1,
        name: 'Doom',
        description: 'Classic first-person shooter game.',
        imageUrl: 'assets/images/doom_card.jpg',
        tags: ['Shooter', 'Classic'],
        dateReleased: '1993-12-10',
        company: 'id Software',
        version: '1.0',
      ),
      Game(
        id: 2,
        name: 'Starcraft',
        description: 'Legendary real-time strategy game.',
        imageUrl: 'assets/images/starcraft_card.jpg',
        tags: ['Strategy', 'RTS'],
        dateReleased: '1998-03-31',
        company: 'Blizzard Entertainment',
        version: '1.0',
      ),
      Game(
        id: 3,
        name: 'Gears of War',
        description: 'Third-person shooter with cover mechanics.',
        imageUrl: 'assets/images/gearsofwar_card.jpg',
        tags: ['Shooter', 'Action'],
        dateReleased: '2006-11-07',
        company: 'Epic Games',
        version: '1.0',
      ),
      Game(
        id: 4,
        name: 'Far Cry',
        description: 'Open world first-person shooter.',
        imageUrl: 'assets/images/farcry_card.jpg',
        tags: ['Shooter', 'Open World'],
        dateReleased: '2004-03-23',
        company: 'Crytek',
        version: '1.0',
      ),
      Game(
        id: 5,
        name: 'World of Warcraft',
        description: 'The most popular MMORPG.',
        imageUrl: 'assets/images/worldofwarcraft_card.jpg',
        tags: ['MMORPG', 'Fantasy'],
        dateReleased: '2004-11-23',
        company: 'Blizzard Entertainment',
        version: '1.0',
      ),
      Game(
        id: 6,
        name: 'Baldur\'s Gate 2',
        description: 'Classic D&D RPG adventure.',
        imageUrl: 'assets/images/baldursgate2_card.jpg',
        tags: ['RPG', 'Fantasy'],
        dateReleased: '2000-09-21',
        company: 'BioWare',
        version: '1.0',
      ),
      Game(
        id: 7,
        name: 'Diablo',
        description: 'Action RPG dungeon crawler.',
        imageUrl: 'assets/images/diablo_card.jpg',
        tags: ['RPG', 'Action'],
        dateReleased: '1996-12-31',
        company: 'Blizzard Entertainment',
        version: '1.0',
      ),
      Game(
        id: 8,
        name: 'Terraria',
        description: '2D sandbox adventure game.',
        imageUrl: 'assets/images/terraria_card.jpg',
        tags: ['Sandbox', 'Adventure'],
        dateReleased: '2011-05-16',
        company: 'Re-Logic',
        version: '1.0',
      ),
      Game(
        id: 9,
        name: 'Killzone 2',
        description: 'Futuristic first-person shooter.',
        imageUrl: 'assets/images/killzone2_card.jpg',
        tags: ['Shooter', 'Futuristic'],
        dateReleased: '2009-02-27',
        company: 'Guerrilla Games',
        version: '1.0',
      ),
    ];
    for (final game in sampleGames) {
      await insertGame(game);
    }
  }
}