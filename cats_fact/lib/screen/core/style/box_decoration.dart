import 'package:flutter/material.dart';

import 'box_shadow.dart';

BoxDecoration boxDecoration({
  Color? color,
  double? borderRadius,
  bool useBackgroundImage = false,
  bool useBoxShadow = true,
}) {
  return BoxDecoration(
    color: color ?? Colors.white,
    borderRadius: BorderRadius.circular(borderRadius ?? 4),
    boxShadow: useBoxShadow ? [boxShadow()] : null,
    image: useBackgroundImage
        ? const DecorationImage(
            image: AssetImage('assets/images/ukraine.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black87, BlendMode.saturation))
        : null,
  );
}
