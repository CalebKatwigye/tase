import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  //signout method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: Text(
          'Logged in as ' + user.email!,
          style: TextStyle(fontSize: 20),
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