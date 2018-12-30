import 'package:flutter/material.dart';

// To visually see location positions
class LocationsGridDebug extends StatelessWidget {
  final Size boardsize;

  final double piecesize;

  LocationsGridDebug({Key key, this.boardsize, this.piecesize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double verticalpadding = (boardsize.height % piecesize) / 2;
    final double horizontalpadding = (boardsize.width % piecesize) / 2;
    final int rows = (boardsize.height / piecesize).floor();
    final int columns = (boardsize.width / piecesize).floor();
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: verticalpadding, horizontal: horizontalpadding),
      child: GridView.count(
          crossAxisCount: columns,
          children: List.generate((rows * columns).floor(), (spot) {
            return Container(
              height: piecesize,
              width: piecesize,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: Center(
                child: Text("$spot"),
              ),
            );
          })),
    );
  }
}
