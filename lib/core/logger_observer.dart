import 'package:budget_app/common/log.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

base class LoggerObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    logInfo('[${context.provider.name ?? context.provider.runtimeType}] updated: $previousValue -> $newValue');
  }
}