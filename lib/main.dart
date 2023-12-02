import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:try_bloc/apis/login_api.dart';
import 'package:try_bloc/apis/notes_api.dart';
import 'package:try_bloc/bloc/action.dart';
import 'package:try_bloc/bloc/app_bloc.dart';
import 'package:try_bloc/bloc/state.dart';
import 'package:try_bloc/dialogs/generic_dialog.dart';
import 'package:try_bloc/dialogs/loading_screen.dart';
import 'package:try_bloc/models.dart';
import 'package:try_bloc/strings.dart';
import 'package:try_bloc/views/iterable_list_view.dart';
import 'package:try_bloc/views/login_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => AppBloc(
          acceptanceHandle: const LoginHandle.fooBar(),
          loginApi: LoginApi(),
          notesApiProtocol: NoteApi(),
        ),
        child: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(home),
      ),
      body: BlocConsumer<AppBloc, AppState>(
        listener: (context, state) {
          if (state.isLoading) {
            LoadingScreen.instance().show(
              context: context,
              text: loadingText,
            );
          } else {
            LoadingScreen.instance().hide();
          }

          final loginError = state.error;
          if (loginError != null) {
            showGenericDialog(
              context: context,
              title: loginErrorTitle,
              content: loginErrorDesc,
              optionBuilder: () => {ok: true},
            );
          }

          if (!state.isLoading &&
              state.error == null &&
              state.handle == const LoginHandle.fooBar() &&
              state.noteDatas == null) {
            context.read<AppBloc>().add(const LoadNotesAction());
          }
        },
        builder: (context, state) {
          final notes = state.noteDatas;

          if (notes == null) {
            return LoginView(
              onTap: (email, password) {
                context.read<AppBloc>().add(
                      LoginAction(
                        email: email,
                        password: password,
                      ),
                    );
              },
            );
          } else {
            return notes.toListView();
          }
        },
      ),
    );
  }
}
