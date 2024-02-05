import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_arch_app/src/domain/log_notifier.dart';

import '../domain/app_storage.dart';

class ExperimentPage extends ConsumerWidget {
  const ExperimentPage({
    super.key,
    required this.themeColorWidget,
    required this.themeModeWidget,
    required this.pageBuilder,
  });

  /// The [ColorSelector] widget should be nested inside the tree.
  final Widget themeColorWidget;

  /// The [ThemeModeSelector] widget should be nested inside the tree.
  final Widget themeModeWidget;

  final Widget Function(
    Widget Function(
      BuildContext context, {
      required Color themeColor,
      required ThemeMode themeMode,
    }) builder,
  ) pageBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return pageBuilder(
      (context, {required themeColor, required themeMode}) {
        wlog('$ExperimentPage with {$themeMode, ${themeColor.value}}');

        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: themeColor,
              brightness: switch (themeMode) {
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
                  title: Text('<${themeMode.name}> mode'),
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
                  themeColorWidget: themeColorWidget,
                  themeModeWidget: themeModeWidget,
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
  late int lastIndex = ref.read(LogNotifier.instance).length;

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
      if (_scrollController.hasClients) {
        await _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 500),
        );

        lastIndex = logs.length - 1;
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
          tileColor: index > lastIndex ? theme.colorScheme.error : null,
        );

        if (index == logs.length - 1) {
          return Column(
            children: [
              tile,
              const SizedBox(height: 88),
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
    required this.themeColorWidget,
    required this.themeModeWidget,
  });

  final Widget themeColorWidget;
  final Widget themeModeWidget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 32.0),
        Consumer(
          builder: (context, ref, child) => FloatingActionButton(
            heroTag: 'invalidate_storage',
            onPressed: () => ref.invalidate(AppStorage.instance),
            tooltip:
                'Invalidate <$AppStorage> provider. This will update all dependencies.',
            child: const Icon(Icons.restart_alt_rounded),
          ),
        ),
        const Spacer(),
        themeModeWidget,
        const SizedBox(width: 16.0),
        themeColorWidget,
      ],
    );
  }
}

class ColorSelector extends CyclicSelectorButton<Color> {
  ColorSelector({
    required void Function(Color color) onChange,
    required Color color,
  }) : super(
          onNext: onChange,
          child: Icon(color: color, Icons.circle_rounded, size: 30.0),
          current: color,
          items: Colors.primaries,
        );

  @override
  Widget build(BuildContext context) {
    wlog('$ColorSelector with {${current.value}}');
    return super.build(context);
  }
}

class ThemeModeSelector extends CyclicSelectorButton<ThemeMode> {
  ThemeModeSelector({
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

  @override
  Widget build(BuildContext context) {
    wlog('$ThemeModeSelector with {$current}');
    return super.build(context);
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
