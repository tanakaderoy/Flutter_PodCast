import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pod_cast_app/screens/BottomAppBar.dart';
import 'package:pod_cast_app/screens/LoginPage.dart';
import 'package:pod_cast_app/service/ApiService.dart';
import 'package:pod_cast_app/service/FirebaseHelper.dart';

import 'models/ItunesSearchResultModel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'PodCast App', debugShowCheckedModeBanner:false ,theme: ThemeData.dark(), home: BufferPage());
  }

//  Widget screen() {
//    return FirebaseHelper.instance.currentUser != null
//        ? BottomNavBarController()
//        : LoginPage();
//  }

}

class BufferPage extends StatefulWidget {
  @override
  _BufferPageState createState() => _BufferPageState();
}

class _BufferPageState extends State<BufferPage> {
  List<iTunesSearchResults> list;

  void setUp() async {
    var newList = await ApiService.instance.getTopPodcasts();
    setState(() {
      list = newList;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setUp();
  }

  @override
  Widget build(BuildContext context) {
    return list == null
        ? Container()
        : SplashPage(
            list: list,
          );
  }
}

class SplashPage extends StatefulWidget {
  final List<iTunesSearchResults> list;

  SplashPage({@required this.list});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  List<iTunesSearchResults> list;
  Future<FirebaseUser> _user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    list = widget.list;
    print(list.length);
    _user = FirebaseHelper.instance.auth.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    //TODO: fix the sign in correctly
    return FutureBuilder<FirebaseUser>(
      future: _user,
      builder: (context, snapShot) {
        if (snapShot.hasData && snapShot.data is FirebaseUser) {
          FirebaseHelper.instance.currentUser = snapShot.data;

          return BottomNavBarController(
            list: list,
          );
        } else if (snapShot.connectionState == ConnectionState.done) {
          return LoginPage();
        } else {
          return CircularProgressIndicator();
        }

        return LoginPage();
      },
    );
  }

//  Widget screen() {
//    return isSignedIn
//        ? BottomNavBarController(
//            list: list,
//          )
//        : LoginPage();
//  }
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
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
