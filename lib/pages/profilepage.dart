import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tase/components/textbox.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;

  //all users
  final usersCollection = FirebaseFirestore.instance.collection("Users");

  //edit field
  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.black,
              title: Text(
                'Edit $field',
                style: const TextStyle(color: Colors.white),
              ),
              content: TextField(
                autofocus: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: "Enter new $field",
                    hintStyle: TextStyle(color: Colors.grey)),
                onChanged: (value) {
                  newValue = value;
                },
              ),
              actions: [
                //cancel button
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    
                  ),
                ),
                //cancel button
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(newValue);
                  },
                  child: Text(
                    'Save',
                    
                  ),
                )
              ],
            ));

            //update in firestore
            if (newValue.trim().length>0){
              //only update if there is something in the text field
              await usersCollection.doc(user.email).update({field: newValue});
            }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[350],
        appBar: AppBar(
          title: Center(child: Text('Profile Page')),
          backgroundColor: Colors.black,
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(user.email)
              .snapshots(),
          builder: (context, snapshot) {
            //get user data
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;

              return ListView(
                children: [
                  const SizedBox(
                    height: 50,
                  ),

                  //profile pic
                  const Icon(
                    Icons.person,
                    size: 72,
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  //user email
                  Text(
                    user.email!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                  ),

                  const SizedBox(
                    height: 50,
                  ),

                  //user details
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      'My Details',
                      style: TextStyle(color: Colors.grey[600], fontSize: 20),
                    ),
                  ),

                  //username
                  MyTextBox(
                    text: userData['username'],
                    sectionName: 'username',
                    onPressed: () => editField('username'),
                  ),

                  //phone number
                  MyTextBox(
                    text: userData['phonenumber'],
                    sectionName: 'phonenumber',
                    onPressed: () => editField('phonenumber'),
                  ),

                  //address
                  MyTextBox(
                    text: userData['address'],
                    sectionName: 'address',
                    onPressed: () => editField('address'),
                  ),

                  const SizedBox(
                    height: 50,
                  ),

                  //user loans
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      'My Loans',
                      style: TextStyle(color: Colors.grey[600], fontSize: 20),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error${snapshot.error}'),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
