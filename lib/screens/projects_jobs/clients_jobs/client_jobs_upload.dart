import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freelance_app/utils/global_methods.dart';
import 'package:freelance_app/utils/global_variables.dart';
import 'package:freelance_app/utils/clr.dart';
import 'package:freelance_app/utils/layout.dart';
import 'package:freelance_app/utils/txt.dart';
import 'package:uuid/uuid.dart';

class JobsUpload extends StatefulWidget {
  final String userID;
  final String? uEmail;

  const JobsUpload({
    super.key,
    required this.userID,
    required this.uEmail,
  });
  @override
  State<JobsUpload> createState() => _JobsUploadState();
}

class _JobsUploadState extends State<JobsUpload> {
  final _uploadJobsFormKey = GlobalKey<FormState>();

  final TextEditingController _jobsSubjectController = TextEditingController();
  final FocusNode _jobsSubjectFocusNode = FocusNode();

  final TextEditingController _jobsTitleController = TextEditingController();
  final FocusNode _jobsTitleFocusNode = FocusNode();

  final TextEditingController _jobsDescController = TextEditingController();
  final FocusNode _jobsDescFocusNode = FocusNode();

  final TextEditingController _jobsDeadlineController = TextEditingController();
  final FocusNode _jobsDeadlineFocusNode = FocusNode();
  DateTime? selectedDeadline;
  Timestamp? deadlineDateTimeStamp;

  bool _isLoading = false;

