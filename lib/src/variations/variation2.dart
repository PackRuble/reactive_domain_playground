import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_arch_app/src/ui/experiment_page.dart';

import '../domain/app_storage.dart';

// -----------------------------------------------------------------------------
// domain layer

class SettingsNotifier {
  SettingsNotifier({required AppStorage appStorage}) : _appStorage = appStorage;

  static final instance = Provider.autoDispose<SettingsNotifier>(
    (ref) {
      final appStorage = ref.watch(AppStorage.instance);
      return SettingsNotifier(appStorage: appStorage);
    },
    name: '$SettingsNotifier',
  );

  final AppStorage _appStorage;

  // ignore: avoid_public_notifier_properties
  late final themeMode = Provider.autoDispose<ThemeMode>(
    (ref) => _appStorage.attach(
      AppCards.themeMode,
      (value) => ref.state = value,
      detacher: ref.onDispose,
    ),
    name: 'themeMode',
  );

  Future<void> changeThemeMode(ThemeMode mode) async =>
      _appStorage.set<ThemeMode>(AppCards.themeMode, mode);

  // ignore: avoid_public_notifier_properties
  late final themeColor = Provider.autoDispose<Color>(
    (ref) => _appStorage.attach(
      AppCards.themeColor,
      (value) => ref.state = value!,
      detacher: ref.onDispose,
    ),
    name: 'themeColor',
  );

  Future<void> changeThemeColor(Color color) async =>
      _appStorage.set<Color>(AppCards.themeColor, color);
}

// -----------------------------------------------------------------------------
// ui layer

class Variation2 extends StatelessWidget {
  const Variation2({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. use this
    return ExperimentPage(
      pageBuilder: (builder) => Consumer(
        builder: (context, ref, child) {
          final settingNotifier = ref.watch(SettingsNotifier.instance);
          final themeColor = ref.watch(settingNotifier.themeColor);
          final themeMode = ref.watch(settingNotifier.themeMode);
          return builder(
            context,
            themeColor: themeColor,
            themeMode: themeMode,
          );
        },
      ),
      themeModeWidget: Consumer(
        builder: (_, ref, __) {
          final settingNotifier = ref.watch(SettingsNotifier.instance);
          final themeMode = ref.watch(settingNotifier.themeMode);
          // 2. use this
          return ThemeModeSelector(
            mode: themeMode,
            onChange: (ThemeMode mode) async {
              await ref.read(SettingsNotifier.instance).changeThemeMode(mode);
            },
          );
        },
      ),
      themeColorWidget: Consumer(
        builder: (_, ref, __) {
          final settingNotifier = ref.watch(SettingsNotifier.instance);
          final themeColor = ref.watch(settingNotifier.themeColor);
          // 3. use this
          return ColorSelector(
            color: themeColor,
            onChange: (Color color) async {
              await ref.read(SettingsNotifier.instance).changeThemeColor(color);
            },
          );
        },
      ),
    );
  }
}
