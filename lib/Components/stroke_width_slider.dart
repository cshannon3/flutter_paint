import 'package:flutter/material.dart';
import 'package:flutter_paint/paint_controller.dart';
import 'package:flutter_paint/shared.dart';

class StrokeWidthSlider extends StatefulWidget {
  final PaintController paintController;

  const StrokeWidthSlider({Key key, @required this.paintController})
      : super(key: key);

  @override
  StrokeWidthSliderState createState() {
    return new StrokeWidthSliderState();
  }
}

class StrokeWidthSliderState extends State<StrokeWidthSlider> {
  double strokeWidthValue = 4.0;

  @override
  void initState() {
    super.initState();
    strokeWidthValue = widget.paintController.currentStrokeWidth;
  }

  @override
  Widget build(BuildContext context) {
    return FormattedWidget(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.bottomCenter,
        size: Size(250.0, 50.0),
        child: Slider(
          value: strokeWidthValue,
          min: 1.0,
          max: 10.0,
          divisions: 9,
          label: 'Thickness ${strokeWidthValue}',
          activeColor: Colors.blue,
          onChanged: (newThickness) {
            if (strokeWidthValue != newThickness) {
              setState(() {
                strokeWidthValue = newThickness;
                widget.paintController.currentStrokeWidth = newThickness;
              });
            }
            ;
          },
        ));
  }
}
