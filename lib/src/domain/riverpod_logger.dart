import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'log_notifier.dart' show xlog;

class RiverpodObserver extends ProviderObserver{
  const RiverpodObserver();

  Function(String) get onLog  => xlog;

  @override
  void didAddProvider(
      ProviderBase provider,
      Object? value,
      ProviderContainer container,
      ) {
    if (provider.name != null) {
      onLog('[D] INIT: ${provider.name}'
          '\n╔══'
          '\n║ value: $value'
          '\n╚══');
    }
  }

  @override
  void didUpdateProvider(
      ProviderBase provider,
      Object? previousValue,
      Object? newValue,
      ProviderContainer container,
      ) {
    if (provider.name != null) {
      onLog('[D] UPD: ${provider.name}'
          '\n╔══'
          '\n║ previousValue: $previousValue'
          '\n║ newValue: $newValue'
          '\n╚══');
    }
  }

  /// A provider was disposed.
  @override
  void didDisposeProvider(
      ProviderBase provider,
      ProviderContainer container,
      ) {
    if (provider.name != null) {
      onLog('[D] Dispose: ${provider.name}');
    }
  }

  @override
  void providerDidFail(
      ProviderBase provider,
      Object error,
      StackTrace stackTrace,
      ProviderContainer container,
      ) {
    onLog('[D] FAIL: ${provider.name}, $error, $stackTrace');
  }
}
