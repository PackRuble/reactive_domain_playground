import 'package:cardoteka/cardoteka.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src1/ui.dart';

Future<void> main() async {
  await Cardoteka.init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Architecture styles with Riverpod',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
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
                builder: (context) => const SRC1Page(),
              ),
            ),
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    );
  }
}
