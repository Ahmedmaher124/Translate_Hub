import 'package:flutter/material.dart';

double getScallFactor(BuildContext context) {
  var screenWidth = MediaQuery.sizeOf(context).width;
  if (screenWidth < 550) {
    return (screenWidth / 392);
  } else {
    return 1;
  }
}
