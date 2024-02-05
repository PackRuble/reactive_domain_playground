import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_arch_app/src/ui/experiment_page.dart';

import '../domain/app_storage.dart';

// -----------------------------------------------------------------------------
// domain layer

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
    return '{$themeMode, ${themeColor.value}}';
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

// -----------------------------------------------------------------------------
// ui layer

class Variation1 extends StatelessWidget {
  const Variation1({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. use this
    return ExperimentPage(
      pageBuilder: (builder) => Consumer(
        builder: (context, ref, child) {
          final model = ref.watch(SettingsNotifier.instance);
          return builder(
            context,
            themeColor: model.themeColor,
            themeMode: model.themeMode,
          );
        },
      ),
      themeModeWidget: Consumer(
        builder: (_, ref, __) {
          final mode = ref.watch(
            SettingsNotifier.instance.select((value) => value.themeMode),
          );
          // 2. use this
          return ThemeModeSelector(
            mode: mode,
            onChange: (ThemeMode mode) async {
              await ref
                  .read(SettingsNotifier.instance.notifier)
                  .changeThemeMode(mode);
            },
          );
        },
      ),
      themeColorWidget: Consumer(
        builder: (_, ref, __) {
          final color = ref.watch(
            SettingsNotifier.instance.select((value) => value.themeColor),
          );
          // 3. use this
          return ColorSelector(
            color: color,
            onChange: (Color color) async {
              await ref
                  .read(SettingsNotifier.instance.notifier)
                  .changeColorTheme(color);
            },
          );
        },
      ),
    );
  }
}
