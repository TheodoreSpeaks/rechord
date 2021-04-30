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
        "user": "TheodoreSpeaks",
        "time": DateTime.now().toString()
      });

      var response = await dio.post('$ip/new_post', data: formData);
    } else {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(widget.track.path),
        "title": _titleController.text,
        "user": "TheodoreSpeaks",
        "time": DateTime.now().toString()
      });

      var response =
          await dio.post('$ip/new_track/${widget.postId}', data: formData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.purple, Colors.blue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                ),
                child: Column(
                  children: [
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                    SizedBox(height: 32),
                    Text(
                      'Add submission info',
                      style: TextStyle(color: Colors.white, fontSize: 28),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'For your new song!',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFormField(
                                controller: _titleController,
                                style: TextStyle(color: Colors.white),
                                keyboardType: TextInputType.multiline,
                                maxLines: 3,
                                decoration: InputDecoration(
                                    enabledBorder: InputBorder.none,
                                    hintStyle: TextStyle(color: Colors.white70),
                                    focusColor: Colors.white,
                                    hoverColor: Colors.white,
                                    hintText: 'Title your masterpiece...'),
                              ),
                              SizedBox(height: 16.0),
                              Row(
                                children: [
                                  Expanded(
                                      child: SoundPlayerUI.fromTrack(
                                          widget.track)),
                                  widget.postId == null
                                      ? InkWell(
                                          child: Container(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              margin: const EdgeInsets.only(
                                                  left: 8.0),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(64),
                                                  border: Border.all(
                                                      color: Colors.white)),
                                              child: Text(currentGenre,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16))),
                                          onTap: () => showBottomSheet(context),
                                        )
                                      : Container(),
                                ],
                              ),
                              SizedBox(height: 8.0),
                            ],
                          ),
                        )),

                    // Container()
                    //     padding: EdgeInsets.all(16.0),
                    //     margin:
                    //         EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
                    //     height: 250,
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Expanded(
                    //           child:
                    //         Spacer(),
                    //         Row(
                    //           children: [
                    //             Expanded(
                    //                 child:
                    //                     SoundPlayerUI.fromTrack(widget.track)),
                    //           ],
                    //         )
                    //       ],
                    //     )),
                  ],
                ))));
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child:
                        Text('Choose a genre:', style: TextStyle(fontSize: 28)),
                  ),
                  Wrap(
                      direction: Axis.horizontal,
                      runSpacing: 8.0,
                      children: genres.map((genre) {
                        bool selected = currentGenre == genre.name;
                        return Padding(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: InkWell(
                            onTap: () => setState(() {
                              currentGenre = genre.name;
                              Navigator.of(context).pop();
                            }),
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(32.0),
                                  color: selected
                                      ? Colors.purple
                                      : Colors.transparent,
                                  border: Border.all(color: Colors.purple)),
                              child: Text(
                                genre.name,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: selected
                                        ? Colors.white
                                        : Colors.purple),
                              ),
                              // backgroundColor: Colors.white,
                            ),
                          ),
                        );
                      }).toList())
                ],
              ));
        });
  }

  void onBottomLabelTap(String label) {
    setState(() {
      currentGenre = label;
    });
  }
}
