// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/foundation.dart' show immutable;
import 'package:try_bloc/models.dart';
import 'package:collection/collection.dart';

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

  @override
  bool operator ==(covariant AppState other) {
    final otherIsEqual = isLoading == other.isLoading &&
        error == other.error &&
        handle == other.handle;

    if (noteDatas == null && other.noteDatas == null) {
      return otherIsEqual;
    } else {
      return otherIsEqual && (noteDatas?.isEqualTo(other.noteDatas) ?? false);
    }
  }

  @override
  int get hashCode => Object.hash(
        isLoading,
        error,
        handle,
        noteDatas,
      );
}

extension UnorderedEquality on Object {
  bool isEqualTo(other) {
    return const DeepCollectionEquality.unordered().equals(this, other);
  }
}
