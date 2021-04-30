// @dart=2.9
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rechord/constants.dart';

import 'RecordingPage.dart';
import 'components/TrackCard.dart';

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
            textTheme: GoogleFonts.ralewayTextTheme()),
        initialRoute: '/',
        routes: {
          '/': (context) => MyHomePage(),
        });
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> json = [];
  String genre = 'All Genres';

  Future<void> refresh() async {
    var dio = Dio();

    var response = await dio.get('$ip/all_post');
    setState(() {
      json = response.data['feed'];
    });
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredJson = [];
    for (dynamic entry in json) {
      if (genre == 'All Genres' || entry['genre'] == genre) {
        filteredJson.add(entry);
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(genre),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Choose a Genre:',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              decoration: BoxDecoration(
                color: Colors.purple,
              ),
            ),
            ListTile(
              title: Text('All Genres'),
              onTap: () {
                setState(() => genre = 'All Genres');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Country'),
              onTap: () {
                setState(() => genre = 'Country');

                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Rock'),
              onTap: () {
                setState(() => genre = 'Rock');

                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Indie'),
              onTap: () {
                setState(() => genre = 'Indie');

                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Soul'),
              onTap: () {
                setState(() => genre = 'Soul');

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: Center(
            child: ListView.builder(
          itemCount: filteredJson.length,
          itemBuilder: (context, index) =>
              TrackCard.fromJson(filteredJson[index], 0),
        )),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => RecordingPage(),
        )),
        backgroundColor: Colors.lightGreen,
        heroTag: null,
        label: Text('Create Track'),
        icon: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
