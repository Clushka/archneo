import 'package:flutter/material.dart';
import 'projects_card.dart';
import 'package:freelance_app/utils/layout.dart';
import 'package:freelance_app/utils/txt.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class posted extends StatefulWidget {
  const posted({super.key});

  @override
  State<posted> createState() => _postedState();
}

class _postedState extends State<posted> {
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
      // nameForposted = userDoc.docs[0]['Name'];
      // userImageForPosted = userDoc.docs[0]['PhotoUrl'];
    });
  }

  @override
  void initState() {
    super.initState();
    getMyData();
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    final uid = user!.uid;

    return Container(
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('projects').snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          print(snapshot);
          print('hello');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data?.docs.isNotEmpty == true) {
              return Padding(
                padding: const EdgeInsets.only(
                  top: 0,
                  bottom: layout.padding,
                  left: layout.padding,
                  right: layout.padding,
                ),
                child: ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Project(
                        projectID: snapshot.data.docs[index]['ID'],
                        authorName: snapshot.data.docs[index]['Author'],
                        projectImage: snapshot.data.docs[index]
                            ['ProjectImageUrl'],
                        projectTitle: snapshot.data.docs[index]['Name'],
                        uploadedBy: snapshot.data.docs[index]['Name'],
                        projectDesc: snapshot.data.docs[index]['Description'],
                      );
                    }),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(layout.padding),
                

                // padding: const EdgeInsets.all(layout.padding * 6),
                child: Center(
                  child: Image.asset('assets/images/empty.png'),
                ),
              );
            }
          } else {
            return Center(
              child: Text(
                'FATAL ERROR',
                style: txt.error,
              ),
            );
          }
        },
      ),
    );
  }
}
