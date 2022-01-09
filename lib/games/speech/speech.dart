import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';

const String kAccessKey = 'FEGjbJwHsT1y6Kzx0P3Ux_7rU_TKshCq45bMFWR--YU';

Future<String> fetchUrl(String value) async {
  // print('fetchUrl-----');

  final translator = GoogleTranslator();
  final translation = await translator.translate(value, from: 'it', to: 'en');

  Map<String, dynamic> json;

  String path = 'https://api.unsplash.com/search/photos';
  path += '?page=1&per_page=20&query=$translation';
  path += '&client_id=$kAccessKey';

  // print(path);
  final response = await http.get(Uri.parse(path));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    // print(response.body);
    json = jsonDecode(response.body);

    final List<dynamic> results = json['results'];
    // print(results.length);
    final random = Random().nextInt(results.length);
    final result = results[random]['urls']['small'];
    // print(result);
    return result;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class SpeechPage extends StatefulWidget {
  const SpeechPage({Key? key, required this.title}) : super(key: key);

  final String title;
  static const String routeName = '/speechpage';

  @override
  _SpeechPageState createState() => _SpeechPageState();
}

class _SpeechPageState extends State<SpeechPage> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  String _lastUrlImage = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    if (result.finalResult == true) {
      print('_onSpeechResult: ${result.finalResult}');
      fetchUrl(result.recognizedWords).then((String value) {
        setState(() {
          _lastWords = result.recognizedWords;
          _lastUrlImage = value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // print('build---');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /*Text(
              _lastUrlImage,
              style: const TextStyle(fontSize: 8.0),
            ),*/
            (_lastUrlImage == '')
                ? const Text('')
                : Image.network(_lastUrlImage),
            /*
            Container(
              padding: const EdgeInsets.all(16),
              child: const Text(
                'Recognized words:',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  // If listening is active show the recognized words
                  _speechToText.isListening
                      ? '$_lastWords'
                      // If listening isn't active but could be tell the user
                      // how to start it, otherwise indicate that speech
                      // recognition is not yet ready or not supported on
                      // the target device
                      : _speechEnabled
                          ? 'Tap the microphone to start listening...'
                          : 'Speech not available',
                ),
              ),
            ),*/
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            // If not yet listening for speech start, otherwise stop
            _speechToText.isNotListening ? _startListening : _stopListening,
        tooltip: 'Listen',
        child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }
}
