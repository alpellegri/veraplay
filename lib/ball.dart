import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:ui' as ui;
import 'package:vector_math/vector_math.dart' as vec;

const kPoints = 50;
const kFriction = -.01;
const kAttraction = 0.5;

class BallPage extends StatefulWidget {
  const BallPage({Key? key, required this.title}) : super(key: key);

  final String title;
  static const String routeName = '/ballpage';

  @override
  _BallPageState createState() => _BallPageState();
}

class _BallPageState extends State<BallPage> {
  late final List<Offset> _points = [];

  vec.Vector2? _acceleration;
  late StreamSubscription<AccelerometerEvent> _streamSubscription;
  late Timer _timer;
  int _last = DateTime.now().millisecondsSinceEpoch;

  final vec.Vector2 _x = vec.Vector2(0.0, 0.0);
  final vec.Vector2 _v = vec.Vector2(0.0, 0.0);
  Offset point = const Offset(0, 0);

  vec.Vector2? attractor;
  double attraction = 0;

  @override
  void initState() {
    super.initState();

    _streamSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _acceleration = vec.Vector2(event.x, event.y);
      });
    });

    _timer = Timer.periodic(const Duration(milliseconds: 25), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final current = DateTime.now().millisecondsSinceEpoch;
    double dt = .01 * (current.toDouble() - _last.toDouble());
    _last = current;

    if (_acceleration != null) {
      final dvg = vec.Vector2.copy(_acceleration!);
      dvg.scale(-dt);
      _v.add(dvg);
    }
    if (attractor != null) {
      final dva = vec.Vector2.copy(attractor!);
      dva.sub(_x);
      // dva.normalize();
      dva.scale(dt * attraction);
      _v.add(dva);
    }
    final dvt = vec.Vector2.copy(_v);
    dvt.scale(kFriction);
    _v.add(dvt);
    final dx = vec.Vector2.copy(_v);
    dx.scale(dt);
    _x.add(dx);

    final __x = vec.Vector2.copy(_x);
    __x.clamp(
        vec.Vector2(-MediaQuery.of(context).size.width / 2,
            -MediaQuery.of(context).size.height / 2),
        vec.Vector2(MediaQuery.of(context).size.width / 2,
            MediaQuery.of(context).size.height / 2));

    for (var i = 0; i < 2; i++) {
      if (_x.storage[i] != __x.storage[i]) {
        _v.storage[i] *= -1;
        _x.storage[i] = __x.storage[i];
      }
    }

    point = Offset(MediaQuery.of(context).size.width / 2 + _x[0],
        MediaQuery.of(context).size.height / 2 - _x[1]);
    _points.add(point);

    if (_points.length > kPoints) {
      _points.removeRange(0, (_points.length - kPoints));
    }

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
              backgroundColor: Colors.indigo,
              child: const Icon(Icons.delete_outline),
              onPressed: () {
                setState(() {
                  _points.clear();
                  _x.setZero();
                  _v.setZero();
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
              painter: MyPainter(_points),
            ),
          ),
        ),
      ),
    );
  }

  void _onDragStartHandler(DragStartDetails details) {
    setState(() {
      attraction = kAttraction;
      attractor = vec.Vector2(
          details.globalPosition.dx - (MediaQuery.of(context).size.width / 2),
          (MediaQuery.of(context).size.height / 2) - details.globalPosition.dy);
    });
  }

  void _onDragUpdateHandler(DragUpdateDetails details) {
    setState(() {
      attraction = kAttraction;
      attractor = vec.Vector2(
          details.globalPosition.dx - (MediaQuery.of(context).size.width / 2),
          (MediaQuery.of(context).size.height / 2) - details.globalPosition.dy);
    });

    print(attractor);
  }

  void _onDragEndHandler(DragEndDetails details) {
    setState(() {
      attraction = 0;
    });
  }
}

class MyPainter extends CustomPainter {
  List<Offset> points;
  MyPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    const pointMode = ui.PointMode.polygon;
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(pointMode, points, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return true;
  }
}
