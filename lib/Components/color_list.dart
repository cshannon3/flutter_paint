import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paint/paint_controller.dart';
import 'package:flutter_paint/shared.dart';

class ColorList extends StatefulWidget {
  final PaintController paintController;

  const ColorList({Key key, @required this.paintController}) : super(key: key);

  @override
  ColorListState createState() {
    return new ColorListState();
  }
}

class ColorListState extends State<ColorList> {
  Color currentColorValue;

  @override
  void initState() {
    // TODO: implement initState
    currentColorValue = widget.paintController.currentColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> colorButtons = List.generate(colorOptions.length, (i) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Container(
            color: colorOptions[i],
            height: 40.0,
            width: 40.0,
          ),
        ),
      );
    });
    return InfiniteList(
        onPressed: (selectedindex) {
          if (currentColorValue != colorOptions[selectedindex]) {
            setState(() {
              currentColorValue = colorOptions[selectedindex];
              widget.paintController.currentColor = colorOptions[selectedindex];
            });
          }
        },
        items: colorButtons);
  }
}
