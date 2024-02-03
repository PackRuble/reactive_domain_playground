import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogNotifier extends AutoDisposeNotifier<List<String>> {
  static final instance =
      AutoDisposeNotifierProvider<LogNotifier, List<String>>(
    LogNotifier.new,
    name: '$LogNotifier',
  );

  @override
  List<String> build() => ['logger activated'];

  void l(Object? message) {
    state = [message.toString(), ...state];
  }

  void clear() => state = build();
}
