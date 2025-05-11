// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:translate_hub/core/widgets/custom_error_message.dart';
// import 'package:translate_hub/core/widgets/custom_loading_indicator.dart';
// import 'package:translate_hub/features/explore_translators/presentation/views/widgets/explore_search_field.dart';
// import 'package:translate_hub/features/home/presentation/manager/fetch_translators_cubit/fetch_translators_cubit.dart';
// import 'package:translate_hub/features/home/presentation/views/widgets/translator_card.dart';

// class ExploreTranslatorsView extends StatefulWidget {
//   const ExploreTranslatorsView({super.key});

//   @override
//   State<ExploreTranslatorsView> createState() => _ExploreTranslatorsViewState();
// }

// class _ExploreTranslatorsViewState extends State<ExploreTranslatorsView> {
//   @override
//   void initState() {
//     super.initState();
//     // Ensure translators are fetched when the view is created
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (context.read<FetchTranslatorsCubit>().state
//           is! FetchTranslatorsSuccess) {
//         context.read<FetchTranslatorsCubit>().fetchTranslators();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text(
//           'Explore Translators',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//             fontSize: 24,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           // Search bar
//           const ExploreSearchField(),

//           // Results or loading indicator
//           Expanded(
//             child: BlocBuilder<FetchTranslatorsCubit, FetchTranslatorsState>(
//               builder: (context, state) {
//                 if (state is FetchTranslatorsSuccess) {
//                   // Check if there are any results
//                   if (state.translatorsList.isEmpty) {
//                     return const Center(
//                       child: Text(
//                         'No translators found.\nTry a different search term.',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     );
//                   }

//                   // Show results
//                   return Column(
//                     children: [
//                       // Results counter
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 8),
//                         child: Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             '${state.translatorsList.length} translators found',
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey.shade600,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       ),

//                       // Results list
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 16),
//                           child: ListView.builder(
//                             physics: const BouncingScrollPhysics(),
//                             itemCount: state.translatorsList.length,
//                             itemBuilder: (context, index) {
//                               return Padding(
//                                 padding: const EdgeInsets.only(bottom: 10),
//                                 child: TranslatorCard(
//                                     translatorModel:
//                                         state.translatorsList[index]),
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 } else if (state is FetchTranslatorsFailure) {
//                   return CustomErrorMessage(errMessage: state.errMessage);
//                 } else {
//                   return const CustomLoadingIndicator();
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grade3/core/widgets/custom_error_message.dart';
import 'package:grade3/core/widgets/custom_loading_indicator.dart';
import 'package:grade3/features/explore_translators/presentation/views/widgets/explore_search_field.dart';
import 'package:grade3/features/home/data/models/translator_model.dart';
import 'package:grade3/features/home/presentation/manager/fetch_translators_cubit/fetch_translators_cubit.dart';
import 'package:grade3/features/home/presentation/manager/fetch_translators_cubit/fetch_translators_state.dart';
import 'package:grade3/features/home/presentation/views/widgets/translator_card.dart';

class ExploreTranslatorsView extends StatefulWidget {
  const ExploreTranslatorsView({super.key});

  @override
  State<ExploreTranslatorsView> createState() => _ExploreTranslatorsViewState();
}

class _ExploreTranslatorsViewState extends State<ExploreTranslatorsView> {
  String selectedCategory = 'all'; // Default category to show all translators

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchTranslatorsCubit>().fetchTranslators();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Explore Translators',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // Wrap the entire Column in SingleChildScrollView
        child: Column(
          children: [
            const ExploreSearchField(),
            // Category buttons in a horizontally scrollable view
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _categoryButton('all', 'All'),
                    _categoryButton('immediate', 'Immediate'),
                    _categoryButton('emergency', 'Emergency'),
                    _categoryButton('editorial', 'Editorial'),
                  ],
                ),
              ),
            ),
            BlocBuilder<FetchTranslatorsCubit, FetchTranslatorsState>(
              builder: (context, state) {
                if (state is FetchTranslatorsLoading) {
                  return const CustomLoadingIndicator();
                } else if (state is FetchTranslatorsFailure) {
                  return CustomErrorMessage(errMessage: state.errMessage);
                } else if (state is FetchTranslatorsSuccess) {
                  List<TranslatorModel> filteredTranslators = [];
                  // Filter translators based on selected category
                  if (selectedCategory == 'all') {
                    filteredTranslators = state.immediateTranslators +
                        state.emergencyTranslators +
                        state.editorialTranslators;
                  } else if (selectedCategory == 'immediate') {
                    filteredTranslators = state.immediateTranslators;
                  } else if (selectedCategory == 'emergency') {
                    filteredTranslators = state.emergencyTranslators;
                  } else if (selectedCategory == 'editorial') {
                    filteredTranslators = state.editorialTranslators;
                  }

                  return ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    shrinkWrap:
                        true, // Ensures the list view takes as much space as needed
                    children: [
                      if (filteredTranslators.isEmpty)
                        const Center(child: Text("No translators found.")),
                      ...filteredTranslators.map((t) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: TranslatorCard(translatorModel: t),
                          )),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to create category buttons
  Widget _categoryButton(String category, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },
      child: Container(
        alignment: Alignment.center,
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: selectedCategory == category ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color:
                selectedCategory == category ? Colors.white : Colors.grey[700],
          ),
        ),
      ),
    );
  }
}
