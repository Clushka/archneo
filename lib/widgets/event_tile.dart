import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freelance_app/screens/homescreen/components/event_details.dart';
import 'package:freelance_app/utils/global_methods.dart';

import '../utils/clr.dart';
import '../utils/layout.dart';
import "../utils/txt.dart";

class Event extends StatefulWidget {
  final String eventID;
  final String eventTitle;
  final String eventDesc;
  final String uploadedBy;
  final String contactName;
  final String contactImage;
  final String contactEmail;
  final String eventVenue;
  final bool isActive;

  const Event({
    required this.eventID,
    required this.eventTitle,
    required this.eventDesc,
    required this.uploadedBy,
    required this.contactName,
    required this.contactImage,
    required this.contactEmail,
    required this.eventVenue,
    required this.isActive,
  });

  @override
  State<Event> createState() => _EventState();
}

class _EventState extends State<Event> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: layout.padding / 2,
        bottom: layout.padding / 2,
        left: 0,
        right: 0,
      ),
      child: Card(
        elevation: 3,
        color: clr.card,
        child: ListTile(
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => EventDetailsScreen(
                          id: widget.uploadedBy,
                          eventID: widget.eventID,
                        )));
          },
          onLongPress: () {
            _deleteDialog();
          },
          contentPadding: const EdgeInsets.all(layout.padding / 2),
          leading: Container(
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(width: 1),
              ),
            ),
            child: Image.network(
              widget.contactImage,
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(bottom: layout.padding / 4),
            child: Text(
              widget.eventTitle,
              style: txt.subTitleDark,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: layout.padding / 4),
                  child: Text(
                    widget.eventDesc,
                    style: txt.body1Dark,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ]),
          trailing: const Icon(
            Icons.keyboard_arrow_right,
            color: Color.fromARGB(255, 14, 14, 54),
            size: layout.iconMedium,
          ),
        ),
      ),
    );
  }

  _deleteDialog() {
    User? user = _auth.currentUser;
    final uid = user!.uid;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(actions: [
          Padding(
            padding: const EdgeInsets.all(layout.padding),
            child: Column(children: [
              const Text(
                'Are you sure you want to delete this event?',
                style: txt.subTitleDark,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                _textButtonDelete(user, uid),
                _textButtonCancel(context),
              ]),
            ]),
          ),
        ]);
      },
    );
  }

  Widget _textButtonDelete(User? user, uid) {
    return TextButton(
      onPressed: () async {
        try {
          if (widget.uploadedBy == uid) {
            await FirebaseFirestore.instance
                .collection('events')
                .doc(widget.eventID)
                .delete();
            Navigator.canPop(context) ? Navigator.pop(context) : null;
            Navigator.canPop(context) ? Navigator.pop(context) : null;
            await Fluttertoast.showToast(
              msg: 'The event has been successfully deleted',
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: clr.passive,
              fontSize: txt.textSizeDefault,
            );
          } else {
            Navigator.canPop(context) ? Navigator.pop(context) : null;
            Navigator.canPop(context) ? Navigator.pop(context) : null;
            GlobalMethod.showErrorDialog(
              context: context,
              icon: Icons.verified_user,
              iconColor: clr.primary,
              title: 'Unable to delete',
              body: 'Only the user who created the event can delete it',
              buttonText: 'OK',
            );
          }
        } catch (error) {
          GlobalMethod.showErrorDialog(
            context: context,
            icon: Icons.error,
            iconColor: clr.error,
            title: 'Error',
            body: 'Unable to delete event',
            buttonText: 'OK',
          );
        } finally {}
      },
      child: Row(children: const [
        Icon(
          Icons.delete,
          color: Colors.red,
        ),
        Text(
          ' Yes',
          style: txt.body2Dark,
        ),
      ]),
    );
  }

  Widget _textButtonCancel(con1) {
    return TextButton(
      onPressed: () {
        Navigator.canPop(con1) ? Navigator.pop(con1) : null;
      },
      child: Row(children: const [
        Icon(
          Icons.cancel,
          color: clr.primary,
        ),
        Text(
          ' No',
          style: txt.body2Dark,
        ),
      ]),
    );
  }
}
