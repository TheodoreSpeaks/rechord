import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rechord/components/TrackCard.dart';
import 'package:sounds/sounds.dart';
import 'package:dio/dio.dart';
import 'package:rechord/constants.dart';

class SubmitPage extends StatefulWidget {
  final Track track;
  final String? postId;

  const SubmitPage({Key? key, required this.track, this.postId})
      : super(key: key);

  @override
  _SubmitPageState createState() => _SubmitPageState();
}

class _SubmitPageState extends State<SubmitPage> {
  String currentGenre = 'Genre';
  late TextEditingController _titleController;
  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController();

    // track = Track(trackPath: widget.path, codec: Codec.aacADTS);
  }

  void submitPost() async {
    var dio = Dio();

    if (widget.postId == null) {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(widget.track.path),
        "genre": currentGenre,
        "title": _titleController.text,
        "user": "TheodoreSpeaks"
      });

      var response = await dio.post('$ip/new_post', data: formData);
    } else {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(widget.track.path),
        "title": _titleController.text,
        "user": "TheodoreSpeaks"
      });

      var response =
          await dio.post('$ip/new_track/${widget.postId}', data: formData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Add submission title')),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              submitPost();
              Navigator.of(context).popUntil(ModalRoute.withName('/'));
            },
            label: Text('Post'),
            icon: Icon(Icons.send),
            key: null),
        body: Center(
            child: Container(
                child: Column(
          children: [
            Container(
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
                    Expanded(
                      child: Row(children: [
                        Expanded(
                          child: TextFormField(
                            controller: _titleController,
                            style: TextStyle(color: Colors.white),
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            decoration: InputDecoration(
                                enabledBorder: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.white70),
                                hintText: 'Title your masterpiece!'),
                          ),
                        ),
                        widget.postId == null
                            ? FloatingActionButton.extended(
                                key: null,
                                backgroundColor: Colors.white,
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Text('Choose a genre:',
                                                  style:
                                                      TextStyle(fontSize: 28)),
                                            ),
                                            BottomSelectableItem(
                                                label: 'Country',
                                                onTap: onBottomLabelTap),
                                            Divider(),
                                            BottomSelectableItem(
                                                label: 'Rock',
                                                onTap: onBottomLabelTap),
                                            Divider(),
                                            BottomSelectableItem(
                                                label: 'Indie',
                                                onTap: onBottomLabelTap),
                                            Divider(),
                                            BottomSelectableItem(
                                                label: 'Soul',
                                                onTap: onBottomLabelTap),
                                          ],
                                        ));
                                      });
                                },
                                label: Text(currentGenre,
                                    style: TextStyle(color: Colors.purple)))
                            : Container()
                      ]),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Expanded(child: SoundPlayerUI.fromTrack(widget.track)),
                      ],
                    )
                  ],
                )),
          ],
        ))));
  }

  void onBottomLabelTap(String label) {
    setState(() {
      currentGenre = label;
    });
  }
}
