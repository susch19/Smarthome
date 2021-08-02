import 'package:signalr_core/signalr_core.dart';

class PermanentRetryPolicy extends RetryPolicy{
  static const List<int> retryTimes = [1,5,10];
  
  @override
  int? nextRetryDelayInMilliseconds(RetryContext retryContext) {
    var retryCount = retryContext.previousRetryCount ?? 0;
    if(retryCount >= retryTimes.length)
      return retryTimes.last;
    return retryTimes[retryCount];
  }

}