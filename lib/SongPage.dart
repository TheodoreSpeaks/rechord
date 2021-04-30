import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rechord/RecordingPage.dart';
import 'dart:math';
import 'package:timeago/timeago.dart' as timeago;

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
  bool playing = false;

  List<dynamic> commentsJson = [];
  List<dynamic> tracksJson = [];

  List<SoundPlayer> players = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    refresh();

    _commentController = TextEditingController();

    liked = widget.isLiked;
  }

  Future<Track> loadTrack(String path) async {
    Track track;
    track = Track.fromURL('$ip/get_file?path=$path',
        mediaFormat: WellKnownMediaFormats.adtsAac);
    return track;
  }

  List<String> getTrackPaths() {
    List<String> toReturn = [widget.filePath];

    for (dynamic json in tracksJson) {
      toReturn.add(json['file']);
    }
    return toReturn;
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
      "time": DateTime.now().toString(),
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
        return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: Container(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(32.0)),
              height: 260,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Add a comment', style: TextStyle(fontSize: 24)),
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
                        SizedBox(width: 8.0),
                        FloatingActionButton.extended(
                            key: null,
                            onPressed: () {
                              submitComment();
                              Navigator.of(context).pop();
                            },
                            label: Text('Submit'))
                        // TextButton(
                        //     onPressed: () {
                        //       submitComment();
                        //       Navigator.of(context).pop();
                        //     },
                        //     child: Text('Submit')),
                      ],
                    ),
                  ]),
            ));
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
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => RecordingPage(
                title: widget.title,
                author: widget.user,
                filePath: widget.filePath,
                postId: widget.postId,
              ),
            ));
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
                            dynamic json = tracksJson[index];
                            return TrackComment(
                              title: json['title'],
                              likes: 0,
                              filePath: json['file'],
                              time: json['time'],
                              user: json['user'],
                            );
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
                              time: json['time'],
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
                  child: SoundPlayerUI.fromLoader(
                      (context) => loadTrack(widget.filePath))),
              // FloatingActionButton(
              //   key: null,
              //   onPressed: () {
              //     if (!playing) {
              //       startPlayer();
              //     } else {
              //       stopPlayer();
              //     }
              //     setState(() {
              //       playing = !playing;
              //     });
              //   },
              //   child: Icon(playing ? Icons.pause : Icons.play_arrow),
              //   backgroundColor: Colors.lightGreen,
              // ),
              // Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: InkWell(
                  onTap: () => setState(() => liked = !liked),
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

class TrackComment extends StatefulWidget {
  final String title;
  final String user;
  final int likes;
  final String filePath;
  final String time;

  const TrackComment(
      {Key? key,
      this.title = 'Lorem ipsum',
      this.user = 'TheodoreSpeaks',
      this.likes = 0,
      this.filePath = '',
      required this.time})
      : super(key: key);

  @override
  _TrackCommentState createState() => _TrackCommentState();
}

class _TrackCommentState extends State<TrackComment> {
  Future<Track> loadTrack(String path) async {
    Track track;
    track = Track.fromURL('$ip/get_file?path=$path',
        mediaFormat: WellKnownMediaFormats.adtsAac);
    return track;
  }

  bool liked = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.all(4),
              child: Text(
                  '@${widget.user}, ${timeago.format(DateTime.parse(widget.time), locale: 'en_short')}')),
          Padding(
              padding: EdgeInsets.all(4),
              child: Text(widget.title, style: TextStyle(fontSize: 18))),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                  child: SoundPlayerUI.fromLoader(
                      (context) => loadTrack(widget.filePath))),
              SizedBox(width: 8.0),
              Icon(
                liked ? Icons.favorite : Icons.favorite_border,
                size: 24,
              ),
              SizedBox(width: 8.0),
              Text('${widget.likes + (liked ? 1 : 0)}')
            ],
          )
        ],
      ),
    );
  }
}

class Comment extends StatefulWidget {
  final String title;
  final String user;
  final String time;
  final int likes;

  const Comment(
      {Key? key,
      required this.title,
      required this.user,
      required this.likes,
      required this.time})
      : super(key: key);

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  bool liked = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                '@${widget.user}, ${timeago.format(DateTime.parse(widget.time), locale: 'en_short')}'),
            InkWell(
              onTap: () => setState(() => liked = !liked),
              child: Row(
                children: [
                  Expanded(
                    child:
                        Text(this.widget.title, style: TextStyle(fontSize: 18)),
                  ),
                  Icon(
                    liked ? Icons.favorite : Icons.favorite_border,
                    size: 24,
                  ),
                  SizedBox(width: 8.0),
                  Text('${widget.likes + (liked ? 1 : 0)}')
                ],
              ),
            ),
            SizedBox(height: 8),
          ],
        ));
  }
}
