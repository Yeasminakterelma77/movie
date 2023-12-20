import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: MovieZone(),
    );
  }
}

class MovieZone extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MovieZoneState();
  }
}

class MovieZoneState extends State<MovieZone> {
  final String apiKey = "a1fd18df"; // Replace with your actual API key
  final String baseUrl = "http://www.omdbapi.com/";

  TextEditingController movieController = TextEditingController();
  Map<String, dynamic> movieData = {};

  Future<void> getMovieData(String movieName) async {
    final String apiUrl =
        "$baseUrl?apikey=$apiKey&t=${Uri.encodeQueryComponent(movieName)}";

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      setState(() {
        movieData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load movie data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Movie Zone")),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Movie Name'),
                style: TextStyle(fontSize: 20),
                controller: movieController,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                child: Text("Find", style: TextStyle(fontSize: 20)),
                onPressed: () {
                  String movieName = movieController.text.trim();
                  if (movieName.isNotEmpty) {
                    getMovieData(movieName);
                  }
                },
              ),
              SizedBox(height: 20),
              movieData.isNotEmpty
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (movieData['Poster'] != "N/A")
                    Image.network(
                      movieData['Poster'],
                      height: 300,
                      width: 300,
                    ),
                  Text("Title: ${movieData['Title']}",
                      style: TextStyle(fontSize: 18)),
                  Text("Release Year: ${movieData['Released']}",
                      style: TextStyle(fontSize: 18)),
                  Text("Runtime: ${movieData['Runtime']}",
                      style: TextStyle(fontSize: 18)),
                  Text("Director: ${movieData['Director']}",
                      style: TextStyle(fontSize: 18)),
                  Text("Box Office: ${movieData['BoxOffice']}",
                      style: TextStyle(fontSize: 18)),
                  Text("Country: ${movieData['Country']}",
                      style: TextStyle(fontSize: 18)),
                  Text("Actors: ${movieData['Actors']}",
                      style: TextStyle(fontSize: 18)),
                  Text("Plot: ${movieData['Plot']}",
                      style: TextStyle(fontSize: 18)),
                ],
              )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
