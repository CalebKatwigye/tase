import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tase/components/deletebutton.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;

  const WallPost(
      {super.key,
      required this.message,
      required this.user,
      required this.postId});

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  final user = FirebaseAuth.instance.currentUser!;

  void deletePost() {
    //show confirmation dialog for deletion
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.grey[900],
              title: const Text(
                'Delete Loan Request',
                style: TextStyle(color: Colors.white),
              ),
              content: const Text(
                  'Are you sure you want to delete this loan request?',
                  style: TextStyle(color: Colors.white)),
              actions: [
                //cancel button
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),

                //delete button
                TextButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection("User Posts")
                        .doc(widget.postId)
                        .delete()
                        .then((value) => print("post deleted"))
                        .catchError(
                            (error) => print("failed to delete post: $error"));

                    Navigator.pop(context);
                  },
                  child: const Text('Delete'),
                )
              ],
            ));
  }

  //dialog for accepting loan
  void acceptLoan() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Text('Accept Loan Request',
                style: TextStyle(color: Colors.white)),
            content: Text(
                'Are you sure you want to accept this loan request? If you do, you will be sent a mobile money pin prompt.',
                style: TextStyle(color: Colors.white)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Accept')),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: Row(
        children: [
          //profile pic
          Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.grey[400]),
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          //message and user email

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user,
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.message,
                  )
                ],
              ),
              //delete button
              if (widget.user == user.email)
                DeleteButton(
                  onTap: deletePost,
                ),

              //delete button
              if (widget.user != user.email)
                Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: IconButton(
                      icon: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      onPressed: acceptLoan),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
