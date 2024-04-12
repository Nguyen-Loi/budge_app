import 'package:budget_app/common/log.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoggerObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    logInfo('[${provider.name ?? provider.runtimeType}] value: $newValue');
  }
}