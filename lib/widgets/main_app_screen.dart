import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

import 'package:wakelock_plus/wakelock_plus.dart';

import '../widgets/loading_screen.dart';
import '../widgets/personal_island.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import 'authentication_screen.dart';
import 'settings_page.dart';

import '../services/database.dart';
import '../models/account.dart';
import '../models/game.dart';
import '../models/user_game.dart';
import 'home_page.dart';
import 'game_page.dart';
import 'profile_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  void _setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
    setState(() {
      _darkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loqosaurus',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green, brightness: Brightness.light),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
      home: const MyHomePage(title: 'For the smart people.'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  final void Function()? onOpenSettings;
  const MyHomePage({super.key, required this.title, this.onOpenSettings});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // variables
  final uuid = const Uuid();

  static const Color _themeBG = Color(0xfff5f5f5);
  static const Color _themeMain = Color(0xff7fb902);
  static const Color _themeLite = Color(0xffdbebb7);
  static const Color _themeGrey = Color(0xff505050);

  late bool _keepScreenOn = false;
  late bool _useLargeTexts = false;
  late double _extraLarge = 36.0;
  late double _headLine2 = 22.0;
  late double _headLine3 = 20.0;
  late double _body = 16.0;

  bool _isLoading = true;
  bool _isOfflineMode = true;
  bool _isConnectionLost = false;
  bool _isSignedIn = false;
  bool _isAdmin = false;
  int _selectedIndex = 0;
  late Widget _signingScreen;
  late Widget _loadingScreen = SizedBox();
  late Widget _dashboardScreen = Container();
  late Widget _currentScreen;

  late Account _signedAccount;
  Widget _netImgSm = const SizedBox(width: 15.0);
  Widget _netImgLg = const SizedBox(width: 30.0);
  String _apiPhotoUrl = '';
  String _apiEmail = '';
  String _fullName = '';

  List<Game> _games = [];
  Map<int, UserGame> _userGames = {};
  String _userId = 'demo_user'; // TODO: Replace with real user id from account

  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
    _initializeRequirements();
    _populateAndLoadGames();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  Future<void> _setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
    setState(() {
      _darkMode = value;
    });
  }

  Future<void> _setLastUserId(String uuid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastUserId', uuid);
  }

  Future<String?> _getLastUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('lastUserId');
  }

  // UI methods

  void _handleNavItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _buildHomePage();
  }

  void _handleAppSettingsTap() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SettingsPage(
        netImgLg: _netImgLg,
        apiName: _fullName,
        apiEmail: _apiEmail,
        headLine2: _headLine2,
        body: _body,
        themeBG: _darkMode ? Colors.black : _themeBG,
        themeGrey: _themeGrey,
        themeMain: _themeMain,
        themeLite: _themeLite,
        keepScreenOn: _keepScreenOn,
        useLargeTexts: _useLargeTexts,
        darkMode: _darkMode,
        onDarkModeChanged: _setDarkMode,
        onKeepScreenOnChanged: (newValue) {
          setState(() {
            _keepScreenOn = newValue;
          });
          WakelockPlus.toggle(enable: _keepScreenOn);
        },
        onUseLargeTextsChanged: (newValue) {
          setState(() {
            _useLargeTexts = newValue;
          });
          _rescaleFontSizes();
        },
        onSignOutTap: () async {
          await DatabaseService().clearAccounts();
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('lastUserId');
          setState(() {
            _isSignedIn = false;
            _selectedIndex = 0;
          });
          SystemNavigator.pop();
        },
      ),
    ));
  }

  Future<void> _rescaleFontSizes() async {
    setState(() {
      _extraLarge = _useLargeTexts ? 54.0 : 32.0;
      _headLine2 = _useLargeTexts ? 34.0 : 22.0;
      _headLine3 = _useLargeTexts ? 24.0 : 20.0;
      _body = _useLargeTexts ? 20.0 : 16.0;
    });
  }

  Widget _buildProfileImage({required double radius}) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white,
      child: _apiPhotoUrl.isEmpty
          ? const Icon(Icons.person, color: Colors.blueAccent)
          : ClipOval(
        child: Image.network(
          _apiPhotoUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.error_outline, color: Colors.red);
          },
        ),
      ),
    );
  }

  Future<void> _loadNetImg() async {
    if (!_isOfflineMode && _isSignedIn) {
      try {
        final netImgSm = _buildProfileImage(radius: 15);
        final netImgLg = _buildProfileImage(radius: 30);

        setState(() {
          _netImgSm = netImgSm;
          _netImgLg = netImgLg;
        });
      } catch (e) {
        setState(() {
          _netImgSm = const SizedBox(width: 15.0);
          _netImgLg = const SizedBox(width: 30.0);
        });
      }
    } else {
      setState(() {
        _netImgSm = const SizedBox(width: 15.0);
        _netImgLg = const SizedBox(width: 30.0);
      });
    }
  }

  Future<void> _showAppOfflineDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
        title: Text(
          "Device is Offline",
          style: TextStyle(
            fontSize: _headLine2,
          ),
        ),
        content: Text(
          "Please check your internet connection.",
          style: TextStyle(
            fontSize: _body,
          ),
        ),
        actions: [
        TextButton(
        onPressed: () async {
      setState(() => _isConnectionLost = true);
      Navigator.of(context).pop();
      _checkInternetConnection();
        },
          child: Text(
            "Retry",
            style: TextStyle(
              fontSize: _body,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ],
        ),
    );
  }

  Future<void> _buildAuthenticationScreen() async {
    _loadingScreen = LoadingScreen(size: 80.0, color: _themeMain);
    _signingScreen = AuthenticationScreen(
      onSignedIn: () {
        setState(() => _isSignedIn = true);
        _checkSignedAccount();
        _loadNetImg();
      },
    );
    _updateCurrentScreen();
  }

  Future<void> _buildHomePage() async {
    WakelockPlus.toggle(enable: _keepScreenOn);

    _dashboardScreen = Scaffold(
        body: Stack(
        children: [
        PersonalIsland(
        netImgSm: _netImgSm,
        apiName: _fullName,
        themeLite: _themeLite,
        headLine3: _headLine3,
        isSignedIn: _isSignedIn,
        onAppSettingsTap: _handleAppSettingsTap,
    ),
    Center(
    child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
    Text(
    'Loqosaurus',
    style: TextStyle(
    fontSize: _extraLarge,
    fontWeight: FontWeight.bold,
    fontFamily: 'Barriecito',
    color: _themeMain,
    ),
    ),
    const SizedBox(width: 12.0),
    Text(
    'v1.0',
    style: TextStyle(
    fontSize: _body,
    color: _themeGrey,
    ),
    ),
    ],
    ),
    ),
    ],
    ),
    bottomNavigationBar: CustomBottomNavBar(
    themeLite: _themeLite,
    themeDark: _themeMain,
    themeGrey: _themeGrey,
    navItem: _selectedIndex,
    isAdminMode: _isAdmin,
      isSignedIn: _isSignedIn,
      hideAdminFeatures: !_isAdmin,
      isFullyLoaded: !_isLoading,
      onItemSelected: _handleNavItemSelected,
    ),
    );
    _updateCurrentScreen();
  }

  void _updateCurrentScreen() {
    setState(() => _currentScreen = _isSignedIn ? _dashboardScreen : _signingScreen);
  }

  // helpers and utilities
  Future<void> _checkInternetConnection() async {
    setState(() => _isLoading = true);

    bool connected = false;
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 15));
      connected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;

      if (_isConnectionLost) {
        setState(() => _isConnectionLost = false);
        _initializeRequirements();
      }
    } catch (_) {
      _showAppOfflineDialog();
    }

    setState(() {
      _isOfflineMode = !connected;
      _isLoading = false;
    });
  }

  Future<void> _checkSignedAccount() async {
    final accounts = await DatabaseService().getSignedAccount();
    if (accounts.isEmpty) {
      // Try auto-login from prefs
      final lastUserId = await _getLastUserId();
      if (lastUserId != null) {
        final accs = await DatabaseService().getAccount(lastUserId);
        if (accs.isNotEmpty) {
          final acc = accs.first;
          acc.isSignedIn = 1;
          await DatabaseService().updateAccount(acc);
          await _setLastUserId(acc.uuid);
          setState(() {
            _signedAccount = acc;
            _userId = acc.uuid;
            _fullName = acc.apiName!;
            _apiEmail = acc.apiEmail!;
            _apiPhotoUrl = acc.apiPhotoUrl!;
            _isAdmin = (acc.userLevel! >= 2);
            _isSignedIn = true;
          });
          _buildHomePage();
          return;
        }
      }
      setState(() => _isSignedIn = false);
      _buildHomePage();
      return;
    }
    setState(() {
      _signedAccount = accounts.first;
      _userId = _signedAccount.uuid;
      _fullName = _signedAccount.apiName!;
      _apiEmail = _signedAccount.apiEmail!;
      _apiPhotoUrl = _signedAccount.apiPhotoUrl!;
      _isAdmin = (_signedAccount.userLevel! >= 2);
      _isSignedIn = true;
    });
    _setLastUserId(_signedAccount.uuid);
    _buildHomePage();
  }

  Future<void> _loadGamesAndUserGames() async {
    final db = DatabaseService();
    final games = await db.getGames();
    final userGames = await db.getUserGames(_userId);
    setState(() {
      _games = games;
      _userGames = {for (var ug in userGames) ug.gameId: ug};
    });
  }

  Future<void> _populateAndLoadGames() async {
    await DatabaseService().populateSampleGames();
    await _loadGamesAndUserGames();
  }

  void _onGameTap(Game game) async {
    final userGame = _userGames[game.id] ?? UserGame(gameId: game.id, userId: _userId);
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => GamePage(
        game: game,
        rating: userGame.rating,
        played: userGame.played,
        onRatingChanged: (newRating) async {
          final updated = UserGame(gameId: game.id, userId: _userId, rating: newRating, played: userGame.played);
          await DatabaseService().upsertUserGame(updated);
          setState(() => _userGames[game.id] = updated);
        },
        onPlayedChanged: (newPlayed) async {
          final updated = UserGame(gameId: game.id, userId: _userId, rating: userGame.rating, played: newPlayed);
          await DatabaseService().upsertUserGame(updated);
          setState(() => _userGames[game.id] = updated);
        },
      ),
    ));
    await _loadGamesAndUserGames();
  }

  // system methods
  Future<void> _initializeRequirements() async {
    await _checkInternetConnection();
    await _buildAuthenticationScreen();
    await _checkSignedAccount();
  }

  @override
  Widget build(BuildContext context) {
    // Compute average ratings and popularity
    Map<int, double> avgRatings = {};
    Map<int, int> playedCounts = {};
    for (var game in _games) {
      final userGame = _userGames[game.id];
      avgRatings[game.id] = userGame?.rating ?? 0;
      playedCounts[game.id] = userGame?.played == true ? 1 : 0;
    }
    final highestRated = List<Game>.from(_games)
      ..sort((a, b) => (avgRatings[b.id] ?? 0).compareTo(avgRatings[a.id] ?? 0));
    final popular = List<Game>.from(_games)
      ..sort((a, b) => (playedCounts[b.id] ?? 0).compareTo(playedCounts[a.id] ?? 0));
    final other = _games.where((g) => !highestRated.take(5).contains(g) && !popular.take(5).contains(g)).toList();

    final playedGames = _games.where((g) => _userGames[g.id]?.played == true).toList();
    final ratedGames = _games.where((g) => (_userGames[g.id]?.rating ?? 0) > 0).toList();

    return Scaffold(
      body: _selectedIndex == 0
          ? HomePage(
              games: _games,
              userGames: _userGames,
              onGameTap: _onGameTap,
              onRatingChanged: (game, rating) async {
                final userGame = _userGames[game.id] ?? UserGame(gameId: game.id, userId: _userId);
                final updated = UserGame(gameId: game.id, userId: _userId, rating: rating, played: userGame.played);
                await DatabaseService().upsertUserGame(updated);
                setState(() => _userGames[game.id] = updated);
              },
              onPlayedChanged: (game, played) async {
                final userGame = _userGames[game.id] ?? UserGame(gameId: game.id, userId: _userId);
                final updated = UserGame(gameId: game.id, userId: _userId, rating: userGame.rating, played: played);
                await DatabaseService().upsertUserGame(updated);
                setState(() => _userGames[game.id] = updated);
              },
              highestRated: highestRated.take(5).toList(),
              popular: popular.take(5).toList(),
              other: other,
            )
          : _selectedIndex == 1
          ? ProfilePage(
              playedGames: playedGames,
              ratedGames: ratedGames,
              userGames: _userGames,
              onGameTap: _onGameTap,
              onRatingChanged: (game, rating) async {
                final userGame = _userGames[game.id] ?? UserGame(gameId: game.id, userId: _userId);
                final updated = UserGame(gameId: game.id, userId: _userId, rating: rating, played: userGame.played);
                await DatabaseService().upsertUserGame(updated);
                setState(() => _userGames[game.id] = updated);
              },
              onPlayedChanged: (game, played) async {
                final userGame = _userGames[game.id] ?? UserGame(gameId: game.id, userId: _userId);
                final updated = UserGame(gameId: game.id, userId: _userId, rating: userGame.rating, played: played);
                await DatabaseService().upsertUserGame(updated);
                setState(() => _userGames[game.id] = updated);
              },
            )
          : SettingsPage(
              netImgLg: _netImgLg,
              apiName: _fullName,
              apiEmail: _apiEmail,
              headLine2: _headLine2,
              body: _body,
              themeBG: _darkMode ? Colors.black : _themeBG,
              themeGrey: _themeGrey,
              themeMain: _themeMain,
              themeLite: _themeLite,
              keepScreenOn: _keepScreenOn,
              useLargeTexts: _useLargeTexts,
              darkMode: _darkMode,
              onDarkModeChanged: _setDarkMode,
              onKeepScreenOnChanged: (newValue) {
                setState(() {
                  _keepScreenOn = newValue;
                });
                WakelockPlus.toggle(enable: _keepScreenOn);
              },
              onUseLargeTextsChanged: (newValue) {
                setState(() {
                  _useLargeTexts = newValue;
                });
                _rescaleFontSizes();
              },
              onSignOutTap: () async {
                await DatabaseService().clearAccounts();
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('lastUserId');
                setState(() {
                  _isSignedIn = false;
                  _selectedIndex = 0;
                });
                SystemNavigator.pop();
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}