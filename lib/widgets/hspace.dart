
import 'package:flutter/material.dart';

class HSpace extends StatelessWidget {
  final double width;
  const HSpace(this.width, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}