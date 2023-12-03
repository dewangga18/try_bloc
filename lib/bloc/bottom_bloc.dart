import 'package:try_bloc/bloc/app_bloc.dart';

class BottomBloc extends AppBloc {
  BottomBloc({
    required Iterable<String> urls,
    Duration? duration,
  }) : super(urls: urls, duration: duration);
}
