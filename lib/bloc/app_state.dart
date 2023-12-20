import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show immutable, kDebugMode;
import 'package:try_bloc/auth/auth_error.dart';

@immutable
abstract class AppState {
  final bool isLoading;
  final AuthError? error;

  const AppState({
    required this.isLoading,
    this.error,
  });
}

@immutable
class AppStateLoggedIn extends AppState {
  final User user;
  final Iterable<Reference> images;

  const AppStateLoggedIn({
    required super.isLoading,
    super.error,
    required this.user,
    required this.images,
  });

  @override
  bool operator ==(other) {
    final otherClass = other;
    if (otherClass is AppStateLoggedIn) {
      return isLoading == otherClass.isLoading &&
          user.uid == otherClass.user.uid &&
          images.length == otherClass.images.length;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(user.uid, images);

  @override
  String toString() => 'Logged In => Images count ${images.length}';
}

@immutable
class AppStateLoggedOut extends AppState {
  const AppStateLoggedOut({
    required super.isLoading,
    super.error,
  });

  @override
  String toString() => 'AppState Logged Out';
}

@immutable
class AppStateInRegistration extends AppState {
  const AppStateInRegistration({
    required super.isLoading,
    super.error,
  });
}

extension GetUser on AppState {
  User? get user {
    final cls = this;
    if (cls is AppStateLoggedIn) {
      return cls.user;
    } else {
      return null;
    }
  }
}

extension GetImages on AppState {
  Iterable<Reference>? get images {
    final cls = this;
    if (cls is AppStateLoggedIn) {
      return cls.images;
    } else {
      return null;
    }
  }
}

extension IfDebugging on String {
  String? get ifDebugging => kDebugMode ? this : null;
}
