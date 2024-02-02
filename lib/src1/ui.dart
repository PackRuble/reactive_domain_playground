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
        // FloatingActionButton(
        //   onPressed: () async {
        //     int index =
        //         colors.indexWhere((element) => element.value == color.value);
        //
        //     return ref
        //         .read(SettingsNotifier.instance.notifier)
        //         .changeColorTheme(colors[++index % colors.length]);
        //   },
        //   child: Icon(
        //     color: color,
        //     Icons.circle_rounded,
        //   ),
        // ),
        CyclicSelectorWidget(
          items: themeModes.keys.toList(),
          initialItem: themeMode,
          onNext: ref.read(SettingsNotifier.instance.notifier).changeThemeMode,
          child: Icon(themeModes[themeMode]),
        ),
        const SizedBox(),
        CyclicSelectorWidget(
          items: colors,
          initialItem: color,
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

class CyclicSelectorWidget<T> extends StatefulWidget {
  const CyclicSelectorWidget({
    super.key,
    required this.items,
    required this.onNext,
    required this.initialItem,
    required this.child,
  });

  final T initialItem;
  final List<T> items;
  final Function(T) onNext;
  final Widget child;

  @override
  State<CyclicSelectorWidget<T>> createState() =>
      _CyclicSelectorWidgetState<T>();
}

class _CyclicSelectorWidgetState<T> extends State<CyclicSelectorWidget<T>> {
  late int _index = widget.items.indexWhere((el) => widget.initialItem == el);

  void _onNext() =>
      widget.onNext.call(widget.items[++_index % widget.items.length]);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _onNext,
      child: widget.child,
    );
  }
}
