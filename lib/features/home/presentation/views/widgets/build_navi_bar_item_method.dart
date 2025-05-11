import 'package:flutter/material.dart';

Widget buildNavigationBarItem({
  required IconData icon,
  required String label,
  required int index,
  required int selectedIndex,
  required BuildContext context,
  required Function(int) onTap,
}) {
  bool isSelected = selectedIndex == index;
  return GestureDetector(
    onTap: () => onTap(index),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: isSelected
          ? BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(50),
            )
          : const BoxDecoration(),
      child: Row(
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : Colors.black54,
            size: 23,
          ),
          if (isSelected)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    ),
  );
}
