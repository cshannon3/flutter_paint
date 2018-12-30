import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paint/Components/paint_layer.dart';
import 'package:flutter_paint/Components/shapes_list.dart';
import 'package:flutter_paint/Debug/locations_grid.dart';
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
  // shape or line layer is the index of the paint order list
  // and shape or coloredLine index is the actual value,
  // the shape index will be the negative version -1
  // coloredlines will be pos +1 and 0 will be open/placeholder

  // Grid

  // Shapes and Lines have param PaintLayerIndex so that they can be
  // stacked in layers above and below
  @override
  void initState() {
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
          // the position of the widget and index will be at same place so the index
          // of the paint layer can be found by searching for the index in paint layer order
          paintLayerOrder.add(paintController.coloredLines.length);

          // Send Acknowledgement to Paint Controller
          // Not Sure if this is implemented properly/is necessary yet
          paintController.updateMadeAdded(false, paintLayers.length - 1);
          // rebuild with new widget added to list, will appear on top(below activePaintArea)
          setState(() {});
          break;
        case UpdateStatus.LineRemoved:
          break;

        case UpdateStatus.ShapeAdded:
          paintLayers
              .add(ShapeCentered(shape: paintController.getNewestShape()));
          final int len = -paintController.shapes.length;
          paintLayerOrder.add(len);
          paintController.updateMade(resetActiveShapeIndex: true);
          setState(() {});
          break;
        case UpdateStatus.ActiveShape:
          // Replace shape replace shape widget with placeholder
          assert(paintController.activeShapeIndex != null);
          paintLayers[paintLayerOrder
              .indexOf(-(paintController.activeShapeIndex + 1))] = SizedBox();
          setState(() {});
          break;

        case UpdateStatus.ShapeChange:
          assert(paintController.activeShapeIndex != null);
          paintLayers[paintLayerOrder.indexOf(
              -(paintController.activeShapeIndex + 1))] = ShapeCentered(
            shape: paintController.getActiveShape(),
          );
          paintController.updateMade(resetActiveShapeIndex: true);
          setState(() {});
          break;

        case UpdateStatus.ShapeRemoved:
          // TODO remove the Layer Widget from list and from Layer Order List
          break;

        case UpdateStatus.ClearAll:
          paintLayers.clear();
          paintLayerOrder.clear();
          setState(() {});
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Making Grid ..
    Size screenSize = MediaQuery.of(context).size;

    return SizedBox.fromSize(
      size: MediaQuery.of(context).size,
      child: Stack(
        children: [
          LocationsGridDebug(
            boardsize: MediaQuery.of(context).size,
            piecesize: 40.0,
          ),
        ]
          ..addAll(paintLayers)
          ..add(activePaintArea),
      ),
    );
  }
}
