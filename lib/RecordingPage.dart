import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rechord/SubmitPage.dart';
import 'package:rechord/components/WaveVisualization.dart';
import 'package:sounds/sounds.dart';

enum RecordingStage { notRecording, recording, reviewRecording }

class RecordingPage extends StatefulWidget {
  final String? title;
  final String? author;
  final Track? track;

  const RecordingPage({Key? key, this.title, this.author, this.track})
      : super(key: key);
  @override
  _RecordingPageState createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> {
  RecordingStage? stage;
  late DateTime recordStartTime;
  late Timer timer;

  late SoundRecorder _recorder;
  late SoundPlayer _player;
  // Track? track;

  static const String recordTrack = 'recorded_sound';
  // static const Codec recordCodec = Codec.aacADTS;
  String recording = Track.tempFile(WellKnownMediaFormats.adtsAac);
  Track? track;

  @override
  void initState() {
    super.initState();

    stage = RecordingStage.notRecording;
    const oneSecond = const Duration(milliseconds: 100);
    timer = Timer.periodic(oneSecond, (Timer t) {
      if (mounted && stage == RecordingStage.recording) {
        setState(() {});
      }
    });

    requestPermissions();

    track =
        Track.fromFile(recording, mediaFormat: WellKnownMediaFormats.adtsAac);

    _recorder = SoundRecorder();

    _player = SoundPlayer.noUI();
  }

  @override
  void dispose() {
    timer.cancel();
    _recorder.release();
    _player.release();
    super.dispose();
  }

  void requestPermissions() async {
    var status = await Permission.microphone.status;
    if (status.isDenied) {
      Permission.microphone.request();
    }
  }

  String getTitleText() {
    switch (stage!) {
      case RecordingStage.notRecording:
        return 'Start recording!';
      case RecordingStage.recording:
        return 'Recording...';
      case RecordingStage.reviewRecording:
        return 'Recorded!';
    }
  }

  void record() async {
    _recorder.record(track);
  }

  void stopRecorder() async {
    _recorder.stop();
    // await _recorder.stopRecorder();
    // track = Track(trackPath: recordTrack, codec: recordCodec);
    setState(() {});
  }

  void startPlayer() async {
    // await _player.startPlayer(
    //     fromURI: recordTrack,
    //     codec: recordCodec,
    //     whenFinished: () {
    //       setState(() {});
    //     });

    setState(() {});
  }

  void stopPlayer() async {
    // await _player.stopPlayer();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              getTitleText(),
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
            SizedBox(height: 32.0),
            Text(
              widget.title != null ? widget.title! : 'Your new song!',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 8.0),
            Text(
              'By ${widget.author != null ? widget.author : 'you!'}',
              style:
                  TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
            ),
            Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WaveVisualization(),
                    widget.track != null
                        ? Column(
                            children: [
                              SizedBox(height: 128),
                              WaveVisualization(),
                            ],
                          )
                        : Container(),
                  ],
                )),
            Spacer(flex: 1),
            stage != RecordingStage.reviewRecording
                ? buildBottomRecording()
                : buildBottomReview(),
          ],
        ),
      ),
    );
  }

  Column buildBottomRecording() {
    Duration duration = stage == RecordingStage.recording
        ? DateTime.now().difference(recordStartTime)
        : Duration(milliseconds: 0);

    int min = duration.inMinutes;
    int sec = duration.inSeconds % 60;
    return Column(
      children: [
        Text('$min:${sec ~/ 10 == 0 ? '0' + sec.toString() : sec} / 1:00',
            style: TextStyle(color: Colors.white)),
        SizedBox(height: 16.0),
        InkWell(
          onTap: () {
            switch (stage!) {
              case RecordingStage.notRecording:
                stage = RecordingStage.recording;
                recordStartTime = DateTime.now();
                record();
                break;
              case RecordingStage.recording:
                stage = RecordingStage.reviewRecording;
                stopRecorder();
                setState(() {});
                break;
              case RecordingStage.reviewRecording:
                stage = RecordingStage.notRecording;
                break;
            }
            setState(() {});
          },
          child: Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32), color: Colors.white),
            child: Stack(
              children: [
                stage == RecordingStage.recording
                    ? Center(
                        child: SizedBox(
                        width: 61, // Get progress aligned with circle
                        height: 61,
                        child: CircularProgressIndicator(
                          value: duration.inMilliseconds /
                              Duration(minutes: 1).inMilliseconds,
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.red),
                        ),
                      ))
                    : Container(),
                Center(
                  child: Icon(
                    stage == RecordingStage.notRecording
                        ? Icons.fiber_manual_record
                        : Icons.stop,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 32.0),
      ],
    );
  }

  Column buildBottomReview() {
    return Column(
      children: [
        track != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: SoundPlayerUI.fromTrack(track!),
              )
            : Container(),
        SizedBox(height: 64),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () => setState(() => stage = RecordingStage.notRecording),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.history,
                      color: Colors.white,
                      size: 36,
                    ),
                    SizedBox(width: 8.0),
                    Text('Retry',
                        style: TextStyle(color: Colors.white, fontSize: 24))
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SubmitPage(
                  track: track!,
                ),
              )),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('Next',
                        style: TextStyle(color: Colors.white, fontSize: 24)),
                    SizedBox(width: 8.0),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.white,
                      size: 36,
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
