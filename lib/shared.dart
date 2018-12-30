import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';

List<Color> colorOptions = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.orange,
  Colors.purple,
  Colors.black,
  Colors.amber,
];
final List<Shape> templateShapes = [
  Shape(
    shapeType: ShapeType.circle,
    circle: Circle(radius: 20.0),
  ),
  Shape(
      shapeType: ShapeType.polygon, polygon: Polygon(sidelen: 50.0, sides: 3)),
  Shape(
      shapeType: ShapeType.polygon, polygon: Polygon(sidelen: 40.0, sides: 4)),
  Shape(
      shapeType: ShapeType.polygon, polygon: Polygon(sidelen: 30.0, sides: 5)),
  Shape(
      shapeType: ShapeType.polygon, polygon: Polygon(sidelen: 25.0, sides: 6)),
];

class FormattedWidget extends StatelessWidget {
  final Size size;
  final EdgeInsets padding;
  final Alignment alignment;
  //final Function(double newValue) onChanged;
  final Widget child;
  //currentValue;

  FormattedWidget({
    this.size,
    this.padding,
    this.alignment,
    //  this.onChanged,
    this.child,
    //this.currentValue
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: alignment,
        child: SizedBox.fromSize(size: size, child: child),
      ),
    );
  }
}
