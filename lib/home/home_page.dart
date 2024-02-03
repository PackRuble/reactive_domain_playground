import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_arch_app/domain/log_notifier.dart';

import '../src1/domain.dart';

typedef SelectorBuilder<Type, SelectWidget> = Widget Function(
  BuildContext context,
  SelectWidget Function({
    required Type type,
    required void Function(Type type) onChange,
  }) selectorBuilder,
);

class HomePage extends ConsumerWidget {
  const HomePage({
    super.key,
    required this.pageSelectorBuilder,
    required this.colorSelector,
    required this.modeSelectorBuilder,
  });

  final SelectorBuilder<Color, _ColorSelector> colorSelector;
  final SelectorBuilder<ThemeMode, _ThemeSelector> modeSelectorBuilder;

  // final Widget Function(
  //   BuildContext context,
  //   _ThemeSelector Function({
  //     required ThemeMode mode,
  //     required void Function(ThemeMode) onChange,
  //   }) modeSelectorBuilder,
  // ) themeSelector;
  //
  final Widget Function({
    required Widget Function(
      BuildContext context,
      Color color,
      ThemeMode mode,
    ) builder,
  }) pageSelectorBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return pageSelectorBuilder(
      builder: (context, color, mode) {
        xlog('[W]: $HomePage build with $mode & $color');

        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: color,
              brightness: switch (mode) {
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
                  title: Text('<${mode.name}> mode'),
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
                floatingActionButton: SelectorsWidget(
                  colorBuilder: colorSelector,
                  themeBuilder: modeSelectorBuilder,
                ),
                body: const ListViewBody(),
              );
            },
          ),
        );
      },
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
  int lastIndex = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final logs = ref.watch(LogNotifier.instance);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      lastIndex = logs.length - 1;
      if (_scrollController.hasClients) {
        // ignore: discarded_futures
        await _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 500),
        );
      }
    });

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
          tileColor: index >= lastIndex ? theme.colorScheme.error : null,
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

class SelectorsWidget extends StatelessWidget {
  const SelectorsWidget({
    super.key,
    required this.colorBuilder,
    required this.themeBuilder,
  });

  final SelectorBuilder<Color, _ColorSelector> colorBuilder;
  final SelectorBuilder<ThemeMode, _ThemeSelector> themeBuilder;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        themeBuilder(
          context,
          ({required onChange, required type}) {
            xlog('[W]: $_ThemeSelector build with $type');
            return _ThemeSelector(onChange: onChange, mode: type);
          },
        ),
        const SizedBox(width: 16.0),
        colorBuilder(
          context,
          ({required onChange, required type}) {
            xlog('[W]: $_ColorSelector build with $type');
            return _ColorSelector(onChange: onChange, color: type);
          },
        ),
      ],
    );
  }
}

class _ColorSelector extends CyclicSelectorButton<Color> {
  _ColorSelector({
    required void Function(Color color) onChange,
    required Color color,
  }) : super(
          onNext: onChange,
          child: Icon(color: color, Icons.circle_rounded, size: 30.0),
          current: color,
          items: Colors.primaries,
        );
}

class _ThemeSelector extends CyclicSelectorButton<ThemeMode> {
  _ThemeSelector({
    required void Function(ThemeMode mode) onChange,
    required ThemeMode mode,
  }) : super(
          onNext: onChange,
          child: Icon(themeModes[mode]),
          current: mode,
          items: themeModes.keys.toList(),
        );

  static const themeModes = <ThemeMode, IconData>{
    ThemeMode.light: Icons.light_mode_rounded,
    ThemeMode.dark: Icons.dark_mode_rounded,
    ThemeMode.system: Icons.contrast_rounded,
  };
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
  final void Function(T) onNext;
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
