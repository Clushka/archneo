import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:freelance_app/utils/global_variables.dart';

import 'package:freelance_app/utils/layout.dart';
import 'package:freelance_app/utils/txt.dart';
import 'package:freelance_app/utils/clr.dart';
import 'package:freelance_app/widgets/event_tile.dart';

class posted2 extends StatefulWidget {
  const posted2({super.key});

  @override
  State<posted2> createState() => _posted2State();
}

class _posted2State extends State<posted2> {
  String? eventsCategoryFilter;

  void getMyData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('architects')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    setState(() {
      name = userDoc.get('Name');
      user_image = userDoc.get('PhotoUrl');
    });
  }

  @override
  void initState() {
    super.initState();
    getMyData();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      children: [
        // Expanded(
        //   flex: 0,
        //   child: Row(
        //     children: [
        //       const SizedBox(
        //         width: 10,
        //       ),
        //       IconButton(
        //         onPressed: () {
        //           showJobCategoriesDialog();
        //         },
        //         icon: const Icon(
        //           Icons.filter_list,
        //           color: clr.primary,
        //           size: layout.iconMedium,
        //         ),
        //       ),
        //       Text(
        //         "Filter Events based on your choice",
        //         style: txt.body2Dark.copyWith(color: Colors.grey),
        //         //TextStyle(fontSize: 15, color: Colors.grey),
        //       ),
        //     ],
        //   ),
        // ),
        // Container(
        //   child: eventsCategoryFilter != null
        //   ? Text(
        //       eventsCategoryFilter.toString(),
        //       style: txt.body2Dark,
        //     )
        //   : const Text(
        //       "Recent Events",
        //       style: txt.body2Dark,
        //   ),
        // ),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('events')
                .where('Subjects', isEqualTo: eventsCategoryFilter)
                .orderBy('CreatedAt', descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
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
                          return Event(
                            eventID: snapshot.data.docs[index]['EventID'],
                            eventTitle: snapshot.data.docs[index]['Title'],
                            eventDesc: snapshot.data.docs[index]['Description'],
                            uploadedBy: snapshot.data.docs[index]['ID'],
                            contactName: snapshot.data.docs[index]['Name'],
                            contactImage: snapshot.data.docs[index]['PhotoUrl'],
                            contactEmail: snapshot.data.docs[index]['Email'],
                            eventVenue: snapshot.data.docs[index]['Venue'],
                            isActive: snapshot.data.docs[index]['Recruiting'],
                          );
                        }),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(layout.padding * 6),
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
        ),
      ],
    ));
  }

  //job filtering

  
}
