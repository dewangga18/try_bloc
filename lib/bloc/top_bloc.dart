import 'package:try_bloc/bloc/app_bloc.dart';

class TopBloc extends AppBloc {
  TopBloc({
    required Iterable<String> urls,
    Duration? duration,
  }) : super (urls: urls, duration: duration);
}
