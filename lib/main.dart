import 'package:flutter/material.dart';
import 'package:custom_utils/custom_utils.dart';
import 'package:flutter_paint/Components/color_list.dart';
import 'package:flutter_paint/Components/shapes_list.dart';
import 'package:flutter_paint/Components/stroke_width_slider.dart';
import 'package:flutter_paint/Components/undo_buttons.dart';
import 'package:flutter_paint/active_paint_area.dart';
import 'package:flutter_paint/paint_area.dart';
import 'package:flutter_paint/paint_controller.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        // showPerformanceOverlay: true,
        title: 'Flutter Paint',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Home());
  }
}

class Home extends StatelessWidget {
  PaintController paintController;
  ColorList colorList;
  StrokeWidthSlider strokeWidthSlider;
  UndoButtonBar undoButtonBar;
  PaintArea paintArea;
  ShapeTemplatesList shapeTemplatesList;

  @override
  Widget build(BuildContext context) {
    paintController = PaintController();
    colorList = ColorList(
      paintController: paintController,
    );
    strokeWidthSlider = StrokeWidthSlider(
      paintController: paintController,
    );
    // TODO add undo button bar
    undoButtonBar = UndoButtonBar(paintController: paintController);

    paintArea = PaintArea(
      paintController: paintController,
    );
    shapeTemplatesList = ShapeTemplatesList(
      paintController: paintController,
    );

    return Scaffold(
        appBar: AppBar(
            title: Text('Paint'),
            bottom: PreferredSize(
                preferredSize: Size(MediaQuery.of(context).size.width, 50.0),
                child: colorList)),
        body: Stack(
          children: <Widget>[
            //Paint Area
            // Undo Buttom
            paintArea,
            strokeWidthSlider,
            shapeTemplatesList,
            undoButtonBar,
          ],
        ));
  }
}

/*
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  /*[PaintController] is the brain of the application,
   The only Widget that can update it's state without a call from paint controller is
   [ActivePaintArea] where all of the actual painting occurs
   [PaintArea] contains all the components that have been painted but aren't being actively edited
   All the other UI components will be changed through this paint controller listener
   */
  PaintController paintController;
  ColorList colorList;
  StrokeWidthSlider strokeWidthSlider;
  UndoButtonBar undoButtonBar;
  PaintArea paintArea;

  Color mostRecentColor = Colors.blue;
  double mostRecentStrokeWidth = 4.0;

  // TODO Look into Inherited widgets
  @override
  void initState() {
    super.initState();
    paintController = PaintController();
    colorList = ColorList(
      paintController: paintController,
    );
    strokeWidthSlider = StrokeWidthSlider(
      paintController: paintController,
    );
    // TODO add undo button bar
    undoButtonBar = UndoButtonBar(paintController: paintController);

    paintArea = PaintArea(
      paintController: paintController,
    );
    // shapes List
    // PaintArea -> holds active Paint area inside it
    paintController.addListener(() {
      switch (paintController.updateStatus) {
        case UpdateStatus.ColorChange:
          assert(mostRecentColor != paintController.currentColor);
          setState(() {
            colorList = ColorList(paintController: paintController);
          });
          break;
        case UpdateStatus.StrokeWidthChange:
          assert(mostRecentStrokeWidth != paintController.currentStrokeWidth);
          strokeWidthSlider =
              StrokeWidthSlider(paintController: paintController);
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Paint'),
            bottom: PreferredSize(
                preferredSize: Size(MediaQuery.of(context).size.width, 50.0),
                child: colorList)),
        body: Stack(
          children: <Widget>[
            //Paint Area
            // Undo Buttom
            paintArea,
            strokeWidthSlider,
          ],
        ));
  }
}
// TODO Look into Inherited widgets

class Home2 extends StatefulWidget {
  @override
  _HomeState2 createState() => _HomeState2();
}

class _HomeState2 extends State<Home2> {
  //Second Option is to setState anytime

  /[PaintController] is the brain of the application,
   The only Widget that can update it's state without a call from paint controller is
   [ActivePaintArea] where all of the actual painting occurs
   [PaintArea] contains all the components that have been painted but aren't being actively edited
   All the other UI components will be changed through this paint controller listener
   /
  PaintController paintController;
  ColorList colorList;
  StrokeWidthSlider strokeWidthSlider;
  UndoButtonBar undoButtonBar;

  Color mostRecentColor = Colors.blue;
  double mostRecentStrokeWidth = 4.0;

  @override
  void initState() {
    super.initState();
    paintController = PaintController();
    colorList = ColorList(
      paintController: paintController,
    );
    strokeWidthSlider = StrokeWidthSlider(
      paintController: paintController,
    );
    undoButtonBar = UndoButtonBar(paintController: paintController);
    // shapes List
    // PaintArea -> holds active Paint area inside it
    paintController.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
*/
