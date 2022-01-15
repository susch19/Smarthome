import 'package:signalr_core/signalr_core.dart';

class PermanentRetryPolicy extends RetryPolicy {
  static const List<int> retryTimes = [250, 500, 1000, 2500, 5000, 7500, 10000, 15000, 20000, 25000, 30000];

  @override
  int? nextRetryDelayInMilliseconds(RetryContext retryContext) {
    var retryCount = retryContext.previousRetryCount ?? 0;
    if (retryCount >= retryTimes.length) return retryTimes.last;
    return retryTimes[retryCount];
  }
}
