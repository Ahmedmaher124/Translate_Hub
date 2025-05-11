import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:grade3/features/company_profile/presentation/views/widgets/job_card.dart';

import 'package:grade3/features/home/data/models/jobs_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AvailableJobs extends StatefulWidget {
  const AvailableJobs({super.key, required this.companyId});

  final String companyId;

  @override
  State<AvailableJobs> createState() => _AvailableJobsState();
}

class _AvailableJobsState extends State<AvailableJobs> {
  List<JobModel> jobs = [];
  List<JobModel> filteredJobs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    final url = Uri.parse(
        'https://translator-project-seven.vercel.app/company/job/${widget.companyId}/list-job');
    try {
      final response = await http.get(url);
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> jobsJson = data['jobs'];
        setState(() {
          jobs = jobsJson.map((e) => JobModel.fromJson(e)).toList();
          filteredJobs = jobs;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load jobs');
      }
    } catch (e) {
      log('Error: $e');
      setState(() => isLoading = false);
    }
  }

  void filterJobs(String query) {
    final filtered = jobs.where((job) {
      final titleLower = job.title.toLowerCase();
      final companyLower = job.companyName.toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower) ||
          companyLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredJobs = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Available Translation Jobs',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              onChanged: filterJobs,
              decoration: InputDecoration(
                hintText: 'Search by title or company...',
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 10),
            isLoading
                ? const Expanded(
                    child: Center(child: CircularProgressIndicator()))
                : Expanded(
                    child: filteredJobs.isEmpty
                        ? const Center(
                            child: Text(
                            'No Available Jobs for This Company.',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ))
                        : ListView.builder(
                            itemCount: filteredJobs.length,
                            itemBuilder: (context, index) {
                              final job = filteredJobs[index];
                              return JobCard(job: job);
                            },
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
