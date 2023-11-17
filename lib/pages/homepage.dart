import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tase/components/loanpost.dart';
//import 'package:tase/components/post.dart';
//import 'package:tase/components/textfield.dart';
import 'package:tase/pages/calculatorpage.dart';
import 'package:tase/pages/profilepage.dart';
import 'package:tase/pages/settingspage.dart';


//hooli-tx-1920bbdsdssdsdsYTYTTtytty
//FLWSECK-69fda727ee7df02bab6a24cdcd7e3ffd-18b5c7c3f10vt-X

/*
handlePaymentInitialization() async { 
	 
Map<String, String> headers = {
  'Authorization': 'Bearer FLWSECK-69fda727ee7df02bab6a24cdcd7e3ffd-18b5c7c3f10vt-X',
  'Content-type': 'application/json',
         'Accept': 'application/json'
};

Map<String, dynamic> body = {
  "tx_ref": "hooli-tx-1920bbdsdssdsdsYTYTTtytty", // Unique transaction reference
  'amount': '100',
  'currency': 'NGN',
  'redirect_url': 'https://your-redirect-url', // URL to redirect user after payment
  'meta': {
    'consumer_id': 23,
    'consumer_mac': '92a3-912ba-1192a',
  },
  'customer': {
    'email': 'user@gmail.com',
    'phonenumber': '256703882021',
    'name': 'Yemi Desola',
  },
  'customizations': {
    'title': 'Pied Piper Payments',
    'logo': 'http://www.piedpiper.com/app/themes/joystick-v27/images/logo.png',
  },
};


final response = await http.post(
  Uri.parse('https://api.flutterwave.com/v3/payments',),
  headers: headers,
  body: jsonEncode(body),
);
print('Response status code: ${response.statusCode}');
print('Response body: ${response.body}');
final responseData = jsonDecode(response.body);
final data = responseData['data'];
final link = data['link'];
final urlString = link;
final Uri url = Uri.parse(urlString);
print(url);
launchUrl(url);
  
 }

PaymentInitialization() async { 
	 final Customer customer = Customer(
	 name: "Flutterwave Developer",
	 phoneNumber: "1234566677777",   
     email: "customer@customer.com"  
 );            
    final Flutterwave flutterwave = Flutterwave(
        context: context, publicKey: "FLWPUBK-ab5d0c0188cb40123a5568cf8b56c666-X",
		currency: "UGX",   
        redirectUrl: "https://pub.dev/packages/flutter_inappwebview",  
        txRef: "add-your-unique-reference-here",   
        amount: "3000",   
        customer: customer,   
        paymentOptions: "ussd, card, barter, payattitude",   
        customization: Customization(title: "My Payment"),
        isTestMode: false );
        final ChargeResponse response = await flutterwave.charge();
 }
 */

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
                      .collection("User Loan Posts")
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
                            return LoanPost(
                              postId: post.id,
                              totalInterest: post['TotalInterest'],
                              netInterest: post['NetInterest'],
                              selected: post['Selected'],
                              monthlyInstallment: post['MonthlyInstallment'],
                              collateral: post['Collateral'],
                              ttAmount: post['TotalAmount'],
                              user: post['UserEmail'],
                            );
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
        onPressed: (){
           Navigator.push(
                    context,
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