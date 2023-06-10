import 'package:flutter/material.dart';
import 'package:freelance_app/screens/activity/applicant-card.dart';
import '../../utils/global_variables.dart';
import '../search/projects_card.dart';
import 'package:freelance_app/utils/layout.dart';
import 'package:freelance_app/utils/txt.dart';
import 'package:freelance_app/utils/clr.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApplicantsApp extends StatefulWidget {
  final String? projectID;
  const ApplicantsApp({super.key, this.projectID});

  @override
  State<ApplicantsApp> createState() => _ApplicantsAppState();
}

class _ApplicantsAppState extends State<ApplicantsApp> {
  final _auth = FirebaseAuth.instance;
  String? nameForposted;
  String? userImageForPosted;
  String? addressForposted;
  void getMyData() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('architects')
        .where('Email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();

    setState(() {
      nameForposted = userDoc.docs[0]['Name'];
      userImageForPosted = userDoc.docs[0]['PhotoUrl'];
    });
  }

  @override
  void initState() {
    super.initState();
    getProjectData();
    getMyData();
  }

  void getProjectData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('projects')
        .doc(widget.projectID)
        .get();
    setState(() {
      projectName = userDoc.get('Name');
      projectDescription = userDoc.get('Description');
      projectImageUrl = userDoc.get('ProjectImageUrl');
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    // final uid = user!.uid;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.orange,
        ),
        title: const Padding(
          padding: EdgeInsets.only(left: 180),
          child: Text(
            "ArchNEO",
            style: TextStyle(color: Colors.orange),
          ),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              // height: 30,
              //width: 180,
              child: Text(
                projectName!,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              //width: 180,
              child: Image(
                  image: NetworkImage(projectImageUrl!), fit: BoxFit.fill),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              //width: 180,
              child: Text(
                projectDescription!,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
