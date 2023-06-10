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

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({super.key, required this.id, required this.eventID});
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

  applyForJob() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: emailCompany,
      query:
          'subject=Applying for $eventTitle&body=Hello, please attach Resume CV file',
    );
    final url = params; //removed toString
    launchUrl(url);
    addNewApplicant();
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            applicants.toString(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          const Text(
                            'Applicants',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Icon(
                            Icons.how_to_reg_sharp,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      FirebaseAuth.instance.currentUser!.uid != widget.id
                          ? Container()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                dividerWidget(),
                                const Text(
                                  'Recruitment:',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        User? user = _auth.currentUser;
                                        final _uid = user!.uid;
                                        if (_uid == widget.id) {
                                          try {
                                            FirebaseFirestore.instance
                                                .collection('events')
                                                .doc(widget.eventID)
                                                .update({'Recruitment': true});
                                          } catch (err) {
                                            GlobalMethodTwo.showErrorDialog(
                                                error:
                                                    'Action cant be performed',
                                                ctx: context);
                                          }
                                        } else {
                                          GlobalMethodTwo.showErrorDialog(
                                              error:
                                                  'You cant perform this action',
                                              ctx: context);
                                        }
                                        getJobData();
                                      },
                                      child: const Text(
                                        'ON',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    Opacity(
                                      opacity: recruiting == true ? 1 : 0,
                                      child: const Icon(
                                        Icons.check_box,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 40,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        User? user = _auth.currentUser;
                                        final _uid = user!.uid;
                                        if (_uid == widget.id) {
                                          try {
                                            FirebaseFirestore.instance
                                                .collection('events')
                                                .doc(widget.eventID)
                                                .update({'Recruitment': false});
                                          } catch (err) {
                                            GlobalMethodTwo.showErrorDialog(
                                                error:
                                                    'Action cant be performed',
                                                ctx: context);
                                          }
                                        } else {
                                          GlobalMethodTwo.showErrorDialog(
                                              error:
                                                  'You cant perform this action',
                                              ctx: context);
                                        }
                                        getJobData();
                                      },
                                      child: const Text(
                                        'OFF',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    Opacity(
                                      opacity: recruiting == false ? 1 : 0,
                                      child: const Icon(
                                        Icons.check_box,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
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
                      dividerWidget(),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                color: Colors.orange[200],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          isDeadlineAvailable
                              ? 'Actively Recruiting, Send CV/Resume:'
                              : ' Deadline Passed away.',
                          style: TextStyle(
                              color: isDeadlineAvailable
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.normal,
                              fontSize: 16),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Center(
                        child: MaterialButton(
                          onPressed: () {
                            applyForJob();
                          },
                          color: Colors.black,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13)),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Text(
                              'Apply Now',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      dividerWidget(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Uploaded on:',
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            postedDate == null ? '' : postedDate!,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Deadline date:',
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            deadlineDate == null ? '' : deadlineDate!,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          )
                        ],
                      ),
                      dividerWidget(),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                color: Colors.orange[200],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(
                          milliseconds: 500,
                        ),
                        child: _isCommenting
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: TextField(
                                      controller: _commentController,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      maxLength: 200,
                                      keyboardType: TextInputType.text,
                                      maxLines: 6,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        enabledBorder:
                                            const UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.pink),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: MaterialButton(
                                            onPressed: () async {
                                              if (_commentController
                                                      .text.length <
                                                  7) {
                                                GlobalMethodTwo.showErrorDialog(
                                                    error:
                                                        'Comment cant be less than 7 characters',
                                                    ctx: context);
                                              } else {
                                                final _generatedId =
                                                    const Uuid().v4();
                                                await FirebaseFirestore.instance
                                                    .collection('events')
                                                    .doc(widget.eventID)
                                                    .update({
                                                  'Comments':
                                                      FieldValue.arrayUnion([
                                                    {
                                                      'ID': FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid,
                                                      'CommentId': _generatedId,
                                                      'Name': name,
                                                      'PhotoUrl': user_image,
                                                      'CommentBody':
                                                          _commentController
                                                              .text,
                                                      'Time': Timestamp.now(),
                                                    }
                                                  ]),
                                                });
                                                await Fluttertoast.showToast(
                                                    msg:
                                                        "Your comment has been added",
                                                    toastLength:
                                                        Toast.LENGTH_LONG,
                                                    backgroundColor:
                                                        Colors.grey,
                                                    fontSize: 18.0);
                                                _commentController.clear();
                                              }
                                              setState(() {
                                                showComment = true;
                                              });
                                            },
                                            color: Colors.black,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: const Text(
                                              'Post',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                _isCommenting = !_isCommenting;
                                                showComment = false;
                                              });
                                            },
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isCommenting = !_isCommenting;
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.add_comment,
                                      color: Colors.black,
                                      size: 40,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        showComment = true;
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.arrow_drop_down_circle,
                                      color: Colors.black,
                                      size: 40,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      showComment == false
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('events')
                                    .doc(widget.eventID)
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    if (snapshot.data!["Comments"] == null) {
                                      const Center(
                                          child:
                                              Text('No Comment for this event'));
                                    }
                                  }
                                  return ListView.separated(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return CommentWidget(
                                            commentId:
                                                snapshot.data!['Comments']
                                                    [index]['CommentId'],
                                            commenterId: snapshot
                                                .data!['Comments'][index]['ID'],
                                            commenterName:
                                                snapshot.data!['Comments']
                                                    [index]['Name'],
                                            commentBody:
                                                snapshot.data!['Comments']
                                                    [index]['CommentBody'],
                                            commenterImageUrl:
                                                snapshot.data!['Comments']
                                                    [index]['PhotoUrl']);
                                      },
                                      separatorBuilder: (context, index) {
                                        return const Divider(
                                          thickness: 1,
                                          color: Colors.grey,
                                        );
                                      },
                                      itemCount:
                                          snapshot.data!['Comments'].length);
                                },
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
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
