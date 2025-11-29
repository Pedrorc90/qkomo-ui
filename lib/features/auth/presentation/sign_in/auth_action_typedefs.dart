typedef AuthAction = Future<void> Function();
typedef AuthActionRunner = Future<void> Function(AuthAction action);
