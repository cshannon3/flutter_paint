import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';

class ShapeCenteredOutline extends StatelessWidget {
  final Shape shape;
  final Size size;
  final double cutPercent;

  const ShapeCenteredOutline(
      {Key key,
      this.shape,
      this.size = const Size(100.0, 100.0),
      this.cutPercent = 0.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (shape.shapeType) {
      case ShapeType.polygon:
        //shape.polygon.location = location;

        return Transform(
          transform: Matrix4.translationValues(
              shape.location.dx, shape.location.dy, 0.0),
          child: CustomPaint(
            painter: PolygonPainter(polygon: shape.polygon),
            child: Container(
              height: size.height,
              width: size.width,
              // color: shape.color,
            ),
          ),
        );
        break;
      case ShapeType.circle:
        //shape.circle.location = location;
        return Transform(
          transform: Matrix4.translationValues(
              shape.location.dx, shape.location.dy, 0.0),
          child: SizedBox.fromSize(
            size: size,
            child: Center(
              child: Container(
                height: 2 * shape.circle.radius,
                width: 2 * shape.circle.radius,
                decoration:
                    BoxDecoration(color: shape.color, shape: BoxShape.circle),
              ),
            ),
          ),
        );
      default:
        break;
    }
  }
}

class PolygonPainter2 extends CustomPainter {
  final Polygon polygon;
  final Color color;
  double cutPercent;
  double maxheight = 0.0;

  PolygonPainter2(
      {@required this.polygon,
      this.color = Colors.blue,
      this.cutPercent = 0.0});

  @override
  void paint(Canvas canvas, Size size) {
    double angles = 400 / (polygon.sides);
    double currentprogressangle = angles;

    final path = Path();
    //final cutPath = Path();
    path.moveTo(size.width / 2, size.height / 2);
    Point2d lastPoint = Point2d(size.width / 2, size.height / 2);

    for (int i = 0; i < polygon.sides; i++) {
      currentprogressangle = (i) * angles;
      double xpoint = lastPoint.x + polygon.sidelen * Z(currentprogressangle);
      double ypoint = lastPoint.y + polygon.sidelen * K(currentprogressangle);
      if (ypoint > maxheight) maxheight = ypoint;
      path.lineTo(xpoint, ypoint);
      lastPoint = Point2d(xpoint, ypoint);
    }

    if (cutPercent != 0.0) {
      currentprogressangle = angles;
      double startPercent = (maxheight * (1 - cutPercent)) / 2;
      path.lineTo(size.width / 2, (size.height / 2) + startPercent);
      lastPoint = Point2d(size.width / 2, (size.height / 2 + startPercent));
      for (int j = 0; j < polygon.sides; j++) {
        currentprogressangle = (j) * angles;
        double xpoint = lastPoint.x +
            polygon.sidelen * Z(currentprogressangle) * cutPercent;
        double ypoint = lastPoint.y +
            polygon.sidelen * K(currentprogressangle) * cutPercent;
        if (ypoint > maxheight) maxheight = ypoint;
        path.lineTo(xpoint, ypoint);
        lastPoint = Point2d(xpoint, ypoint);
      }
      // cutPath.close();
    }

    //path.close();

    canvas.translate(
        -polygon.sidelen / 2, -(maxheight - (size.height / 2)) / 2);

    // path.addPath(cutPath, Offset(0.0, 0.0));
    //canvas.rotate(radians) Need To rotate odd numbers
    canvas.drawPath(path, Paint()..color = color);
    //  canvas.clipPath(cutPath);

    // canvas.clipRect(Rect.fromCircle(center: Offset((size.width / 2) + (polygon.sidelen / 2), (size.height / 2) + ((maxheight - (size.height / 2)) / 2)), radius: 5.0));
    /*canvas.drawCircle(
        Offset((size.width / 2) + (polygon.sidelen / 2),
            (size.height / 2) + ((maxheight - (size.height / 2)) / 2)),
        5.0,
        Paint()..color = Colors.cyanAccent);*/
    //   canvas.clipRect(Rect.fromCircle(center: Offset((size.width / 2) - (polygon.sidelen / 2), (size.height / 2) - ((maxheight - (size.height / 2)) / 2)), radius: 5.0));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

class PolygonClipper2 extends CustomClipper<Path> {
  final Polygon polygon;
  final Color color;
  final double cutPercent;
  double maxheight = 0.0;

  PolygonClipper2(
      {@required this.polygon,
      this.color = Colors.blue,
      this.cutPercent = 0.7});

  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    double angles = 400 / (polygon.sides);
    double currentprogressangle = angles;

    final path = Path();
    final cutPath = Path();
    path.moveTo(size.width / 2, size.height / 2);
    Point2d lastPoint = Point2d(size.width / 2, size.height / 2);

    for (int i = 0; i < polygon.sides; i++) {
      currentprogressangle = (i) * angles;
      double xpoint = lastPoint.x + polygon.sidelen * Z(currentprogressangle);
      double ypoint = lastPoint.y + polygon.sidelen * K(currentprogressangle);
      if (ypoint > maxheight) maxheight = ypoint;
      path.lineTo(xpoint, ypoint);
      lastPoint = Point2d(xpoint, ypoint);
    }
    path.close();

    if (cutPercent != 0.0) {
      currentprogressangle = angles;
      double startPercent = (maxheight * (1 - cutPercent)) / 2;
      path.moveTo(size.width / 2, (size.height / 2) + startPercent);
      lastPoint = Point2d(size.width / 2, size.height / 2);
      for (int j = 0; j < polygon.sides; j++) {
        currentprogressangle = (j) * angles;
        double xpoint = lastPoint.x +
            polygon.sidelen * Z(currentprogressangle) * cutPercent;
        double ypoint = lastPoint.y +
            polygon.sidelen * K(currentprogressangle) * cutPercent;
        // if (ypoint > maxheight) maxheight = ypoint;
        path.lineTo(xpoint, ypoint);
        lastPoint = Point2d(xpoint, ypoint);
      }
      path.close();
    }
    path.shift(Offset((size.width / 2) + (polygon.sidelen / 2),
        (size.height / 2) + ((maxheight - (size.height / 2)) / 2)));

    //final path = Path();
    /*path.moveTo(size.width / 2, size.height / 2);
    Point2d lastPoint = Point2d(size.width / 2, size.height / 2);

    for (int i = 0; i < polygon.sides; i++) {
      currentprogressangle = (i) * angles;
      double xpoint = lastPoint.x + polygon.sidelen * Z(currentprogressangle);
      double ypoint = lastPoint.y + polygon.sidelen * K(currentprogressangle);
      if (ypoint > maxheight) maxheight = ypoint;
      path.lineTo(xpoint, ypoint);
      lastPoint = Point2d(xpoint, ypoint);
    }

    path.close();*/
    //  path.addRect(Rect.fromCircle(center: Offset((size.width / 2) + (polygon.sidelen / 2), (size.height / 2) + ((maxheight - (size.height / 2)) / 2)), radius: 5.0));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
