import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grade3/core/services/api_service.dart';
import 'package:grade3/core/utils/app_router.dart';
import 'package:grade3/features/auth/logic/login_cubit.dart';
import 'package:grade3/features/home/data/repos/home_repo_impl.dart';
import 'package:grade3/features/home/presentation/manager/fetch_company_cubit/fetch_companies_cubit.dart';
import 'package:grade3/features/home/presentation/manager/fetch_translators_cubit/fetch_translators_cubit.dart';
import 'package:grade3/features/home/presentation/manager/select_language_cubit.dart';
import 'package:grade3/features/user_account/logic/user_profile_cubit.dart';

void main() {
  runApp(const GraduationApp());
}

class GraduationApp extends StatelessWidget {
  const GraduationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => FetchCompaniesCubit(
            HomeRepoImpl(
              apiService: ApiService(dio: Dio()),
            ),
          )..fetchCompanies(),
        ),
        BlocProvider(
          create: (context) => FetchTranslatorsCubit(
            HomeRepoImpl(
              apiService: ApiService(dio: Dio()),
            ),
          )..fetchTranslators(),
        ),
        BlocProvider(
          create: (context) => SelectLanguageCubit(),
        ),
        BlocProvider(
          create: (context) => UserProfileCubit(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.robotoTextTheme(),
        ),
      ),
    );
  }
}
