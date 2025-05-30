import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final Widget? netImgLg;
  final String? apiName;
  final String? apiEmail;
  final double headLine2;
  final double body;
  final Color themeBG;
  final Color themeGrey;
  final Color themeMain;
  final Color themeLite;
  final bool keepScreenOn;
  final bool useLargeTexts;
  final bool darkMode;
  final ValueChanged<bool>? onKeepScreenOnChanged;
  final ValueChanged<bool>? onUseLargeTextsChanged;
  final ValueChanged<bool>? onDarkModeChanged;
  final VoidCallback? onSignOutTap;

  const SettingsPage({
    super.key,
    this.netImgLg,
    this.apiName,
    this.apiEmail,
    required this.headLine2,
    required this.body,
    required this.themeBG,
    required this.themeGrey,
    required this.themeMain,
    required this.themeLite,
    required this.keepScreenOn,
    required this.useLargeTexts,
    required this.darkMode,
    this.onKeepScreenOnChanged,
    this.onUseLargeTextsChanged,
    this.onDarkModeChanged,
    this.onSignOutTap,
  });

  static const EdgeInsets _settingsItemPadding = EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 12);
  static const TextStyle _settingsItemTextStyle = TextStyle(fontSize: 18.0);
  static const EdgeInsets _signOutPadding = EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 24);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: themeMain,
      ),
      backgroundColor: themeBG,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
            child: Row(
              children: [
                netImgLg ?? const SizedBox.shrink(),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        apiName ?? '',
                        style: TextStyle(
                          fontSize: headLine2,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        apiEmail ?? '',
                        style: TextStyle(
                          fontSize: body,
                          color: themeGrey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(thickness: 1.0),
          Padding(
            padding: _settingsItemPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Dark mode", style: _settingsItemTextStyle),
                    Switch(
                      value: darkMode,
                      activeColor: themeMain,
                      activeTrackColor: themeLite,
                      onChanged: onDarkModeChanged,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Keep screen on", style: _settingsItemTextStyle),
                    Switch(
                      value: keepScreenOn,
                      activeColor: themeMain,
                      activeTrackColor: themeLite,
                      onChanged: onKeepScreenOnChanged,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Use large texts", style: _settingsItemTextStyle),
                    Switch(
                      value: useLargeTexts,
                      activeColor: themeMain,
                      activeTrackColor: themeLite,
                      onChanged: onUseLargeTextsChanged,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(thickness: 1.0),
          InkWell(
            onTap: onSignOutTap,
            child: Padding(
              padding: _signOutPadding,
              child: const Text(
                "Sign out",
                style: _settingsItemTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 