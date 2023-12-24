import 'package:flutter/material.dart';
import 'package:ispy/theme/apptheme.dart';

import '../theme/app_color.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {super.key,
      required this.text,
      this.onTap,
      this.icon,
      this.padding,
      this.color,
      this.textColor,
      this.fontsize,
      this.fontWeight,
      this.innerPadding,
      this.frontIcon,
      this.borderColor,
      this.frontIconWidth,
      this.borderRadius});
  final String text;
  final Function()? onTap;
  final Widget? icon;
  final EdgeInsets? padding;
  final Color? color;
  final Color? textColor;
  final double? fontsize;
  final FontWeight? fontWeight;
  final MaterialStateProperty<EdgeInsetsGeometry?>? innerPadding;
  final Widget? frontIcon;
  final Color? borderColor;
  final double? frontIconWidth;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
      child: TextButton(
          style: ButtonStyle(
            padding: innerPadding,
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 4.0),
                side: BorderSide(
                    color: onTap != null
                        ? borderColor ?? AppColors.primary
                        : Colors.grey.withOpacity(0.71)),
              ),
            ),
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {}
                return onTap != null
                    ? color ?? AppColors.primary
                    : Colors.grey.withOpacity(0.71);
              },
            ),
          ),
          onPressed: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (frontIcon != null) ...[
                frontIcon!,
                SizedBox(
                  width: frontIconWidth ?? 16,
                ),
              ],
              Flexible(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: AppTheme.bodyText2.copyWith(
                      color: textColor ?? Colors.white,
                      fontSize: fontsize ?? 15,
                      fontWeight: fontWeight ?? FontWeight.w500),
                ),
              ),
              if (icon != null) ...[
                SizedBox(
                  width: 10,
                ),
                icon!
              ]
            ],
          )),
    );
  }
}
