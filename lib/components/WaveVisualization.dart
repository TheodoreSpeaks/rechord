import 'dart:math';

import 'package:flutter/material.dart';

class WaveVisualization extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    List<Widget> lines = [];
    for (int i = 0; i < width ~/ 8; i++) {
      lines.add(Container(
        margin: EdgeInsets.all(1),
        decoration: BoxDecoration(
            color: Colors.white70, borderRadius: BorderRadius.circular(30)),
        width: 6,
        // height: 24 * (sin(i * pi / 4) + 1),
        height: 6,
      ));
    }
    return Row(
      children: lines,
    );
  }
}
