import 'package:flutter/material.dart' show Color, ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data.dart';

class SettingsModel {
  final ThemeMode themeMode;
  final Color themeColor;

  SettingsModel({required this.themeMode, required this.themeColor});

  SettingsModel copyWith({
    ThemeMode? themeMode,
    Color? themeColor,
  }) {
    return SettingsModel(
      themeMode: themeMode ?? this.themeMode,
      themeColor: themeColor ?? this.themeColor,
    );
  }

  @override
  String toString() {
    return 'SettingsModel{themeMode: $themeMode, themeColor: $themeColor}';
  }
}

class SettingsNotifier extends AutoDisposeNotifier<SettingsModel> {
  static final instance =
      AutoDisposeNotifierProvider<SettingsNotifier, SettingsModel>(
    SettingsNotifier.new,
    name: '$SettingsNotifier',
  );

  late AppStorage _appStorage;

  @override
  SettingsModel build() {
    _appStorage = ref.watch(AppStorage.instance);

    return SettingsModel(
      themeMode: _appStorage.attach(
        AppCards.themeMode,
        (value) => state = state.copyWith(themeMode: value),
        detacher: ref.onDispose,
      ),
      themeColor: _appStorage.attach(
        AppCards.themeColor,
        (value) => state = state.copyWith(themeColor: value),
        detacher: ref.onDispose,
      ),
    );
  }

  Future<void> changeThemeMode(ThemeMode mode) async =>
      _appStorage.set<ThemeMode>(AppCards.themeMode, mode);

  Future<void> changeColorTheme(Color color) async =>
      _appStorage.set<Color>(AppCards.themeColor, color);
}
