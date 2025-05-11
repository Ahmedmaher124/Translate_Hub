import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grade3/features/home/presentation/manager/select_language_cubit.dart';

import 'package:grade3/features/home/presentation/views/widgets/category_container_list_view_item.dart';

class LanguagesContainerListView extends StatefulWidget {
  const LanguagesContainerListView({super.key});

  @override
  State<LanguagesContainerListView> createState() =>
      _LanguagesContainerListViewState();
}

class _LanguagesContainerListViewState
    extends State<LanguagesContainerListView> {
  int selectedIndex = 0;
  List<String> languages = [
    'all',
    'english',
    'german',
    'spanish',
    'italian',
    'chinese',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40 * (MediaQuery.sizeOf(context).width / 393),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: languages.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CategoryContainerListViewItem(
              isSelected: selectedIndex == index,
              onTap: () {
                context
                    .read<SelectLanguageCubit>()
                    .selectLanguage(languages[index]);
                setState(() {
                  selectedIndex = index;
                });
              },
              categoryName: languages[index][0].toUpperCase() +
                  languages[index].substring(1).toLowerCase(),
            ),
          );
        },
      ),
    );
  }
}
