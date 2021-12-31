import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';
import 'paint.dart';
import 'ball.dart';

void main() => runApp(const MyApp());

Map<String, WidgetBuilder> menuRoutes = <String, WidgetBuilder>{
  PaintPage.routeName: (BuildContext context) =>
      const PaintPage(title: 'Paint'),
  BallPage.routeName: (BuildContext context) => const BallPage(title: 'Ball'),
};

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const appTitle = 'Vera Play';

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: appTitle,
      home: const MyHomePage(title: appTitle),
      routes: menuRoutes,
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(
        child: Text('My Page!'),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Games'),
            ),
            ListTile(
              title: const Text('Paint'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(PaintPage.routeName);
              },
            ),
            ListTile(
              title: const Text('Ball'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(BallPage.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
