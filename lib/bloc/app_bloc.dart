import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:try_bloc/auth/auth_error.dart';
import 'package:try_bloc/bloc/app_event.dart';
import 'package:try_bloc/bloc/app_state.dart';
import 'package:try_bloc/utils/upload_image.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppStateLoggedOut(isLoading: false)) {
    on<AppEventUploadImage>((event, emit) async {
      final user = state.user;
      if (user == null) {
        emit(const AppStateLoggedOut(isLoading: false));
        return;
      }
      emit(
        AppStateLoggedIn(
          isLoading: true,
          user: user,
          images: state.images ?? [],
        ),
      );
      final file = File(event.filePath);
      await uploadImage(file: file, userId: user.uid);
      final images = await _getImages(user.uid);
      emit(AppStateLoggedIn(isLoading: false, user: user, images: images));
    });

    on<AppEventDeleteAccount>((event, emit) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(const AppStateLoggedOut(isLoading: false));
        return;
      }
      emit(
        AppStateLoggedIn(
          isLoading: true,
          user: user,
          images: state.images ?? [],
        ),
      );
      try {
        final folder = await FirebaseStorage.instance.ref(user.uid).list();
        for (final item in folder.items) {
          item.delete().catchError((_) {});
        }
        await FirebaseStorage.instance
            .ref(user.uid)
            .delete()
            .catchError((_) {});
        await user.delete();
        await FirebaseAuth.instance.signOut();
        emit(const AppStateLoggedOut(isLoading: false));
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateLoggedIn(
            isLoading: false,
            user: user,
            images: state.images ?? [],
            error: AuthError.from(e),
          ),
        );
      } on FirebaseException {
        emit(const AppStateLoggedOut(isLoading: false));
      }
    });

    on<AppEventLogout>((event, emit) async {
      emit(const AppStateLoggedOut(isLoading: true));
      await FirebaseAuth.instance.signOut();
      emit(const AppStateLoggedOut(isLoading: false));
    });

    on<AppEventInitialize>((event, emit) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(const AppStateLoggedOut(isLoading: false));
      } else {
        final images = await _getImages(user.uid);
        emit(AppStateLoggedIn(isLoading: false, user: user, images: images));
      }
    });

    on<AppEventRegister>((event, emit) async {
      emit(const AppStateInRegistration(isLoading: true));
      final email = event.email;
      final password = event.password;
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        emit(
          AppStateLoggedIn(
            isLoading: false,
            user: credential.user!,
            images: const [],
          ),
        );
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateInRegistration(isLoading: false, error: AuthError.from(e)),
        );
      }
    });

    on<AppEventLogin>((event, emit) async {
      emit(const AppStateLoggedOut(isLoading: true));
      try {
        final email = event.email;
        final password = event.password;
        final credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        final user = credential.user!;
        final images = await _getImages(user.uid);
        emit(AppStateLoggedIn(isLoading: false, user: user, images: images));
      } on FirebaseAuthException catch (e) {
        emit(AppStateLoggedOut(isLoading: false, error: AuthError.from(e)));
      }
    });

    on<AppEventGoToLogin>((event, emit) {
      emit(const AppStateLoggedOut(isLoading: false));
    });

    on<AppEventGoToRegistration>((event, emit) {
      emit(const AppStateInRegistration(isLoading: false));
    });
  }

  Future<Iterable<Reference>> _getImages(String usrId) {
    return FirebaseStorage.instance
        .ref(usrId)
        .list()
        .then((value) => value.items);
  }
}
