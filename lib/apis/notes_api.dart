import 'package:flutter/foundation.dart' show immutable;
import 'package:try_bloc/models.dart';

@immutable
abstract class NotesApiProtocol {
  const NotesApiProtocol();
  Future<Iterable<Note>?> getNotes({
    required LoginHandle handle,
  });
}

@immutable
class NoteApi implements NotesApiProtocol {
  @override
  Future<Iterable<Note>?> getNotes({
    required LoginHandle handle,
  }) =>
      Future.delayed(
        const Duration(seconds: 2),
        () => handle == const LoginHandle.fooBar() ? mockNotes : null,
      );
}
