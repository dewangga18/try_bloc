import 'package:flutter/foundation.dart' show immutable;

@immutable
class LoginHandle {
  final String token;

  const LoginHandle({required this.token});

  const LoginHandle.fooBar() : token = 'foobar';

  @override
  operator ==(covariant LoginHandle other) => token == other.token;

  @override
  int get hashCode => token.hashCode;

  @override
  String toString() => 'Token $token';
}

enum LoginErrors { invalid }

@immutable
class Note {
  final String title;

  const Note({required this.title});

  @override
  String toString() => 'Note(title = $title )';
}

final mockNotes = Iterable.generate(
  3,
  (i) => Note(title: 'Note ${i + 1 }'),
);
