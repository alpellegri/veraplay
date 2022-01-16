import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';
import 'games/paint/paint.dart';
import 'games/ball/ball.dart';
import 'games/speech/speech.dart';
import 'games/tone/tone.dart';
import 'games/drawxy/drawxy.dart';
import 'widgets/gamecard.dart';

void main() => runApp(const MyApp());

Map<String, WidgetBuilder> menuRoutes = <String, WidgetBuilder>{
  PaintPage.routeName: (BuildContext context) =>
      const PaintPage(title: 'Paint'),
  BallPage.routeName: (BuildContext context) => const BallPage(title: 'Ball'),
  SpeechPage.routeName: (BuildContext context) =>
      const SpeechPage(title: 'Speech'),
  TonePage.routeName: (BuildContext context) => const TonePage(title: 'Tone'),
  DrawxyPage.routeName: (BuildContext context) =>
      const DrawxyPage(title: 'Drawxy'),
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
              Navigator.of(context).pushNamed(PaintPage.routeName);
            },
          ),
          InkWell(
            child: GameCardWidget('Ball', 'Ball', ''),
            onTap: () {
              Navigator.of(context).pushNamed(BallPage.routeName);
            },
          ),
          InkWell(
            child: GameCardWidget('Speech', 'Speech', ''),
            onTap: () {
              Navigator.of(context).pushNamed(SpeechPage.routeName);
            },
          ),
          InkWell(
            child: GameCardWidget('Tone', 'Tone', ''),
            onTap: () {
              Navigator.of(context).pushNamed(TonePage.routeName);
            },
          ),
          InkWell(
            child: GameCardWidget('Drawxy', 'Drawxy', ''),
            onTap: () {
              Navigator.of(context).pushNamed(DrawxyPage.routeName);
            },
          ),
        ],
      ),
    );
  }
}
