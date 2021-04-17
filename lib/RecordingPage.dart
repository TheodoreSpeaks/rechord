import 'dart:async';

import 'package:flutter/material.dart';

enum RecordingStage { notRecording, recording, reviewRecording }

class RecordingPage extends StatefulWidget {
  @override
  _RecordingPageState createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> {
  RecordingStage stage;
  DateTime recordStartTime;
  Timer timer;

  @override
  void initState() {
    super.initState();

    stage = RecordingStage.notRecording;
    const oneSecond = const Duration(milliseconds: 100);
    timer = Timer.periodic(oneSecond, (Timer t) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String getTitleText() {
    switch (stage) {
      case RecordingStage.notRecording:
        return 'Start recording!';
      case RecordingStage.recording:
        return 'Recording...';
      case RecordingStage.reviewRecording:
        return 'Recorded!';
    }
    return '';
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
              'Created a funky bassline, have fun with it yall',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 8.0),
            Text(
              'By TheodoreSpeaks, CJRosas, JZhou, and Jack',
              style:
                  TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
            ),
            Expanded(
                flex: 3,
                child: Divider(
                  color: Colors.white,
                  thickness: 8,
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
        Text('${min}:${sec ~/ 10 == 0 ? '0' + sec.toString() : sec} / 1:00',
            style: TextStyle(color: Colors.white)),
        SizedBox(height: 16.0),
        InkWell(
          onTap: () {
            switch (stage) {
              case RecordingStage.notRecording:
                stage = RecordingStage.recording;
                recordStartTime = DateTime.now();
                break;
              case RecordingStage.recording:
                stage = RecordingStage.reviewRecording;
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
              onTap: () => setState(() => stage = RecordingStage.notRecording),
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
