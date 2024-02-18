import 'package:flutter/material.dart';
import 'package:flutter_tube/api.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_tube/models/video_model.dart';
import 'package:flutter_tube/blocs/favorite_bloc.dart';

class Favorites extends StatelessWidget {
  const Favorites({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.getBloc<FavoriteBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Favoritos",
        ),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Colors.black87,
      body: StreamBuilder<Map<String, Video>>(
          stream: bloc.outFav,
          initialData: const {},
          builder: (context, snapshot) {
            return ListView(
              children: snapshot.data!.values.map((v) {
                return InkWell(
                  onTap: () {
                    /*  FlutterYoutube.playYoutubeVideoById(
                        apiKey: API_KEY, videoId: v.id);*/
                  },
                  onLongPress: () {
                    bloc.toggleFavorite(v);
                  },
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 100,
                        height: 50,
                        child: Image.network(v.thumb),
                      ),
                      Expanded(
                        child: Text(
                          v.title,
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                          maxLines: 2,
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),
            );
          }),
    );
  }
}
