import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:try_bloc/bloc/app_bloc.dart';
import 'package:try_bloc/bloc/app_event.dart';
import 'package:try_bloc/bloc/app_state.dart';
import 'package:try_bloc/dialogs/error_dialog.dart';
import 'package:try_bloc/firebase_options.dart';
import 'package:try_bloc/loading/loading_screen.dart';
import 'package:try_bloc/views/gallery_view.dart';
import 'package:try_bloc/views/login_view.dart';
import 'package:try_bloc/views/register_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppBloc()..add(AppEventInitialize()),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
          ),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: BlocConsumer<AppBloc, AppState>(
          listener: (context, state) {
            if (state.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: 'Loading...',
              ); 
            } else {
              LoadingScreen.instance().hide();
            }
            final authError = state.error;
            if (authError != null) {
              showAuthErorDialog(
                context: context,
                error: authError,
              );
            }
          },
          builder: (context, state) {
            if (state is AppStateLoggedOut) {
              return const LoginView();
            } else if (state is AppStateLoggedIn) {
              return const GalleryView();
            } else if (state is AppStateInRegistration) {
              return const RegisterView();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
