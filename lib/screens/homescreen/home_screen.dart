import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:freelance_app/screens/activity/activity.dart';
import 'package:freelance_app/screens/homescreen/components/event_making_screen.dart';

import 'package:freelance_app/screens/profile/profile.dart';
import 'package:freelance_app/screens/projects_jobs/architects_projects/project_decription.dart';
import 'package:freelance_app/screens/projects_jobs/architects_projects/projects.dart';
import 'package:freelance_app/utils/colors.dart';
import 'package:freelance_app/screens/homescreen/components/posted_events.dart';
import 'package:freelance_app/screens/homescreen/sidebar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? eventsCategoryFilter;
  String collectionName = '';
  String profileID = '';
  final auth = FirebaseAuth.instance;

  void getMyData() async {
    final QuerySnapshot rolesDoc = await FirebaseFirestore.instance
        .collection('roles')
        .where('Email', isEqualTo: auth.currentUser!.email)
        .get();

    setState(() {
      collectionName = rolesDoc.docs[0]['Role'] + 's';
      profileID = rolesDoc.docs[0]['ID'];
    });
  }

  @override
  void initState() {
    super.initState();
    getMyData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomNavigationPage(
        title: "ArchNEO",
        collectionName: collectionName,
        profileID: profileID,
      ),
    );
  }
}

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({
    Key? key,
    required this.title,
    required this.collectionName,
    required this.profileID,
  }) : super(key: key);
  final String title;
  final String collectionName;
  final String profileID;

  @override
  _BottomNavigationPageState createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  late int currentIndex;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
  }

  void changePage(int? index) {
    setState(() {
      currentIndex = index!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _uid = user!.uid;
    final _email = user!.email;
    // print(_uid);
    return Scaffold(
      body: <Widget>[
        Homepage(
          collectionName: widget.collectionName,
          profileID: widget.profileID,
        ),
        Projects(),
        const Activity(),
        ProfilePage(
          userID: _uid,
          collectionName: widget.collectionName,
          profileID: widget.profileID,
        ),
      ][currentIndex],
      floatingActionButton: currentIndex == 0
          //for event making
          ? FloatingActionButton(
              backgroundColor: const Color(0xffD2A244),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => Upload(
                            userID: _uid,
                            collectionName: widget.collectionName,
                            profileID: widget.profileID,
                          ) //const LoginScreen(),
                      ),
                );
              },
              //dl
              child: const Icon(
                Icons.add_rounded,
                //size: 40,
                color: Colors.white,
              ),
            )
          : currentIndex == 3
              //button for project making
              ? FloatingActionButton(
                  backgroundColor: const Color(0xffD2A244),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ProjUpload(
                                userID: _uid,
                                uEmail: _email,
                              ) //const LoginScreen(),
                          ),
                    );
                  },
                  child: const Icon(
                    Icons.add_rounded,
                    //size: 40,
                    color: Colors.white,
                  ),
                )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BubbleBottomBar(
        backgroundColor: Colors.white,
        hasNotch: true,
        // fabLocation: BubbleBottomBarFabLocation.end,
        opacity: 1,
        currentIndex: currentIndex,
        onTap: changePage,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(0),
        ), //border radius doesn't work when the notch is enabled.
        //elevation: 10,
        tilesPadding: const EdgeInsets.symmetric(
          vertical: 8.0,
        ),

        items: const <BubbleBottomBarItem>[
          BubbleBottomBarItem(
            backgroundColor: Color.fromARGB(255, 14, 14, 54),
            icon: const Icon(
              Icons.dashboard,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.dashboard,
              color: Colors.white,
            ),
            title: Text(
              "Home ",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          BubbleBottomBarItem(
              backgroundColor: Color.fromARGB(255, 14, 14, 54),
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              title: Text(
                "Projects",
                style: TextStyle(color: Colors.white, fontSize: 16),
              )),
          BubbleBottomBarItem(
              backgroundColor: Color.fromARGB(255, 14, 14, 54),
              icon: const Icon(
                Icons.library_books,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.library_books,
                color: Colors.white,
              ),
              title: Text(
                "Events",
                style: TextStyle(color: Colors.white, fontSize: 16),
              )),
          BubbleBottomBarItem(
              backgroundColor: Color.fromARGB(255, 14, 14, 54),
              icon: const Icon(
                Icons.person_outline,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.person_outline_rounded,
                color: Colors.white,
              ),
              title: Text(
                "Profile",
                style: TextStyle(color: Colors.white, fontSize: 16),
              )),
        ],
      ),
    );
  }
}

class Homepage extends StatefulWidget {
  final String collectionName;
  final String profileID;
  const Homepage({
    super.key,
    required this.collectionName,
    required this.profileID,
  });

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: white,
        iconTheme: const IconThemeData(
          color: Color(0xffD2A244),
        ),
        title: const Padding(
          padding: EdgeInsets.only(left: 180),
          child: Text(
            "ArchNEO",
            style: TextStyle(color: Color(0xffD2A244)),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15, top: 20),
              child: Text(
                "Join Upcoming ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, bottom: 15),
              child: Text(
                "Events",
                style: TextStyle(
                  color: Color(0xffD2A244),
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                ),
              ),
            ),
            // Category(),
            SizedBox(
              height: 10,
            ),
            Events(
              collectionName: widget.collectionName,
              profileID: widget.profileID,
            ),

            //Bottomnavbar(),
          ],
        ),
      ),
    );
  }
}
