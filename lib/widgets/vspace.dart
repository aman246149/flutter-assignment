import 'package:flutter/material.dart';

class VSpace extends StatelessWidget {
  final double height;
  const VSpace(this.height, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}