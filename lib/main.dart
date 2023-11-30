import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:try_bloc/bloc/bloc_actions.dart';
import 'package:try_bloc/bloc/person.dart';
import 'package:try_bloc/bloc/persons_bloc.dart';

Future<Iterable<Person>> getPersons(String url) async => HttpClient()
    .getUrl(Uri.parse(url))
    .then((req) => req.close())
    .then((resp) => resp.transform(utf8.decoder).join())
    .then((str) => json.decode(str) as List<dynamic>)
    .then((list) => list.map((val) => Person.fromJson(val)));

extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}

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
      home: BlocProvider(
        create: (_) => PersonBloc(),
        child: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning BLOC'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          BlocBuilder<PersonBloc, FetchResult?>(
            buildWhen: (prev, current) {
              return prev?.persons != current?.persons;
            },
            builder: (context, state) {
              final persons = state?.persons;
              if (persons == null) {
                return const SizedBox();
              }

              return Column(
                children: [
                  Text('Retrieve From Cache : ${state?.isCache ?? false}'),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: persons.length,
                    itemBuilder: (_, i) {
                      final person = persons[i];
                      return Center(
                        child: Text('${person?.name} - ${person?.age}'),
                      );
                    },
                  ),
                ],
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  context.read<PersonBloc>().add(
                        const LoadPersonsAction(
                          url: persons1Url,
                          loader: getPersons,
                        ),
                      );
                },
                child: const Text('Load Json #1'),
              ),
              TextButton(
                onPressed: () {
                  context.read<PersonBloc>().add(
                        const LoadPersonsAction(
                          url: persons2Url,
                          loader: getPersons,
                        ),
                      );
                },
                child: const Text('Load Json #2'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
