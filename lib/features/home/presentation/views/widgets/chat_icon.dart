import 'package:flutter/material.dart';

import 'package:grade3/core/utils/app_colors.dart';

import 'package:grade3/core/utils/get_responsive_icon_size_method.dart';

class ChatIcon extends StatelessWidget {
  const ChatIcon({
    super.key,
    required this.onTap,
  });
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.14,
        child: AspectRatio(
          aspectRatio: 1.4,
          child: Container(
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(
                Icons.chat,
                size: getResponsiveIconSize(
                  baseIconSize: 22,
                  context: context,
                ),
                color: AppColors.categoryContainerColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
