import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:vector_math/vector_math.dart' as vec;
import 'package:time/time.dart';
import 'dart:math';

const kFriction = -.002;
const kAttraction = -100.0;

class PsycoPage extends StatefulWidget {
  const PsycoPage({Key? key, required this.title}) : super(key: key);

  final String title;
  static const String routeName = '/psycopage';

  @override
  _PsycoPageState createState() => _PsycoPageState();
}

class _PsycoPageState extends State<PsycoPage> {
  late Timer _timer;
  int _last = DateTime.now().millisecondsSinceEpoch;
  int _hit = 0;
  int _good = 0;
  double _delay = 200;

  final vec.Vector2 _x = vec.Vector2(0.0, 0.0);
  final vec.Vector2 _v = vec.Vector2(0.0, 0.0);
  Offset ball = const Offset(0, 0);
  Offset touch = const Offset(0, 0);
  DateTime touchTime = DateTime.now() - 10.minutes;
  int toDraw = 0;
  int isTouched = 0;

  vec.Vector2? attractor;
  double attraction = 0;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(milliseconds: 10), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final current = DateTime.now().millisecondsSinceEpoch;
    double dt = .01 * (current.toDouble() - _last.toDouble());
    _last = current;

    double time = current.toDouble();
    double delay = (sin(time / 10000) > 0) ? (_delay) : (0);

    /*
    if (attractor != null) {
      final dva = vec.Vector2.copy(attractor!);
      dva.sub(_x);
      double fact = 1 / (dva.normalize() * dva.normalize() * dva.normalize());
      dva.normalized();
      dva.scale(dt * fact * attraction);
      _v.add(dva);
    }*/

    final dvt = vec.Vector2.copy(_v);
    dvt.scale(kFriction);
    _v.add(dvt);
    final dx = vec.Vector2.copy(_v);
    dx.scale(dt);
    _x.add(dx);

    /* borders */
    final __x = vec.Vector2.copy(_x);
    __x.clamp(
        vec.Vector2(-MediaQuery.of(context).size.width / 2,
            -MediaQuery.of(context).size.height / 2),
        vec.Vector2(MediaQuery.of(context).size.width / 2,
            MediaQuery.of(context).size.height / 2));

    /* rebound */
    for (var i = 0; i < 2; i++) {
      if (_x.storage[i] != __x.storage[i]) {
        _v.storage[i] *= -1;
        _x.storage[i] = __x.storage[i];
      }
    }

    ball = Offset(MediaQuery.of(context).size.width / 2 + _x[0],
        MediaQuery.of(context).size.height / 2 - _x[1]);

    final now = DateTime.now();
    final dtime = now.difference(touchTime);

    if ((dtime.inMilliseconds > _delay) && (dtime.inMilliseconds < 500)) {
      toDraw = 1;
    } else {
      toDraw = 0;
      isTouched = 0;
    }

    if ((dtime.inMilliseconds > _delay) &&
        (dtime.inMilliseconds < (_delay + 50))) {
      if ((ball - touch).distance < 32.0) {
        _x.setZero();
        _good++;
        isTouched = 1;
        _restart();
      } else {
        // isTouched = 0;
      }
    } else {
      // isTouched = 0;
    }

    attraction = 0;

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
              heroTag: "ball-btn1",
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.delete_outline),
              onPressed: () {
                setState(() {
                  _hit = 0;
                  _good = 0;
                  _restart();
                });
              },
            ),
            Text('delay: $delay'),
            Text('$_good'),
            Text('${_hit - _good}'),
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
              painter: MyPainter(ball, touch, toDraw, isTouched),
            ),
          ),
        ),
      ),
    );
  }

  void _restart() {
    _x.storage[0] = 0;
    _x.storage[1] = 200;
    Random random = Random();
    _v.storage[0] = 0 * (random.nextDouble() - 0.5);
    _v.storage[1] = 100 * (0 * random.nextDouble() - 1 * 0.5);
  }

  void _onDragStartHandler(DragStartDetails details) {
    setState(() {
      isTouched = 0;
      _hit++;
      touchTime = DateTime.now();
      touch = details.globalPosition;
      attraction = kAttraction;
      attractor = vec.Vector2(
          details.globalPosition.dx - (MediaQuery.of(context).size.width / 2),
          (MediaQuery.of(context).size.height / 2) - details.globalPosition.dy);
    });
  }

  void _onDragUpdateHandler(DragUpdateDetails details) {}

  void _onDragEndHandler(DragEndDetails details) {
    setState(() {
      attraction = 0;
    });
  }
}

class MyPainter extends CustomPainter {
  Offset ball;
  Offset touch;
  int toDraw;
  int isTouched;
  MyPainter(this.ball, this.touch, this.toDraw, this.isTouched);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint;
    List<Offset> list = [];
    list.add(ball);

    Color color = (isTouched == 1) ? (Colors.green) : (Colors.grey);

    if (toDraw == 1) {
      List<Offset> list = [];
      list.add(touch);
      Paint paint = Paint()
        ..color = color
        ..strokeWidth = 64
        ..strokeCap = StrokeCap.round;
      canvas.drawPoints(ui.PointMode.points, list, paint);
    }
    paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 32
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(ui.PointMode.points, list, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return true;
  }
}
