import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tase/components/loanpost.dart';
import 'package:tase/pages/adminpage.dart';
//import 'package:tase/components/post.dart';
//import 'package:tase/components/textfield.dart';
import 'package:tase/pages/calculatorpage.dart';
import 'package:tase/pages/profilepage.dart';
import 'package:http/http.dart' as http;
import 'package:tase/pages/termsandconditions.dart';
import 'dart:convert';

import 'package:tase/pages/trackmyloans.dart';
//import 'package:tase/pages/settingspage.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  final textController = TextEditingController();

  //signout method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  //postmessagemethod
  /*
  void postMessage() {
    //post only if something is in the text field
    if (textController.text.isNotEmpty) {
      //store in firebase
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail': user.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now()
      });
    }
    //clear the textfield
    setState(() {
      textController.clear();
    });
  }
   */

  @override
  Widget build(BuildContext context) {
 

 Future admintile() async {
   final collectionReference =
          FirebaseFirestore.instance.collection('Users');
      final querySnapshot = await collectionReference.doc(user.email).get();
      if (querySnapshot['admin'] == true){
        return true;
      }else{
        return false;
      }

 }
     
    Future _verifyPayments() async {
      final collectionReference =
          FirebaseFirestore.instance.collection('Transactions');
      final querySnapshot = await collectionReference.get();

      for (final doc in querySnapshot.docs) {
        final txRef = doc['txref'];
        final docid = doc['post-id'];
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
            FirebaseFirestore.instance
                .collection('User Loan Posts')
                .doc('${docid}')
                .update({
              'taken': true,
            });
          } else {
            print(
                'Failed to fetch verified payments: ${responseData['message']}');
          }
        } catch (err) {
          print('Error making Flutterwave payment: ${err}');
        }
      }
    }

    _verifyPayments();
    return Scaffold(
      backgroundColor: Colors.grey[350],
      appBar: AppBar(
        title: Center(child: Text('Home')),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
            icon: Icon(Icons.person),
          )
        ],
        backgroundColor: Colors.black,
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: Container(
          child: FutureBuilder(
            future: admintile(),
            builder: (context, snapshot) {
                if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
              final isAdmin = snapshot.data!;
              return ListView(
                children: [
                  DrawerHeader(
                      child: Center(
                          child: Container(
                              width: 80, // Set the desired width
                              height: 80, // Set the desired height
                              child: ClipOval(
                                child: Image(
                                  image: AssetImage("assets/images/logo3.jpg"),
                                  fit: BoxFit
                                      .cover, // You can use BoxFit.contain or other options based on your preference
                                ),
                              )))),
                  ListTile(
                    leading: Icon(Icons.home, color: Colors.white),
                    title: Text("Home",
                        selectionColor: Colors.amber,
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.calculate, color: Colors.white),
                    title: Text("Calculator",
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CalculatorPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.book, color: Colors.white),
                    title: Text("Terms and conditions",
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TermsAndConditions()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.money, color: Colors.white),
                    title: Text("Track My Loans",
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TrackMyLoans()),
                      );
                    },
                  ),
                    if (isAdmin) 
                  ListTile(
                    leading: Icon(Icons.admin_panel_settings, color: Colors.white),
                    title: Text("Admin",
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AdminPage()),
                      );
                    },
                  ),
                  SizedBox(
                    height: 400,
                  ),
                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.white),
                    title: Text("Logout",
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    onTap: signUserOut,
                  ),
                ],
              );
            }
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            //the wall
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("User Loan Posts")
                      .where('taken', isEqualTo: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            //get the message
                            final post = snapshot.data!.docs[index];
                            return StreamBuilder<Object>(
                                stream: null,
                                builder: (context, snapshot) {
                                  return LoanPost(
                                    postId: post['post-id'],
                                    totalInterest: post['TotalInterest'],
                                    netInterest: post['NetInterest'],
                                    selected: post['Selected'],
                                    monthlyInstallment:
                                        post['MonthlyInstallment'],
                                    collateral: post['Collateral'],
                                    ttAmount: post['TotalAmount'],
                                    user: post['UserEmail'],
                                    paymentAmount: post['PaymentAmount'],
                                    principal: post['Principal'],
                                  );
                                });
                          });
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error:${snapshot.error}'),
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ),

            /*
            Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("User Posts")
                        .orderBy(
                          "TimeStamp",
                          descending: false,
                        )
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              //get the message
                              final post = snapshot.data!.docs[index];
                              return WallPost(
                                  postId: post.id,
                                  message: post['Message'],
                                  user: post['UserEmail']);
                            });
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error:${snapshot.error}'),
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    })),
             */

            //post message

            /* 
            Padding(
              padding: const EdgeInsets.only(right: 15, top: 25, bottom: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //textfield
                  Expanded(
                      child: MyTextFeild(
                          controller: textController,
                          hintText: 'Write something on the wall',
                          obscureText: false)),

                  //post button
                  IconButton(
                      onPressed: postMessage,
                      icon: const Icon(
                        Icons.arrow_circle_up,
                      ))
                ],
              ),
            ),
            */
            const SizedBox(
              height: 20,
            ),
            Text(
              'Logged in as ' + user.email!,
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CalculatorPage()));
          }),
    );
  }
  // Function to launch the website URL
}
/*child: Center(
            child: Text(
              'Logged in as ' + user.email!,
              style: TextStyle(fontSize: 20),
              ),),

              actions: [
            IconButton(
              onPressed: signUserOut, 
              icon: Icon(Icons.logout),)
          ],
*/