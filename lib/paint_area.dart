import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paint/Components/paint_layer.dart';
import 'package:flutter_paint/active_paint_area.dart';
import 'package:flutter_paint/paint_controller.dart';

class PaintArea extends StatefulWidget {
  final PaintController paintController;

  PaintArea({Key key, @required this.paintController}) : super(key: key);

  @override
  _PaintAreaState createState() => _PaintAreaState();
}

class _PaintAreaState extends State<PaintArea> {
  PaintController paintController;
  // Paint layers
  List<Widget> paintLayers = [];
  ActivePaintArea activePaintArea;
  // use this to index paintLayers
  List<int> paintLayerOrder = [];

  // Shapes and Lines have param PaintLayerIndex so that they can be
  // stacked in layers above and below
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    paintController = widget.paintController;
    activePaintArea = ActivePaintArea(
      paintController: paintController,
    );

    paintController.addListener(() {
      switch (paintController.updateStatus) {
        case UpdateStatus.LineAdded:
          // Add line to widgets

          paintLayers.add(
              PaintLayerWidget(coloredLine: paintController.getNewestLine()));
          // Add position of Widget in list to paintOrder list
          paintLayerOrder.add(paintLayers.length - 1);
          // Send Acknowledgement to Paint Controller
          paintController.updateMadeAdded(false, paintLayers.length - 1);
          // rebuild with new widget added to list, will appear on top(below activePaintArea)
          setState(() {});
          break;
        case UpdateStatus.LineRemoved:
          break;

        case UpdateStatus.ShapeAdded:
          paintLayers
              .add(ShapeCentered(shape: paintController.getNewestShape()));
          setState(() {});
          break;
        case UpdateStatus.ActiveShape:
          // Replace shape replace shape widget with placeholder

          break;

        case UpdateStatus.ShapeChange:
          break;

        case UpdateStatus.ShapeRemoved:
          break;

        case UpdateStatus.ClearAll:
          break;
        default:
          break;
      }
    });
  }

  Widget _lineLayer(ColoredLine _newColoredLine) {
    return Container(
      margin: EdgeInsets.all(1.0),
      alignment: Alignment.topLeft,
      color: Colors.transparent,
      child: CustomPaint(
        painter: PaintLayer(_newColoredLine),
        child: Center(
          child: Text(_newColoredLine.points.length.toString()),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // print(paintLayers.length);
    return //paintLayers.length > 0 ? paintLayers[0] : Container();

        SizedBox.fromSize(
      size: MediaQuery.of(context).size,
      child: Stack(
        children: []
          ..addAll(paintLayers)
          ..add(activePaintArea),
      ),
    );
  }
}
