import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_arch_app/home/home_page.dart';

import '../src1/domain.dart';

class Feature1 extends StatelessWidget {
  const Feature1({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. use this
    return HomePage(
      pageBuilder: (builder) => Consumer(
        builder: (context, ref, child) {
          final model = ref.watch(SettingsNotifier.instance);
          return builder(
            context,
            model.themeColor,
            model.themeMode,
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
