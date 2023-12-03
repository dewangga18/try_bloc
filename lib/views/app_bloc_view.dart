import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:try_bloc/bloc/app_bloc.dart';
import 'package:try_bloc/bloc/app_event.dart';
import 'package:try_bloc/bloc/app_state.dart';
import 'package:try_bloc/extensions/stream/start_with.dart';

class AppBlocView<T extends AppBloc> extends StatelessWidget {
  const AppBlocView({Key? key}) : super(key: key);

  void startUploatingBloc(BuildContext context) {
    Stream.periodic(
      const Duration(seconds: 10),
      (_) => LoadNextUrlEvent(),
    ).startWith(LoadNextUrlEvent()).forEach((event) {
      context.read<T>().add(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    startUploatingBloc(context);

    return Expanded(
      child: BlocBuilder<T, AppState>(
        builder: (context, state) {
          if (state.error != null) {
            return const Center(child: Text('Getting an Error'));
          } else if (state.data != null) {
            return Image.memory(
              state.data!,
              fit: BoxFit.fitHeight,
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
