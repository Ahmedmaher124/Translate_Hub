import 'package:flutter/material.dart';

import 'package:grade3/features/home/presentation/views/widgets/category_container_list_view_item.dart';

class CategoryContainerListView extends StatefulWidget {
  const CategoryContainerListView({super.key});

  @override
  State<CategoryContainerListView> createState() =>
      _CategoryContainerListViewState();
}

class _CategoryContainerListViewState extends State<CategoryContainerListView> {
  int selectedIndex = 0;
  List<String> categories = [
    'general',
    'sports',
    'business',
    'technology',
    'science',
    'entertainment',
    'health',
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40 * (MediaQuery.sizeOf(context).width / 393),
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CategoryContainerListViewItem(
                isSelected: selectedIndex == index,
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                categoryName: categories[index][0].toUpperCase() +
                    categories[index].substring(1).toLowerCase(),
              ),
            );
          }),
    );
  }
}
