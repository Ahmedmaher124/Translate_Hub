import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:grade3/core/services/token_storage_service.dart';
import 'package:grade3/core/utils/app_colors.dart';
import 'package:grade3/features/company_profile/presentation/views/widgets/row_details_item.dart';
import 'package:grade3/features/home/data/models/jobs_model.dart';
import 'package:http/http.dart' as http;

class JobCard extends StatelessWidget {
  const JobCard({super.key, required this.job});

  final JobModel job;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 10, 15, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: const Border(
          left: BorderSide(
            color: AppColors.categoryContainerColor,
            width: 3.0,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            job.title,
            style: const TextStyle(
              color: AppColors.categoryContainerColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              RowDetailsItem(
                  title: job.companyName, icon: FontAwesomeIcons.solidBuilding),
              const SizedBox(width: 8),
              RowDetailsItem(
                  title: job.address, icon: FontAwesomeIcons.locationDot),
              const SizedBox(width: 8),
              RowDetailsItem(
                  title: job.jobType, icon: FontAwesomeIcons.briefcase),
              const SizedBox(width: 8),
              RowDetailsItem(
                  title: job.jobLocation, icon: FontAwesomeIcons.globe),
            ],
          ),
          const SizedBox(height: 5),
          infoRow('Languages:', job.requiredLanguages.join(', ')),
          infoRow('Skills:', job.skillsRequired.join(', ')),
          infoRow('Description:', job.description),
          infoRow('Salary:', '\$${job.budget}'),
          infoRow('Payment method:', job.paymentMethod),
          Divider(color: Colors.grey[300]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Posted on: ${job.createdAt.toLocal().toString().split(' ')[0]}',
                style: const TextStyle(color: Colors.grey, fontSize: 10),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.blue.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  job.status,
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
              TextButton(
                onPressed: () async {
                  final success = await applyToJob(context);
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Center(
                        child: Text(
                          success
                              ? 'Application sent successfully'
                              : 'Failed to apply',
                        ),
                      ),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  // ignore: deprecated_member_use
                  backgroundColor: Colors.green.withOpacity(0.9),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
                child: const Text('Apply'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget infoRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(label,
              style: const TextStyle(fontSize: 15, color: Colors.black)),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  Future<bool> applyToJob(BuildContext context) async {
    final token = await TokenStorageService.getToken();
    final userId = await TokenStorageService.getUserId();

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null) {
      log('لم يتم اختيار أي ملف.');
      return false;
    }

    String? filePath = result.files.single.path;
    if (filePath == null) {
      log('لم يتم اختيار ملف صالح.');
      return false;
    }

    File cvFile = File(filePath);

    final url = Uri.parse(
      'https://translator-project-seven.vercel.app/application/create/${job.id}',
    );

    try {
      var request = http.MultipartRequest('POST', url)
        ..headers['token'] = token.toString()
        ..fields['jobId'] = job.id
        ..fields['companyName'] = job.companyName
        ..fields['userId'] = userId.toString()
        ..files.add(await http.MultipartFile.fromPath('cv', cvFile.path));

      final response = await request.send();

      if (response.statusCode == 201 || response.statusCode == 200) {
        log('تم التقديم بنجاح');
        return true;
      } else {
        final responseBody = await response.stream.bytesToString();
        log('Apply failed: $responseBody');
        return false;
      }
    } catch (e) {
      log('Error applying: $e');
      return false;
    }
  }
}
