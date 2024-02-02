import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'domain.dart';

class SRC1Page extends ConsumerWidget {
  const SRC1Page({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsModel = ref.watch(SettingsNotifier.instance);
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSeed(
          brightness: switch (settingsModel.themeMode) {
            ThemeMode.light => Brightness.light,
            ThemeMode.dark => Brightness.dark,
            _ => MediaQuery.platformBrightnessOf(context),
          },
          seedColor: settingsModel.themeColor,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Тип 1'),
        ),
        floatingActionButton: const _ThemeColorSelector(),
      ),
    );
  }
}

class _ThemeColorSelector extends ConsumerWidget {
  const _ThemeColorSelector({
    super.key,
  });

  static const colors = Colors.primaries;

  static const themeModes = <ThemeMode, IconData>{
    ThemeMode.light: Icons.light_mode_rounded,
    ThemeMode.dark: Icons.dark_mode_rounded,
    ThemeMode.system: Icons.contrast_rounded,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = ref.watch(
      SettingsNotifier.instance.select((value) => value.themeColor),
    );

    final themeMode = ref.watch(
      SettingsNotifier.instance.select((value) => value.themeMode),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CyclicSelectorButton(
          items: themeModes.keys.toList(),
          current: themeMode,
          onNext: ref.read(SettingsNotifier.instance.notifier).changeThemeMode,
          child: Icon(themeModes[themeMode]),
        ),
        const SizedBox(height: 16.0),
        CyclicSelectorButton(
          items: colors,
          current: color,
          onNext: ref.read(SettingsNotifier.instance.notifier).changeColorTheme,
          child: Icon(
            color: color,
            Icons.circle_rounded,
          ),
        ),
      ],
    );
  }
}

class CyclicSelectorButton<T> extends StatelessWidget {
  const CyclicSelectorButton({
    super.key,
    required this.items,
    required this.onNext,
    required this.current,
    required this.child,
  });

  final T current;
  final List<T> items;
  final Function(T) onNext;
  final Widget child;

  void _onNext() => onNext.call(
        items[(items.indexWhere((el) => current == el) + 1) % items.length],
      );

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: '$current',
      onPressed: _onNext,
      child: child,
    );
  }
}
