import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';
import 'pages/paint.dart';
import 'pages/ball.dart';
import 'widgets/gamecard.dart';

void main() => runApp(const MyApp());

Map<String, WidgetBuilder> menuRoutes = <String, WidgetBuilder>{
  PaintPage.routeName: (BuildContext context) => PaintPage(title: 'Paint'),
  BallPage.routeName: (BuildContext context) => BallPage(title: 'Ball'),
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
      body: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          crossAxisCount: 3,
        ),
        // primary: false,
        padding: const EdgeInsets.all(8.0),
        physics: const BouncingScrollPhysics(),
        children: [
          InkWell(
            child: GameCardWidget('Paint', 'Paint', ''),
            onTap: () {
              // Navigator.pop(context);
              Navigator.of(context).pushNamed(PaintPage.routeName);
            },
          ),
          InkWell(
            child: GameCardWidget('Ball', 'Ball', ''),
            onTap: () {
              // Navigator.pop(context);
              Navigator.of(context).pushNamed(BallPage.routeName);
            },
          ),
        ],
      ),
    );
  }
}
