import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AppEvent {
  const AppEvent();
}

@immutable
class AppEventUploadImage extends AppEvent {
  final String filePath;

  const AppEventUploadImage({required this.filePath});
}

@immutable
class AppEventDeleteAccount extends AppEvent {}

@immutable
class AppEventGoToRegistration extends AppEvent {}

@immutable
class AppEventGoToLogin extends AppEvent {}

@immutable
class AppEventLogout extends AppEvent {}

@immutable
class AppEventLogin extends AppEvent {
  final String email;
  final String password;

  const AppEventLogin({
    required this.email,
    required this.password,
  });
}

@immutable
class AppEventRegister extends AppEvent {
  final String email;
  final String password;

  const AppEventRegister({
    required this.email,
    required this.password,
  });
}

@immutable
class AppEventInitialize extends AppEvent {}
