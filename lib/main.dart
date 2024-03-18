import 'package:cardoteka/cardoteka.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_domain_playground/src/domain/log_notifier.dart';

import 'src/domain/riverpod_logger.dart';
import 'src/variations/variation1.dart';
import 'src/variations/variation2.dart';
import 'src/variations/variation3.dart';
import 'src/variations/variation4.dart';
import 'src/variations/variation5.dart';

Future<void> main() async {
  await Cardoteka.init();
  runApp(const ProviderScope(observers: [RiverpodObserver()], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reactive domain on Playground',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey),
        useMaterial3: true,
      ),
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: PointerDeviceKind.values.toSet(),
          ),
          child: child!,
        );
      },
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Reactive domain Playground'),
      ),
      body: ListView(
        children: [
          _VariationTile(
            name: 'Variation1',
            description:
                '`AutoDisposeNotifier` + `SettingsModel`. Reactive state update and wiretap attachment using `Watcher.attach`. The widget is updated using `Consumer` and calls `ref.watch` + `select` for spot updates.',
            pageWhenTap: (context) => const Variation1(),
          ),
          _VariationTile(
            name: 'Variation2',
            description:
                '`Settings` class with `late final` providers of type `Provider.autoDispose`. Reactive state update and wiretap attachment using `Watcher.attach`. Perhaps this method is presented purposefully and is an **anti-pattern**, although it works as expected. The widget is updated with `Consumer` and `ref.watch` calls.',
            pageWhenTap: (context) => const Variation2(),
          ),
          _VariationTile(
            name: 'Variation3',
            description:
                '`AutoDisposeNotifier` and split into two notifiers: `ThemeModeNotifier` and `ThemeColorNotifier`. Reactive state update and wiretap attachment using `Watcher.attach`. Preferred method because of the strict division of responsibilities. The widget is updated with `Consumer` and `ref.watch` calls.',
            pageWhenTap: (context) => const Variation3(),
          ),
          _VariationTile(
            name: 'Variation4',
            description:
                '`ChangeNotifier` with a mutable data update scheme using the `notifyListeners` call. Initial retrieval of data from storage using `AppStorage.get`, state update is imperative. Injecting notifier as an instance variable. The widget is updated with `ListenableBuilder`. There is no point update.',
            pageWhenTap: (context) => const Variation4(),
          ),
          _VariationTile(
            name: 'Variation5',
            description:
                '`ValueNotifier` and split into two notifiers: `ThemeModeNotifier` and `ThemeColorNotifier`. Initial retrieval of data from storage using `AppStorage.get`, state update is reactive in terms of `ValueNotifier`. Implement notifier as an instance variable + create a shared notifier using `Listenable.merge`. The widget can be updated point-by-point with `ValueListenableBuilder`.',
            pageWhenTap: (context) => const Variation5(),
          ),
        ],
      ),
    );
  }
}

class _VariationTile extends StatelessWidget {
  const _VariationTile({
    super.key,
    required this.name,
    required this.description,
    required this.pageWhenTap,
  });

  final String name;
  final String description;
  final WidgetBuilder pageWhenTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: MarkdownBody(
        data: description,
        selectable: true,
        onTapText: () async => _onTap(context),
      ),
      onTap: () async => _onTap(context),
      trailing: const Icon(Icons.chevron_right_rounded),
    );
  }

  Future<void> _onTap(BuildContext context) async {
    xlog('-----\n$name: $description\n-----');
    await Navigator.of(context).push(
      MaterialPageRoute(builder: pageWhenTap),
    );
  }
}
