import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rechord/SubmitPage.dart';
import 'package:rechord/components/WaveVisualization.dart';
import 'package:rechord/constants.dart';
import 'package:sounds/sounds.dart';

enum RecordingStage { notRecording, recording, reviewRecording }

class RecordingPage extends StatefulWidget {
  final String? title;
  final String? author;
  final String? postId;
  final String? filePath;

  const RecordingPage(
      {Key? key, this.title, this.author, this.filePath, this.postId})
      : super(key: key);
  @override
  _RecordingPageState createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> {
  RecordingStage? stage;
  late DateTime recordStartTime;
  late Timer timer;
  late Timer waveTimer;

  List<int> waveArray1 = [];
  List<int> waveArray2 = [];

  late SoundRecorder _recorder;
  String recording = Track.tempFile(WellKnownMediaFormats.adtsAac);
  Track? track;

  SoundPlayer? player;

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
    waveTimer = Timer.periodic(const Duration(milliseconds: 200), (Timer t) {
      if (mounted) {
        var rng = Random();
        if (stage == RecordingStage.recording) {
          setState(() {
            waveArray1.add(rng.nextInt(36) + 6);
            waveArray2.add(rng.nextInt(36) + 6);
          });
        }
      }
    });

    requestPermissions();

    track =
        Track.fromFile(recording, mediaFormat: WellKnownMediaFormats.adtsAac);

    _recorder = SoundRecorder();
  }

  @override
  void dispose() {
    timer.cancel();
    waveTimer.cancel();
    _recorder.release();
    if (player != null) player!.release();
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

  void startPlayerRecorder() async {
    // TODO: might break?
    if (widget.filePath != null) {
      player = SoundPlayer.noUI();
      player!.play(Track.fromURL('$ip/get_file?path=${widget.filePath}',
          mediaFormat: WellKnownMediaFormats.adtsAac));
    }

    record();
  }

  void stopPlayer() async {
    // await _player.stopPlayer();
    if (player != null && !player!.isStopped) {
      await player!.pause();
      await player!.stop();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 128),
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
                    WaveVisualization(data: waveArray1),
                    widget.filePath != null
                        ? Column(
                            children: [
                              SizedBox(height: 128),
                              WaveVisualization(data: waveArray2),
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
                startPlayerRecorder();
                break;
              case RecordingStage.recording:
                stage = RecordingStage.reviewRecording;
                stopRecorder();
                stopPlayer();
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
                  postId: widget.postId,
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
