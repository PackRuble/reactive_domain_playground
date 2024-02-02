import 'package:cardoteka/cardoteka.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppStorage extends Cardoteka with WatcherImpl {
  AppStorage({required super.config});

  static final instance = Provider(
    (ref) => AppStorage(config: AppCards._config),
  );
}

enum AppCards<T extends Object> implements Card<T> {
  themeMode<ThemeMode>(DataType.string, ThemeMode.system),
  themeColor<Color>(DataType.int, Colors.grey),
  ;

  const AppCards(this.type, this.defaultValue);

  @override
  final T defaultValue;

  @override
  String get key => name;

  @override
  final DataType type;

  static const _config = CardotekaConfig(
    name: 'app',
    cards: values,
    converters: {
      themeMode: EnumAsStringConverter(ThemeMode.values),
      themeColor: Converters.colorAsInt,
    },
  );
}
