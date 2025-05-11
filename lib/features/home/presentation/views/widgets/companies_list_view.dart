import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grade3/core/widgets/custom_error_message.dart';
import 'package:grade3/core/widgets/custom_loading_indicator.dart';
import 'package:grade3/features/home/presentation/manager/fetch_company_cubit/fetch_companies_cubit.dart';
import 'package:grade3/features/home/presentation/views/widgets/company_card.dart';

class CompaniesListView extends StatelessWidget {
  const CompaniesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchCompaniesCubit, FetchCompaniesState>(
      builder: (context, state) {
        if (state is FetchCompaniesSuccess) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: state.companiesList.length,
              (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 16,
                    left: 16,
                    right: 16,
                  ),
                  child: CompanyCard(
                    companyModel: state.companiesList[index],
                  ),
                );
              },
            ),
          );
        } else if (state is FetchCompaniesFailure) {
          return SliverFillRemaining(
            child: CustomErrorMessage(errMessage: state.errMessage),
          );
        } else {
          return const SliverFillRemaining(
            child: CustomLoadingIndicator(),
          );
        }
      },
    );
  }
}
