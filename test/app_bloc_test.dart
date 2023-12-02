import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_test/flutter_test.dart';
import 'package:try_bloc/apis/login_api.dart';
import 'package:try_bloc/apis/notes_api.dart';
import 'package:try_bloc/bloc/action.dart';
import 'package:try_bloc/bloc/app_bloc.dart';
import 'package:try_bloc/bloc/state.dart';
import 'package:try_bloc/models.dart';

const Iterable<Note> mockNotes = [
  Note(title: 'Note 1'),
  Note(title: 'Note 2'),
  Note(title: 'Note 3'),
];

@immutable
class DummyNotesApi implements NotesApiProtocol {
  final LoginHandle acceptenceLoginHandle;
  final Iterable<Note>? notesFromDummy;

  const DummyNotesApi({
    required this.acceptenceLoginHandle,
    required this.notesFromDummy,
  });

  const DummyNotesApi.empty()
      : acceptenceLoginHandle = const LoginHandle.fooBar(),
        notesFromDummy = null;

  @override
  Future<Iterable<Note>?> getNotes({
    required LoginHandle handle,
  }) async {
    if (handle == acceptenceLoginHandle) {
      return notesFromDummy;
    } else {
      return null;
    }
  }
}

@immutable
class DummyLoginApi implements LoginApiProtocol {
  final String acceptanceEmail;
  final String acceptancePassword;
  final LoginHandle handleReturn;

  const DummyLoginApi({
    required this.acceptanceEmail,
    required this.acceptancePassword,
    required this.handleReturn,
  });

  const DummyLoginApi.empty()
      : acceptanceEmail = '',
        acceptancePassword = '',
        handleReturn = const LoginHandle.fooBar();

  @override
  Future<LoginHandle?> login({
    required String email,
    required String password,
  }) async {
    if (email == acceptanceEmail && acceptancePassword == password) {
      return handleReturn;
    } else {
      return null;
    }
  }
}

void main() {
  blocTest<AppBloc, AppState>(
    'Initial state is empty?',
    build: () => AppBloc(
      acceptanceHandle: const LoginHandle.fooBar(),
      loginApi: const DummyLoginApi.empty(),
      notesApiProtocol: const DummyNotesApi.empty(),
    ),
    verify: (bloc) => expect(bloc.state, const AppState.empty()),
  );
  blocTest<AppBloc, AppState>(
    'can login with corret credentials?',
    build: () => AppBloc(
      acceptanceHandle: const LoginHandle.fooBar(),
      loginApi: const DummyLoginApi(
        acceptanceEmail: 'bar@baz.com',
        acceptancePassword: 'foo',
        handleReturn: LoginHandle(token: 'ABC'),
      ),
      notesApiProtocol: const DummyNotesApi.empty(),
    ),
    act: (bloc) => bloc.add(
      const LoginAction(
        email: 'bar@baz.com',
        password: 'foo',
      ),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
        error: null,
        handle: null,
        noteDatas: null,
      ),
      const AppState(
        isLoading: false,
        error: null,
        handle: LoginHandle(token: 'ABC'),
        noteDatas: null,
      ),
    ],
  );
  blocTest<AppBloc, AppState>(
    'can not login with invalid credentials',
    build: () => AppBloc(
      acceptanceHandle: const LoginHandle.fooBar(),
      loginApi: const DummyLoginApi(
        acceptanceEmail: 'bar@baz.com',
        acceptancePassword: 'foo',
        handleReturn: LoginHandle(token: 'ABC'),
      ),
      notesApiProtocol: const DummyNotesApi.empty(),
    ),
    act: (bloc) => bloc.add(
      const LoginAction(
        email: 'fobar@baz.com',
        password: 'foo',
      ),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
        error: null,
        handle: null,
        noteDatas: null,
      ),
      const AppState(
        isLoading: false,
        error: LoginErrors.invalid,
        handle: null,
        noteDatas: null,
      ),
    ],
  );
  blocTest<AppBloc, AppState>(
    'Load some notes data',
    build: () => AppBloc(
      acceptanceHandle: const LoginHandle(token: 'ABC'),
      loginApi: const DummyLoginApi(
        acceptanceEmail: 'fobar@baz.com',
        acceptancePassword: 'foo',
        handleReturn: LoginHandle(token: 'ABC'),
      ),
      notesApiProtocol: const DummyNotesApi(
        acceptenceLoginHandle: LoginHandle(token: 'ABC'),
        notesFromDummy: mockNotes,
      ),
    ),
    act: (bloc) {
      bloc.add(
        const LoginAction(
          email: 'fobar@baz.com',
          password: 'foo',
        ),
      );
      bloc.add(const LoadNotesAction());
    },
    expect: () => [
      const AppState(
        isLoading: true,
        error: null,
        handle: null,
        noteDatas: null,
      ),
      const AppState(
        isLoading: false,
        error: null,
        handle: LoginHandle(token: 'ABC'),
        noteDatas: null,
      ),
      const AppState(
        isLoading: true,
        error: null,
        handle: LoginHandle(token: 'ABC'),
        noteDatas: null,
      ),
      const AppState(
        isLoading: false,
        error: null,
        handle: LoginHandle(token: 'ABC'),
        noteDatas: mockNotes,
      ),
    ],
  );
}
