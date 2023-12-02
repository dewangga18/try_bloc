import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:try_bloc/apis/login_api.dart';
import 'package:try_bloc/apis/notes_api.dart';
import 'package:try_bloc/bloc/action.dart';
import 'package:try_bloc/bloc/state.dart';
import 'package:try_bloc/models.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  final LoginApiProtocol loginApi;
  final NotesApiProtocol notesApiProtocol;
  final LoginHandle acceptanceHandle;

  AppBloc({
    required this.loginApi,
    required this.notesApiProtocol,
    required this.acceptanceHandle,
  }) : super(const AppState.empty()) {
    on<LoginAction>(_hanleLoginAction);
    on<LoadNotesAction>(_hanleNotesAction);
  }

  FutureOr<void> _hanleLoginAction(event, emit) async {
    emit(
      const AppState(
        isLoading: true,
        error: null,
        handle: null,
        noteDatas: null,
      ),
    );
    final loginHandle = await loginApi.login(
      email: event.email,
      password: event.password,
    );
    emit(
      AppState(
        isLoading: false,
        error: loginHandle == null ? LoginErrors.invalid : null,
        handle: loginHandle,
        noteDatas: null,
      ),
    );
  }

  FutureOr<void> _hanleNotesAction(event, emit) async {
    emit(
      AppState(
        isLoading: true,
        error: null,
        handle: state.handle,
        noteDatas: null,
      ),
    );
    final loginHandle = state.handle;
    if (loginHandle != acceptanceHandle) {
      emit(
        AppState(
          isLoading: false,
          error: LoginErrors.invalid,
          handle: loginHandle,
          noteDatas: null,
        ),
      );
      return;
    }
    final notes = await notesApiProtocol.getNotes(
      handle: state.handle!,
    );
    emit(
      AppState(
        isLoading: false,
        error: null,
        handle: loginHandle,
        noteDatas: notes,
      ),
    );
  }
}
