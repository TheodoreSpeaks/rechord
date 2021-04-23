import 'dart:math';

import 'package:flutter/material.dart';

class WaveVisualization extends StatelessWidget {
  final List<int> data;

  const WaveVisualization({Key? key, required this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    List<Widget> lines = [];
    int size = width ~/ 8;

    for (int i = 0; i < size; i++) {
      int index;
      int height;

      if (size >= data.length) {
        index = i - (size - data.length);

        if (index < 0) {
          height = 6;
        } else {
          height = data[index];
        }
      } else {
        index = i + data.length - size;
        height = data[index];
      }

      lines.add(Container(
        margin: EdgeInsets.all(1),
        decoration: BoxDecoration(
            color: Colors.white70, borderRadius: BorderRadius.circular(30)),
        width: 6,
        // height: 24 * (sin(i * pi / 4) + 1),
        height: height.toDouble(),
      ));
    }
    return Row(
      children: lines,
    );
  }
}
