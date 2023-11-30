import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:try_bloc/bloc/bloc_actions.dart';
import 'package:try_bloc/bloc/person.dart';

extension IsEqualToIgnoringOrdering<T> on Iterable<T> {
  bool isEqualToIgnoringOrdering(Iterable<T> other) =>
      length == other.length &&
      {...this}.intersection({...other}).length == length;
}

@immutable
class FetchResult {
  final Iterable<Person> persons;
  final bool isCache;

  const FetchResult({required this.persons, required this.isCache});

  @override
  String toString() => 'From cache $isCache => $persons';

  @override
  bool operator ==(covariant FetchResult other) =>
      persons.isEqualToIgnoringOrdering(other.persons) &&
      isCache == other.isCache;

  @override
  int get hashCode => Object.hash(persons, isCache);
}

class PersonBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<String, Iterable<Person>> _cacheResult = {};
  PersonBloc() : super(null) {
    on<LoadPersonsAction>((event, emit) async {
      final url = event.url;
      if (_cacheResult.containsKey(url)) {
        final cachedPerson = _cacheResult[url]!;
        final result = FetchResult(persons: cachedPerson, isCache: true);
        emit(result);
      } else {
        final loader = event.loader;
        final persons = await loader(url);
        _cacheResult[url] = persons;
        final result = FetchResult(persons: persons, isCache: false);
        emit(result);
      }
    });
  }
}
