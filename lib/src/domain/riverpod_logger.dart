import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'log_notifier.dart' show xlog;

class RiverpodObserver extends ProviderObserver {
  const RiverpodObserver();

  Function(String) get onLog => xlog;

  @override
  void didAddProvider(
    ProviderBase provider,
    Object? value,
    ProviderContainer container,
  ) {
    if (provider.name != null) {
      onLog('[D] INIT: ${provider.name} ${_withHash(provider)}'
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
      onLog('[D] UPD: ${provider.name} ${_withHash(provider)}'
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
      onLog('[D] DISPOSE: ${provider.name} ${_withHash(provider)}');
    }
  }

  @override
  void providerDidFail(
    ProviderBase provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    onLog(
      '[D] FAIL: ${provider.name} ${_withHash(provider)}, $error, $stackTrace',
    );
  }

  String _withHash(ProviderBase provider) => '{hash=${provider.hashCode}}';
}
