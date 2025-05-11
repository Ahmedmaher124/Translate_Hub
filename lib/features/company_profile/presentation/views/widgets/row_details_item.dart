import 'package:flutter/material.dart';

class RowDetailsItem extends StatelessWidget {
  const RowDetailsItem({
    super.key,
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 15),
        const SizedBox(width: 3),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
