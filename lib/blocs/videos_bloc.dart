import 'dart:async';
import 'package:flutter_tube/api.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_tube/models/video_model.dart';
import 'package:flutter/foundation.dart';

class VideosBloc with ChangeNotifier implements BlocBase {
  late Api api;
  List<Video> videos = [];

  Sink<String> get inSearch => _searchController.sink;
  Stream<List<Video>> get outVideos => _videosController.stream;
  final StreamController<List<Video>> _videosController =
      StreamController<List<Video>>.broadcast();
  final StreamController<String> _searchController = StreamController<String>();

  VideosBloc(this.api) {
    _searchController.stream.listen(_search);
  }

  void _search(String search) async {
    List<Video> searchedVideos = await api.search(search);
    videos = searchedVideos;
    _videosController.sink.add(searchedVideos);
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _videosController.close();
    _searchController.close();
  }

  void search(String query) {
    inSearch.add(query);
  }

  Stream<List<Video>> getVideos() {
    return outVideos;
  }
}
