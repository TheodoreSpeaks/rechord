import 'package:flutter/material.dart';

String ip = 'http://192.168.1.146:5000';

class Genre {
  final String name;
  final MaterialColor topLeftColor;
  final MaterialColor bottomRightColor;

  Genre({
    this.topLeftColor: Colors.red,
    this.bottomRightColor: Colors.purple,
    required this.name,
  });
}

List<Genre> genres = [
  Genre(name: 'Country'),
  Genre(name: 'Rock'),
  Genre(name: 'Jazz'),
  Genre(name: 'Hip Hop'),
  Genre(name: 'Pop'),
  Genre(name: 'Indie'),
  Genre(name: 'Soul'),
];
