import 'package:flutter/material.dart';
import 'dart:math';

class SongPage extends StatefulWidget {
  @override
  _SongPageState createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                ListView(
                  children: [
                    TrackComment(),
                    TrackComment(),
                    TrackComment(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FloatingActionButton.extended(
                          heroTag: null,
                          onPressed: () {},
                          label: Text('Add a new track')),
                    )
                  ],
                ),
                Text('It\'s rainy here'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
            "Created this funky bassline, have fun with it y'all!",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          SizedBox(height: 10.0),
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
          ),
          Spacer()
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
        width: 6,
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('@CJRosas'),
          SizedBox(height: 4),
          Text('Got a simple drum track for that!',
              style: TextStyle(fontSize: 18)),
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
