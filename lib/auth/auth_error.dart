import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:flutter/foundation.dart' show immutable;

const Map<String, AuthError> authErrorMap = {
  'user-not-found': AuthErrorUserNotFound(),
  'weak-password': AuthErrorWeakPassword(),
  'invalid-email': AuthErrorInvalidEmail(),
  'operation-not-allowed': AuthErrorOperationNoAllowed(),
  'email-already-in-use': AuthErrorEmailAlreadyInUse(),
  'requires-recent-login': AuthErrorRequiresRecentLogin(),
  'no-current-user': AuthErrorNoCurrentUser(),
};

@immutable
abstract class AuthError {
  final String errorTitle;
  final String errorText;

  const AuthError({
    required this.errorTitle,
    required this.errorText,  
  });

  factory AuthError.from(FirebaseAuthException err) =>
      authErrorMap[err.code.toLowerCase().trim()] ?? AuthErrorUnknown(err);
}

@immutable
class AuthErrorUnknown extends AuthError {
  final FirebaseAuthException exception;
  const AuthErrorUnknown(this.exception)
      : super(
          errorTitle: 'Authentication Error',
          errorText: 'Unknown authentication error',
        );
}

@immutable
class AuthErrorNoCurrentUser extends AuthError {
  const AuthErrorNoCurrentUser()
      : super(
          errorTitle: 'No Current User',
          errorText: 'No Curent user with this information was found!',
        );
}

@immutable
class AuthErrorRequiresRecentLogin extends AuthError {
  const AuthErrorRequiresRecentLogin()
      : super(
          errorTitle: 'Request Recent Login',
          errorText: 'You need to relogin to perform this operation',
        );
}

@immutable 
class AuthErrorOperationNoAllowed extends AuthError {
  const AuthErrorOperationNoAllowed()
      : super(
          errorTitle: 'Operation Not Allowed',
          errorText: 'You cannot register using this method at this moment!',
        );
}

@immutable
class AuthErrorUserNotFound extends AuthError {
  const AuthErrorUserNotFound()
      : super(
          errorTitle: 'User Not Found',
          errorText: 'The given user was not found on this server! ',
        );
}

@immutable
class AuthErrorWeakPassword extends AuthError {
  const AuthErrorWeakPassword()
      : super(
          errorTitle: 'Weak Password',
          errorText: 'Please choose a stonger password consisting of more character!',
        );
}

@immutable
class AuthErrorInvalidEmail extends AuthError {
  const AuthErrorInvalidEmail()
      : super(
          errorTitle: 'Invalid Email',
          errorText: 'Please double check your email and try again!',
        );
}

@immutable
class AuthErrorEmailAlreadyInUse extends AuthError {
  const AuthErrorEmailAlreadyInUse()
      : super(
          errorTitle: 'Email Already in Use',
          errorText: 'Please use another email!',
        );
}
