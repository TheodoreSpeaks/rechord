import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.purple,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('reChord'),
        centerTitle: true,
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            TrackCard(),
            TrackCard(),
            TrackCard(),
            TrackCard(),
            TrackCard(),
            TrackCard(),
            TrackCard(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class TrackCard extends StatelessWidget {
  const TrackCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            Row(children: [
              Spacer(),
              Icon(
                Icons.music_note,
                color: Colors.white,
              ),
              Text(
                'Rock',
                style: TextStyle(color: Colors.white),
              )
            ]),
            Text(
              'Created a funky bassline, let me know what you think!',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Text(
              '@TheodoreSpeaks',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Spacer(),
            Row(
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.lightGreen,
                  child: Icon(
                    Icons.play_arrow,
                    size: 36,
                  ),
                ),
                Spacer(),
                buildTrackVisualization(),
                Spacer(),
                Column(
                  children: [
                    Text(
                      '36',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                      size: 36,
                    )
                  ],
                )
              ],
            )
          ],
        ));
  }

  Widget buildTrackVisualization() {
    List<Widget> lines = [];
    for (int i = 0; i < 35; i++) {
      lines.add(Container(
        margin: EdgeInsets.all(1),
        decoration: BoxDecoration(
            color: Colors.white70, borderRadius: BorderRadius.circular(30)),
        width: 6,
        height: 24 * (sin(i * pi / 4) + 1),
      ));
    }
    return Row(
      children: lines,
    );
  }
}
