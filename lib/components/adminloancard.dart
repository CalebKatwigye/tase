import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminLoanCard extends StatefulWidget {
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

  AdminLoanCard(
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
  State<AdminLoanCard> createState() => _AdminLoanCardState();
}

class _AdminLoanCardState extends State<AdminLoanCard> {
  final user = FirebaseAuth.instance.currentUser!;
  handleloan() async {
    DateTime now = DateTime.now();
    final collectionReference = FirebaseFirestore.instance
        .collection('User Loan Posts')
        .doc(widget.postId);
    final querySnapshot = await collectionReference.get();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    DateTime fourMonthsLater =
        DateTime.now().add(Duration(days: 30 * int.parse(widget.selected)));
    FirebaseFirestore.instance
        .collection("Pending Loans")
        .doc('${formattedDate}')
        .set({
      'Email': querySnapshot['UserEmail'],
      'txref': formattedDate,
      'Balance': widget.ttAmount,
      'TotalInterest': widget.totalInterest,
      'NetInterest': widget.netInterest,
      'Selected': widget.selected,
      'MonthlyInstallment': widget.monthlyInstallment,
      'Collateral': widget.collateral,
      'TotalAmount': widget.ttAmount,
      'PaymentAmount': widget.paymentAmount,
      'Principal': widget.principal,
      'TimeStamp': Timestamp.now(),
      'post-id': widget.postId,
      'start-date': now,
      'end-date': fourMonthsLater,
      'verified': false
    });
    FirebaseFirestore.instance
        .collection("User Loan Posts")
        .doc('${widget.postId}')
        .update({
      'sent': null,
      'taken': null,
    });
    
  }

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
                    //  handlePaymentInitialization();
                    // print(widget.postId);
                    handleloan();
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

          //loan post
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email: ' +
                        widget.user,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Principal: UGX ' + widget.principal.toStringAsFixed(2),
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Net Interest: UGX ' +
                        widget.netInterest.toStringAsFixed(2),
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
                    'Total Balance: UGX ' +
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
                  onPressed: acceptLoan),
            ],
          ),
        ],
      ),
    );
  }
}
