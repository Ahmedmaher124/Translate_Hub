import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grade3/core/widgets/custom_error_message.dart';
import 'package:grade3/core/widgets/custom_loading_indicator.dart';
import 'package:grade3/features/home/presentation/manager/fetch_company_cubit/fetch_companies_cubit.dart';

import 'package:grade3/features/home/presentation/views/widgets/company_card.dart';

class CompanyView extends StatelessWidget {
  const CompanyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Company',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocBuilder<FetchCompaniesCubit, FetchCompaniesState>(
          builder: (context, state) {
            if (state is FetchCompaniesSuccess) {
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: state.companiesList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child:
                        CompanyCard(companyModel: state.companiesList[index]),
                  );
                },
              );
            } else if (state is FetchCompaniesFailure) {
              return CustomErrorMessage(errMessage: state.errMessage);
            } else {
              return const CustomLoadingIndicator();
            }
          },
        ),
      ),
    );
  }
}
