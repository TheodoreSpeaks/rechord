import 'package:flutter/material.dart';
import 'dart:math';

import 'package:sounds/sounds.dart';

import 'constants.dart';

class SongPage extends StatefulWidget {
  final String title;
  final String user;
  final String genre;
  final String filePath;
  final int likes;
  final bool isLiked;
  final String postId;

  const SongPage(
      {Key? key,
      required this.title,
      required this.user,
      required this.genre,
      required this.filePath,
      required this.likes,
      required this.isLiked,
      required this.postId})
      : super(key: key);

  @override
  _SongPageState createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> with TickerProviderStateMixin {
  TabController? _tabController;
  late bool liked;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController?.addListener(() {
      setState(() {});
    });

    liked = widget.isLiked;
  }

  Future<Track> loadTrack() async {
    Track track;
    track = Track.fromURL('$ip/get_file?path=${widget.filePath}',
        mediaFormat: WellKnownMediaFormats.adtsAac);
    return track;
  }

  void refresh() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label:
            Text(_tabController?.index == 0 ? 'Add a track' : 'Add a comment'),
        icon: Icon(Icons.add),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: buildHeader(),
          ),
          Expanded(
            flex: 5,
            child: buildTrackComments(),
          )
        ],
      ),
    );
  }

  Container buildTrackComments() {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const <Widget>[
              Tab(
                icon: Icon(
                  Icons.library_music,
                  color: Colors.black,
                ),
                child: Text('Tracks', style: TextStyle(color: Colors.black)),
              ),
              Tab(
                icon: Icon(
                  Icons.comment,
                  color: Colors.black,
                ),
                child: Text('Comments', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Column(children: [
                  Expanded(
                    child: ListView.separated(
                        itemCount: getTrackCount(),
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(),
                        padding: EdgeInsets.all(16.0),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return TrackComment();
                        }),
                  ),
                ]),
                Column(children: [
                  Expanded(
                    flex: 8,
                    child: ListView.separated(
                        itemCount: getTrackCount(),
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(),
                        padding: EdgeInsets.all(16.0),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return Comment();
                        }),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int getTrackCount() {
    // Do backend stuff
    return 4;
  }

  Container buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      width: double.infinity,
      height: double.infinity,
      // color: Colors.purple,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.red, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          Text(
            widget.title,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          SizedBox(height: 10.0),
          Text(
            '@${widget.user}',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          Spacer(),
          Row(
            children: [
              Expanded(
                  child: SoundPlayerUI.fromLoader((context) => loadTrack())),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  children: [
                    Text(
                      '${widget.likes + (liked ? 1 : 0)}',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Icon(
                      liked ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                      size: 36,
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTrackVisualization() {
    List<Widget> lines = [];
    for (int i = 0; i < 35; i++) {
      lines.add(Container(
        margin: EdgeInsets.all(1),
        decoration: BoxDecoration(
            color: Colors.white70, borderRadius: BorderRadius.circular(30)),
        width: 4,
        height: 24 * (sin(i * pi / 4) + 1),
      ));
    }
    return Row(
      children: lines,
    );
  }
}

class TrackComment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.all(4), child: Text('@CJRosas')),
          Padding(
              padding: EdgeInsets.all(4),
              child: Text('Got a simple drum track for that!',
                  style: TextStyle(fontSize: 18))),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.volume_up),
              Spacer(),
              Icon(
                Icons.favorite_border,
                size: 24,
              ),
              SizedBox(width: 8.0),
              Text('31')
            ],
          )
        ],
      ),
    );
  }
}

class Comment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('@CJRosas'),
            Row(
              children: [
                Expanded(
                  child: Text('Got a simple drum track for that!',
                      style: TextStyle(fontSize: 18)),
                ),
                Icon(
                  Icons.favorite_border,
                  size: 24,
                ),
                SizedBox(width: 8.0),
                Text('31')
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [],
            )
          ],
        ));
  }
}
