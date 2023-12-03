// ignore_for_file: depend_on_referenced_packages

import 'package:async/async.dart' show StreamGroup;

extension StartWith<T> on Stream<T> {
  Stream<T> startWith(T value) {
    return StreamGroup.merge([this, Stream<T>.value(value)]);
  }
}
