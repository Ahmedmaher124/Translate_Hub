import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grade3/features/home/presentation/manager/fetch_translators_cubit/fetch_translators_cubit.dart';

class ExploreSearchField extends StatefulWidget {
  const ExploreSearchField({super.key});

  @override
  State<ExploreSearchField> createState() => _ExploreSearchFieldState();
}

class _ExploreSearchFieldState extends State<ExploreSearchField> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Listen for changes to update the clear button visibility
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        textInputAction: TextInputAction.search,
        onChanged: (value) {
          // Call the search method in the cubit
          context.read<FetchTranslatorsCubit>().searchTranslators(value);
        },
        decoration: InputDecoration(
          hintText: 'Search by name or language...',
          hintStyle: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey.shade600,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    context.read<FetchTranslatorsCubit>().clearSearch();
                    _focusNode.unfocus();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}
