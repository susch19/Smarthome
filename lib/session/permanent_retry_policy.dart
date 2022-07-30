// // import 'package:signalr_core/signalr_core.dart';
// import 'package:signalr_netcore/signalr_client.dart';

// class PermanentRetryPolicy extends RetryPolicy {
//   static const List<int> retryTimes = [1, 2, 5, 10, 25, 50, 75, 100, 150, 200, 250, 300];

//   @override
//   int? nextRetryDelayInMilliseconds(final RetryContext retryContext) {
//     final retryCount = retryContext.previousRetryCount ?? 0;
//     if (retryCount >= retryTimes.length) return retryTimes.last;
//     return retryTimes[retryCount];
//   }
// }
