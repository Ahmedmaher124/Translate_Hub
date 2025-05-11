import 'package:flutter/material.dart';
import 'package:grade3/core/utils/get_scall_factor.dart';

double getResponsiveFontSize(BuildContext context,
    {required double baseFontSize}) {
  double scallFactor = getScallFactor(context);
  double responsiveFontSize = scallFactor * baseFontSize;
  double lowerFontSize = baseFontSize * 0.8;
  double upperFontSize = baseFontSize * 1.4;
  double limititedResponsiveFontSize =
      responsiveFontSize.clamp(lowerFontSize, upperFontSize);
  return limititedResponsiveFontSize;
}
