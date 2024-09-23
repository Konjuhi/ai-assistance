import 'package:firebase_auth/firebase_auth.dart';

import 'app_exceptions.dart';
import 'failures.dart';

AppException mapFirebaseAuthException(FirebaseAuthException e) {
  switch (e.code) {
    case 'email-already-in-use':
      return EmailAlreadyInUseException();
    case 'wrong-password':
      return WrongPasswordException();
    case 'user-not-found':
      return UserNotFoundException();
    case 'too-many-requests':
      return TooManyRequestsException();
    default:
      return UnknownException(
          message: e.message ?? 'Unknown authentication error');
  }
}

Failure mapFirebaseAuthFailure(FirebaseAuthException e) {
  switch (e.code) {
    case 'email-already-in-use':
      return EmailAlreadyInUseFailure();
    case 'wrong-password':
      return WrongPasswordFailure();
    case 'user-not-found':
      return UserNotFoundFailure();
    case 'too-many-requests':
      return TooManyRequestsFailure();
    default:
      return UnknownFailure(
          message: e.message ?? 'Unknown authentication failure');
  }
}
