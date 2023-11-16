import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tase/components/post.dart';
import 'package:tase/components/textfield.dart';
import 'package:tase/pages/calculatorpage.dart';
import 'package:tase/pages/profilepage.dart';
import 'package:tase/pages/settingspage.dart';

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

  @override
  Widget build(BuildContext context) {
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
          child: ListView(
            children: [
              DrawerHeader(
                  child: Center(
                child: Text("logo",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold)),
              )),
              ListTile(
                leading: Icon(Icons.home, color: Colors.white),
                title: Text("Home",
                    selectionColor: Colors.amber,
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
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
                    MaterialPageRoute(builder: (context) => SettingsPage()),
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

            //post message
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
            Text(
              'Logged in as ' + user.email!,
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
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