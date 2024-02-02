import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'domain.dart';

class SRC1Page extends ConsumerWidget {
  const SRC1Page({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsModel = ref.watch(SettingsNotifier.instance);

    log('$SRC1Page build with $settingsModel');
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
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          final textTheme = theme.textTheme;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: theme.colorScheme.primary,
              title: Text(settingsModel.themeMode.name),
              titleTextStyle: textTheme.headlineSmall!.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
            floatingActionButton: const _SettingsSelectors(),
          );
        },
      ),
    );
  }
}

class _SettingsSelectors extends StatelessWidget {
  const _SettingsSelectors({super.key});

  static const colors = Colors.primaries;

  static const themeModes = <ThemeMode, IconData>{
    ThemeMode.light: Icons.light_mode_rounded,
    ThemeMode.dark: Icons.dark_mode_rounded,
    ThemeMode.system: Icons.contrast_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Consumer(
          builder: (context, ref, child) {
            final themeMode = ref.watch(
              SettingsNotifier.instance.select((value) => value.themeMode),
            );

            log('$_SettingsSelectors build with $themeMode');

            return CyclicSelectorButton(
              items: themeModes.keys.toList(),
              current: themeMode,
              onNext:
                  ref.read(SettingsNotifier.instance.notifier).changeThemeMode,
              child: Icon(themeModes[themeMode]),
            );
          },
        ),
        const SizedBox(height: 16.0),
        Consumer(
          builder: (context, ref, child) {
            final color = ref.watch(
              SettingsNotifier.instance.select((value) => value.themeColor),
            );

            log('$_SettingsSelectors build with $color');

            return CyclicSelectorButton(
              items: colors,
              current: color,
              onNext:
                  ref.read(SettingsNotifier.instance.notifier).changeColorTheme,
              child: Icon(color: color, Icons.circle_rounded, size: 30.0),
            );
          },
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
