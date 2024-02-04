import 'package:cardoteka/cardoteka.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_arch_app/features/feature_1.dart';

import 'domain/riverpod_logger.dart';

Future<void> main() async {
  await Cardoteka.init();
  runApp(const ProviderScope(observers: [RiverpodObserver()], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Architecture styles with Riverpod',
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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

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
            title: const Text('Архитектура1'),
            subtitle: const Text('Описание этой архитектуры'),
            onTap: () async => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const Feature1(),
              ),
            ),
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    );
  }
}



