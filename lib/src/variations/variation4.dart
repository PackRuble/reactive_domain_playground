import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_arch_app/src/domain/log_notifier.dart';
import 'package:riverpod_arch_app/src/ui/experiment_page.dart';

import '../domain/app_storage.dart';

// -----------------------------------------------------------------------------
// domain layer

class SettingsNotifier with ChangeNotifier {
  SettingsNotifier({
    required AppStorage appStorage,
  }) : _appStorage = appStorage {
    dlog('$SettingsNotifier init');
    themeColor = _appStorage.get(AppCards.themeColor);
    themeMode = _appStorage.get(AppCards.themeMode);
  }

  late Color themeColor;
  late ThemeMode themeMode;

  final AppStorage _appStorage;

  Future<void> changeThemeColor(Color color) async {
    themeColor = color;
    notifyListeners();

    await _appStorage.set<Color>(AppCards.themeColor, color);
  }

  Future<void> changeThemeMode(ThemeMode mode) async {
    themeMode = mode;
    notifyListeners();

    await _appStorage.set<ThemeMode>(AppCards.themeMode, mode);
  }

  @override
  void dispose() {
    dlog('$SettingsNotifier disposed');
    super.dispose();
  }
}

// -----------------------------------------------------------------------------
// ui layer

class Variation4 extends StatefulWidget {
  const Variation4({super.key});

  @override
  State<Variation4> createState() => _Variation4State();
}

class _Variation4State extends State<Variation4> {
  late final SettingsNotifier settingsNotifier;

  @override
  void didChangeDependencies() {
    // I use this method only because Riverpod is used everywhere for DI
    final appStorage =
        ProviderScope.containerOf(context).read(AppStorage.instance);
    settingsNotifier = SettingsNotifier(appStorage: appStorage);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    settingsNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. use this
    return ExperimentPage(
      pageBuilder: (builder) => ListenableBuilder(
        listenable: settingsNotifier,
        builder: (context, _) {
          return builder(
            context,
            themeColor: settingsNotifier.themeColor,
            themeMode: settingsNotifier.themeMode,
          );
        },
      ),
      themeModeWidget: ListenableBuilder(
        listenable: settingsNotifier,
        builder: (context, _) {
          final themeMode = settingsNotifier.themeMode;
          // 2. use this
          return ThemeModeSelector(
            mode: themeMode,
            onChange: settingsNotifier.changeThemeMode,
          );
        },
      ),
      themeColorWidget: ListenableBuilder(
        listenable: settingsNotifier,
        builder: (context, _) {
          final themeColor = settingsNotifier.themeColor;
          // 3. use this
          return ColorSelector(
            color: themeColor,
            onChange: settingsNotifier.changeThemeColor,
          );
        },
      ),
    );
  }
}
