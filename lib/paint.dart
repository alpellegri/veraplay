import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

const kPoints = 600;

class PaintPage extends StatefulWidget {
  const PaintPage({Key? key, required this.title}) : super(key: key);

  final String title;
  static const String routeName = '/paintpage';

  @override
  _PaintPageState createState() => _PaintPageState();
}

class _PaintPageState extends State<PaintPage> {
  Color _color =
      Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  late final List<List<Offset>> _strokes = [];
  late final List<Color> _colors = [];

  @override
  void initState() {
    super.initState();
    _color =
        Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
              heroTag: "paint-btn1",
              backgroundColor: Colors.indigo,
              child: const Icon(Icons.delete_outline),
              onPressed: () {
                setState(() {
                  _strokes.clear();
                  _colors.clear();
                });
              },
            ),
            FloatingActionButton(
              heroTag: "paint-btn2",
              backgroundColor: Colors.indigo,
              child: const Icon(Icons.undo),
              onPressed: () {
                setState(() {
                  if (_strokes.isNotEmpty) {
                    _strokes.removeLast();
                  }
                  if (_colors.isNotEmpty) {
                    _colors.removeLast();
                  }
                });
              },
            ),
            FloatingActionButton(
              heroTag: "paint-btn3",
              backgroundColor: _color,
              child: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _color =
                      Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                          .withOpacity(1.0);
                });
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.grey[100],
        child: GestureDetector(
          onPanStart: _onDragStartHandler,
          onPanUpdate: _onDragUpdateHandler,
          onPanEnd: _onDragEndHandler,
          behavior: HitTestBehavior.translucent,
          child: Center(
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height),
              painter: MyPainter(_strokes, _colors),
            ),
          ),
        ),
      ),
    );
  }

  void _onDragStartHandler(DragStartDetails details) {
    setState(() {
      _strokes.add([details.globalPosition]);
      _colors.add(_color);
    });
  }

  void _onDragUpdateHandler(DragUpdateDetails details) {
    setState(() {
      _strokes.last.add(details.globalPosition);
      // if (_points.length > kPoints) {
      //   _points.removeRange(0, _points.length - kPoints);
      // }
    });
  }

  void _onDragEndHandler(DragEndDetails details) {
    setState(() {});
  }
}

class MyPainter extends CustomPainter {
  List<List<Offset>> strokes;
  List<Color> colors;
  MyPainter(this.strokes, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    const pointMode = ui.PointMode.polygon;
    for (var i = 0; i < strokes.length; i++) {
      final paint = Paint()
        ..color = colors[i]
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round;
      canvas.drawPoints(pointMode, strokes[i], paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return true;
  }
}