  @override
  void dispose() {
    _jobsSubjectController.dispose();
    _jobsSubjectFocusNode.dispose();
    _jobsTitleController.dispose();
    _jobsTitleFocusNode.dispose();
    _jobsDescController.dispose();
    _jobsDescFocusNode.dispose();
    _jobsDeadlineController.dispose();
    _jobsDeadlineFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        decoration: boxDecorationGradient(),
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
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
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.only(
              top: layout.padding * 3,
              bottom: layout.padding,
              left: layout.padding,
              right: layout.padding,
            ),
            child: SingleChildScrollView(
              child: Card(
                color: Color.fromARGB(255, 242, 242, 242),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Color.fromARGB(255, 248, 243, 243),
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(layout.padding),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: layout.padding),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Job Description',
                              style: txt.titleDark,
                            ),
                          ),
                        ),
                        Form(
                          key: _uploadJobsFormKey,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // _project1SubjectFormField(),
                                // _project1TitleFormField(),
                                // _project1DescFormField(),
                                // _project1DeadlineFormField

                                _jobsSubjectFormField(),
                                _jobsTitleFormField(),
                                _jobsDescFormField(),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: layout.padding),
                                  child: _jobsDeadlineFormField(),
                                ),
                              ]),
                        ),
                        _isLoading
                            ? const Align(
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(
                                  top: 0,
                                  bottom: layout.padding,
                                  left: layout.padding,
                                  right: layout.padding,
                                ),
                                //_upload1ProjectButt
                                child: _uploadJobsButt(),
                              ),
                      ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _jobsSubjectFormField() {
    return GestureDetector(
      onTap: () {
        //_showEventsSubjects1Dialog
        _showJobsSubjectsDialog();
      },
      child: TextFormField(
        enabled: false,
        focusNode: _jobsSubjectFocusNode,
        autofocus: false,
        controller: _jobsSubjectController,
        style: txt.fieldDark,
        maxLines: 1,
        maxLength: 100,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onEditingComplete: () => _jobsTitleFocusNode.requestFocus(),
        decoration: InputDecoration(
          labelText: 'Select a job category',
          labelStyle: txt.labelDark,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          floatingLabelStyle: txt.floatingLabelDark,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: clr.dark,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: clr.dark,
            ),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: clr.error,
            ),
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Value is missing';
          }
          return null;
        },
      ),
    );
  }

  Widget _jobsTitleFormField() {
    return TextFormField(
      enabled: true,
      focusNode: _jobsTitleFocusNode,
      autofocus: false,
      controller: _jobsTitleController,
      style: txt.fieldDark,
      maxLines: 1,
      maxLength: 100,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => _jobsDescFocusNode.requestFocus(),
      decoration: InputDecoration(
        labelText: 'Title',
        labelStyle: txt.labelDark,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelStyle: txt.floatingLabelDark,
        // filled: true,
        // fillColor: clr.passive,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: clr.dark,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: clr.dark,
          ),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: clr.error,
          ),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Value is missing';
        }
        return null;
      },
    );
  }

  Widget _jobsDescFormField() {
    return TextFormField(
      enabled: true,
      focusNode: _jobsDescFocusNode,
      autofocus: false,
      controller: _jobsDescController,
      style: txt.fieldDark,
      maxLines: 3,
      maxLength: 300,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => _jobsDescFocusNode.unfocus(),
      decoration: InputDecoration(
        labelText: 'Description',
        labelStyle: txt.labelDark,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelStyle: txt.floatingLabelDark,
        // filled: true,
        // fillColor: clr.passive,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: clr.dark,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: clr.dark,
          ),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: clr.error,
          ),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Value is missing';
        }
        return null;
      },
    );
  }

  Widget _jobsDeadlineFormField() {
    return GestureDetector(
      onTap: () {
        _selectDeadlineDialog();
      },
      child: TextFormField(
        enabled: false,
        focusNode: _jobsDeadlineFocusNode,
        autofocus: false,
        controller: _jobsDeadlineController,
        style: txt.fieldDark,
        maxLines: 1,
        maxLength: 100,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        onEditingComplete: () => _jobsDeadlineFocusNode.unfocus(),
        decoration: InputDecoration(
          labelText: 'Select deadline date',
          labelStyle: txt.labelDark,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          floatingLabelStyle: txt.floatingLabelDark,
          // filled: true,
          // fillColor: clr.passive,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: clr.dark,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: clr.dark,
            ),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: clr.error,
            ),
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Value is missing';
          }
          return null;
        },
      ),
    );
  }

  Widget _uploadJobsButt() {
    return MaterialButton(
      onPressed: () {
        _uploadJobs();
      },
      elevation: layout.elevation,
      color: Color.fromARGB(255, 14, 14, 54),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(layout.radius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(layout.padding * 0.75),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                'Upload a Job   ',
                style: txt.button,
              ),
              Icon(
                Icons.upload_file,
                color: Colors.white,
                size: layout.iconMedium,
              ),
            ]),
      ),
    );
  }

  _showJobsSubjectsDialog() {
    Size size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: Colors.black54,
            title: Padding(
              padding: const EdgeInsets.only(
                top: layout.padding,
                bottom: layout.padding,
              ),
              child: Text(
                'Select a job category',
                textAlign: TextAlign.center,
                style: txt.titleLight.copyWith(color: clr.passiveLight),
              ),
            ),
            content: SizedBox(
              width: size.width * 0.9,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: jobsSubjects.length,
                itemBuilder: ((context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _jobsSubjectController.text = jobsSubjects[index];
                        Navigator.pop(context);
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: index != jobsSubjects.length - 1
                            ? layout.padding
                            : 0,
                      ),
                      child: Row(children: [
                        Icon(
                          Icons.business,
                          color: clr.passiveLight,
                          size: 25.0,
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: layout.padding * 1.25,
                            ),
                            child: Text(
                              jobsSubjects[index],
                              style: txt.body2Light
                                  .copyWith(color: clr.passiveLight),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  );
                }),
              ),
            ),
            actions: [
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                InkWell(
                  onTap: () {
                    _jobsSubjectController.text = '';
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: layout.padding,
                      bottom: layout.padding * 2,
                    ),
                    child: Row(children: [
                      Icon(
                        Icons.cancel,
                        color: clr.passiveLight,
                        size: layout.iconSmall,
                      ),
                      const Text(
                        ' Cancel',
                        style: txt.button,
                      ),
                    ]),
                  ),
                ),
              ]),
            ]);
      },
    );
  }

  void _selectDeadlineDialog() async {
    selectedDeadline = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (selectedDeadline != null) {
      setState(
        () {
          _jobsDeadlineController.text =
              '${selectedDeadline!.day} - ${selectedDeadline!.month} -${selectedDeadline!.year}';
          deadlineDateTimeStamp = Timestamp.fromMicrosecondsSinceEpoch(
              selectedDeadline!.microsecondsSinceEpoch);
        },
      );
    } else {
      _jobsDeadlineController.text = '';
      deadlineDateTimeStamp = null;
    }
  }

  void _uploadJobs() async {
    getUserData();
    final jobsID = const Uuid().v4();
    User? user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('architects')
        .doc(widget.userID)
        .get();
    //final isValid = _uploadJobFormKey.currentState!.validate();

    // if (isValid) {
    if (_jobsSubjectController.text == '' ||
        _jobsTitleController.text == '' ||
        _jobsDescController.text == '' ||
        _jobsDeadlineController.text == '') {
      GlobalMethod.showErrorDialog(
        context: context,
        icon: Icons.error,
        iconColor: clr.error,
        title: 'Missing Information',
        body: 'Please enter all information about job.',
        buttonText: 'OK',
      );
      return;
      // }
    }
    setState(() {
      _isLoading = true;
    });
    setState(() {
      _isLoading = true;
      user_image = userDoc.get('PhotoUrl');
    });
    try {
      await FirebaseFirestore.instance.collection('jobPosted').doc(jobsID).set({
        // 'CreatedAt': Timestamp.now(),
        // 'AuthorID': uid,
        // 'Description': _jobsDescController.text,
        // 'ID': jobsID,
        // 'ProjectImageUrl':
        //     'https://firebasestorage.googleapis.com/v0/b/getjob-ef46d.appspot.com/o/projects%2Funnamed.jpg?alt=media&token=0b461dbe-7c35-4d30-9f87-5c54f1793040',
        // 'Name': _jobsTitleController.text,

        'CreatedAt': Timestamp.now(),
        'ID': jobsID,
        'applicants': 1,
        'applicantsList': 0,
        'category': _jobsSubjectController.text,
        'comments': [],
        'deadlinedate': _jobsDeadlineController.text,
        'deadlinetimestamp': deadlineDateTimeStamp,
        'desc': _jobsDescController.text,
        'email': user.email,
        'job_ID': jobsID,
        'recruiting': true,
        'title': _jobsTitleController.text,
        'user_image': imageUrl
      });
      await Fluttertoast.showToast(
        msg: 'The job has been successfully uploaded.',
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.black54,
        fontSize: txt.textSizeDefault,
      );
      setState(() {
        _jobsSubjectController.clear();
        _jobsTitleController.clear();
        _jobsDescController.clear();
        _jobsDeadlineController.clear();
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      GlobalMethod.showErrorDialog(
          context: context,
          icon: Icons.error,
          iconColor: clr.error,
          title: 'Error',
          body: error.toString(),
          buttonText: 'OK');
    } finally {
      setState(() {
        _isLoading = false;
        Navigator.canPop(context) ? Navigator.pop(context) : null;
      });
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String phoneNumber = "";
  String email = "";
  String? name;
  String imageUrl = "";
  String joinedAt = " ";
  bool _isSameUser = false;
  String collectionName = "";
  String profileID = "";

  void getUserData() async {
    try {
      _isLoading = true;
      final QuerySnapshot rolesDoc =
          await FirebaseFirestore.instance.collection('roles').get();
      for (var i = 0; i < rolesDoc.docs.length; i++) {
        if (rolesDoc.docs[i].get('Email') == widget.uEmail) {
          collectionName = rolesDoc.docs[i].get('Role') + 's';
          profileID = rolesDoc.docs[i].get('ID');
        }
      }
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(profileID)
          .get();
      setState(() {
        email = userDoc.get('Email');
        name = userDoc.get('Name');
        phoneNumber = userDoc.get('Phone');
        imageUrl = userDoc.get('PhotoUrl');
        Timestamp joinedAtTimeStamp = userDoc.get('CreatedAt');
        var joinedDate = joinedAtTimeStamp.toDate();
        joinedAt = '${joinedDate.year}-${joinedDate.month}-${joinedDate.day}';
      });
      User? user = _auth.currentUser;
      final _uid = user!.uid;
      setState(() {
        _isSameUser = _uid == widget.userID;
      });
    } finally {
      _isLoading = false;
    }
  }
}

BoxDecoration boxDecorationGradient() {
  return BoxDecoration(
    gradient: LinearGradient(
      colors: [
        clr.backgroundGradient1,
        clr.backgroundGradient2,
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      stops: const [0.2, 1.0],
    ),
  );
}
