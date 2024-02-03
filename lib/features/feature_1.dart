import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_arch_app/home/home_page.dart';

import '../src1/domain.dart';
//
// typedef ColorBuilder = Widget Function(BuildContext context, Color color);
// typedef ThemeBuilder = Widget Function(BuildContext context, ThemeMode mode);

class Feature1 extends StatelessWidget {
  const Feature1({super.key});

  @override
  Widget build(BuildContext context) {
    return HomePage(
      pageSelectorBuilder: ({required builder}) {
        return Consumer(
          builder: (context, ref, child) {
            final model = ref.watch(SettingsNotifier.instance);
            return builder(
              context,
              model.themeColor,
              model.themeMode,
            );
          },
        );
      },
      colorSelector: (_, colorSelectorBuilder) {
        return Consumer(
          builder: (_, ref, __) {
            final color = ref.watch(
              SettingsNotifier.instance.select((value) => value.themeColor),
            );
            return colorSelectorBuilder(
              type: color,
              onChange: (Color color) async {
                await ref
                    .read(SettingsNotifier.instance.notifier)
                    .changeColorTheme(color);
              },
            );
          },
        );
      },
      modeSelectorBuilder: (_, modeSelectorBuilder) {
        return Consumer(
          builder: (_, ref, __) {
            final mode = ref.watch(
              SettingsNotifier.instance.select((value) => value.themeMode),
            );
            return modeSelectorBuilder(
              type: mode,
              onChange: (ThemeMode mode) async {
                await ref
                    .read(SettingsNotifier.instance.notifier)
                    .changeThemeMode(mode);
              },
            );
          },
        );
      },

    );
  }
}
