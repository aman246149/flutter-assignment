import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:ispy/constant/loader.dart';

void showSnackbar(context, String message) {
  Flushbar(
    message: message,
    duration: const Duration(seconds: 3),
  ).show(context);
}

void showErrorSnackbar(context, String message) {
  var title = "Error";
  if (message.isEmpty) return;
  Flushbar(
    title: title,
    backgroundColor: Colors.red,
    message: message,
    duration: const Duration(seconds: 3),
  ).show(context);
}

void showSuccessSnackbar(context, message) {
  var title = "Success";
  Flushbar(
    title: title,
    backgroundColor: Colors.green,
    message: message,
    duration: const Duration(seconds: 3),
  ).show(context);
}

void showOverlayLoader(BuildContext context) {
  Loader().showLoader(context);
}

void hideOverlayLoader(BuildContext context) {
  debugPrint("Hiding Loader");
  Loader().hideLoader(context);
}
