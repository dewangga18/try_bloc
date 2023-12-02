import 'package:flutter/foundation.dart' show immutable;
import 'package:try_bloc/models.dart';

@immutable
class AppState {
  final bool isLoading;
  final LoginErrors? error;
  final LoginHandle? handle;
  final Iterable<Note>? noteDatas;

  const AppState({
    required this.isLoading,
    required this.error,
    required this.handle,
    required this.noteDatas,
  });

  const AppState.empty()
      : isLoading = false,
        error = null,
        handle = null,
        noteDatas = null;

  @override
  String toString() => {
        'isLoading': isLoading,
        'error': error,
        'handle': handle,
        'data': noteDatas,
      }.toString();
}
