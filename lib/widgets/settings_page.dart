import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:flutter/services.dart';

class SettingsPage extends StatefulWidget {
  final ValueChanged<bool>? onDarkModeChanged;
  const SettingsPage({super.key, this.onDarkModeChanged});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = false;
  bool _keepScreenOn = false;
  bool _useLargeTexts = false;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool('darkMode') ?? false;
      _keepScreenOn = prefs.getBool('keepScreenOn') ?? false;
      _useLargeTexts = prefs.getBool('useLargeTexts') ?? false;
    });
    WakelockPlus.toggle(enable: _keepScreenOn);
  }

  Future<void> _setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
    setState(() {
      _darkMode = value;
    });
    if (widget.onDarkModeChanged != null) {
      widget.onDarkModeChanged!(value);
    } else {
      (context as Element).markNeedsBuild();
    }
  }

  Future<void> _setKeepScreenOn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('keepScreenOn', value);
    setState(() {
      _keepScreenOn = value;
    });
    WakelockPlus.toggle(enable: value);
  }

  Future<void> _setUseLargeTexts(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useLargeTexts', value);
    setState(() {
      _useLargeTexts = value;
    });
  }

  void _signOut() {
    SystemNavigator.pop();
  }

  Color get bgColor => _darkMode ? const Color(0xFF181A20) : const Color(0xFFF5F6FA);
  Color get cardColor => _darkMode ? const Color(0xFF23262F) : Colors.white;
  Color get textColor => _darkMode ? Colors.white : Colors.black;
  Color get subTextColor => _darkMode ? Colors.grey[400]! : Colors.grey[800]!;
  Color get accentColor => Colors.deepPurple;

  @override
  Widget build(BuildContext context) {
    final double headLine2 = _useLargeTexts ? 34.0 : 22.0;
    final double body = _useLargeTexts ? 20.0 : 16.0;
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: textColor)),
        backgroundColor: accentColor,
        iconTheme: IconThemeData(color: textColor),
      ),
      backgroundColor: bgColor,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Game Hub',
                  style: TextStyle(
                    fontSize: headLine2,
                    color: textColor,
                  ),
                ),
                Text(
                  'gamehub@app.com',
                  style: TextStyle(
                    fontSize: body,
                    color: subTextColor,
                  ),
                ),
              ],
            ),
          ),
          const Divider(thickness: 1.0),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Dark mode (in development)", style: TextStyle(fontSize: 18.0, color: textColor)),
                    Switch(
                      value: _darkMode,
                      activeColor: accentColor,
                      activeTrackColor: accentColor.withOpacity(0.2),
                      onChanged: _setDarkMode,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Keep screen on", style: TextStyle(fontSize: 18.0, color: textColor)),
                    Switch(
                      value: _keepScreenOn,
                      activeColor: accentColor,
                      activeTrackColor: accentColor.withOpacity(0.2),
                      onChanged: _setKeepScreenOn,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Use large texts", style: TextStyle(fontSize: 18.0, color: textColor)),
                    Switch(
                      value: _useLargeTexts,
                      activeColor: accentColor,
                      activeTrackColor: accentColor.withOpacity(0.2),
                      onChanged: _setUseLargeTexts,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(thickness: 1.0),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 24),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: textColor,
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: _signOut,
              child: Text('Sign out', style: TextStyle(color: textColor)),
            ),
          ),
        ],
      ),
    );
  }
} 