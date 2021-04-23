import 'package:flutter/material.dart';
import 'package:rechord/components/TrackCard.dart';
import 'package:sounds/sounds.dart';

class SubmitPage extends StatefulWidget {
  final Track track;

  const SubmitPage({Key? key, required this.track}) : super(key: key);

  @override
  _SubmitPageState createState() => _SubmitPageState();
}

class _SubmitPageState extends State<SubmitPage> {
  @override
  void initState() {
    super.initState();

    // track = Track(trackPath: widget.path, codec: Codec.aacADTS);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Add submission title')),
        body: Center(
            child: Container(
                child: Column(
          children: [
            TrackCard(
              isEditable: true,
              track: widget.track,
            ),
            SizedBox(height: 32.0),
            FloatingActionButton.extended(
                onPressed: () {
                  Navigator.of(context).popUntil(ModalRoute.withName('/'));
                },
                label: Text('Post', style: TextStyle(fontSize: 24)),
                key: null),
          ],
        ))));
  }
}
