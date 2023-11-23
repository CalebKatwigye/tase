import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;


void _launchUrl(String url) async {
  await launchUrl(Uri.parse(url));
}
class TrackMyLoanCard extends StatefulWidget {
  final double totalInterest;
  final String user;
  final double netInterest;
  final String selected;
  final double monthlyInstallment;
  final String collateral;
  final double ttAmount;
  final double paymentAmount;
  final int principal;
  final String postId;
  final DateTime now;
  final DateTime fourMonthsLater;

  TrackMyLoanCard(
      {super.key,
      required this.totalInterest,
      required this.netInterest,
      required this.selected,
      required this.monthlyInstallment,
      required this.collateral,
      required this.paymentAmount,
      required this.principal,
      required this.user,
      required this.postId,
      required this.ttAmount,
      required this.now,
      required this.fourMonthsLater});

  @override
  State<TrackMyLoanCard> createState() => _TrackMyLoanCardState();
}

class _TrackMyLoanCardState extends State<TrackMyLoanCard> {
  final user = FirebaseAuth.instance.currentUser!;

  TextEditingController enteredAmount = new TextEditingController();
 Future<void> handlePaymentInitialization() async {
  final money = int.parse(enteredAmount.text);
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
        'amount': '${money}',
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
        FirebaseFirestore.instance
            .collection("Loan Repayment Transactions")
            .doc('${formattedDate}')
            .set({
          'Email': user.email,
          'txref': formattedDate,
         'money_paid': money,
          'TimeStamp': Timestamp.now(),
          'post-id':widget.postId,
          
        });
        _launchUrl(link);
      } else {
        print('Payment failed: ${responseData['message']}');
      }
    } catch (err) {
      print('Error making Flutterwave payment: ${err}');
    }
  }


  void payInstallment() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Text('Pay Installment',
                style: TextStyle(color: Colors.white)),
            content: TextField(
              autofocus: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: "Enter amount to pay",
                    hintStyle: TextStyle(color: Colors.grey)),
                controller: enteredAmount,
            ),
               
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              TextButton(
                  onPressed: () {
                  
                    handlePaymentInitialization();
                  },
                  child: Text('Submit')),
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

          //loan post
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Principal: UGX ' + widget.principal.toStringAsFixed(2),
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Total Interest: UGX ' +
                        widget.totalInterest.toStringAsFixed(2),
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
                    'Start Date: ' +
                        DateFormat('yyyy-MM-dd').format(widget.now),
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'End Date: ' +
                        DateFormat('yyyy-MM-dd').format(widget.fourMonthsLater),
                    style: TextStyle(color: Colors.grey[700]),
                  ),
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
                    'Installment: UGX ' +
                        widget.monthlyInstallment.toStringAsFixed(2),
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Balance: UGX ' +
                        widget.ttAmount.toStringAsFixed(2),
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),

              //delete button
              /*
              if (widget.user == user.email)
                IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: (){}),
               */

              //accept button
              //if (widget.user != user.email)
              IconButton(
                  icon: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  onPressed: payInstallment),
            ],
          ),
        ],
      ),
    );
  }
}
