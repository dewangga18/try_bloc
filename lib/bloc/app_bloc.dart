import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:try_bloc/bloc/app_event.dart';
import 'package:try_bloc/bloc/app_state.dart';

typedef RandomURLPicker = String Function(Iterable<String> urls);
typedef URLLoader = Future<Uint8List> Function(String url);

extension RandomElement<T> on Iterable<T> {
  T randomElement() => elementAt(Random().nextInt(length));
}

class AppBloc extends Bloc<AppEvent, AppState> {
  String _picker(Iterable<String> urls) => urls.randomElement();
  Future<Uint8List> _loadUrl(String url) => NetworkAssetBundle(Uri.parse(url))
      .load(url)
      .then((value) => value.buffer.asUint8List());

  AppBloc({
    RandomURLPicker? urlPicker,
    Duration? duration,
    required Iterable<String> urls,
    URLLoader? urlLoader,
  }) : super(const AppState.empty()) {
    on<LoadNextUrlEvent>((event, emit) async {
      emit(const AppState(isLoading: true, data: null, error: null));
      final url = (urlPicker ?? _picker)(urls);
      try {
        if (duration != null) {
          await Future.delayed(duration);
        }
        final data = await (urlLoader ?? _loadUrl)(url);
        // comment
        // final bundle = NetworkAssetBundle(Uri.parse(url));
        // final data = (await bundle.load(url)).buffer.asUint8List();
        emit(AppState(isLoading: false, data: data, error: null));
      } catch (e) {
        emit(AppState(isLoading: false, data: null, error: e));
      }
    });
  }
}
