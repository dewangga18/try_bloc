import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'dart:math';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class NamesCubit extends Cubit<String?> {
  NamesCubit() : super(null);

  void pickName() => emit(names.randomElement());
}

const names = [
  "Aaron",
  "Evanjulio",
  "Dewangga",
];

extension RandomElement<T> on Iterable<T> {
  T randomElement() => elementAt(Random().nextInt(length));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final NamesCubit cubit;

  @override
  void initState() {
    cubit = NamesCubit();
    super.initState();
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning BLOC'),
      ),
      body: Center(
        child: StreamBuilder<String?>(
          stream: cubit.stream,
          builder: (_, snapshot) {
            final button = TextButton(
              onPressed: () => cubit.pickName(),
              child: const Text('Random Name'),
            );

            switch (snapshot.connectionState) {
              case ConnectionState.none:
               return button;
              case ConnectionState.waiting:
                return button;
              case ConnectionState.active:
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(snapshot.data ?? ''),
                    button,
                  ],
                );
              case ConnectionState.done:
                return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
