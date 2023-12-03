import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:try_bloc/bloc/bottom_bloc.dart';
import 'package:try_bloc/bloc/top_bloc.dart';
import 'package:try_bloc/models/constant.dart';
import 'package:try_bloc/views/app_bloc_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<TopBloc>(
              create: (_) => TopBloc(
                duration: const Duration(seconds: 3),
                urls: images,
              ),
            ),
            BlocProvider<BottomBloc>(
              create: (_) => BottomBloc(
                duration: const Duration(seconds: 3),
                urls: images,
              ),
            ),
          ],
          child: const Column(
            children: [
              AppBlocView<TopBloc>(),
              AppBlocView<BottomBloc>(),
            ],
          ),
        ),
      ),
    );
  }
}
