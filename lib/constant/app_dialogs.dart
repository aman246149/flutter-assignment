import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ispy/constant/snackbar.dart';
import 'package:ispy/widgets/HSpace.dart';
import 'package:ispy/widgets/border_textfield.dart';
import 'package:ispy/widgets/vspace.dart';

import '../theme/app_color.dart';
import '../theme/apptheme.dart';
import '../widgets/primary_button.dart';

Future showConfirmDialog(
    {required BuildContext context,
    required Function() cancelTap,
    required Function() confirmTap,
    required String message,
    required String title,
    String confirmButtonText = "YES",
    String cancelButtonText = "NO"}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        titlePadding: EdgeInsets.only(left: 30, right: 14, top: 14, bottom: 1),
        contentPadding:
            EdgeInsets.only(left: 30, right: 30, top: 0, bottom: 30),
        title: Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.close,
              color: AppColors.primary,
            ),
          ),
        ),
        content: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.start,
                    style: AppTheme.bodyText2
                        .copyWith(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                ],
              ),
              VSpace(32),
              Text(
                message,
                textAlign: TextAlign.start,
                style: AppTheme.bodyText2
                    .copyWith(fontWeight: FontWeight.w500, fontSize: 14),
              ),
              VSpace(30),
              Row(
                children: [
                  HSpace(53),
                  Expanded(
                      child: PrimaryButton(
                    text: cancelButtonText,
                    onTap: () {
                      cancelTap();
                    },
                    color: Color(0xffF9470E),
                    padding: EdgeInsets.zero,
                  )),
                  const HSpace(8),
                  Expanded(
                    child: PrimaryButton(
                      text: confirmButtonText,
                      onTap: () {
                        confirmTap();
                      },
                      color: Color(0xffF9470E),
                      padding: EdgeInsets.zero,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}

Future showImageDialog(
    BuildContext context, File imageFile, Function() sendClick) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.file(
              imageFile,
              height: 200,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.contain,
            ),
            VSpace(10),
            Text("I spy with my little eye a thing starting with the letter"),
            VSpace(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: PrimaryButton(
                    text: "Cancel",
                    onTap: () {
                      Navigator.pop(context);
                    },
                    color: Color(0xffF9470E),
                    padding: EdgeInsets.zero,
                  ),
                ),
                HSpace(10),
                Expanded(
                  child: PrimaryButton(
                    text: "Send",
                    onTap: () {
                      sendClick();
                    },
                    color: Color(0xffF9470E),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            )
          ],
        ),
      );
    },
  );
}
