import 'package:cardoteka/cardoteka.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
            description: 'Описание этой архитектуры',
            pageWhenTap: (context) => const Variation1(),
          ),
          _VariationTile(
            name: 'Variation2',
            description: 'Описание2',
            pageWhenTap: (context) => const Variation2(),
          ),
          _VariationTile(
            name: 'Variation3',
            description: 'Описание3',
            pageWhenTap: (context) => const Variation3(),
          ),
          _VariationTile(
            name: 'Variation4',
            description: 'Описание4',
            pageWhenTap: (context) => const Variation4(),
          ),
          _VariationTile(
            name: 'Variation5',
            description: 'Описание5',
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
      subtitle: Text(description),
      onTap: () async {
        xlog('-----\n$name: $description\n-----');
        await Navigator.of(context).push(
          MaterialPageRoute(builder: pageWhenTap),
        );
      },
      trailing: const Icon(Icons.chevron_right_rounded),
    );
  }
}
