import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grade3/core/services/api_service.dart';
import 'package:grade3/features/chat/presentation/views/chat_view.dart';
import 'package:grade3/features/company/presentation/views/Company_view.dart';
import 'package:grade3/features/explore_translators/presentation/views/explore_translators_view.dart';
import 'package:grade3/features/home/data/repos/home_repo_impl.dart';
import 'package:grade3/features/home/presentation/manager/fetch_company_cubit/fetch_companies_cubit.dart';
import 'package:grade3/features/home/presentation/manager/fetch_translators_cubit/fetch_translators_cubit.dart';
import 'package:grade3/features/home/presentation/views/widgets/custom_bottom_nav_bar.dart';
import 'package:grade3/features/home/presentation/views/widgets/home_view_body.dart';
import 'package:grade3/features/user_account/logic/user_profile_cubit.dart';
import 'package:grade3/features/user_account/presentation/views/user_account_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int selectedIndex = 0;
  void onTappedItem(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  List<Widget> views = [
    const HomeViewBody(),
    const ExploreTranslatorsView(),
    const CompanyView(),
    const ChatView(),
    const UserAccountView(),
  ];

  @override
  Widget build(BuildContext context) {
    // Create dependencies
    final dio = Dio();
    final apiService = ApiService(dio: dio);
    final homeRepo = HomeRepoImpl(apiService: apiService);

    // Ensure all required cubits are available
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserProfileCubit(),
        ),
        BlocProvider(
          create: (context) =>
              FetchTranslatorsCubit(homeRepo)..fetchTranslators(),
        ),
        BlocProvider(
          create: (context) => FetchCompaniesCubit(homeRepo)..fetchCompanies(),
        ),
      ],
      child: Scaffold(
        body: IndexedStack(
          index: selectedIndex,
          children: views,
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          selectedIndex: selectedIndex,
          onItemTapped: onTappedItem,
        ),
      ),
    );
  }
}
