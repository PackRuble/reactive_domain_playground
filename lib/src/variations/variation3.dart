import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_domain_playground/src/ui/experiment_page.dart';

import '../domain/app_storage.dart';

// -----------------------------------------------------------------------------
// domain layer

class ThemeModeNotifier extends AutoDisposeNotifier<ThemeMode> {
  static final instance =
      AutoDisposeNotifierProvider<ThemeModeNotifier, ThemeMode>(
    ThemeModeNotifier.new,
    name: '$ThemeModeNotifier',
  );

  late AppStorage _appStorage;

  @override
  ThemeMode build() {
    _appStorage = ref.watch(AppStorage.instance);

    return _appStorage.attach(
      AppCards.themeMode,
      (value) => state = value,
      detacher: ref.onDispose,
    );
  }

  Future<void> changeThemeMode(ThemeMode mode) async =>
      _appStorage.set<ThemeMode>(AppCards.themeMode, mode);
}

class ThemeColorNotifier extends AutoDisposeNotifier<Color> {
  static final instance =
      AutoDisposeNotifierProvider<ThemeColorNotifier, Color>(
    ThemeColorNotifier.new,
    name: '$ThemeColorNotifier',
  );

  late AppStorage _appStorage;

  @override
  Color build() {
    _appStorage = ref.watch(AppStorage.instance);

    return _appStorage.attach(
      AppCards.themeColor,
      (value) => state = value,
      detacher: ref.onDispose,
    );
  }

  Future<void> changeThemeColor(Color color) async =>
      _appStorage.set<Color>(AppCards.themeColor, color);
}

// -----------------------------------------------------------------------------
// ui layer

class Variation3 extends StatelessWidget {
  const Variation3({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. use this
    return ExperimentPage(
      pageBuilder: (builder) => Consumer(
        builder: (context, ref, child) {
          final themeColor = ref.watch(ThemeColorNotifier.instance);
          final themeMode = ref.watch(ThemeModeNotifier.instance);
          return builder(
            context,
            themeColor: themeColor,
            themeMode: themeMode,
          );
        },
      ),
      themeModeWidget: Consumer(
        builder: (_, ref, __) {
          final themeMode = ref.watch(ThemeModeNotifier.instance);
          // 2. use this
          return ThemeModeSelector(
            mode: themeMode,
            onChange:
                ref.read(ThemeModeNotifier.instance.notifier).changeThemeMode,
          );
        },
      ),
      themeColorWidget: Consumer(
        builder: (_, ref, __) {
          final themeColor = ref.watch(ThemeColorNotifier.instance);
          // 3. use this
          return ColorSelector(
            color: themeColor,
            onChange:
                ref.read(ThemeColorNotifier.instance.notifier).changeThemeColor,
          );
        },
      ),
    );
  }
}
