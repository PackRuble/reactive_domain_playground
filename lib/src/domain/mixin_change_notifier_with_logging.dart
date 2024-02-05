

import 'package:flutter/foundation.dart' show ChangeNotifier;

import 'log_notifier.dart';

mixin ChangeNotifierLogger on ChangeNotifier {
  @override
  void notifyListeners() {
    dlog('UPD: $this');
    super.notifyListeners();
  }

  @override
  void dispose() {
    dlog('DISPOSE: $this');
    super.dispose();
  }
}
