import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../activity/applicants.dart';
import '../activity/details.dart';

class Project extends StatelessWidget {
  final String projectID;
  final String projectTitle;
  final String uploadedBy;
  final String authorName;
  final String projectImage;
  final String projectDesc;

  const Project({
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
            builder: (context) => ApplicantsApp(
              projectID: projectID,
            ),
          ),
        );
      },
      child: Column(
        children: [
          const SizedBox(height: 6),
          // Card(
          //   elevation: 2,
          //   color: Colors.white,
          //   child: ListTile(
          //     onTap: () {},
          //     contentPadding: const EdgeInsets.only(bottom: 16.0 / 2),
          //     leading: Container(
          //         decoration: const BoxDecoration(
          //           border: Border(
          //             right: BorderSide(width: 1),
          //           ),
          //         ),
          //         // child: Text('data')
          //         // Image.network(
          //         //   projectImage,
          //         // ),
          //         ),
          //     title: Padding(
          //       padding: const EdgeInsets.only(bottom: 16.0 / 4),
          //       child: Image.network(projectImage),
          //       // Text(
          //       //   projectTitle,
          //       //   style: TextStyle(
          //       //     fontFamily: 'JosefinSans',
          //       //     fontWeight: FontWeight.bold,
          //       //     fontSize: 20.0 * 1.1,
          //       //     color: Color.fromARGB(255, 14, 14, 54),
          //       //   ),
          //       //   maxLines: 2,
          //       //   overflow: TextOverflow.ellipsis,
          //       // ),
          //     ),
          //     subtitle: Column(
          //         mainAxisAlignment: MainAxisAlignment.start,
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Padding(
          //             padding: const EdgeInsets.only(bottom: 16.0 / 4),
          //             child: Text(
          //               projectDesc,
          //               style: TextStyle(
          //                 fontFamily: 'Yeseva',
          //                 fontWeight: FontWeight.normal,
          //                 fontSize: 12.0 * 1.1,
          //                 color: Color.fromARGB(255, 11, 74, 103),
          //               ),
          //               maxLines: 2,
          //               overflow: TextOverflow.ellipsis,
          //             ),
          //           ),
          //         ]),
          //     trailing: const Icon(
          //       Icons.keyboard_arrow_right,
          //       color: Color.fromARGB(255, 14, 14, 54),
          //       size: 30.0,
          //     ),
          //   ),
          // ),
          Card(
            color: Colors.grey[200],
            elevation: 2,
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
