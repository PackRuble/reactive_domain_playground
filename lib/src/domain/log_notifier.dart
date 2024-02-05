import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore_for_file: prefer_function_declarations_over_variables

class LogNotifier extends AutoDisposeNotifier<List<String>> {
  static final instance =
      AutoDisposeNotifierProvider<LogNotifier, List<String>>(LogNotifier.new);

  @override
  List<String> build() {
    slog('$LogNotifier activated');

    final subscription = _controller.stream.listen((message) {
      state = [...state, message];
    });

    ref.listenSelf(_updateLastIndex);

    _lastUpdatedIndex = _logs.length;
    _stopwatch.start();

    ref.onDispose(() {
      _stopwatch
        ..stop()
        ..reset();
      unawaited(subscription.cancel());
    });
    return _logs;
  }

  final _stopwatch = Stopwatch();

  int _lastUpdatedIndex = 0;
  // ignore: avoid_public_notifier_properties
  int get lastUpdatedIndex => _lastUpdatedIndex;

  void _updateLastIndex(List<String>? previous, List<String> next) {
    if (_stopwatch.elapsed > const Duration(milliseconds: 100)) {
      _lastUpdatedIndex = next.length - 2;
      _stopwatch.reset();
    }
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
final wlog = (Object? message) => LogNotifier.log('[W] $message'); // Widget
final dlog = (Object? message) => LogNotifier.log('[D] $message'); // Domain
final slog = (Object? message) => LogNotifier.log('[SYS] $message'); // System
