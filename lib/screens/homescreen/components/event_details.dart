import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freelance_app/screens/homescreen/components/posted_events.dart';
import 'package:freelance_app/screens/homescreen/home_screen.dart';
import 'package:freelance_app/utils/global_methods.dart';
import 'package:freelance_app/utils/global_variables.dart';
import 'package:freelance_app/widgets/comments_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:freelance_app/utils/layout.dart';
import 'package:freelance_app/utils/txt.dart';
import 'package:freelance_app/utils/clr.dart';

import 'dart:math';

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:agora_rtc_engine/rtc_engine.dart';

import 'package:permission_handler/permission_handler.dart';

// import '../../utils/colors.dart';
// import '../../utils/global_methods.dart';
// import '../../utils/global_variables.dart';
// import '../homescreen/sidebar.dart';
import '/../screens/conference/call.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen(
      {super.key, required this.id, required this.eventID});
  final String id;
  final String eventID;

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final TextEditingController _commentController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isCommenting = false;
  String? authorName;
  String? userImageUrl;
  String? eventSubjects;
  String? eventDescription;
  String? eventTitle;
  bool? recruiting;
  Timestamp? postedDateTimeStamp;
  Timestamp? deadlineDateTimeStamp;
  String? postedDate;
  String? deadlineDate;
  String locationCompany = "";
  String emailCompany = "";
  int applicants = 0;
  bool isDeadlineAvailable = false;
  bool showComment = false;

  @override
  void initState() {
    super.initState();
    getJobData();
  }

  void addNewApplicant() async {
    final _generatedId = const Uuid().v4();
    await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.eventID)
        .update({
      'ApplicantsList': FieldValue.arrayUnion([
        {
          'ID': FirebaseAuth.instance.currentUser!.uid,
          'ApplicantsId': widget.eventID,
          'Name': authorName,
          'PhotoUrl': user_image,
          //'commentBody': _commentController.text,
          'timeapplied': Timestamp.now(),
        }
      ]),
    });
    var docRef =
        FirebaseFirestore.instance.collection('events').doc(widget.eventID);

    docRef.update({
      "Applicants": applicants + 1,
    });

    Navigator.pop(context);
  }

//----------------------------------------------------------------

  ClientRole? _role = ClientRole.Broadcaster;
  late var channelController = eventTitle.toString();

  void _addConference() async {
    final confID = const Uuid().v4();
    try {
      FirebaseFirestore.instance.collection('conferences').doc(confID).set(
        {
          'id': confID,
          'Name': channelController,
          'AuthorName': name,
          'AuthorID': id,
          'CreatedAt': Timestamp.now(),
        },
      );
      Navigator.canPop(context) ? Navigator.pop(context) : null;
    } catch (error) {
      GlobalMethod.showErrorDialog(
        context: context,
        icon: Icons.error,
        iconColor: clr.error,
        title: 'Error',
        body: error.toString(),
        buttonText: 'OK',
      );
    }
  }

  Future<void> onJoin() async {
    _addConference();
    // update input validation

    if (channelController.isNotEmpty) {
      await _fetchData();
      // await for camera and mic permissions before pushing video page
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);
      // push video page with given channel name
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            channelName: channelController,
            role: _role,
            userID: id,
            tokenFromServer: token,
            gID: guid,
          ),
        ),
      );
    }
  }

  Future<void> _fetchData() async {
    _generateUid();
    uri = 'https://archneo-token-server.herokuapp.com/rtc/' +
        channelController +
        '/publisher/userAccount/' +
        guid.toString() +
        '/';
    var url = Uri.parse(uri!);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        final data = json.decode(response.body);
        setState(() {
          token = data['rtcToken'];
        });
      });
    } else {
      throw Exception('Failed to fetch data');
    }

    print("uri: $uri token: $token");
  }

  void _generateUid() {
    Random random = Random();
    int min = 100000;
    int max = 999999;
    guid = min + random.nextInt(max - min);
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  void getJobData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('architects')
        .doc(widget.id)
        .get();

    if (userDoc == null) {
      return;
    } else {
      setState(() {
        authorName = userDoc.get('Name');
        userImageUrl = userDoc.get('PhotoUrl');
      });
    }
    final DocumentSnapshot eventDatabase = await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.eventID)
        .get();
    if (eventDatabase == null) {
      return;
    } else {
      setState(() {
        eventTitle = eventDatabase.get('Title');
        eventDescription = eventDatabase.get('Description');
        recruiting = eventDatabase.get('Recruiting');
        emailCompany = eventDatabase.get('Email');
        locationCompany = eventDatabase.get('Venue');
        applicants = eventDatabase.get('Applicants');
        postedDateTimeStamp = eventDatabase.get('CreatedAt');
        deadlineDateTimeStamp = eventDatabase.get('DeadlineTimestamp');
        deadlineDate = eventDatabase.get('DeadlineDate');
        var postDate = postedDateTimeStamp!.toDate();
        postedDate = '${postDate.year}-${postDate.month}-${postDate.day}';
      });

      var date = deadlineDateTimeStamp!.toDate();
      isDeadlineAvailable = date.isAfter(DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
            icon: const Icon(Icons.close_sharp, size: 30, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            }),
        title: const Text(
          "Event Details",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          eventTitle == null ? '' : eventTitle!,
                          maxLines: 3,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 3,
                                color: Colors.black,
                              ),
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                  image: NetworkImage(
                                    userImageUrl == null
                                        ? 'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png'
                                        : userImageUrl!,
                                  ),
                                  fit: BoxFit.fill),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  authorName == null ? '' : authorName!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(locationCompany,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                      dividerWidget(),
                      const Text(
                        'Event Description:',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        eventDescription == null ? '' : eventDescription!,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Card(
                  elevation: 5,
                  child: RadioListTile<ClientRole>(
                    activeColor: const Color(0xffD2A244),
                    title: const Text('Join as  Broadcaster'),
                    value: ClientRole.Broadcaster,
                    groupValue: _role,
                    onChanged: (ClientRole? value) {
                      setState(() {
                        _role = value;
                      });
                    },
                  ),
                ),
                Card(
                  elevation: 5,
                  child: RadioListTile<ClientRole>(
                    activeColor: const Color(0xffD2A244),
                    title: const Text('Join as a Listener'),
                    value: ClientRole.Audience,
                    groupValue: _role,
                    onChanged: (ClientRole? value) {
                      setState(() {
                        _role = value;
                      });
                    },
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: MaterialButton(
                    onPressed: onJoin,
                    // elevation: layout.elevation,
                    color: Color.fromARGB(255, 14, 14, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(layout.radius * 2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(layout.padding * 0.75),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text(
                              'Join',
                              style: txt.button,
                            ),
                          ]),
                    ),
                  ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget dividerWidget() {
    return Column(
      children: const [
        SizedBox(
          height: 10,
        ),
        Divider(
          thickness: 1,
          color: Colors.grey,
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
