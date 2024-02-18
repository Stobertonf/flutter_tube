import 'package:flutter/material.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_tube/pages/favorites.dart';
import 'package:flutter_tube/blocs/videos_bloc.dart';
import 'package:flutter_tube/widgets/videotile.dart';
import 'package:flutter_tube/models/video_model.dart';
import 'package:flutter_tube/blocs/favorite_bloc.dart';
import 'package:flutter_tube/delegates/data_search.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.getBloc<VideosBloc>(); // Use o VideosBloc

    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 25,
          child: Image.asset(
            "images/yt_logo_rgb_dark.png",
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.black87,
        actions: <Widget>[
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, Video>>(
              stream: BlocProvider.getBloc<FavoriteBloc>().outFav,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text("${snapshot.data!.length}");
                } else {
                  return Container();
                }
              },
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.star,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const Favorites(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.search,
            ),
            onPressed: () async {
              String? result = await showSearch(
                context: context,
                delegate: DataSearch(),
              );
              if (result != null) bloc.search(result);
            },
          )
        ],
      ),
      backgroundColor: Colors.black87,
      body: StreamBuilder(
        stream: bloc.getVideos(),
        initialData: const [],
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            if (data != null && data.isNotEmpty) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  if (index < data.length) {
                    return VideoTile(data[index]);
                  } else {
                    if (index > 1) {
                      return Container(
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }
                },
                itemCount: data.length + 1,
              );
            } else {
              return Container();
            }
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
