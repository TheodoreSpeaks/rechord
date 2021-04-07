import 'package:flutter/material.dart';

class RecordingPage extends StatelessWidget {
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
              'Start recording!',
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
            Text('0:00 / 1:00', style: TextStyle(color: Colors.white)),
            SizedBox(height: 16.0),
            Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 6),
                  borderRadius: BorderRadius.circular(32),
                  color: Colors.red),
              child: Center(
                child: Icon(
                  Icons.fiber_manual_record,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 32.0),
          ],
        ),
      ),
    );
  }
}
