typedef OnSuccess = void Function();
typedef OnError = void Function(int code);
typedef OnResult = void Function(int code, String resutl);

class StatusCallback {
  OnSuccess onSuccess;
  OnError onError;
  OnResult onResult;
  StatusCallback({required this.onSuccess, required this.onError, required this.onResult});
}
