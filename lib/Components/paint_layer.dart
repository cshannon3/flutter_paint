import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';

class PaintLayerWidget extends StatelessWidget {
  //final ColoredLine coloredLine;
  final ColoredLine coloredLine;
  const PaintLayerWidget({Key key, this.coloredLine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(1.0),
      alignment: Alignment.topLeft,
      color: Colors.transparent,
      child: CustomPaint(
        painter: PaintLayer2(coloredLine),
        isComplex: true,
        willChange: false,
      ),
    );
  }
}

class PaintLayer2 extends CustomPainter {
  final ColoredLine coloredLine;

  const PaintLayer2(this.coloredLine);

  @override
  bool shouldRepaint(PaintLayer2 oldDelegate) {
    return true;
  }

  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = coloredLine.color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = coloredLine.strokeWidth;
    for (int i = 0; i < coloredLine.getPoints().length - 1; i++) {
      if (coloredLine.getPoints()[i] != null &&
          coloredLine.getPoints()[i + 1] != null) {
        canvas.drawLine(
            coloredLine.getPoints()[i], coloredLine.getPoints()[i + 1], paint);
      }
    }
  }
}
