// @dart=2.9
import 'package:backdrop/backdrop.dart';
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
  final searchController = TextEditingController();

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
      if ((genre == 'All Genres' || entry['genre'] == genre) &&
          (searchController.text == '' ||
              entry['title'].contains(searchController.text))) {
        print(entry['title'].contains(searchController.text));
        filteredJson.add(entry);
      }
    }
    return BackdropScaffold(
      // appBar: AppBar(
      //   title: Text(genre),
      // ),
      appBar: BackdropAppBar(
        title: Text(genre),
        // leading: IconButton(
        //     onPressed: () => Backdrop.of(context).fling(),
        //     icon: Icon(Icons.filter_list)),
      ),
      resizeToAvoidBottomInset: false,
      backLayer: Container(
        height: 250,
        width: double.infinity,
        color: Colors.purple,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Filter by Genre:',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            Container(
              height: 45,
              child: ListView.builder(
                itemCount: genres.length + 1,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  String currentGenre =
                      index == 0 ? 'All Genres' : genres[index - 1].name;
                  bool selected = genre == currentGenre;
                  return Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: InkWell(
                      onTap: () => setState(() => genre = currentGenre),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32.0),
                            border: Border.all(color: Colors.white),
                            color: selected ? Colors.white : Colors.purple),
                        child: Text(
                          currentGenre,
                          style: TextStyle(
                              fontSize: 18,
                              color: selected ? Colors.purple : Colors.white),
                        ),
                        // backgroundColor: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Search:',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            TextFormField(
              // controller: searchController,
              onFieldSubmitted: (String search) {
                setState(() {});
                print('text');
                print(searchController.text);
              },
              onEditingComplete: () => setState(() {}),
              controller: searchController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Find a specific song...',
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
                contentPadding:
                    // TODO: fix alignment
                    EdgeInsets.only(left: 10, top: 12, bottom: 5),
                prefixIcon: Icon(Icons.search, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      headerHeight: MediaQuery.of(context).size.height - 300,

      frontLayer: RefreshIndicator(
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
