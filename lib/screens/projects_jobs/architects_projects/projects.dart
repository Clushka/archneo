import 'package:flutter/material.dart';
import 'package:freelance_app/screens/homescreen/sidebar.dart';
import 'package:freelance_app/screens/projects_jobs/architects_projects/projects_posted.dart';
import 'package:freelance_app/screens/projects_jobs/clients_jobs/jobs.dart';
import 'package:freelance_app/utils/colors.dart';

class Projects extends StatefulWidget {
  const Projects({super.key});

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  int _selectedIndex = 0;

  _onItemTapped(int index) {
    setState(() {
      // change _selectedIndex, fab will show or hide
      _selectedIndex = index;
      // change app bar title
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: SideBar(),
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
          bottom: TabBar(
            onTap: _onItemTapped,
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
              posted(),
              taken2(),
            ])),
          ],
        ),
        floatingActionButton: _selectedIndex == 1
            ? FloatingActionButton(
                backgroundColor: Color.fromARGB(255, 210, 68, 149),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (_) => ProjUpload(
                  //             userID: _uid,
                  //             uEmail: _email,
                  //           ) //const LoginScreen(),
                  //       ),
                  // );
                },
                child: const Icon(
                  Icons.add_rounded,
                  //size: 40,
                  color: Colors.white,
                ),
              )
            : null,
      ),
    );
  }
}
