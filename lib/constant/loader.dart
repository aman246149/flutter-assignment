import 'package:flutter/material.dart';

class Loader {
  bool loaderShowing = false;

  // Private constructor
  Loader._privateConstructor();

  // Static instance
  static final Loader _instance = Loader._privateConstructor();

  // Factory constructor
  factory Loader() {
    return _instance;
  }

  void showLoader(BuildContext context) {
    if (!loaderShowing) {
      loaderShowing = true;
      showDialog(
          context: context,
          builder: ((context) => const LoadingWidget()),
          barrierDismissible: false);
    }
  }

  void hideLoader(BuildContext context) {
    if (loaderShowing) {
      Navigator.of(context, rootNavigator: true).pop();
      loaderShowing = false;
    }
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: SizedBox(
      width: 50,
      child: Center(
        child: LinearProgressIndicator(),
      ),
    ));
  }
}