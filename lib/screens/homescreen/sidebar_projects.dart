import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelance_app/screens/homescreen/sidebar.dart';
import 'package:freelance_app/screens/projects_jobs/architects_projects/projects_posted.dart';
import 'package:freelance_app/screens/projects_jobs/clients_jobs/jobs.dart';
import 'package:freelance_app/utils/colors.dart';

class ProjPost extends StatefulWidget {
    final String userID;

  final String collectionName;
  final String profileID;
  const ProjPost({super.key, required this.collectionName, required this.profileID, required this.userID});

  @override
  State<ProjPost> createState() => _ProjPostState();
}

class _ProjPostState extends State<ProjPost> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
      final _uid = user!.uid;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          // drawer: SideBar(),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(
              color: Color(0xffD2A244),
            ),
            title: const Padding(
              padding: EdgeInsets.only(left: 210),
              child: Text(
                "ArchNEO",
                style: TextStyle(color: Color(0xffD2A244)),
              ),
            ),
            bottom: const TabBar(
              tabs: [Tab(text: 'Projects'), Tab(text: 'Jobs')],
              labelColor: Colors.black,
              labelStyle: TextStyle(fontSize: 15),
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Material(
                        elevation: 5,
                        child: TextField(
                          // onChanged: (value) => updateList(value),
                          style: TextStyle(color: yellow),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none),
                            hintText: "Join the Event...",
                            prefixIcon: const Icon(Icons.search),
                            prefixIconColor: Color.fromRGBO(245, 186, 65, 1),
                            suffixIconColor: yellow,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: TabBarView(children: [
                posted(
          //         userID: _uid,
          // collectionName: widget.collectionName,
          // profileID: widget.profileID,
          ),
                taken2(),
              ])),
            ],
          )),
    );
  }
}
