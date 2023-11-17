import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

final Uri _url = Uri.parse('https://flutter.dev');
void _launchUrl(String url) async {

 
    await launchUrl(Uri.parse(url));
  
}

  Future<void> _launchUrls() async {
       final Uri _url = Uri.parse('https://www.pdfdrive.com/artificial-intelligence-e11895991.html');
  if (!await launchUrl(_url)) {
    throw 'Could not launch $_url';
  }}

class LoanPost extends StatefulWidget {
  final double totalInterest;
  final String user;
  final double netInterest;
  final String selected;
  final double monthlyInstallment;
  final String collateral;
  final double ttAmount;
  final String postId;
  const LoanPost(
      {super.key,
      required this.totalInterest,
      required this.netInterest,
      required this.selected,
      required this.monthlyInstallment,
      required this.collateral,
      required this.ttAmount,
      required this.postId,
      required this.user});

  @override
  State<LoanPost> createState() => _LoanPostState();
}

class _LoanPostState extends State<LoanPost> {
  final user = FirebaseAuth.instance.currentUser!;

  //mobile money function

 Future<void> handlePaymentInitialization() async {
 
    try {
      final Map<String, String> headers = {
        'Authorization':
            'Bearer FLWSECK-69fda727ee7df02bab6a24cdcd7e3ffd-18b5c7c3f10vt-X',
        "Content-Type": "application/json",
      };
DateTime now = DateTime.now();
String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
final user = FirebaseAuth.instance.currentUser!;
      final Map<String, dynamic> body = {
        'tx_ref': '${formattedDate}',
        'amount': '${widget.ttAmount}',
        'currency': 'UGX',
        'redirect_url':
            'https://webhook.site/9d0b00ba-9a69-44fa-a43d-a82c33c36fdc',
        'meta': {
          'consumer_id': user.email,
          'consumer_mac': '92a3-912ba-1192a',
        },
        'customer': {
          'email': '${user.email}',
          'phonenumber': '${user.phoneNumber}',
          'name': '${user.displayName}',
        },
        'customizations': {
          'title': 'Tase',
          
        },
      };

      final response = await http.post(
        Uri.parse('https://api.flutterwave.com/v3/payments'),
        headers: headers,
        body: jsonEncode(body),
      );

      final responseData = jsonDecode(response.body);

      if (responseData['status'] == 'success') {
        String link = responseData['data']['link'];

        Uri url = Uri.parse(link);
       FirebaseFirestore.instance.collection("Transcations").doc('${formattedDate}').set({
      'Email': user.email,
      'txref': formattedDate,
      'TotalInterest': widget.totalInterest,
      'NetInterest': widget.netInterest,
      'Selected': widget.selected,
      'MonthlyInstallment': widget.monthlyInstallment,
      'Collateral': widget.collateral,
      'TotalAmount': widget.ttAmount,
      'TimeStamp': Timestamp.now(),
      'verified':false
    });
        _launchUrl(link);
     
      } else {
        print('Payment failed: ${responseData['message']}');
      }
    } catch (err) {
      print('Error making Flutterwave payment: ${err}');
    }
  }

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
                    ;
                  },
                  child: const Text('Cancel'),
                ),

                //delete button
                TextButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection("User Loan Posts")
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
                   // _launchUrl('https://flutter.dev');
                   handlePaymentInitialization();
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
                    'Net Interest: UGX ' +
                        widget.netInterest.toStringAsFixed(2),
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('Payment Period: ' + widget.selected + ' months',
                      style: TextStyle(color: Colors.grey[700])),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Collateral: ' + widget.collateral.toUpperCase(),
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Total Payment: UGX ' + widget.ttAmount.toStringAsFixed(2),
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),

              //delete button
              if (widget.user == user.email)
                IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: deletePost),

              //accept button
              if (widget.user != user.email)
                IconButton(
                    icon: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                    onPressed: acceptLoan),
            ],
          ),
        ],
      ),
    );
  }
}
