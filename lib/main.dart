import 'package:cardoteka/cardoteka.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/domain/riverpod_logger.dart';
import 'src/variations/variation1.dart';

Future<void> main() async {
  await Cardoteka.init();
  runApp(const ProviderScope(observers: [RiverpodObserver()], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Architecture styles',
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
        title: const Text('Architecture styles with Riverpod'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Variation1'),
            subtitle: const Text('Описание этой архитектуры'),
            onTap: () async => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const Variation1(),
              ),
            ),
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    );
  }
}



