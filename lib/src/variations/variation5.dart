import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_domain_playground/src/domain/log_notifier.dart';
import 'package:reactive_domain_playground/src/ui/experiment_page.dart';

import '../domain/app_storage.dart';
import '../domain/mixin_change_notifier_with_logging.dart';

// -----------------------------------------------------------------------------
// domain layer

class ThemeColorNotifier extends ValueNotifier<Color>
    with ChangeNotifierLogger {
  ThemeColorNotifier({
    Color? initialValue,
    required AppStorage appStorage,
  })  : _appStorage = appStorage,
        super(initialValue ?? appStorage.get(AppCards.themeColor)) {
    dlog('INIT: $this');
  }

  final AppStorage _appStorage;

  Future<void> changeThemeColor(Color color) async {
    value = color;
    await _appStorage.set<Color>(AppCards.themeColor, color);
  }
}

class ThemeModeNotifier extends ValueNotifier<ThemeMode>
    with ChangeNotifierLogger {
  ThemeModeNotifier({
    ThemeMode? initialValue,
    required AppStorage appStorage,
  })  : _appStorage = appStorage,
        super(initialValue ?? appStorage.get(AppCards.themeMode)) {
    dlog('INIT: $this');
  }

  final AppStorage _appStorage;

  Future<void> changeThemeMode(ThemeMode mode) async {
    value = mode;
    await _appStorage.set<ThemeMode>(AppCards.themeMode, mode);
  }
}

// -----------------------------------------------------------------------------
// ui layer

class Variation5 extends StatefulWidget {
  const Variation5({super.key});

  @override
  State<Variation5> createState() => _Variation5State();
}

class _Variation5State extends State<Variation5> {
  late ThemeColorNotifier themeColorNotifier;
  late ThemeModeNotifier themeModeNotifier;
  late Listenable settingsNotifier;

  @override
  void didChangeDependencies() {
    // I use this method to get the AppStorage instance only because Riverpod is used everywhere for DI
    final appStorage =
        ProviderScope.containerOf(context).read(AppStorage.instance);
    themeColorNotifier = ThemeColorNotifier(appStorage: appStorage);
    themeModeNotifier = ThemeModeNotifier(appStorage: appStorage);
    settingsNotifier =
        Listenable.merge([themeColorNotifier, themeModeNotifier]);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    themeColorNotifier.dispose();
    themeModeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. use this
    return ExperimentPage(
      pageBuilder: (builder) => ListenableBuilder(
        listenable: settingsNotifier,
        builder: (context, _) {
          return builder(
            context,
            themeColor: themeColorNotifier.value,
            themeMode: themeModeNotifier.value,
          );
        },
      ),
      themeModeWidget: ValueListenableBuilder(
        valueListenable: themeModeNotifier,
        builder: (context, themeMode, _) {
          // 2. use this
          return ThemeModeSelector(
            mode: themeMode,
            onChange: themeModeNotifier.changeThemeMode,
          );
        },
      ),
      themeColorWidget: ValueListenableBuilder(
        valueListenable: themeColorNotifier,
        builder: (context, themeColor, _) {
          // 3. use this
          return ColorSelector(
            color: themeColor,
            onChange: themeColorNotifier.changeThemeColor,
          );
        },
      ),
    );
  }
}
