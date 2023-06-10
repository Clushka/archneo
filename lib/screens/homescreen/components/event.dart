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

class Upload extends StatefulWidget {
  final String userID;

  const Upload({super.key, required this.userID});
  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  final _uploadEventFormKey = GlobalKey<FormState>();

  final TextEditingController _eventSubjectController = TextEditingController();
  final FocusNode _eventSubjectFocusNode = FocusNode();

  final TextEditingController _eventTitleController = TextEditingController();
  final FocusNode _eventTitleFocusNode = FocusNode();

  final TextEditingController _eventDescController = TextEditingController();
  final FocusNode _eventDescFocusNode = FocusNode();

  final TextEditingController _eventDeadlineController =
      TextEditingController();
  final FocusNode _eventDeadlineFocusNode = FocusNode();
  DateTime? selectedDeadline;
  Timestamp? deadlineDateTimeStamp;

  bool _isLoading = false;

  @override
  void dispose() {
    _eventSubjectController.dispose();
    _eventSubjectFocusNode.dispose();
    _eventTitleController.dispose();
    _eventTitleFocusNode.dispose();
    _eventDescController.dispose();
    _eventDescFocusNode.dispose();
    _eventDeadlineController.dispose();
    _eventDeadlineFocusNode.dispose();
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
                elevation: layout.elevation,
                color: clr.card,
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
                              'Event Description',
                              style: txt.titleDark,
                            ),
                          ),
                        ),
                        Form(
                          key: _uploadEventFormKey,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _eventSubjectFormField(),
                                _eventTitleFormField(),
                                _eventDescFormField(),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: layout.padding),
                                  child: _eventDeadlineFormField(),
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
                                child: _uploadEventButton(),
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

  Widget _eventSubjectFormField() {
    return GestureDetector(
      onTap: () {
        _showEventsSubjectsDialog();
      },
      child: TextFormField(
        enabled: false,
        focusNode: _eventSubjectFocusNode,
        autofocus: false,
        controller: _eventSubjectController,
        style: txt.fieldDark,
        maxLines: 1,
        maxLength: 100,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onEditingComplete: () => _eventTitleFocusNode.requestFocus(),
        decoration: InputDecoration(
          labelText: 'Select event subject',
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

  Widget _eventTitleFormField() {
    return TextFormField(
      enabled: true,
      focusNode: _eventTitleFocusNode,
      autofocus: false,
      controller: _eventTitleController,
      style: txt.fieldDark,
      maxLines: 1,
      maxLength: 100,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => _eventDescFocusNode.requestFocus(),
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

  Widget _eventDescFormField() {
    return TextFormField(
      enabled: true,
      focusNode: _eventDescFocusNode,
      autofocus: false,
      controller: _eventDescController,
      style: txt.fieldDark,
      maxLines: 3,
      maxLength: 300,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => _eventDescFocusNode.unfocus(),
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

  Widget _eventDeadlineFormField() {
    return GestureDetector(
      onTap: () {
        _selectDeadlineDialog();
      },
      child: TextFormField(
        enabled: false,
        focusNode: _eventDeadlineFocusNode,
        autofocus: false,
        controller: _eventDeadlineController,
        style: txt.fieldDark,
        maxLines: 1,
        maxLength: 100,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        onEditingComplete: () => _eventDeadlineFocusNode.unfocus(),
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

  Widget _uploadEventButton() {
    return MaterialButton(
      onPressed: () {
        _uploadEvent();
      },
      elevation: layout.elevation,
      color: clr.primary,
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
                'Upload Event   ',
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

  _showEventsSubjectsDialog() {
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
                'Event Subjects',
                textAlign: TextAlign.center,
                style: txt.titleLight.copyWith(color: clr.passiveLight),
              ),
            ),
            content: SizedBox(
              width: size.width * 0.9,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: eventSubjects.length,
                itemBuilder: ((context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _eventSubjectController.text = eventSubjects[index];
                        Navigator.pop(context);
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: index != eventSubjects.length - 1
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
                              eventSubjects[index],
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
                    _eventSubjectController.text = '';
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
          _eventDeadlineController.text =
              '${selectedDeadline!.year} - ${selectedDeadline!.month} - ${selectedDeadline!.day}';
          deadlineDateTimeStamp = Timestamp.fromMicrosecondsSinceEpoch(
              selectedDeadline!.microsecondsSinceEpoch);
        },
      );
    } else {
      _eventDeadlineController.text = '';
      deadlineDateTimeStamp = null;
    }
  }

  void _uploadEvent() async {
    getUserData();
    final eventID = const Uuid().v4();
    User? user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('architects')
        .doc(widget.userID)
        .get();
    //final isValid = _uploadJobFormKey.currentState!.validate();

    // if (isValid) {
    if (_eventSubjectController.text == '' ||
        _eventTitleController.text == '' ||
        _eventDescController.text == '' ||
        _eventDeadlineController.text == '' ) {
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
      await FirebaseFirestore.instance.collection('events').doc(eventID).set({
        'EventID': eventID,
        'CreatedAt': Timestamp.now(),
        'ID': uid,
        'PhotoUrl': user_image,
        'Name': name,
        'Email': user.email,
        'Venue': venue,
        'Subjects': _eventSubjectController.text,
        'Title': _eventTitleController.text,
        'Description': _eventDescController.text,
        'DeadlineDate': _eventDeadlineController.text,
        'DeadlineTimestamp': deadlineDateTimeStamp,
        'Recruiting': true,
        'Applicants': 0,
        'Comments': [],
        'ApplicantsList': [],
      });
      await Fluttertoast.showToast(
        msg: 'The event has been successfully uploaded.',
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.black54,
        fontSize: txt.textSizeDefault,
      );
      setState(() {
        _eventSubjectController.clear();
        _eventTitleController.clear();
        _eventDescController.clear();
        _eventDeadlineController.clear();
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
      });
    }
  }

  void getUserData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('architects')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      id = userDoc.get('id');
      name = userDoc.get('Name');
      user_image = userDoc.get('PhotoUrl');
      venue = userDoc.get('address');
    });
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
