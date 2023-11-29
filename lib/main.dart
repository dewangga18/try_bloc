import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<PersonUrl, Iterable<Person>> _cacheResult = {};
  PersonBloc() : super(null) {
    on<LoadPersonsAction>((event, emit) async {
      final url = event.url;
      if (_cacheResult.containsKey(url)) {
        final cachedPerson = _cacheResult[url]!;
        final result = FetchResult(persons: cachedPerson, isCache: true);
        emit(result);
      } else {
        final persons = await getPersons(url.urlString);
        _cacheResult[url] = persons;
        final result = FetchResult(persons: persons, isCache: false);
        emit(result);
      }
    });
  }
}

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonsAction implements LoadAction {
  final PersonUrl url;

  const LoadPersonsAction({required this.url}) : super();
}

@immutable
class Person {
  final String name;
  final int age;

  const Person({required this.name, required this.age});

  Person.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        age = json["age"];
}

@immutable
class FetchResult {
  final Iterable<Person> persons;
  final bool isCache;

  const FetchResult({required this.persons, required this.isCache});

  @override
  String toString() => 'From cache $isCache => $persons';
}

enum PersonUrl { persons1, persons2 }

Future<Iterable<Person>> getPersons(String url) async => HttpClient()
    .getUrl(Uri.parse(url))
    .then((req) => req.close())
    .then((resp) => resp.transform(utf8.decoder).join())
    .then((str) => json.decode(str) as List<dynamic>)
    .then((list) => list.map((val) => Person.fromJson(val)));

extension UrlString on PersonUrl {
  String get urlString {
    switch (this) {
      case PersonUrl.persons1:

        /// start live server
        /// adb reverse tcp:5500 tcp:5500 common issues when use android emulator
        return 'http://127.0.0.1:5500/api/persons1.json';
      case PersonUrl.persons2:
        return 'http://127.0.0.1:5500/api/persons2.json';
    }
  }
}

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
                        const LoadPersonsAction(url: PersonUrl.persons1),
                      );
                },
                child: const Text('Load Json #1'),
              ),
              TextButton(
                onPressed: () {
                  context.read<PersonBloc>().add(
                        const LoadPersonsAction(url: PersonUrl.persons2),
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
