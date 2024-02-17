import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(
          Icons.clear,
        ),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(
          context,
          "",
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    } else {
      return FutureBuilder<List<String>>(
        future: suggestions(query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Error',
              ),
            );
          } else {
            return ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    snapshot.data![index],
                  ),
                  leading: const Icon(
                    Icons.play_arrow,
                  ),
                  onTap: () {
                    close(
                      context,
                      snapshot.data![index],
                    );
                  },
                );
              },
              itemCount: snapshot.data!.length,
            );
          }
        },
      );
    }
  }

  Future<List<String>> suggestions(String search) async {
    final Uri url = Uri.parse(
        "http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json");

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> suggestions = json.decode(response.body)[1];
      return suggestions.map<String>((e) => e[0].toString()).toList();
    } else {
      throw Exception(
        "Failed to load suggestions",
      );
    }
  }
}
