import 'package:flutter/material.dart';
import 'package:flutter_paint/paint_controller.dart';
import 'package:flutter_paint/shared.dart';

class UndoButtonBar extends StatelessWidget {
  final PaintController paintController;

  const UndoButtonBar({Key key, @required this.paintController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormattedWidget(
      alignment: Alignment.bottomRight,
      size: Size(50.0, 150.0),
      padding: EdgeInsets.only(right: 5.0, bottom: 10.0),
      child: Column(children: <Widget>[
        FloatingActionButton(
          tooltip: 'clear Screen',
          backgroundColor: Colors.blue,
          child: Icon(Icons.undo),
          onPressed: () {},
        ),
        FloatingActionButton(
          tooltip: 'clear Screen',
          backgroundColor: Colors.grey,
          child: Icon(Icons.undo),
          onPressed: () {
            paintController.clearAll();
          },
        ),
      ]),
    );
  }
}
