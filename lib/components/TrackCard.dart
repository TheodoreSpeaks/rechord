import 'package:flutter/material.dart';
import 'package:sounds/sounds.dart';
import 'dart:math';

import '../SongPage.dart';

class TrackCard extends StatefulWidget {
  final bool isEditable;
  final Track? track;

  const TrackCard({Key? key, this.isEditable: false, this.track})
      : super(key: key);
  @override
  _TrackCardState createState() => _TrackCardState();
}

class _TrackCardState extends State<TrackCard> {
  String currentGenre = 'Genre';

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
                widget.isEditable
                    ? FloatingActionButton.extended(
                        key: null,
                        backgroundColor: Colors.white,
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text('Choose a genre:',
                                          style: TextStyle(fontSize: 28)),
                                    ),
                                    BottomSelectableItem(
                                        label: 'Country',
                                        onTap: onBottomLabelTap),
                                    BottomSelectableItem(
                                        label: 'Rock', onTap: onBottomLabelTap),
                                    BottomSelectableItem(
                                        label: 'Indie',
                                        onTap: onBottomLabelTap),
                                    BottomSelectableItem(
                                        label: 'Soul', onTap: onBottomLabelTap),
                                  ],
                                ));
                              });
                        },
                        label: Text(currentGenre,
                            style: TextStyle(color: Colors.purple)))
                    : Row(
                        children: [
                          Icon(
                            Icons.music_note,
                            color: Colors.white,
                          ),
                          Text(
                            'Rock',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
              ]),
              widget.isEditable
                  ? Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                enabledBorder: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.white54),
                                hintText: 'Title your masterpiece!'),
                          ),
                        ),
                      ],
                    )
                  : Text(
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
                  widget.isEditable
                      ? Expanded(child: SoundPlayerUI.fromTrack(widget.track))
                      : Container(),
                  widget.isEditable
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            children: [
                              Text(
                                '36',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              Icon(
                                Icons.favorite_border,
                                color: Colors.white,
                                size: 36,
                              )
                            ],
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
