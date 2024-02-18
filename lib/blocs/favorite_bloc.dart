import 'dart:async';
import 'dart:convert';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/foundation.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_tube/models/video_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteBloc with ChangeNotifier implements BlocBase {
  Map<String, Video> _favorites = {};
  Stream<Map<String, Video>> get outFav => _favController.stream;
  final _favController = BehaviorSubject<Map<String, Video>>.seeded({});

  FavoriteBloc() {
    SharedPreferences.getInstance().then(
      (prefs) {
        final favoritesJson = prefs.getString("favorites");
        if (favoritesJson != null) {
          final Map<String, dynamic> favoritesMap = json.decode(
            favoritesJson,
          );
          _favorites = favoritesMap.map((k, v) {
            return MapEntry(k, Video.fromJson(v));
          }).cast<String, Video>();

          _favController.add(_favorites);
        }
      },
    );
  }

  void toggleFavorite(Video video) {
    if (_favorites.containsKey(video.id)) {
      _favorites.remove(video.id);
    } else {
      _favorites[video.id] = video;
    }

    _favController.sink.add(_favorites);

    _saveFav();
  }

  void _saveFav() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("favorites", json.encode(_favorites));
    });
  }

  @override
  void dispose() {
    _favController.close();
  }
}
