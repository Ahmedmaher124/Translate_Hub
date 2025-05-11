import 'package:flutter/material.dart';
import 'package:grade3/core/utils/get_scall_factor.dart';

double getResponsiveIconSize(
    {required double baseIconSize, required BuildContext context}) {
  double scaleFactor = getScallFactor(context);
  double responsiveIconSize = scaleFactor * baseIconSize;
  double lowerResponsiveSize = responsiveIconSize * 0.75;
  double upperResponsiveSize = responsiveIconSize * 1.35;
  double limitedResponsiveIconSize = responsiveIconSize.clamp(
    lowerResponsiveSize,
    upperResponsiveSize,
  );
  return limitedResponsiveIconSize;
}
