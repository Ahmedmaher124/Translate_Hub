import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grade3/core/utils/get_responsive_font_size.dart';
import 'package:grade3/features/home/presentation/manager/fetch_company_cubit/fetch_companies_cubit.dart';
import 'package:grade3/features/home/presentation/manager/fetch_translators_cubit/fetch_translators_cubit.dart';
import 'package:grade3/features/home/presentation/views/widgets/custom_app_bar.dart';
import 'package:grade3/features/home/presentation/views/widgets/custom_search_text_field.dart';
import 'package:grade3/features/home/presentation/views/widgets/languages_container_list_view.dart';

import 'package:grade3/features/home/presentation/views/widgets/top_translator_list_view.dart';
import 'package:grade3/features/home/presentation/views/widgets/companies_list_view.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // Refresh both translators and companies data
        await context.read<FetchTranslatorsCubit>().fetchTranslators();
        // ignore: use_build_context_synchronously
        await context.read<FetchCompaniesCubit>().fetchCompanies();
      },
      child: CustomScrollView(
        physics:
            const AlwaysScrollableScrollPhysics(), // Changed from BouncingScrollPhysics to ensure refresh works
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomAppBar(),
                  const SizedBox(height: 28),
                  const CustomSearchTextField(),
                  const SizedBox(height: 25),
                  Text(
                    'Popular Languages',
                    style: TextStyle(
                      fontSize: getResponsiveFontSize(
                        context,
                        baseFontSize: 17,
                      ),
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const LanguagesContainerListView(),
                  const SizedBox(height: 20),
                  Text(
                    'Top Translators',
                    style: TextStyle(
                      fontSize: getResponsiveFontSize(
                        context,
                        baseFontSize: 17,
                      ),
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const TopTranslatorListView(),
                  const SizedBox(height: 25),
                  Text(
                    'Top Companies',
                    style: TextStyle(
                      fontSize: getResponsiveFontSize(
                        context,
                        baseFontSize: 17,
                      ),
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          const CompaniesListView(),
        ],
      ),
    );
  }
}
