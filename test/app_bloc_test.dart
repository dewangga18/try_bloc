import 'dart:typed_data';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:try_bloc/bloc/app_bloc.dart';
import 'package:try_bloc/bloc/app_event.dart';
import 'package:try_bloc/bloc/app_state.dart';

extension ToList on String {
  Uint8List toUin8List() => Uint8List.fromList(codeUnits);
}

final text1Data = 'Foo'.toUin8List();
final text2Data = 'Ba '.toUin8List();

enum Errors { dummy }

void main() {
  blocTest<AppBloc, AppState>(
    'Initial state of the bloc should be empty',
    build: () => AppBloc(
      urls: [],
    ),
    verify: (bloc) => expect(
      bloc.state,
      const AppState.empty(),
    ),
  );
  blocTest<AppBloc, AppState>(
    'Load mock data',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.value(text1Data),
    ),
    act: (bloc) => bloc.add(LoadNextUrlEvent()),
    expect: () => [
      const AppState(
        isLoading: true,
        data: null,
        error: null,
      ),
      AppState(
        isLoading: false,
        data: text1Data,
        error: null,
      ),
    ],
  );
  blocTest<AppBloc, AppState>(
    'Throw error and catch it',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.error(Errors.dummy),
    ),
    act: (bloc) => bloc.add(LoadNextUrlEvent()),
    expect: () => [
      const AppState(
        isLoading: true,
        data: null,
        error: null,
      ),
      const AppState(
        isLoading: false,
        data: null,
        error: Errors.dummy,
      ),
    ],
  );
  blocTest<AppBloc, AppState>(
    'Test the ability to load more than one url ',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.value(text2Data),
    ),
    act: (bloc) {
      bloc.add(LoadNextUrlEvent());
      bloc.add(LoadNextUrlEvent());
    },
    expect: () => [
      const AppState(
        isLoading: true,
        data: null,
        error: null,
      ),
      AppState(
        isLoading: false,
        data: text2Data,
        error: null,
      ),
      const AppState(
        isLoading: true,
        data: null,
        error: null,
      ),
      AppState(
        isLoading: false,
        data: text2Data,
        error: null,
      ),
    ],
  );
}
