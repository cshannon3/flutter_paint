import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paint/Components/paint_layer.dart';
import 'package:flutter_paint/paint_area.dart';
import 'package:flutter_paint/paint_controller.dart';
import 'package:flutter_paint/shared.dart';

class ActivePaintArea extends StatefulWidget {
  final PaintController paintController;

  const ActivePaintArea({Key key, this.paintController}) : super(key: key);

  @override
  _ActivePaintAreaState createState() => _ActivePaintAreaState();
}

// Have Shape Slider here initially
class _ActivePaintAreaState extends State<ActivePaintArea> {
  bool gridOn = false;
  bool shapesShown = false;
  PaintController paintController;

  ColoredLine _activeColoredLine;

  int totalLen = 0;

  @override
  void initState() {
    super.initState();
    paintController = widget.paintController;
    _activeColoredLine = paintController.createColoredLine();
    paintController.addListener(() {
      if (paintController.updateStatus == UpdateStatus.ColorChange ||
          paintController.updateStatus == UpdateStatus.StrokeWidthChange) {
        _activeColoredLine = paintController.createColoredLine();
      }
      /*switch (paintController.updateStatus) {
        case UpdateStatus.ColorChange:
          if(paintController.currentColor != _activeColoredLine.color){
            _activeColoredLine = paintController.createColoredLine();
            /*
            Or could do
            _activeColoredLine.color = paintController.color
            _activeColoredLine.points = [];
            does it matter?
             */
          }
          break;
        case UpdateStatus.StrokeWidthChange:
          break;

        default:
          break;
      }*/
    });
  }

  @override
  Widget build(BuildContext context) {
    final Container sketchArea = Container(
      margin: EdgeInsets.all(1.0),
      alignment: Alignment.topLeft,
      color: Colors.transparent,
      child: CustomPaint(
        painter: PaintLayer(_activeColoredLine),
      ),
    );
    return GestureDetector(
      onTapDown: (details) {
        setState(() {});
        print("Tap down");
      },
      onPanStart: (DragStartDetails details) {
        if (_activeColoredLine.points != null) _activeColoredLine.points = [];
      },
      onPanUpdate: (DragUpdateDetails details) {
        setState(() {
          RenderBox box = context.findRenderObject();
          Offset point = box.globalToLocal(details.globalPosition);

          _activeColoredLine.addPt(point);
        });
      },
      onPanEnd: (DragEndDetails details) {
        // print(totalLen);
        // W/ PaintLayer2 Og settings 1349 ponits before red
        // W/ all being rendered every frame 857 points
        // W/ PaintLayer2 should repaint = true ~ 1200 points
        //  W/ PaintLayer2 should repaint true, and this using PaintLayer2, and isComplex: true,
        //        willChange: true, ~ 1300
        //  W/ PaintLayer2 should repaint true, and this using PaintLayer2, and  no extra settings ~ 1300
        // TODO conclusion on how to improve layeres
        _activeColoredLine.points.add(null);
        List<Offset> _pts = _activeColoredLine.points;
        paintController.addNewColoredLine(_pts);
      },
      child: sketchArea,
    );
  }
}
