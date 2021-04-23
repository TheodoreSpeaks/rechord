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
                          return TrackComment();
                        }),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
                        child: AspectRatio(
                          aspectRatio: 42 / 9,
                          child: FloatingActionButton.extended(
                              heroTag: null,
                              onPressed: () {},
                              label: Text('Add a new track')),
                        )),
                  )
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
                  Expanded(
                    flex: 2,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
                        child: AspectRatio(
                          aspectRatio: 42 / 9,
                          child: FloatingActionButton.extended(
                              heroTag: null,
                              onPressed: () {},
                              label: Text('Add a comment')),
                        )),
                  )
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Text("sample text"));
  }
}
