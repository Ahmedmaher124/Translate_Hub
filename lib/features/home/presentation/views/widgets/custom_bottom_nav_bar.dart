import 'package:flutter/material.dart';
import 'package:grade3/features/home/presentation/views/widgets/build_navi_bar_item_method.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });
  final int selectedIndex;
  final Function(int) onItemTapped;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(66, 115, 115, 115),
            blurRadius: 0.5,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildNavigationBarItem(
            icon: Icons.home,
            label: 'Home',
            index: 0,
            selectedIndex: selectedIndex,
            context: context,
            onTap: onItemTapped,
          ),
          buildNavigationBarItem(
            icon: Icons.explore_outlined,
            label: 'Translators',
            index: 1,
            selectedIndex: selectedIndex,
            context: context,
            onTap: onItemTapped,
          ),
          buildNavigationBarItem(
            icon: Icons.bar_chart_outlined,
            label: 'Company',
            index: 2,
            selectedIndex: selectedIndex,
            context: context,
            onTap: onItemTapped,
          ),
          buildNavigationBarItem(
            icon: Icons.chat,
            label: 'Chat',
            index: 3,
            selectedIndex: selectedIndex,
            context: context,
            onTap: onItemTapped,
          ),
          buildNavigationBarItem(
            icon: Icons.person_outlined,
            label: 'Profile',
            index: 4,
            selectedIndex: selectedIndex,
            context: context,
            onTap: onItemTapped,
          ),
        ],
      ),
    );
  }
}
