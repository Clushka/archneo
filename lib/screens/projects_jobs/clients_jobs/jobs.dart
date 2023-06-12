// import 'package:flutter/material.dart';
// import 'package:freelance_app/screens/projects_jobs/clients_jobs/jobs_card.dart';
// import 'package:freelance_app/screens/projects_jobs/clients_jobs/test_jobs_post.dart';
// import '../architects_projects/projects_card.dart';
// import 'package:freelance_app/utils/layout.dart';
// import 'package:freelance_app/utils/txt.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class taken2 extends StatefulWidget {
//   const taken2({super.key, required this.userID, this.uEmail});
//   final String userID;
//   final String? uEmail;

//   @override
//   State<taken2> createState() => _taken2State();
// }

// class _taken2State extends State<taken2> {
//   final _auth = FirebaseAuth.instance;
//   String? nameForposted;
//   String? userImageForPosted;
//   String? addressForposted;

//   bool _isLoading = false;
//   String phoneNumber = "";
//   String email = "";
//   String? name;
//   String imageUrl = "";
//   String joinedAt = " ";
//   bool _isSameUser = false;
//   String collectionName = "";
//   String profileID = "";

//   void getUserData() async {
//     try {
//       _isLoading = true;
//       final QuerySnapshot rolesDoc =
//           await FirebaseFirestore.instance.collection('roles').get();
//       for (var i = 0; i < rolesDoc.docs.length; i++) {
//         if (rolesDoc.docs[i].get('Email') == widget.uEmail) {
//           collectionName = rolesDoc.docs[i].get('Role') + 's';
//           profileID = rolesDoc.docs[i].get('ID');
//         }
//       }
//       final DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('jobPosted')
//           .doc(FirebaseAuth.instance.currentUser!.uid)
//           .get();
//       setState(() {
//         email = userDoc.get('email');
//         name = userDoc.get('Name');
//         phoneNumber = userDoc.get('Phone');
//         imageUrl = userDoc.get('PhotoUrl');
//         Timestamp joinedAtTimeStamp = userDoc.get('CreatedAt');
//         var joinedDate = joinedAtTimeStamp.toDate();
//         joinedAt = '${joinedDate.day}-${joinedDate.month}-${joinedDate.year}';
//       });
//       User? user = _auth.currentUser;
//       final _uid = user!.uid;
//       setState(() {
//         _isSameUser = _uid == widget.userID;
//       });
//     } finally {
//       _isLoading = false;
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     getUserData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     User? user = _auth.currentUser;
//     final uid = user!.uid;

//     return Container(
//       child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//         stream: FirebaseFirestore.instance.collection('jobPosted').snapshots(),
//         builder: (context, AsyncSnapshot snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.connectionState == ConnectionState.active) {
//             if (snapshot.data?.docs.isNotEmpty == true) {
//               return Padding(
//                 padding: const EdgeInsets.only(
//                   top: 0,
//                   bottom: layout.padding,
//                   left: layout.padding,
//                   right: layout.padding,
//                 ),
//                 child: ListView.builder(
//                     itemCount: snapshot.data?.docs.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       return JobsCard(
//                         // authorName: snapshot.data.docs[index]['name'],
//                         jobDesc: snapshot.data.docs[index]['desc'],
//                         jobsID: snapshot.data.docs[index]['job_ID'],
//                         jobsImage: snapshot.data.docs[index]['user_image'],
//                         jobtitle: snapshot.data.docs[index]['title'],
//                         // uploadedBy: snapshot.data.docs[index]['name'],
//                         userID: snapshot.data.docs[index]['ID'],
//                         // projectID: snapshot.data.docs[index]['ID'
//                         // authorName: snapshot.data.docs[index]['Author'],
//                         // projectImage: snapshot.data.docs[index]
//                         //     ['ProjectImageUrl'],
//                         // projectTitle: snapshot.data.docs[index]['Name'],
//                         // uploadedBy: snapshot.data.docs[index]['Name'],
//                         // projectDesc: snapshot.data.docs[index]
//                         //     ['Description'],
//                       );
//                     }),
//               );
//             } else {
//               return Padding(
//                 padding: const EdgeInsets.all(layout.padding),

//                 // padding: const EdgeInsets.all(layout.padding * 6),
//                 child: Center(
//                   child: Image.asset('assets/images/empty.png'),
//                 ),
//               );
//             }
//           } else {
//             return Center(
//               child: Text(
//                 'FATAL ERROR',
//                 style: txt.error,
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:freelance_app/screens/projects_jobs/architects_projects/projects_card.dart';
import 'package:freelance_app/utils/layout.dart';
import 'package:freelance_app/utils/txt.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class taken2 extends StatefulWidget {
  const taken2({super.key});

  @override
  State<taken2> createState() => _taken2State();
}

class _taken2State extends State<taken2> {
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
                      return ProjectCards(
                        projectID: snapshot.data.docs[index]['ID'],
                        // authorName: snapshot.data.docs[index]['Author'],
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

