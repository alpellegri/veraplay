import 'package:flutter/material.dart';
import 'platform_repository.dart';

const kPoints = 50;
const kFriction = -.01;
const kAttraction = 0.5;

class TonePage extends StatefulWidget {
  const TonePage({Key? key, required this.title}) : super(key: key);

  final String title;
  static const String routeName = '/tonepage';

  @override
  _TonePageState createState() => _TonePageState();
}

class _TonePageState extends State<TonePage> {
  final _repository = PlatformRepository();
  int _f = 200;

  waveform(String w) async {
    await _repository.waveform(w);
  }

  frequency(int f) async {
    await _repository.frequency(f);
  }

  play() async {
    await _repository.play();
  }

  stop() async {
    await _repository.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Slider(
                  value: _f.toDouble(),
                  min: 30,
                  max: 22000,
                  divisions: 1000,
                  label: _f.toString(),
                  onChanged: (double value) {
                    setState(() {
                      _f = value.toInt();
                      frequency(_f);
                    });
                  },
                ),
                ElevatedButton(
                  child: const Text('play'),
                  onPressed: () {
                    setState(() {
                      play();
                    });
                  },
                ),
                ElevatedButton(
                  child: const Text('stop'),
                  onPressed: () {
                    setState(() {
                      stop();
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
