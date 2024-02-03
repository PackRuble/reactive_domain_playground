import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_arch_app/domain/log_notifier.dart';

import 'domain.dart';

class SRC1Page extends ConsumerWidget {
  const SRC1Page({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsModel = ref.watch(SettingsNotifier.instance);

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref
    //       .read(LogNotifier.instance.notifier)
    //       .l('[W]: $SRC1Page build with $settingsModel');
    // });

    xlog('[W]: $SRC1Page build with $settingsModel');

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: settingsModel.themeColor,
          brightness: switch (settingsModel.themeMode) {
            ThemeMode.light => Brightness.light,
            ThemeMode.dark => Brightness.dark,
            _ => MediaQuery.platformBrightnessOf(context),
          },
        ),
      ),
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          final textTheme = theme.textTheme;

          return Scaffold(
            backgroundColor: theme.colorScheme.inverseSurface,
            appBar: AppBar(
              backgroundColor: theme.colorScheme.secondary,
              foregroundColor: theme.colorScheme.onSecondary,
              title: Text('${settingsModel.themeMode.name} mode'),
              titleTextStyle: textTheme.headlineSmall!.copyWith(
                color: theme.colorScheme.onSecondary,
              ),
              actions: [
                IconButton.filledTonal(
                  color: theme.colorScheme.secondary,
                  onPressed: () {
                    LogNotifier.clear();
                    ref.invalidate(LogNotifier.instance);
                  },
                  icon: const Icon(Icons.cleaning_services_rounded),
                ),
                const SizedBox(width: 8.0),
              ],
            ),
            floatingActionButton: const _SettingsSelectors(),
            body: const ListViewBody(),
          );
        },
      ),
    );
  }
}

class ListViewBody extends ConsumerStatefulWidget {
  const ListViewBody({super.key});

  @override
  ConsumerState<ListViewBody> createState() => _ListViewBodyState();
}

class _ListViewBodyState extends ConsumerState<ListViewBody> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        // ignore: discarded_futures
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 500),
        );
      }
    });

    final logs = ref.watch(LogNotifier.instance);
    return ListView.builder(
      controller: _scrollController,
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final tile = ListTile(
          leading: Text((index).toString()),
          title: Text(logs[index]),
          titleTextStyle: textTheme.bodySmall!.copyWith(
            color: theme.colorScheme.onInverseSurface,
          ),
          leadingAndTrailingTextStyle: textTheme.bodySmall!.copyWith(
            color: theme.colorScheme.onInverseSurface,
          ),
        );
        if (index == logs.length - 1) {
          return Column(
            children: [
              tile,
              const SizedBox(height: 80),
            ],
          );
        } else {
          return tile;
        }
      },
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Consumer(
          builder: (context, ref, child) {
            final themeMode = ref.watch(
              SettingsNotifier.instance.select((value) => value.themeMode),
            );

            // WidgetsBinding.instance.addPostFrameCallback((_) {
            //   ref
            //       .watch(LogNotifier.instance.notifier)
            //       .l('[W]: ThemeModeSelector build with $themeMode');
            // });

            xlog('[W]: ThemeModeSelector build with $themeMode');

            return CyclicSelectorButton(
              items: themeModes.keys.toList(),
              current: themeMode,
              onNext:
                  ref.read(SettingsNotifier.instance.notifier).changeThemeMode,
              child: Icon(themeModes[themeMode]),
            );
          },
        ),
        const SizedBox(width: 16.0),
        Consumer(
          builder: (context, ref, child) {
            final color = ref.watch(
              SettingsNotifier.instance.select((value) => value.themeColor),
            );

            // WidgetsBinding.instance.addPostFrameCallback((_) {
            //   ref
            //       .watch(LogNotifier.instance.notifier)
            //       .l('[W]: ColorSelector build with $color');
            // });

            xlog('[W]: ColorSelector build with $color');

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
