import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tase/components/myloancard.dart';
import 'package:tase/components/textbox.dart';
import 'package:http/http.dart' as http;
import '../components/loanpost.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

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
    if (newValue.trim().length > 0) {
      //only update if there is something in the text field
      await usersCollection.doc(user.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _verifyPayments(String txRef) async {
      try {
        final Map<String, String> headers = {
          'Authorization':
              'Bearer FLWSECK-69fda727ee7df02bab6a24cdcd7e3ffd-18b5c7c3f10vt-X',
          "Content-Type": "application/json",
        };
        final response = await http.get(
          Uri.parse(
              'https://api.flutterwave.com/v3/transactions/verify_by_reference?tx_ref=${txRef}'),
          headers: headers,
        );
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          final transactions = responseData['data'];
          // final verifiedPayments = transactions.map((transaction) => transaction['tx_ref']).toList();

          bool verify = true;
          final collectionReference =
              FirebaseFirestore.instance.collection('Transactions').doc(txRef);
          final querySnapshot = await collectionReference.get();
          final post = querySnapshot['post-id'];
          FirebaseFirestore.instance
              .collection('User Loan Posts')
              .doc('${post}')
              .update({
            'taken': true,
          });
          return verify;
        } else {
          print(
              'Failed to fetch verified payments: ${responseData['message']}');
          return false;
        }
      } catch (err) {
        print('Error making Flutterwave payment: ${err}');
        return false;
      }
    }

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
                      'My Transactions',
                      style: TextStyle(color: Colors.grey[600], fontSize: 20),
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(bottom: 20),
                    height: MediaQuery.of(context).size.height,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("Transactions")
                          .where('Email', isEqualTo: user.email)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final transactions = snapshot.data!.docs;
                          final verifiedPayments = [];

                          return ListView.builder(
                            itemCount: transactions.length,
                            itemBuilder: (context, index) {
                              final transaction = transactions[index];
                              final txRef = transaction['txref'];

                              return FutureBuilder<bool>(
                                  future: _verifyPayments(txRef),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text(
                                          'Error verifying payment: ${snapshot.error}');
                                    } else {
                                      final isVerified = snapshot.data!;
                                      print(
                                          'isVerified:${isVerified},txref-${txRef}');
                                      if (isVerified) {
                                        return MyLoanPost(
                                          email: transaction['Email'],
                                          txRef: transaction['txref'],
                                          totalInterest:
                                              transaction['TotalInterest'],
                                          netInterest:
                                              transaction['NetInterest'],
                                          selected: transaction['Selected'],
                                          monthlyInstallment:
                                              transaction['MonthlyInstallment'],
                                          collateral: transaction['Collateral'],
                                          totalAmount:
                                              transaction['TotalAmount'],
                                          paymentAmount:
                                              transaction['PaymentAmount'],
                                          principal: transaction['Principal'],
                                          timeStamp:
                                              transaction['TimeStamp'].toDate(),
                                          verified: true,
                                        );
                                      } else {
                                        return Container();
                                      }
                                    }
                                  });
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),

                  const SizedBox(
                    height: 20,
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
