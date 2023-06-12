import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freelance_app/screens/projects_jobs/clients_jobs/jobs_details.dart';
import 'package:intl/intl.dart';
import '../../activity/details.dart';

class JobsCard extends StatelessWidget {
  final String projectID;
  final String projectTitle;
  final String uploadedBy;
  final String authorName;
  final String projectImage;
  final String projectDesc;

  const JobsCard({
    Key? key,
    required this.projectTitle,
    required this.projectID,
    required this.uploadedBy,
    required this.authorName,
    required this.projectImage,
    required this.projectDesc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => JobsPosted(id: '', jobID: '', userID: '',
              // projectID: projectID,
            ),
          ),
        );
      },
      child: Column(
        children: [
          const SizedBox(height: 6),
          Card(
            color: Colors.white,
            elevation: 5,
            child: ListTile(
              title: Text(
                projectTitle,
                style: const TextStyle(fontSize: 20),
              ),
              subtitle: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Author Name: $authorName',
                        maxLines: 2,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
