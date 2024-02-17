import 'dart:async';
import 'package:flutter_tube/api.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_tube/models/video_model.dart';

abstract class VideosBloc implements BlocBase {
  late Api api = Api();
  List<Video> videos = [];
  Sink<String> get inSearch => _searchController.sink;
  Stream<List<Video>> get outVideos => _videosController.stream;
  final StreamController<List<Video>> _videosController =
      StreamController<List<Video>>.broadcast();
  final StreamController<String> _searchController = StreamController<String>();

  VideosBloc() {
    _searchController.stream.listen(_search);
  }

  void _search(String search) async {
    List<Video> searchedVideos = await api.search(search);
    _videosController.sink.add(searchedVideos);
  }

  @override
  void dispose() {
    _videosController.close();
    _searchController.close();
  }
}
