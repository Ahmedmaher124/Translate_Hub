import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grade3/core/utils/app_router.dart';
import 'package:grade3/features/chat/presentation/views/widgets/chat_item_page.dart';
import 'package:grade3/features/home/data/models/company_model.dart';
import 'package:grade3/features/home/presentation/views/widgets/chat_icon.dart';
import 'package:grade3/features/home/presentation/views/widgets/company_info_card.dart';
import 'package:grade3/features/home/presentation/views/widgets/company_logo_name.dart';

class CompanyCard extends StatelessWidget {
  const CompanyCard({super.key, required this.companyModel});
  final CompanyModel companyModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context)
            .push(AppRouter.companyProfileView, extra: companyModel);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xffEBEBEB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CompanyLogoName(companyModel: companyModel),
                ChatIcon(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatItemPage(
                          company: companyModel, // بعتنا موديل الشركة
                          imageUrl: companyModel.logo, // تمرير صورة الشركة
                          name: companyModel.name,
                          recivedId: companyModel.id, // تمرير اسم الشركة

                          // تمرير اسم الشركة
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            CompanyInfoCard(companyModel: companyModel),
          ],
        ),
      ),
    );
  }
}
