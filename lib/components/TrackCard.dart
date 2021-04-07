import 'package:flutter/material.dart';
import 'dart:math';

import '../SongPage.dart';

class TrackCard extends StatelessWidget {
  const TrackCard({
    Key key,
  }) : super(key: key);

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
                Icon(
                  Icons.music_note,
                  color: Colors.white,
                ),
                Text(
                  'Rock',
                  style: TextStyle(color: Colors.white),
                )
              ]),
              Text(
                'Created a funky bassline, let me know what you think!',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Text(
                '@TheodoreSpeaks',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Spacer(),
              Row(
                children: [
                  FloatingActionButton(
                    heroTag: null,
                    onPressed: () {},
                    backgroundColor: Colors.lightGreen,
                    child: Icon(
                      Icons.play_arrow,
                      size: 36,
                    ),
                  ),
                  Spacer(),
                  buildTrackVisualization(),
                  Spacer(),
                  Column(
                    children: [
                      Text(
                        '36',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                        size: 36,
                      )
                    ],
                  )
                ],
              )
            ],
          )),
    );
  }

  Widget buildTrackVisualization() {
    List<Widget> lines = [];
    for (int i = 0; i < 35; i++) {
      lines.add(Container(
        margin: EdgeInsets.all(1),
        decoration: BoxDecoration(
            color: Colors.white70, borderRadius: BorderRadius.circular(30)),
        width: 6,
        height: 24 * (sin(i * pi / 4) + 1),
      ));
    }
    return Row(
      children: lines,
    );
  }
}
