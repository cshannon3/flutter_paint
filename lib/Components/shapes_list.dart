import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paint/paint_controller.dart';
import 'package:flutter_paint/shared.dart';

class ShapeTemplatesList extends StatefulWidget {
  final PaintController paintController;

  const ShapeTemplatesList({Key key, this.paintController}) : super(key: key);
  @override
  _ShapeTemplatesListState createState() => _ShapeTemplatesListState();
}

class _ShapeTemplatesListState extends State<ShapeTemplatesList>
    with TickerProviderStateMixin {
  AnimationController shapesSliderAnimation;
  List<Animation> shapeAnimations;
  PaintController paintController;
  bool shapesShown = false;

  @override
  void initState() {
    super.initState();
    paintController = widget.paintController;
    paintController.addListener(() {
      if (paintController.updateStatus == UpdateStatus.ColorChange) {
        setState(() {});
      }
    });
    shapesSliderAnimation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1100),
    );
    shapeAnimations = templateShapes.map((sh) {
      int index = templateShapes.indexOf(sh);
      double start = index * 0.1;
      double duration = 0.6;
      double end = duration + start;
      return new Tween<double>(begin: 800.0, end: 0.0).animate(
          new CurvedAnimation(
              parent: shapesSliderAnimation,
              curve: new Interval(start, end, curve: Curves.decelerate)));
    }).toList();
  }

  Iterable<Widget> _buildShapes() {
    return templateShapes.map((sh) {
      sh.color = widget.paintController.currentColor;
      int index = templateShapes.indexOf(sh);
      return AnimatedBuilder(
        animation: shapesSliderAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: //ShapeCentered(shape: sh)),
              Draggable(
                  child: ShapeCentered(shape: sh),
                  onDraggableCanceled: (velocity, offset) {
                    setState(() {
                      paintController.addNewShapeToCanvas(Shape(
                        shapeType: sh.shapeType,
                        color: paintController.currentColor,
                        location: offset -
                            Offset(0.0, AppBar().preferredSize.height + 80.0),
                        polygon: sh.polygon,
                        circle: sh.circle,
                      ));
                    });
                  },
                  feedback: ShapeCentered(shape: sh)),
        ),
        builder: (context, child) => new Transform.translate(
              offset: Offset(0.0, shapeAnimations[index].value),
              child: child,
            ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FormattedWidget(
      alignment: Alignment.topRight,
      size: Size(100.0, 400.0),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 3.0),
        // crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
              width: 100.0,
              height: 50.0,
              color: Colors.lightBlue,
              child: FlatButton(
                onPressed: () {
                  setState(() {
                    shapesShown
                        ? shapesSliderAnimation.forward()
                        : shapesSliderAnimation.reverse();
                    shapesShown = !shapesShown;
                  });
                },
                child: Text('SHAPES'),
              )),
        ]..addAll(_buildShapes()),
      ),
    );
  }
}
