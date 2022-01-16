import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class DrawxyPage extends StatefulWidget {
  const DrawxyPage({Key? key, required this.title}) : super(key: key);

  final String title;
  static const String routeName = '/drawxypage';

  @override
  _DrawxyPageState createState() => _DrawxyPageState();
}

class _DrawxyPageState extends State<DrawxyPage> {
  double ax = 1;
  double ay = 1;
  double bx = 0;
  double by = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Offset> _points = [];
    double kxx = 0.5 * MediaQuery.of(context).size.width;
    double kyy = 0.5 * MediaQuery.of(context).size.height / 2;
    double k = min(kxx, kyy);

    double tx = (2 * pi + bx * pi) / ax;
    double ty = (2 * pi + by * pi) / ay;
    double tm = max(tx, ty);
    for (double t = 0; t <= tm; t += tm/128) {
      double x = sin(ax * t + bx * pi);
      double y = sin(ay * t + by * pi);

      var point = Offset(kxx + (k * x), kyy - (k * y));

      _points.add(point);
    }

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: Container(
        color: Colors.grey[100],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomPaint(
                size: Size(MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height / 2),
                painter: MyPainter(_points),
              ),
              Slider(
                value: ax,
                min: 0,
                max: 4,
                divisions: 8,
                label: ax.toString(),
                onChanged: (double value) {
                  setState(() {
                    ax = value;
                  });
                },
              ),
              Slider(
                value: bx,
                min: -1,
                max: 1,
                divisions: 8,
                label: bx.toString(),
                onChanged: (double value) {
                  setState(() {
                    bx = value;
                  });
                },
              ),
              Slider(
                value: ay,
                min: 0,
                max: 4,
                divisions: 8,
                label: ay.toString(),
                onChanged: (double value) {
                  setState(() {
                    ay = value;
                  });
                },
              ),
              Slider(
                value: by,
                min: -1,
                max: 1,
                divisions: 8,
                label: by.toString(),
                onChanged: (double value) {
                  setState(() {
                    by = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  List<Offset> points;
  MyPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(ui.PointMode.polygon, points, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return true;
  }
}
