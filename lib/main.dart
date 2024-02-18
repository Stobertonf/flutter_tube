import 'package:flutter/material.dart';
import 'package:flutter_tube/api.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_tube/pages/home_page.dart';
import 'package:flutter_tube/blocs/videos_bloc.dart';
import 'package:flutter_tube/blocs/favorite_bloc.dart';

void main() {
  Api api = Api();
  api.search("eletro");

  runApp(
    MyApp(
      api: api,
    ),
  );
}

class MyApp extends StatelessWidget {
  final Api api;

  const MyApp({Key? key, required this.api}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [
        Bloc(
          (_) => VideosBloc(api),
        ),
        Bloc(
          (_) => FavoriteBloc(),
        ),
      ],
      dependencies: const [],
      child: MaterialApp(
        title: 'Flutter Tube',
        debugShowCheckedModeBanner: false,
        home: Home(),
      ),
    );
  }
}
