import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

class SubmitPage extends StatefulWidget {
  final String path;

  const SubmitPage({Key? key, required this.path}) : super(key: key);

  @override
  _SubmitPageState createState() => _SubmitPageState();
}

class _SubmitPageState extends State<SubmitPage> {
  late Track track;
  @override
  void initState() {
    super.initState();

    track = Track(trackPath: widget.path, codec: Codec.aacADTS);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Add submission title')),
        body: Center(
            child: Container(
                width: 400,
                height: 300,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('Submission title...'),
                        Spacer(),
                      ],
                    ),
                    SoundPlayerUI.fromTrack(track),
                    FloatingActionButton.extended(
                        onPressed: () {},
                        label: Text('Post', style: TextStyle(fontSize: 24)),
                        key: null),
                  ],
                ))));
  }
}
