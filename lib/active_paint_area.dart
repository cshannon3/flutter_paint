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
  Shape _selectedShape;
  int totalLen = 0;

  @override
  void initState() {
    super.initState();
    paintController = widget.paintController;
    _activeColoredLine = paintController.createColoredLine();
    paintController.addListener(() {
      switch (paintController.updateStatus) {
        case UpdateStatus.ColorChange:
          setState(() {
            _activeColoredLine = paintController.createColoredLine();
          });
          break;
        case UpdateStatus.StrokeWidthChange:
          setState(() {
            _activeColoredLine = paintController.createColoredLine();
          });

          break;
        case UpdateStatus.ClearAll:
          setState(() {
            _activeColoredLine = paintController.createColoredLine();
          });
          break;
        case UpdateStatus.UpToDate:
          setState(() {});
          break;
        default:
          break;
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
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTapDown: (details) {
            RenderBox box = context.findRenderObject();
            Offset point = box.globalToLocal(details.globalPosition);
            if (paintController.isSpotFilled(point) != 0) {
              setState(() {
                if (_selectedShape == null) {
                  //_selectedShape = paintController
                  _selectedShape = paintController
                      .activateShape(paintController.isSpotFilled(point));
                } else {
                  paintController.saveChangesToShape(_selectedShape);
                  _selectedShape = null;
                }
              });
              // Want a stopwatch to test if long press or pan.. could add long press
              // but don't want to inhibit pan if it is painting instead of selecting
              // an item
              print("Tap down");
            }
          },
          onPanStart: (DragStartDetails details) {
            // TODO if shape is selected move shape instead of create line
            if (_activeColoredLine.points != null)
              _activeColoredLine.points = [];
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
        ),
        _selectedShape == null
            ? SizedBox()
            : ShapeCentered(
                shape: _selectedShape,
              ),
        _selectedShape == null
            ? SizedBox()
            : CenterAbout(
                // TODO account for items location -- if at bottom put above ect
                position: _selectedShape.location + Offset(-50.0, 50.0),
                child: Container(
                    height: 50.0,
                    width: 100.0,
                    color: Colors.green,
                    child: _selectedShape.shapeType == ShapeType.circle
                        ? Slider(
                            value: _selectedShape.circle.radius,
                            max: 100.0,
                            min: 5.0,
                            divisions: 19,
                            onChanged: (newVal) {
                              _selectedShape = Shape.fromOld(_selectedShape,
                                  newCircle: Circle(radius: newVal));
                              setState(() {});
                            })
                        : Slider(
                            value: _selectedShape.polygon.sidelen,
                            max: 100.0,
                            min: 5.0,
                            divisions: 19,
                            onChanged: (newVal) {
                              _selectedShape = Shape.fromOld(_selectedShape,
                                  newPolygon: Polygon(
                                      sidelen: newVal,
                                      sides: _selectedShape.polygon.sides));
                              setState(() {});
                            })),
              )
      ],
    );
  }
}
