import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tase/pages/calculatorpage.dart';
import 'package:tase/pages/profilepage.dart';
import 'package:tase/pages/settingspage.dart';

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
        actions: [
          IconButton(
            onPressed: () {Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );},
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
                    selectionColor: Colors.amber,
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                onTap: () {Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CalculatorPage()),
                  );},
              ),
              ListTile(
                leading: Icon(Icons.settings, color: Colors.white),
                title: Text("Settings",
                    selectionColor: Colors.amber,
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                onTap: () {Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );},
              ),
              SizedBox(
                height: 400,
              ),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.white),
                title: Text("Logout",
                    selectionColor: Colors.amber,
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                onTap: signUserOut,
              ),
            ],
          ),
        ),
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