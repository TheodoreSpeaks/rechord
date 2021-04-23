import 'package:flutter/material.dart';
import 'package:sounds/sounds.dart';
import 'dart:math';

import '../SongPage.dart';
import '../constants.dart';

class TrackCard extends StatefulWidget {
  final String title;
  final String genre;
  final String user;
  final String filePath;
  final int likes;
  final String postId;

  static const String defaultFilePath =
      '../data/1/post_5eedf534-47e3-4f7a-91e5-ffd8c2c9fb58.aac';
  const TrackCard(
      {Key? key,
      required this.title,
      required this.genre,
      this.filePath = defaultFilePath,
      this.likes: 0,
      this.postId: '0',
      required this.user})
      : super(key: key);

  TrackCard.fromJson(Map<String, dynamic> json, this.likes)
      : title = json['title'],
        genre = json['genre'],
        user = json['user'],
        postId = json['post_id'],
        filePath = json['file'];

  @override
  _TrackCardState createState() => _TrackCardState();
}

class _TrackCardState extends State<TrackCard> {
  String currentGenre = 'Genre';
  bool liked = false;

  Future<Track> loadTrack() async {
    Track track;
    track = Track.fromURL('$ip/get_file?path=${widget.filePath}',
        mediaFormat: WellKnownMediaFormats.adtsAac);
    return track;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SongPage(),
      )),
      child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.red, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(32)),
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Spacer(),
                Row(
                  children: [
                    Icon(
                      Icons.music_note,
                      color: Colors.white,
                    ),
                    Text(
                      widget.genre,
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ]),
              Text(
                widget.title,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Text(
                "@${widget.user}",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Spacer(),
              Row(
                children: [
                  Expanded(
                      child:
                          SoundPlayerUI.fromLoader((context) => loadTrack())),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: InkWell(
                      onTap: () => setState(() => liked = !liked),
                      child: Column(
                        children: [
                          Text(
                            "${widget.likes + (liked ? 1 : 0)}",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          Icon(
                            liked ? Icons.favorite : Icons.favorite_border,
                            color: Colors.white,
                            size: 36,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }

  void onBottomLabelTap(String label) {
    setState(() {
      currentGenre = label;
    });
  }
}

class BottomSelectableItem extends StatelessWidget {
  final String label;
  final Function onTap;
  const BottomSelectableItem({
    Key? key,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap(label);
        Navigator.of(context).pop();
      },
      child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(bottom: 8.0, left: 16),
          child: Text(
            label,
            style: TextStyle(fontSize: 20),
          )),
    );
  }
}
