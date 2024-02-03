import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogNotifier extends AutoDisposeNotifier<List<String>> {
  static final instance =
      AutoDisposeNotifierProvider<LogNotifier, List<String>>(LogNotifier.new);

  @override
  List<String> build() {
    log('[P] $LogNotifier activated');

    final subscription = _controller.stream.listen((message) {
      state = [...state, message];
    });

    ref.onDispose(subscription.cancel);
    return _logs;
  }

  static final _controller = StreamController<String>.broadcast();
  static final _logs = <String>[];

  static void log(Object? message) {
    final record = message.toString();
    _controller.add(record);
    _logs.add(record);
    // ignore: avoid_print
    print(record);
  }

  static void clear() {
    _logs.clear();
  }
}

const xlog = LogNotifier.log;
