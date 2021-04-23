import 'package:dio/dio.dart';
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
  late TabController _tabController;
  late TextEditingController _commentController;
  late bool liked;

  List<dynamic> commentsJson = [];
  List<dynamic> tracksJson = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });

    _commentController = TextEditingController();

    liked = widget.isLiked;
  }

  Future<Track> loadTrack() async {
    Track track;
    track = Track.fromURL('$ip/get_file?path=${widget.filePath}',
        mediaFormat: WellKnownMediaFormats.adtsAac);
    return track;
  }

  Future<void> refresh() async {
    var dio = Dio();

    var response = await dio.get('$ip/single_post/${widget.postId}');
    setState(() {
      commentsJson = response.data['comments'] ?? [];
      tracksJson = response.data['tracks'] ?? [];
    });
  }

  Future<void> submitComment() async {
    var dio = Dio();

    FormData formData = FormData.fromMap({
      "comment": _commentController.text,
      "user": "TheodoreSpeaks",
      "likes": 0
    });

    var response =
        await dio.post('$ip/new_comment/${widget.postId}', data: formData);

    _commentController.clear();
  }

  Future<void> showCommentDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Add a comment'),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 400,
                child: TextFormField(
                  controller: _commentController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.black87),
                      hintText: 'Add your comment!'),
                ),
              ),
            ),
            Row(
              children: [
                Spacer(),
                TextButton(
                    onPressed: () {
                      _commentController.clear();
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel')),
                TextButton(
                    onPressed: () {
                      submitComment();
                      Navigator.of(context).pop();
                    },
                    child: Text('Submit')),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_tabController.index == 0) {
            // TODO: send to collaborate screen
          } else {
            showCommentDialog(context);
          }
        },
        label:
            Text(_tabController.index == 0 ? 'Add a track' : 'Add a comment'),
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
                    child: RefreshIndicator(
                      onRefresh: refresh,
                      child: ListView.separated(
                          itemCount: tracksJson.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              Divider(),
                          padding: EdgeInsets.all(16.0),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            return TrackComment();
                          }),
                    ),
                  ),
                ]),
                Column(children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: refresh,
                      child: ListView.separated(
                          itemCount: commentsJson.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              Divider(),
                          padding: EdgeInsets.all(16.0),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            dynamic json = commentsJson[index];
                            return Comment(
                              title: json['comment'],
                              user: json['user'],
                              likes: int.parse(json['likes']),
                            );
                          }),
                    ),
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
  final String title;
  final String user;
  final int likes;
  final String filePath;

  const TrackComment(
      {Key? key,
      this.title = 'Lorem ipsum',
      this.user = 'TheodoreSpeaks',
      this.likes = 0,
      this.filePath = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.all(4), child: Text('@$user')),
          Padding(
              padding: EdgeInsets.all(4),
              child: Text(title, style: TextStyle(fontSize: 18))),
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
              Text('$likes')
            ],
          )
        ],
      ),
    );
  }
}

class Comment extends StatelessWidget {
  final String title;
  final String user;
  final int likes;

  const Comment(
      {Key? key, required this.title, required this.user, required this.likes})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('@$user'),
            Row(
              children: [
                Expanded(
                  child: Text(this.title, style: TextStyle(fontSize: 18)),
                ),
                Icon(
                  Icons.favorite_border,
                  size: 24,
                ),
                SizedBox(width: 8.0),
                Text('$likes')
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
