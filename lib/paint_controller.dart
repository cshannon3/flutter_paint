import 'package:flutter/material.dart';
import 'package:custom_utils/custom_utils.dart';

// TODO Straight lines using custom utils classes

class PaintController extends ChangeNotifier {
  Color _currentColor = Colors.blue;
  double _currentStrokeWidth = 4.0;
  List<Shape> _shapes = [];
  List<ColoredLine> _coloredLines = [];
  //List<PaintLayer> _paintLayers =[];
  bool _gridOn;
  int _activeShapeIndex;
  // Way for listeners to know which changes affect them
  UpdateStatus updateStatus = UpdateStatus.UpToDate;

  /* TODO Grid System for location
   Not setup yet but this will make positions of shapes much more
   indexable by limiting possible locations to ~ 150 spots
   shapes will be added to the list by adding 1 to their line index
   //TODO update list when any shapes are removed or different way to index them
   TODO could make lines clickable by basically going through any block they
   paint through and, if empty add them, if filled by line compare points of current
   with the colored line in that position and set the one with the most in that position
   these will be set by multiplying by -1 then subtracting 1 so they are all negative
   Shapes will always override lines for location
  */
  List<int> gridPositions = List.filled(150, 0);

  PaintController();

  updateMade({bool resetActiveShapeIndex = false}) {
    assert(updateStatus != UpdateStatus.UpToDate);
    if (resetActiveShapeIndex) _activeShapeIndex = null;
    updateStatus = UpdateStatus.UpToDate;
  }

  updateMadeAdded(bool shape, int paintLayerIndex) {
    assert(updateStatus != UpdateStatus.UpToDate);
    updateStatus = UpdateStatus.UpToDate;
  }

  Color get currentColor => _currentColor;

  set currentColor(Color newColor) {
    if (_currentColor != newColor) {
      _currentColor = newColor;
      updateStatus = UpdateStatus.ColorChange;
      notifyListeners();
    }
  }

  double get currentStrokeWidth => _currentStrokeWidth;

  set currentStrokeWidth(double newThickness) {
    if (_currentStrokeWidth != newThickness) {
      _currentStrokeWidth = newThickness;
      updateStatus = UpdateStatus.StrokeWidthChange;
      notifyListeners();
    }
  }

  /*
  SHAPE FUNCTIONS               SHAPE FUNCTIONS
                 SHAPE FUNCTIONS
 SHAPE FUNCTIONS               SHAPE FUNCTIONS
                 SHAPE FUNCTIONS
 SHAPE FUNCTIONS               SHAPE FUNCTIONS
  */

  /* Anytime a shape is being modified or moved, it will become the active shape
  // and functions will be done in a stateful widget in the [ActivePaintArea] widget
  // Once modifications are complete, it will be 'saved'. Meaning if it was already added
  //  to that area before, it will be updated, otherwise it will be added to [PaintArea]
  */
  List<Shape> get shapes => _shapes;

  Shape getShape(int index) {
    assert(isIndexInList(index, _shapes.length));
    return _shapes[index];
  }

  /*
  removeShape(int index) {
    assert(isIndexInList(index, _shapes.length));
    _shapes.removeAt(index);
    notifyListeners();
  }*/

  // Undo button removes last shape
  removeLastShape() {
    if (_shapes.length > 0) {
      _shapes.removeLast();
      assert(_activeShapeIndex == null);
      // active shape must be completed before using this button

    }
  }

  /* To move a shape that is already on canvas,
      // Call comes from [ActivePaintArea] widget
      //
      // Will make sure shape exists, then set active shape index
      // When listeners are notified, [PaintArea] will respond by making
      // that shape invisible until new location is set
// This allows for a clean split between stateless and stateful apps
*/
  activateShape(int shapeIndex) {
    assert(isIndexInList(shapeIndex, _shapes.length));
    _activeShapeIndex = shapeIndex;
    notifyListeners();
  }

  Shape getActiveShape() {
    assert(_activeShapeIndex != null);
    return _shapes[_activeShapeIndex];
  }

  Shape getNewestShape() {
    return _shapes.last;
  }

  // TODO Add a Trash Can to remove shapes if they are at specific location
  /* When location is set, [Paint area] will check the shape of the active index
  // that it stored locally and update location
  */
  setShapeToLocation(Offset location) {
    assert(_activeShapeIndex != null);
    assert(_shapes[_activeShapeIndex].location != location);

    _shapes[_activeShapeIndex].location = location;
    updateStatus = UpdateStatus.ShapeChange;

    notifyListeners();
  }

  // When shape is dragged from template and placed down
  // It is added to [PaintArea] when it is placed down
  addNewShapeToCanvas(Shape newShape) {
    //newShape.location = location;
    _shapes.add(newShape);
    // _activeShapeIndex = _shapes.length -1;
    updateStatus = UpdateStatus.ShapeAdded;
    // When listeners are notified, [PaintArea] will check length
    // with shapes length to see if it needs to add last shape
    notifyListeners();
  }

  /*
  COLORED LINE FUNCTIONS                      COLORED LINE FUNCTIONS
                        COLORED LINE FUNCTIONS
  COLORED LINE FUNCTIONS                      COLORED LINE FUNCTIONS
                        COLORED LINE FUNCTIONS
  COLORED LINE FUNCTIONS                      COLORED LINE FUNCTIONS

   */
  // For the initial App, once a line is
  // TODO
  List<ColoredLine> get coloredLines => _coloredLines;

  ColoredLine getColoredLine(int index) {
    assert(isIndexInList(index, _coloredLines.length));
    return _coloredLines[index];
  }

  addNewColoredLine(List<Offset> points) {
    ColoredLine _cl = createColoredLine();
    _cl.points = points;
    _coloredLines.add(_cl);
    //  _paintLayers.add(PaintLayer(_cl));
    updateStatus = UpdateStatus.LineAdded;
    notifyListeners();
  }

  ColoredLine getNewestLine() {
    // assert(_coloredLines.length > 0);
    return _coloredLines.last;
  }

  ColoredLine createColoredLine() {
    return ColoredLine(
        points: [], strokeWidth: _currentStrokeWidth, color: _currentColor);
  }

  //List<PaintLayer> getPaintLayers(){return _paintLayers;}
}

enum UpdateStatus {
  ColorChange,
  StrokeWidthChange,
  ShapeChange,
  ShapeAdded,
  LineAdded,
  ActiveShape,
  ShapeRemoved,
  LineRemoved,
  ClearAll,
  UpToDate,
}