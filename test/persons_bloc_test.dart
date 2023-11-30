import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:try_bloc/bloc/bloc_actions.dart';
import 'package:try_bloc/bloc/person.dart';
import 'package:try_bloc/bloc/persons_bloc.dart';

const mockedPersons1 = [
  Person(
    name: 'Aura',
    age: 22,
  ),
  Person(
    name: 'Agatha',
    age: 22,
  ),
];

const mockedPersons2 = [
  Person(
    name: 'Aura',
    age: 22,
  ),
  Person(
    name: 'Agatha',
    age: 22,
  ),
];

Future<Iterable<Person>> mockedGetPersons1(String _) =>
    Future.value(mockedPersons1);

Future<Iterable<Person>> mockedGetPersons2(String _) =>
    Future.value(mockedPersons2);

/// run with flutter test

void main() {
  group('Testing BLOC', () {
    late PersonBloc personBloc;

    setUp(() {
      personBloc = PersonBloc();
    });

    blocTest<PersonBloc, FetchResult?>(
      'test initial state',
      build: () => personBloc,
      verify: (bloc) => expect(bloc.state, null),
    );

    blocTest<PersonBloc, FetchResult?>(
      'Mock retrieving persons1',
      build: () => personBloc,
      act: (bloc) {
        bloc.add(
          const LoadPersonsAction(
            url: 'dummy_person_1',
            loader: mockedGetPersons1,
          ),
        );
        bloc.add(
          const LoadPersonsAction(
            url: 'dummy_person_1',
            loader: mockedGetPersons1,
          ),
        );
      },
      expect: () => [
        const FetchResult(
          persons: mockedPersons1,
          isCache: false,
        ),
        const FetchResult(
          persons: mockedPersons1,
          isCache: true,
        ),
      ],
    );
    
    blocTest<PersonBloc, FetchResult?>(
      'Mock retrieving persons2',
      build: () => personBloc,
      act: (bloc) {
        bloc.add(
          const LoadPersonsAction(
            url: 'dummy_person_2',
            loader: mockedGetPersons2,
          ),
        );
        bloc.add(
          const LoadPersonsAction(
            url: 'dummy_person_2',
            loader: mockedGetPersons2,
          ),
        );
      },
      expect: () => [
        const FetchResult(
          persons: mockedPersons2,
          isCache: false,
        ),
        const FetchResult(
          persons: mockedPersons2,
          isCache: true,
        ),
      ],
    );
  });
}
